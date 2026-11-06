"""Unit tests for benchmarks/bench.py: history, averages, baseline, tables. No Neovim needed."""

import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "benchmarks"))
import bench  # noqa: E402


def meta(kind, version, date="2026-10-31T00:00Z"):
  return {"date": date, "kind": kind, "version": version, "commit": "abc1234", "load1": "0.50",
          "nvim": "NVIM v0.13.0"}


def rows(kind, version, values, date="2026-10-31T00:00Z", runs=3):
  measured = {k: (v, v) for k, v in values.items() if k not in bench.COUNTS + bench.SIZES}
  counts = {k: v for k, v in values.items() if k in bench.COUNTS + bench.SIZES}
  return bench.to_rows(meta(kind, version, date), measured, counts, runs)


def by_metric(summary):
  return {s["metric"]: s for s in summary}


class ToRows(unittest.TestCase):
  def test_units_and_order(self):
    result = rows("release", "0.1.0", {"plugins installed": 377, "startup ready": 150.26, "rss peak": 200.0})
    self.assertEqual([r["metric"] for r in result], ["startup ready", "rss peak", "plugins installed"])
    self.assertEqual([r["unit"] for r in result], ["ms", "MiB", "count"])
    self.assertEqual(result[0]["median"], "150.3")
    self.assertEqual(result[2]["median"], "377")
    self.assertEqual(result[2]["runs"], "1")
    self.assertEqual(result[0]["runs"], "3")

  def test_sizes_keep_a_decimal_and_are_not_averaged_runs(self):
    result = rows("release", "0.1.0", {"plugin size": 1234.56})
    self.assertEqual((result[0]["unit"], result[0]["median"], result[0]["runs"]), ("MiB", "1234.6", "1"))

  def test_unknown_metrics_are_dropped(self):
    self.assertEqual(rows("release", "0.1.0", {"bogus": 1.0}), [])


class Record(unittest.TestCase):
  def test_rerun_of_a_release_replaces_its_rows(self):
    history = rows("release", "0.1.0", {"startup ready": 100})
    history = bench.record(history, rows("release", "0.1.0", {"startup ready": 120}))
    self.assertEqual([r["median"] for r in history], ["120.0"])

  def test_rerun_without_times_keeps_the_recorded_times(self):
    history = rows("release", "0.1.0", {"startup ready": 100, "plugins installed": 5})
    history = bench.record(history, rows("release", "0.1.0", {"plugins installed": 6}))
    self.assertEqual({r["metric"]: r["median"] for r in history}, {"startup ready": "100.0", "plugins installed": "6"})

  def test_baselines_accumulate(self):
    history = rows("baseline", "0.1.0", {"startup ready": 100}, date="2026-10-01T00:00Z")
    history = bench.record(history, rows("baseline", "0.1.0", {"startup ready": 90}, date="2026-11-01T00:00Z"))
    self.assertEqual(len(history), 2)

  def test_history_round_trip(self):
    history = rows("release", "0.1.0", {"startup ready": 100, "plugins installed": 5})
    with tempfile.TemporaryDirectory() as directory:
      path = Path(directory) / "history.tsv"
      bench.write_history(history, path)
      self.assertEqual(bench.read_history(path), history)
      self.assertEqual(bench.read_history(Path(directory) / "missing.tsv"), [])


class Summarize(unittest.TestCase):
  def history(self, count):
    history = []
    for index in range(count):
      history += rows("release", f"0.{index}.0", {"startup ready": 100 + index * 10, "plugins installed": 300 + index})
    return history

  def test_average_excludes_the_current_release(self):
    history = self.history(3)  # 100, 110, 120
    current = rows("release", "0.9.0", {"startup ready": 200})
    s = by_metric(bench.summarize(history, current)[0])["startup ready"]
    self.assertEqual(s["average"], 110)
    self.assertEqual(s["averaged"], 3)
    self.assertEqual(s["latest"], 200)

  def test_average_of_an_already_recorded_release_uses_only_earlier_ones(self):
    history = self.history(4)  # 0.3.0 = 130 is the current one
    current = [r for r in history if r["version"] == "0.3.0"]
    s = by_metric(bench.summarize(history, current)[0])["startup ready"]
    self.assertEqual(s["averaged"], 3)
    self.assertEqual(s["average"], 110)

  def test_average_window_is_the_last_ten_releases(self):
    history = self.history(15)  # 100 .. 240
    current = rows("release", "1.0.0", {"startup ready": 0})
    s = by_metric(bench.summarize(history, current)[0])["startup ready"]
    self.assertEqual(s["averaged"], 10)
    self.assertEqual(s["average"], sum(100 + i * 10 for i in range(5, 15)) / 10)

  def test_latest_baseline_wins(self):
    history = rows("baseline", "0.1.0", {"startup ready": 300}, date="2026-10-01T00:00Z")
    history += rows("baseline", "0.2.0", {"startup ready": 250}, date="2026-11-01T00:00Z")
    current = rows("release", "0.3.0", {"startup ready": 200})
    summary, date, _ = bench.summarize(history, current)
    self.assertEqual(by_metric(summary)["startup ready"]["baseline"], 250)
    self.assertEqual(date, "2026-11-01T00:00Z")

  def test_baseline_meta_reports_measured_sessions(self):
    history = rows("baseline", "0.1.0", {"startup ready": 300}, runs=10)
    history += rows("baseline", "0.1.0", {"plugins installed": 300}, runs=1)
    current = rows("release", "0.2.0", {"startup ready": 200})
    _, _, baseline_meta = bench.summarize(history, current)
    self.assertEqual(baseline_meta["runs"], "10")

  def test_no_history(self):
    current = rows("release", "0.1.0", {"startup ready": 200, "plugins installed": 10})
    summary, date, baseline_meta = bench.summarize([], current)
    s = by_metric(summary)
    self.assertIsNone(s["startup ready"]["average"])
    self.assertIsNone(s["startup ready"]["baseline"])
    self.assertIsNone(s["plugins installed"]["previous"])
    self.assertIsNone(date)
    self.assertIsNone(baseline_meta)

  def test_counts_compare_with_the_previous_release(self):
    history = self.history(2)  # plugins 300, 301
    current = rows("release", "0.9.0", {"plugins installed": 310})
    self.assertEqual(by_metric(bench.summarize(history, current)[0])["plugins installed"]["previous"], 301)


class Tables(unittest.TestCase):
  def test_baseline_run_compares_with_the_previous_baseline_not_itself(self):
    history = rows("baseline", "0.1.0", {"startup ready": 300}, date="2026-10-01T00:00Z")
    new = rows("baseline", "0.2.0", {"startup ready": 250}, date="2026-11-01T00:00Z")
    history = bench.record(history, new)
    table, _ = bench.table_for(history, new, 10)
    self.assertIn("| startup ready | 250 ms |", table)
    self.assertIn("| 300 | -17% |", table)

  def test_table_columns_and_warnings(self):
    history = rows("release", "0.1.0", {"startup ready": 100, "plugins installed": 300})
    history += rows("baseline", "0.1.0", {"startup ready": 100}, date="2026-10-30T00:00Z")
    current = rows("release", "0.2.0", {"startup ready": 150, "plugins installed": 310})
    table, warnings = bench.table_for(history, current, 3)
    self.assertIn("| startup ready | 150 ms | 100 | 1 | +50% | 100 | +50% |", table)
    self.assertIn("| plugins installed | 310 | 300 | +10 |", table)
    self.assertEqual(warnings, [])
    self.assertNotIn("Over 25% slower", table)

  def warn_history(self, *medians_and_mins):
    history = []
    for index, (median, best) in enumerate(medians_and_mins):
      history += rows("release", f"0.{index + 1}.0", {"startup ready": median})
      history[-1]["min"] = str(best)
    return history

  def warnings_for(self, history, median, best, version="9.0.0"):
    current = rows("release", version, {"startup ready": median})
    current[0]["min"] = str(best)
    return bench.table_for(history, current, 3)[1]

  def test_warns_when_the_best_run_is_slower_two_releases_in_a_row(self):
    history = self.warn_history((100, 100), (100, 100), (150, 150))
    self.assertEqual(self.warnings_for(history, 150, 150), ["startup ready: best run +50% vs average, 2 releases in a row"])
    current = rows("release", "9.0.0", {"startup ready": 150})
    self.assertIn("Over 25% slower", bench.table_for(history, current, 3)[0])

  def test_one_slow_release_is_not_a_warning(self):
    history = self.warn_history((100, 100), (100, 100), (100, 100))
    self.assertEqual(self.warnings_for(history, 150, 150), [])

  def test_a_noisy_median_with_a_normal_best_run_is_not_a_warning(self):
    history = self.warn_history((100, 100), (100, 100), (300, 101))
    self.assertEqual(self.warnings_for(history, 300, 101), [])

  def test_the_earlier_slow_release_does_not_raise_the_reference(self):
    history = self.warn_history((100, 100), (100, 100), (1000, 1000))
    self.assertEqual(len(self.warnings_for(history, 1000, 1000)), 1)

  def test_a_release_without_times_does_not_break_the_streak(self):
    history = self.warn_history((100, 100), (100, 100), (150, 150))
    history += rows("release", "0.4.0", {"plugins installed": 300})
    self.assertEqual(len(self.warnings_for(history, 150, 150)), 1)

  def test_recovery_clears_the_warning(self):
    history = self.warn_history((100, 100), (100, 100), (150, 150))
    self.assertEqual(self.warnings_for(history, 100, 100), [])

  def baseline_with(self, median, best):
    baseline = rows("baseline", "0.0.0", {"startup ready": median})
    baseline[0]["min"] = str(best)
    return baseline

  def test_a_lucky_baseline_best_run_is_not_a_warning(self):
    # A baseline's best comes from 10 sessions and a release's from 3, so they are not comparable.
    history = self.baseline_with(235, 155) + self.warn_history((267, 199))
    self.assertEqual(self.warnings_for(history, 267, 199), [])

  def test_warns_when_the_best_run_is_slower_than_the_baseline_median(self):
    history = self.baseline_with(100, 60) + self.warn_history((150, 130))
    self.assertEqual(self.warnings_for(history, 150, 130), ["startup ready: best run +30% vs baseline, 2 releases in a row"])

  def test_warns_against_the_baseline_median(self):
    history = rows("baseline", "0.0.0", {"startup ready": 100}) + self.warn_history((150, 150))
    warnings = self.warnings_for(history, 150, 150)
    self.assertEqual(warnings, ["startup ready: best run +50% vs baseline, 2 releases in a row"])

  def test_too_little_history_is_not_a_warning(self):
    self.assertEqual(self.warnings_for(self.warn_history((100, 100)), 500, 500), [])

  def test_rows_without_a_best_run_use_the_median(self):
    history = self.warn_history((100, 100), (100, 100), (150, 150))
    for row in history:
      del row["min"]
    self.assertEqual(len(self.warnings_for(history, 150, 150)), 1)

  def test_faster_is_not_a_warning(self):
    history = rows("release", "0.1.0", {"startup ready": 200})
    _, warnings = bench.table_for(history, rows("release", "0.2.0", {"startup ready": 100}), 3)
    self.assertEqual(warnings, [])

  def test_without_baseline_the_table_says_how_to_make_one(self):
    table, _ = bench.table_for([], rows("release", "0.1.0", {"startup ready": 100}), 3)
    self.assertIn("benchmarks/run --baseline", table)


  def test_sizes_go_in_the_count_table_without_warnings(self):
    history = rows("release", "0.1.0", {"plugin size": 100.0})
    table, warnings = bench.table_for(history, rows("release", "0.2.0", {"plugin size": 200.5}), 3)
    self.assertIn("| plugin size | 200.5 MiB | 100.0 MiB | +100.5 |", table)
    self.assertEqual(warnings, [])

  def test_a_run_without_times_has_no_timing_table(self):
    table, _ = bench.table_for([], rows("release", "0.1.0", {"plugins installed": 5}), 3)
    self.assertNotIn("| Metric |", table)
    self.assertIn("| plugins installed | 5 |", table)


class Trend(unittest.TestCase):
  def test_one_row_per_release_newest_first(self):
    history = rows("release", "0.1.0", {"startup ready": 100, "plugins installed": 300}, date="2026-10-01T00:00Z")
    history += rows("baseline", "0.1.0", {"startup ready": 50}, date="2026-10-02T00:00Z")
    history += rows("release", "0.2.0", {"startup ready": 1250, "plugins installed": 290, "plugin size": 1100.4},
                    date="2026-10-03T00:00Z")
    table = bench.trend_table(history).splitlines()
    self.assertEqual(len(table), 4)
    self.assertIn("| 0.2.0 | 2026-10-03 | 0.50 | 290 |", table[2])
    self.assertIn("| 1,100 |", table[2])
    self.assertIn("| 1,250 |", table[2])
    self.assertIn("| 0.1.0 | 2026-10-01 | 0.50 | 300 |", table[3])

  def test_open_and_render_are_means_over_the_fixtures(self):
    values = {"small.md open": 100, "sample.py open": 300, "small.md render": 1000}
    row = bench.trend_table(rows("release", "0.1.0", values)).splitlines()[2]
    self.assertIn("| 200 | 1,000 |", row)

  def test_a_push_without_times_leaves_them_and_the_load_blank(self):
    row = bench.trend_table(rows("release", "0.1.0", {"plugins installed": 5})).splitlines()[2]
    self.assertIn("| 0.1.0 | 2026-10-31 |  | 5 |", row)
    self.assertTrue(row.endswith("|  |  |  |  |  |  |"))


class MeasureRelease(unittest.TestCase):
  MEASURED = {"startup ready": (100.0, 90.0), "rss peak": (190.0, 190.0), "plugins installed": (5, 5)}
  COUNTS = {"plugins installed": (5, 5)}

  def run_release(self, loads, measure=None):
    loads = iter(loads)
    with mock.patch.object(bench, "load1", lambda: next(loads)), \
        mock.patch.object(bench, "measure", measure or (lambda runs, log: dict(self.MEASURED))), \
        mock.patch.object(bench, "plugin_counts", lambda log: dict(self.COUNTS)), \
        mock.patch.object(bench.LoadWatch, "_watch", lambda watch: None):
      return bench.measure_release(3, log=lambda _: None, cpus=10)

  def test_a_quiet_machine_records_everything(self):
    self.assertEqual(self.run_release([1.0, 1.0]), self.MEASURED)

  def test_a_busy_start_measures_nothing(self):
    def fail(runs, log):
      raise AssertionError("must not measure")
    self.assertEqual(self.run_release([4.5], fail), self.COUNTS)

  def test_a_spike_during_the_run_drops_times_but_keeps_the_rest(self):
    result = self.run_release([1.0, 6.5])
    self.assertNotIn("startup ready", result)
    self.assertEqual(result["rss peak"], (190.0, 190.0))
    self.assertEqual(result["plugins installed"], (5, 5))

  def test_a_failed_run_still_records_counts(self):
    def fail(runs, log):
      raise bench.BenchError("boom")
    self.assertEqual(self.run_release([1.0, 1.0], fail), self.COUNTS)


class LoadWatchPeak(unittest.TestCase):
  def test_catches_a_spike_that_ends_before_the_block_does(self):
    loads = iter([1.0, 9.0, 2.0, 2.0, 2.0, 2.0])
    with mock.patch.object(bench, "load1", lambda: next(loads, 2.0)):
      with bench.LoadWatch(interval=0.01) as watch:
        import time
        time.sleep(0.05)
    self.assertEqual(watch.peak, 9.0)


class Sizes(unittest.TestCase):
  def test_plugin_size_is_disk_use_in_mib(self):
    with mock.patch.object(bench.subprocess, "run", return_value=mock.Mock(stdout="2048\t/x\n")):
      self.assertEqual(bench.plugin_size_mib("/x"), 2.0)

  def test_config_size_sums_tracked_files_and_skips_deleted_ones(self):
    with tempfile.TemporaryDirectory() as directory:
      (Path(directory) / "a").write_bytes(b"x" * (1 << 20))
      with mock.patch.object(bench, "ROOT", Path(directory)), mock.patch.object(bench, "git", lambda *_: "a\0gone\0"):
        self.assertEqual(bench.config_size_mib(), 1.0)


class PerformanceDoc(unittest.TestCase):
  def test_creates_then_replaces_only_the_marked_block(self):
    with tempfile.TemporaryDirectory() as directory:
      path = Path(directory) / "PERFORMANCE.md"
      bench.update_performance_doc("first table", path)
      self.assertIn("first table", path.read_text())
      path.write_text(path.read_text() + "\n## Notes\n\nkept\n")
      bench.update_performance_doc("second table", path)
      text = path.read_text()
      self.assertIn("second table", text)
      self.assertNotIn("first table", text)
      self.assertIn("kept", text)
      self.assertEqual(text.count(bench.START), 1)


class CodeCounts(unittest.TestCase):
  def test_reads_cloc_json(self):
    with tempfile.TemporaryDirectory() as directory:
      main = Path(directory) / "main.json"
      lazy = Path(directory) / "lazy.json"
      main.write_text(json.dumps({"Lua": {"code": 900, "nFiles": 8}, "SUM": {"code": 1000, "nFiles": 10}}))
      lazy.write_text(json.dumps({"SUM": {"code": 50000, "nFiles": 400}}))
      self.assertEqual(bench.code_counts(main, lazy), {
        "config files": 10, "config lua lines": 900, "config lines": 1000, "plugin lines": 50000,
      })


if __name__ == "__main__":
  unittest.main()

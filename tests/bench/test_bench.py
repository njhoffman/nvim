"""Unit tests for benchmarks/bench.py: history, averages, baseline, tables. No Neovim needed."""

import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "benchmarks"))
import bench  # noqa: E402


def meta(kind, version, date="2026-10-31T00:00Z"):
  return {"date": date, "kind": kind, "version": version, "commit": "abc1234", "load1": "0.50",
          "nvim": "NVIM v0.13.0"}


def rows(kind, version, values, date="2026-10-31T00:00Z", runs=3):
  measured = {k: (v, v) for k, v in values.items() if k not in bench.COUNTS}
  counts = {k: v for k, v in values.items() if k in bench.COUNTS}
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

  def test_unknown_metrics_are_dropped(self):
    self.assertEqual(rows("release", "0.1.0", {"bogus": 1.0}), [])


class Record(unittest.TestCase):
  def test_rerun_of_a_release_replaces_its_rows(self):
    history = rows("release", "0.1.0", {"startup ready": 100})
    history = bench.record(history, rows("release", "0.1.0", {"startup ready": 120}))
    self.assertEqual([r["median"] for r in history], ["120.0"])

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
    self.assertEqual(warnings, ["startup ready: +50% vs average", "startup ready: +50% vs baseline"])
    self.assertIn("Over 25% slower", table)

  def test_faster_is_not_a_warning(self):
    history = rows("release", "0.1.0", {"startup ready": 200})
    _, warnings = bench.table_for(history, rows("release", "0.2.0", {"startup ready": 100}), 3)
    self.assertEqual(warnings, [])

  def test_without_baseline_the_table_says_how_to_make_one(self):
    table, _ = bench.table_for([], rows("release", "0.1.0", {"startup ready": 100}), 3)
    self.assertIn("benchmarks/run --baseline", table)


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


class Releases(unittest.TestCase):
  def test_latest_release_rows(self):
    history = rows("release", "0.1.0", {"startup ready": 1})
    history += rows("baseline", "0.1.0", {"startup ready": 2})
    history += rows("release", "0.2.0", {"startup ready": 3})
    self.assertEqual({r["version"] for r in bench.latest_release_rows(history)}, {"0.2.0"})
    self.assertEqual(bench.latest_release_rows([]), [])


if __name__ == "__main__":
  unittest.main()

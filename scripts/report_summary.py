#!/usr/bin/env python3
"""Print summary.md for a report directory written by scripts/report.sh.

usage: report_summary.py REPORT_DIR VERSION [PREVIOUS_VERSION]

Stats and deltas come from the report's files and the newest earlier report on disk. The changes
are the CHANGELOG.md sections after PREVIOUS_VERSION, up to and including VERSION.
"""

import glob
import json
import os
import re
import sys

ANSI = re.compile(r"\x1b\[[0-9;]*m")


def read(path):
  try:
    with open(path, encoding="utf-8", errors="replace") as handle:
      return ANSI.sub("", handle.read())
  except FileNotFoundError:
    return ""


def tests(report):
  log = read(f"{report}/tests.log")
  counts = {
    "plenary": sum(int(n) for n in re.findall(r"Success:\s+(\d+)", log)),
    "mini.test": sum(int(n) for n in re.findall(r"Total number of cases: (\d+)", log)),
    "Python": sum(int(n) for n in re.findall(r"^Ran (\d+) tests?", log, re.M)),
    "bats": len(re.findall(r"^ok \d+", log, re.M)),
  }
  return counts


def coverage(report):
  found = re.findall(r"^Total\s+\d+\s+\d+\s+([\d.]+)%", read(f"{report}/coverage.txt"), re.M)
  return float(found[-1]) if found else None


def cloc(report):
  try:
    with open(f"{report}/main.json", encoding="utf-8") as handle:
      return json.load(handle)
  except (FileNotFoundError, ValueError):
    return {}


def code(data, language):
  return data.get(language, {}).get("code", 0)


def files(data, language):
  return data.get(language, {}).get("nFiles", 0)


def previous_report(report):
  """The newest report directory before this one that has stats to compare with."""
  root = os.path.dirname(os.path.abspath(report))
  this = os.path.basename(os.path.abspath(report))
  names = sorted(os.path.basename(p) for p in glob.glob(f"{root}/*") if os.path.isdir(p))
  for name in reversed(names):
    if name < this and name != "failed" and os.path.exists(f"{root}/{name}/main.json"):
      return f"{root}/{name}"
  return None


def previous_label(report):
  match = re.search(r"\(v([\d.]+)\)", read(f"{report}/summary.md").split("\n")[0])
  return f"v{match.group(1)}" if match else os.path.basename(report)


def delta(new, old, digits=0):
  if old is None or new is None:
    return "-"
  change = round(new - old, digits)
  if digits == 0:
    change = int(change)
  if change == 0:
    return f"{0:.{digits}f}"
  return f"{change:+,.{digits}f}"


def changes(version, previous):
  """Changelog sections newer than previous, oldest last, with their headings one level down."""
  sections = re.split(r"^(?=## \[)", read("CHANGELOG.md"), flags=re.M)
  out, on = [], False
  for section in sections:
    heading = re.match(r"## \[([^\]]+)\]", section)
    if not heading:
      continue
    if heading.group(1) == version:
      on = True
    if heading.group(1) == previous:
      break
    if on:
      out.append(re.sub(r"^(#+) ", r"#\1 ", section.strip(), flags=re.M))
  return out


def table(rows, label):
  head = ["Metric", "Value", f"Delta vs {label}"]
  all_rows = [head] + rows
  widths = [max(len(r[i]) for r in all_rows) for i in range(3)]
  line = lambda r: "| " + " | ".join(c.ljust(widths[i]) for i, c in enumerate(r)) + " |"
  rule = "| " + " | ".join("-" * w for w in widths) + " |"
  return "\n".join([line(head), rule] + [line(r) for r in rows])


def main():
  report, version = sys.argv[1], sys.argv[2]
  previous = sys.argv[3] if len(sys.argv) > 3 and sys.argv[3] else None
  stamp = os.path.basename(os.path.abspath(report))
  before = previous_report(report)
  label = previous_label(before) if before else "previous"

  now, then = tests(report), tests(before) if before else None
  total = sum(now.values())
  detail = ", ".join(f"{n} {name}" for name, n in now.items())
  cov, cov_then = coverage(report), coverage(before) if before else None
  data, data_then = cloc(report), cloc(before) if before else {}
  plugins = len(glob.glob(os.path.expanduser("~/.local/share/nvim/lazy/*/")))
  spec_files = len(glob.glob("tests/unit/*_spec.lua"))

  rows = [
    ["Unit spec files", str(spec_files), "-"],
    [
      "Tests passing",
      f"{total}/{total} ({detail})",
      delta(total, sum(then.values()) if then else None),
    ],
    ["Line coverage (lua/)", f"{cov}%" if cov is not None else "-", delta(cov, cov_then, 2)],
    [
      "Lua code lines (cloc)",
      f"{code(data, 'Lua'):,} in {files(data, 'Lua'):,} files",
      delta(code(data, "Lua"), code(data_then, "Lua") if data_then else None),
    ],
    [
      "Markdown code lines",
      f"{code(data, 'Markdown'):,}",
      delta(code(data, "Markdown"), code(data_then, "Markdown") if data_then else None),
    ],
    [
      "Total code lines",
      f"{code(data, 'SUM'):,} in {files(data, 'SUM'):,} files",
      delta(code(data, "SUM"), code(data_then, "SUM") if data_then else None),
    ],
    ["Installed plugins (lazy/)", str(plugins), "-"],
  ]

  print(f"# Nvim Config Report - {stamp} (v{version})\n")
  sections = changes(version, previous)
  if sections:
    print("\n\n".join(sections) + "\n")
  print(table(rows, label) + "\n")
  bench = read(f"{report}/bench.md").strip()
  if bench:
    print("## Benchmarks\n\n" + bench)


if __name__ == "__main__":
  main()

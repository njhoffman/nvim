#!/usr/bin/python3
"""Generate the benchmark fixtures in benchmarks/fixtures/ (deterministic: same output on every run).

Markdown comes in three sizes plus a code-fence-heavy document, since Markdown rendering
(render-markdown, treesitter injections) is the heaviest path. Lua, Python, TypeScript and JSON
cover the common code filetypes. Tiny warm-up files, one per filetype, load each filetype's
plugins before the measured opens.
"""

import json
from pathlib import Path
import random

FIXTURES = Path(__file__).resolve().parent / "fixtures"

WORDS = (
  "buffer window plugin config render parser highlight query extmark option keymap event "
  "session layout module command picker preview cursor register macro fold motion operator "
  "lazy treesitter completion snippet diagnostic signature format linter project terminal"
).split()


def sentence(rng, words=12):
  text = " ".join(rng.choice(WORDS) for _ in range(words))
  return text[0].upper() + text[1:] + "."


def paragraph(rng, lines=3):
  return [" ".join(sentence(rng) for _ in range(2)) for _ in range(lines)]


def code_block(rng, lang, lines):
  body = {
    "lua": lambda i: f"local {rng.choice(WORDS)}_{i} = vim.tbl_extend(\"force\", {{}}, {{ {rng.choice(WORDS)} = {i} }})",
    "python": lambda i: f"def {rng.choice(WORDS)}_{i}(value: int) -> int:\n    return value * {i}",
    "bash": lambda i: f"{rng.choice(['grep', 'sed', 'awk', 'git'])} --{rng.choice(WORDS)} \"$file_{i}\" | sort -u",
    "typescript": lambda i: f"const {rng.choice(WORDS)}{i}: Record<string, number> = {{ {rng.choice(WORDS)}: {i} }};",
    "json": lambda i: f"  \"{rng.choice(WORDS)}_{i}\": {i},",
  }[lang]
  out = [f"```{lang}"]
  for i in range(lines):
    out.extend(body(i).split("\n"))
  return out + ["```"]


def markdown(rng, sections, code_every, code_lines):
  out = ["# Benchmark document", "", *paragraph(rng, 2), ""]
  langs = ["lua", "python", "bash", "typescript", "json"]
  for s in range(sections):
    out += [f"## {sentence(rng, 4)[:-1]}", ""]
    out += paragraph(rng, 3) + [""]
    out += [f"- [{'x' if i % 2 else ' '}] **{rng.choice(WORDS)}** `{rng.choice(WORDS)}` {sentence(rng, 6)}" for i in range(4)]
    out += [""]
    if s % 3 == 0:
      out += ["| Name | Value | Notes |", "|---|---:|---|"]
      out += [f"| {rng.choice(WORDS)} | {rng.randint(1, 999)} | [{rng.choice(WORDS)}](https://example.com/{s}) |" for _ in range(4)]
      out += [""]
    if s % 4 == 1:
      out += [f"> [!NOTE]", f"> {sentence(rng)}", ""]
    if code_every and s % code_every == 0:
      out += code_block(rng, langs[s % len(langs)], code_lines) + [""]
  return out


def lua_source(rng, functions):
  out = ["local M = {}", ""]
  for i in range(functions):
    name = f"{rng.choice(WORDS)}_{i}"
    out += [
      f"--- {sentence(rng, 8)}",
      f"---@param opts table|nil",
      f"---@return table",
      f"function M.{name}(opts)",
      "  opts = vim.tbl_deep_extend(\"force\", { enabled = true, count = %d }, opts or {})" % i,
      "  local result = {}",
      "  for index, value in ipairs(vim.api.nvim_list_bufs()) do",
      f"    if opts.enabled and index % {i % 7 + 2} == 0 then",
      f"      result[#result + 1] = {{ id = value, name = \"{rng.choice(WORDS)}\" }}",
      "    end",
      "  end",
      "  return result",
      "end",
      "",
    ]
  return out + ["return M"]


def python_source(rng, classes):
  out = ['"""Generated benchmark module."""', "", "import dataclasses", "from typing import Optional", ""]
  for i in range(classes):
    name = rng.choice(WORDS).capitalize() + str(i)
    out += [
      "",
      "@dataclasses.dataclass",
      f"class {name}:",
      f'    """{sentence(rng, 8)}"""',
      "",
      f"    {rng.choice(WORDS)}: int = {i}",
      "    label: Optional[str] = None",
      "",
      "    def total(self, values: list[int]) -> int:",
      f"        return sum(value * {i % 5 + 1} for value in values if value > {i % 3})",
      "",
      "    def describe(self) -> str:",
      f'        return f"{{self.label or \'{rng.choice(WORDS)}\'}}: {{self.total([1, 2, 3])}}"',
      "",
    ]
  return out


def typescript_source(rng, interfaces):
  out = ["import { readFile } from \"node:fs/promises\";", ""]
  for i in range(interfaces):
    name = rng.choice(WORDS).capitalize() + str(i)
    out += [
      f"/** {sentence(rng, 8)} */",
      f"export interface {name} {{",
      f"  {rng.choice(WORDS)}: number;",
      "  label?: string;",
      "}",
      "",
      f"export async function load{name}(path: string): Promise<{name}[]> {{",
      "  const text = await readFile(path, \"utf8\");",
      f"  return JSON.parse(text).filter((item: {name}) => item.label !== undefined).slice(0, {i + 1});",
      "}",
      "",
    ]
  return out


def json_document(rng, entries):
  data = {
    f"{rng.choice(WORDS)}_{i}": {
      "id": i,
      "enabled": i % 2 == 0,
      "tags": [rng.choice(WORDS) for _ in range(3)],
      "settings": {"width": rng.randint(10, 200), "label": sentence(rng, 4)},
    }
    for i in range(entries)
  }
  return json.dumps(data, indent=2).split("\n")


def main():
  rng = random.Random(20261031)
  files = {
    "small.md": markdown(rng, 4, 4, 6),
    "medium.md": markdown(rng, 24, 2, 8),
    "large.md": markdown(rng, 62, 2, 8),
    "code.md": markdown(rng, 40, 1, 10),
    "sample.lua": lua_source(rng, 45),
    "sample.py": python_source(rng, 40),
    "sample.ts": typescript_source(rng, 55),
    "sample.json": json_document(rng, 160),
    "warmup.md": ["# Warm-up", "", "Text with `code`.", "", *code_block(rng, "lua", 2)],
    "warmup.lua": ["local x = 1", "return x"],
    "warmup.py": ["x = 1"],
    "warmup.ts": ["const x: number = 1;"],
    "warmup.json": ['{"x": 1}'],
  }
  FIXTURES.mkdir(exist_ok=True)
  for name, lines in files.items():
    (FIXTURES / name).write_text("\n".join(lines) + "\n")
    print(f"{name}: {len(lines)} lines")


if __name__ == "__main__":
  main()

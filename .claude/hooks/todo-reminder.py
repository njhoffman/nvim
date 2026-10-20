#!/usr/bin/env python3
"""SessionStart hook: summarize open checkbox items in TODO.md."""
import json
import os
import re
import sys

root = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
path = os.path.join(root, "TODO.md")
if not os.path.isfile(path):
    sys.exit(0)

sections, current = {}, None
with open(path, encoding="utf-8") as f:
    for line in f:
        heading = re.match(r"^##\s+(.*)", line)
        if heading:
            current = heading.group(1).strip()
            continue
        item = re.match(r"^\s*- \[ \]\s+(.*)", line)
        if item and current:
            text = re.sub(r"\*\*|`", "", item.group(1)).strip()
            sections.setdefault(current, []).append(text)

total = sum(len(v) for v in sections.values())
if total == 0:
    sys.exit(0)

summary = [f"{name}: {len(items)} open" for name, items in sections.items()]
detail = [f"## {name}\n" + "\n".join(f"- {t}" for t in items) for name, items in sections.items()]

print(json.dumps({
    "systemMessage": f"TODO.md: {total} open items -- " + "; ".join(summary),
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": (
            "Open items in TODO.md (remind the user of these at the start of the session "
            "and ask which to work on):\n\n" + "\n\n".join(detail)
        ),
    },
}))

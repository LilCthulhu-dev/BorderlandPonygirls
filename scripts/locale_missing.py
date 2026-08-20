#!/usr/bin/env python3
"""List English source strings in .tres / .gd that are not in data/locale/de.json.

Missing keys stay English in-game. Run from the repo root:

    python3 scripts/locale_missing.py
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DE_PATH = ROOT / "data" / "locale" / "de.json"
SKIP_DIRS = {".git", "addons", "android", ".godot"}
FIELD_RE = re.compile(
    r"^(titel|title|txt|description|victory_txt|defeat_txt|success_description|fail_description)\s*=\s*"
    r'"((?:[^"\\]|\\.)*)"',
    re.M,
)
GD_TR_RE = re.compile(r'Utils\.translate\(\s*"((?:[^"\\]|\\.)*)"')
FLAVOR_RE = re.compile(r'Array\[String\]\(\[([^\]]*)\]\)')


def unescape(s: str) -> str:
    return bytes(s, "utf-8").decode("unicode_escape") if "\\" in s else s


def collect() -> list[str]:
    found: list[str] = []
    for path in ROOT.rglob("*"):
        if not path.is_file() or path.suffix not in {".tres", ".gd", ".tscn"}:
            continue
        if any(p in SKIP_DIRS for p in path.parts):
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        if path.suffix == ".tres":
            for m in FIELD_RE.finditer(text):
                found.append(unescape(m.group(2)))
            for m in FLAVOR_RE.finditer(text):
                for q in re.findall(r'"((?:[^"\\]|\\.)*)"', m.group(1)):
                    found.append(unescape(q))
        else:
            for m in GD_TR_RE.finditer(text):
                found.append(unescape(m.group(1)))
            if path.suffix == ".tscn":
                for m in re.finditer(r'^text = "((?:[^"\\]|\\.)*)"', text, re.M):
                    found.append(unescape(m.group(1)))
    return found


def main() -> None:
    de = json.loads(DE_PATH.read_text(encoding="utf-8"))
    seen: set[str] = set()
    missing: list[str] = []
    for raw in collect():
        s = raw.replace("\r\n", "\n").strip()
        if not s or s in seen:
            continue
        seen.add(s)
        if s in de or s.replace("\n", " ") in de:
            continue
        if len(s) < 2 or s.startswith("{") and s.endswith("}") and " " not in s:
            continue
        missing.append(s)
    missing.sort(key=lambda x: (len(x), x.lower()))
    print(f"{len(missing)} missing keys (of {len(seen)} unique sources). de.json has {len(de)}.")
    for s in missing:
        preview = s.replace("\n", "\\n")
        if len(preview) > 160:
            preview = preview[:157] + "..."
        print(preview)


if __name__ == "__main__":
    main()

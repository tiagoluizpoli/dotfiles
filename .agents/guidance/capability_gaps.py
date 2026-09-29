#!/usr/bin/env python3
"""Record reusable technology capability gaps in a private JSON-lines file."""

from __future__ import annotations

import argparse
import json
import sys
import uuid
from datetime import date
from pathlib import Path
from typing import Any


DEFAULT_STORE = Path.home() / ".agents" / "capability-gaps.jsonl"


def normalize_terms(terms: list[str]) -> list[str]:
    normalized: list[str] = []
    for term in terms:
        value = term.strip().lower()
        if not value:
            raise ValueError("terms must not be empty")
        if value not in normalized:
            normalized.append(value)
    return normalized


def read_entries(store: Path) -> list[dict[str, Any]]:
    if not store.exists():
        return []
    return [json.loads(line) for line in store.read_text().splitlines() if line]


def append_entry(store: Path, entry: dict[str, Any]) -> None:
    store.parent.mkdir(parents=True, exist_ok=True)
    with store.open("a", encoding="utf-8") as output:
        output.write(json.dumps(entry, sort_keys=True) + "\n")


def replace_entries(store: Path, entries: list[dict[str, Any]]) -> None:
    store.parent.mkdir(parents=True, exist_ok=True)
    store.write_text(
        "".join(json.dumps(entry, sort_keys=True) + "\n" for entry in entries),
        encoding="utf-8",
    )


def add_entry(arguments: argparse.Namespace) -> dict[str, Any]:
    entry = {
        "id": str(uuid.uuid4()),
        "created_at": date.today().isoformat(),
        "keywords": normalize_terms(arguments.keywords),
        "title": arguments.title.strip(),
        "lesson": arguments.lesson.strip(),
    }
    if not entry["title"] or not entry["lesson"]:
        raise ValueError("title and lesson must not be empty")
    append_entry(arguments.store, entry)
    return entry


def search_entries(arguments: argparse.Namespace, require_all: bool) -> list[dict[str, Any]]:
    terms = set(normalize_terms(arguments.terms))
    matches: list[dict[str, Any]] = []
    for entry in read_entries(arguments.store):
        keywords = set(entry["keywords"])
        if (terms <= keywords) if require_all else (terms & keywords):
            matches.append(entry)
    return matches


def remove_entries(arguments: argparse.Namespace, parser: argparse.ArgumentParser) -> list[str]:
    gates = [
        arguments.configuration,
        arguments.implementation_evidence,
        arguments.verification,
        arguments.reviewed_by_user,
        arguments.approved,
    ]
    if not all(gates):
        parser.error(
            "remove requires configuration, implementation evidence, verification, "
            "user review, and --approved"
        )
    selected = set(arguments.ids)
    entries = read_entries(arguments.store)
    removed = [entry["id"] for entry in entries if entry["id"] in selected]
    replace_entries(arguments.store, [entry for entry in entries if entry["id"] not in selected])
    return removed


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--store", type=Path, default=DEFAULT_STORE)
    commands = parser.add_subparsers(dest="command", required=True)

    add = commands.add_parser("add", help="record a reusable technology gap")
    add.add_argument("--keywords", nargs="+", required=True)
    add.add_argument("--title", required=True)
    add.add_argument("--lesson", required=True)

    for name, help_text in (
        ("search-all", "find entries containing every supplied term"),
        ("search-any", "find entries containing any supplied term"),
    ):
        search = commands.add_parser(name, help=help_text)
        search.add_argument("terms", nargs="+")

    remove = commands.add_parser("remove", help="remove entries after every cleanup gate")
    remove.add_argument("ids", nargs="+")
    remove.add_argument("--configuration")
    remove.add_argument("--implementation-evidence")
    remove.add_argument("--verification")
    remove.add_argument("--reviewed-by-user")
    remove.add_argument("--approved", action="store_true")
    return parser


def main() -> int:
    parser = build_parser()
    arguments = parser.parse_args()
    try:
        if arguments.command == "add":
            result = add_entry(arguments)
        elif arguments.command == "search-all":
            result = search_entries(arguments, require_all=True)
        elif arguments.command == "search-any":
            result = search_entries(arguments, require_all=False)
        else:
            result = remove_entries(arguments, parser)
    except ValueError as error:
        parser.error(str(error))
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())

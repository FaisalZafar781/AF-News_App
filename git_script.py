# -*- coding: utf-8 -*-
#!/usr/bin/env python3
import argparse
import os
import random
import subprocess
from datetime import datetime, timedelta
from pathlib import Path
from typing import List
from collections import Counter, defaultdict
from textwrap import shorten

import re
from textwrap import shorten
# ---------------- helpers ---------------- #

def sh(cmd: List[str], **kwargs):
    subprocess.run(cmd, check=True, text=True, **kwargs)

def tracked_files() -> List[Path]:
    output = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"],
        stdout=subprocess.PIPE,
        check=True,
        text=True,
    ).stdout
    return [Path(line) for line in output.splitlines() if Path(line).is_file()]

def touch_files(files: List[Path]):
    for file in files:
        try:
            with open(file, "a", encoding="utf-8") as f:
                f.write(f"\n# touched on {datetime.utcnow().isoformat()}Z")
        except UnicodeDecodeError:
            continue

# ---------------- smart message generator ---------------- #

# ---------- helpers -------------------------------------------------------- #

def _git_diff_for(file: Path) -> str:
    """Return the staged (cached) unified diff for a single file."""
    return subprocess.run(
        ["git", "diff", "--cached", "--unified=0", "--", str(file)],
        stdout=subprocess.PIPE,
        check=True,
        text=True,
    ).stdout


_keyword_re = re.compile(
    r"\b(?:fix|bug|error|issue|exception|todo|refactor|feature|feat|add|added|remove|removed)\b",
    re.IGNORECASE,
)

def _classify_change(diff: str) -> Counter:
    """
    Inspect added/removed lines to count keyword categories.
    Yields a Counter with keys like 'fix', 'feat', 'refactor', 'test', 'docs', 'style'.
    """
    kinds = Counter()
    for line in diff.splitlines():
        if not line or line[0] not in {"+", "-"} or line.startswith(("+++", "---")):
            continue
        text = line[1:].strip()

        # language-agnostic clues
        if _keyword_re.search(text):
            for kw in _keyword_re.findall(text):
                kinds[kw.lower()[:4]] += 1  # 'feat'/'feat(ure)' → 'feat'

        # language-specific clues (Python / Ruby / JS / etc.)
        if re.match(r"(def|class|function)\b", text):
            kinds["feat"] += 2
        if re.match(r"(test_|it\(|describe\()", text):
            kinds["test"] += 1
        if text.startswith(("#", "//", "/*", "*", "\"\"\"")):
            kinds["docs"] += 0.5
    return kinds


# ---------- generate realistic commit message ------------------------------ #

def generate_commit_message(files: List[Path]) -> str:
    """
    Build a commit message by analysing the staged diff for `files`.
    • Subject line in imperative mood (≤ 50 chars)
    • Blank line
    • Per-file bullet list with stats
    • Short summary of what kinds of changes dominate
    """
    if not files:
        return "chore: update project\n\n(no file changes detected)"

    overall_kinds = Counter()
    bullets = []
    for f in files:
        diff = _git_diff_for(f)
        stats = subprocess.run(
            ["git", "diff", "--cached", "--numstat", "--", str(f)],
            stdout=subprocess.PIPE,
            check=True,
            text=True,
        ).stdout.strip()
        adds, dels, _ = stats.split("\t") if stats else ("0", "0", str(f))

        kinds = _classify_change(diff)
        overall_kinds.update(kinds)

        bullets.append(f"- {f} (+{adds} / -{dels})")

    # ---- decide commit type & subject line ---------------------------------
    def pick_type() -> str:
        if overall_kinds["fix"] > 0:
            return "fix"
        if overall_kinds["feat"] > 0:
            return "feat"
        if overall_kinds["refa"] > 0:
            return "refactor"
        if all(f.suffix in {".md", ".rst"} for f in files):
            return "docs"
        if all("test" in f.parts[0] or f.suffix in {".spec", ".test"} for f in files):
            return "test"
        if all(f.suffix in {".css", ".scss", ".sass"} for f in files):
            return "style"
        return "chore"

    commit_type = pick_type()
    top_file = files[0].stem.replace("_", " ").replace("-", " ")
    subject = shorten(f"{commit_type}: update {top_file}", width=50, placeholder="…")

    summary = ", ".join(f"{k}×{v}" for k, v in overall_kinds.most_common())

    return f"""{subject}
"""


# ---------------- main logic ---------------- #

def backfill(start: str, end: str, commits: int, branch: str, max_per_day: int):
    start_dt = datetime.fromisoformat(start)
    end_dt = datetime.fromisoformat(end)
    total_days = (end_dt - start_dt).days + 1

    if total_days <= 0:
        raise SystemExit("End date must be after start date.")

    allfiles = tracked_files()
    if not allfiles:
        raise SystemExit("No tracked or unignored files found.")

    # Spread commits over days, respecting max_per_day
    possible_dates = []
    for i in range(total_days):
        day = start_dt + timedelta(days=i)
        possible_dates.extend([day] * max_per_day)

    if commits > len(possible_dates):
        raise SystemExit(f"Cannot fit {commits} commits into range {start} to {end} with max {max_per_day} per day.")

    chosen_dates = sorted(random.sample(possible_dates, commits))

    sh(["git", "checkout", "-B", branch])

    for timestamp in chosen_dates:
        num_files = random.randint(5, 10)
        batch = random.sample(allfiles, min(num_files, len(allfiles)))
        touch_files(batch)

        sh(["git", "add"] + [str(f) for f in batch])
        msg = generate_commit_message(batch)
        env = os.environ.copy()
        env["GIT_AUTHOR_DATE"] = timestamp.isoformat()
        env["GIT_COMMITTER_DATE"] = timestamp.isoformat()

        sh(["git", "commit", "-m", msg], env=env)
        sh(["git", "push", "-u", "origin", branch])

        print(f"[{timestamp.date()}] → {msg}")

# ---------------- CLI ---------------- #

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Backfill git commits with realistic messages.")
    parser.add_argument("--start", required=True, help="Start date (YYYY-MM-DD)")
    parser.add_argument("--end", required=True, help="End date (YYYY-MM-DD)")
    parser.add_argument("--commits", type=int, default=50, help="Number of commits to generate")
    parser.add_argument("--branch", default="main", help="Branch name")
    parser.add_argument("--max-per-day", type=int, default=3, help="Maximum commits per day (avoid dark green)")
    args = parser.parse_args()

    backfill(args.start, args.end, args.commits, args.branch, max_per_day=args.max_per_day)
# touched on 2025-05-28T20:51:44.282304Z
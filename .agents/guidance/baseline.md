# Global baseline

## Code navigation

When a repository has a `.codegraph/` index, use CodeGraph before text search
or source reads to locate and understand code. Without an index, use normal
repository tools; never create an index unasked.

## Evidence

Inspect live state before reporting it. State verified facts, assumptions, and
material uncertainty separately. Retain settled decisions; disclose material
drift instead of silently reopening or rewriting them.

## Scope

Work one requested frontier at a time. Keep changes traceable to it. Surface
an ambiguity or meaningful trade-off before it changes scope or outcome.
Prefer the smallest solution that satisfies the request; avoid speculative
abstractions, unrelated cleanup, and impossible-case handling.

## Delivery

Use a dedicated worktree and branch for implementation. Keep commits atomic
and conventional. Commit, push, open a PR, install or configure a capability,
or change credentials only with the user's explicit request.

Verify the affected behavior, repair findings in the current frontier, and
report concise, checkable evidence. If normal work reveals missing safeguards,
report the gap without configuring them autonomously.

## Collaboration

Split parallel work into independent file areas with a public seam and a
verification command. Use the least costly capable agent for each slice. Stop
delegating once work is sequential or owned.

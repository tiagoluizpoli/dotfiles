# Agent coordination

## Durable run state

Keep a run's notes (task ids, briefs, copied specs, reports) in
`~/.local/state/agent-runs/<run>/`. That folder is machine-only: never inside
a repository or the dotfiles. Point workers at issues, commits and that
folder. Session scratchpads and `/tmp` are wiped on reboot.

## Worker briefs

- A brief is pointers, not copies: the ticket number, the spec sections it
  names, prior commits. Name target, change, constraints, ownership and the
  acceptance check.
- Name the integration branch as local: workers merge it by name.
- A gate result is its exit code. A failure counts unless it passes when rerun
  alone; the report shows both runs.

## Models

Match the model to the piece, not the whole task. A spec's or skill's own
model section overrides this one.

- Haiku: read-only lookups that run a command (git, `gh`, grep) and report
  what it shows. No edits, tests, or judgement.
- Sonnet 4.6 (`claude-sonnet-4-6`): simple or mechanical edits, merge-conflict
  fixes, a final full validation run.
- Newest Sonnet: work that needs judgement, code review, review fixes.
- Newest Opus: the coordinator, and only genuinely hard pieces (a toolchain or
  type-level knot that later work depends on).
- Escalate one tier only after a failed attempt, never in advance.

Codex tiers map onto the same roles. Pass them with `--model` (and `--effort`)
on `orca orchestration worker-start --agent codex`:

| Role | Claude | Codex |
|---|---|---|
| Lookups, running and waiting on commands, merge/push, mechanical edits from exact instructions | Haiku | `gpt-6-luna` |
| Ticket implementation, review fixes | Sonnet | `gpt-5.6-terra` |
| Coordinator, code review, genuinely hard pieces | Opus | `gpt-6.1-sol` |

Default effort `medium`; `high` only for a retry or a judgement-heavy fix.

## Codex budget

Codex's five-hour window is small: in spec #599 one `gpt-6.1-sol` worker doing
a whole ticket, then parallel Terra workers, used it up twice. So:

- A Sol coordinator only dispatches, decides and reviews. It never implements
  or watches a gate itself.
- The brief carries everything the worker needs (ticket, named files, decided
  design), so it doesn't explore. Tell it to read only the ticket, the files it
  names and the guidance route for that area, not the whole guidance tree.
- Long gates (`validate:affected`, pre-push) run in the background and block on
  exit; never poll a log with model turns. Hand pure waiting to Luna.
- A dispatched worker can't start its own workers in the coordinator's Run
  (`consumer_fenced`). The coordinator dispatches helpers into the ticket's
  worktree: `--worktree path:<dir> --parent <task_id>`.
- When the limit hits, a Codex worker stops on a "switch model?" menu. After
  the reset, choose "Keep current model" and send it a continue prompt with
  `orca terminal send`. Its worktree and uncommitted work are intact.

## Spec runs (`/implement-spec`)

A spec's own process section overrides this one.

- **Orchestration:** coordinate through Orca (`orca skills get orchestration`):
  one Run, one Task per ticket with dependencies mirroring its blockers, one
  worktree and branch per ticket off the integration branch.
- **Models:** the tiers above, one per ticket.
- **Delegation inside a ticket:** at most coordinator → ticket worker →
  helper. A helper gets the cheapest tier that fits, a self-contained brief,
  and only files the ticket worker names; it never commits. An Opus helper is
  a last resort for a hard sub-problem, with the reason stated in its brief
  and in the worker's report.
- **Token discipline:** the coordinator works from worker reports,
  `git diff --stat` and failing test names, never from code or full logs.
  Workers run the affected gate; one Sonnet 4.6 worker runs the full gate
  once, from a clean generated state.
- **Merging:** before merging a ticket, check its report against evidence
  (exit codes, typecheck). The coordinator merges; it starts a worker only for
  a conflict it can't resolve as a plain union.
- **Heartbeats:** ack them and keep waiting; they carry no decision.

## After a crash or restart

1. Per worktree, list commits ahead and uncommitted files. Uncommitted files
   are the worker's progress: keep them.
2. An empty `.git/index.lock` or `.git/config.lock` with no running git
   process is a crash leftover: remove it.
3. Rebuild lost run notes from the issues before relaunching.
4. Release each dead worker, start a fresh one on the same worktree, and tell
   it to review and continue from the uncommitted changes.

# Agent coordination

## Coordination for the sake of budget

Preserve output quality while reducing context growth, token consumption and
monetary cost across available subscriptions. Keep the continuing session
focused on decisions and results; delegate heavy lifting whose working context
would otherwise accumulate there.

Before substantial exploration or execution, choose the work boundary:

- Delegate broad codebase exploration, online research or substantial
  implementation when a worker can own a bounded question or deliverable
  and return a compact, verifiable result. Context volume and complexity
  are separate: a simple search can still consume substantial context.
- Work locally when the task is small, relevant context is already loaded,
  or briefing and integration would cost more than the context saved.
- Parallelize independent slices with separate ownership. Keep dependent work
  sequential; reuse workers when they already hold the needed context.

Use Orca orchestration and its reporting workflow for delegated heavy lifting,
within or across providers. Load the installed orchestration skill before
dispatch. One main session owns decisions, integration and acceptance;
workers own execution. Return conclusions, evidence and artifact pointers;
keep bulk sources, notes and logs with workers or in durable run state.
Inspect targeted details when needed to verify results or resolve uncertainty.
Acceptance criteria remain the quality bar for every provider.

## Model selection

Match capability to each piece's complexity. Choose the least costly capable
model at the required quality, using current preferences and available
subscription allowance. A spec's or skill's own model section overrides
these defaults.

| Complexity | Work | Tier |
|---|---|---|
| Simple | Bounded lookups, exact mechanical edits, running defined checks | Small |
| Moderate | Implementation with established patterns, routine review fixes, ordinary conflict resolution | Medium |
| Complex | Ambiguous design, difficult diagnosis, consequential review, demanding coordination | High |

Choose the initial tier from the requirements. After a failure caused by
insufficient capability, escalate one tier with the evidence and work so far.
Fix missing context or tool failures at the current tier when those explain
the failure. Default effort is medium where supported; use high for
judgement-heavy work or a retry requiring deeper reasoning. Model tier and
reasoning effort are separate choices.

### Current preferences

Editable user preferences based on observed results, rather than universal
provider rankings. Keep provider and model preferences here for one-place edits.

| Work | Preferred route |
|---|---|
| Code review | Codex, `gpt-6.1-sol`, medium effort, through Orca orchestration |
| Analysis and UI development | GPT models through Codex |
| Backend and other complex implementation | Claude |
| Other implementation | Claude |

For work spanning rows, select per slice. Complexity determines the tier within
the preferred provider. Current mapping carried forward from the existing file:

| Tier | Claude | Codex |
|---|---|---|
| Small | `sonnet-4.5` | `gpt-6-luna` |
| Medium | `sonnet-5.5` | `gpt-5.6-terra` |
| High | `opus-5.5` | `gpt-6.1-sol` |

For any unlisted provider, inspect its available models and supported settings
and map them to the capability tiers above. Select the least costly capable
option for the task; adapt effort controls to that provider. A provider with
fewer models may use one model across tiers. Extend the mapping as needed for
the task without requiring the user to maintain a complete provider table.

Confirm identifiers and supported effort settings against the installed CLI
before dispatch; this table expresses preferences, not verified availability.
When a preferred route is unavailable or out of allowance, preserve progress,
use a capable available alternative and report the substitution. If none is
available, report the blocker.

## Durable run state

Keep a run's notes (task ids, briefs, copied specs, reports) in
`~/.local/state/agent-runs/<run>/`. That folder is machine-only: never inside
a repository or the dotfiles. Point workers at issues, commits and that
folder. Session scratchpads and `/tmp` are not durable run state.

## Worker briefs and reports

- Use pointers to tickets, relevant spec sections and prior commits. Include
  target, change, decided design, constraints, ownership and acceptance checks.
  Carry decisions the worker cannot recover from sources.
- Start with named sources and the guidance route for that area. Follow
  relevant dependencies as needed; report discoveries changing scope or design.
- Name the integration branch as local: workers merge it by name.
- Reports give results, changed files or artifacts, check commands and exit
  codes, unresolved findings and decisions needed. Preserve both results after
  an isolated rerun; explain discrepancies or mark them unresolved before
  treating the gate as satisfied.

## Execution budget

- In delegated runs, the main session dispatches, decides, integrates and
  reviews. Workers perform substantial implementation and validation.
- Run long gates (`validate:affected`, pre-push) in the background and wait
  through the CLI's blocking or completion mechanism. Avoid model turns for
  pure waiting; use a small capable worker only when managing the command
  requires a session.
- Return concise completion reports and targeted failure excerpts. A heartbeat
  needs only the acknowledgement required by the orchestration protocol.

### Orca dispatch and Codex recovery

- A dispatched worker cannot start workers in the coordinator's Run
  (`consumer_fenced`). The coordinator dispatches helpers into the ticket's
  worktree: `--worktree path:<dir> --parent <task_id>`.
- For Codex workers, pass supported `--model` and `--effort` settings on
  `orca orchestration worker-start --agent codex`.
- If a Codex worker stops at a "switch model?" menu after hitting a limit,
  preserve its worktree and uncommitted work. To resume after the reset,
  choose "Keep current model" and send a continue prompt with
  `orca terminal send`. Inspect current terminal state before acting.

## Spec runs (`/implement-spec`)

A spec's own process section overrides this one.

- **Orchestration:** one Orca Run, one Task per ticket with dependencies
  mirroring its blockers, one worktree and branch per ticket off the
  integration branch.
- **Models:** apply model selection per ticket and per helper.
- **Delegation inside a ticket:** at most coordinator → ticket worker →
  helper. The coordinator dispatches helpers requested by ticket workers.
  Each helper gets a bounded brief, the least costly capable tier and named
  starting files; it never commits. Reserve high-tier helpers for hard
  sub-problems, with the reason in the brief and report.
- **Verification:** workers run affected gates. One validation worker runs
  the full gate once from a clean generated state; rerun after changes that
  invalidate the result. Select its tier for the judgement the check needs.
- **Merging:** before merging, check the report against evidence (exit codes,
  typecheck). The coordinator merges; delegate conflicts needing implementation
  judgement. Inspect code or logs when reports leave correctness unresolved.

## After a crash or restart

1. Per worktree, list commits ahead and uncommitted files. Uncommitted files
   are the worker's progress: keep them.
2. Inspect `.git/index.lock` or `.git/config.lock` if present. Remove a lock
   only after confirming it belongs to an interrupted operation and no live
   process is using it.
3. Rebuild lost run notes from issues and surviving work before relaunching.
4. Release each dead worker, start a fresh one on the same worktree, and tell
   it to review and continue from the uncommitted changes.

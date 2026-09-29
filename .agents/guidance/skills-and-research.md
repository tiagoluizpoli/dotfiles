# Skills and research

After classifying the task and targets, select every installed specialist skill
whose description applies. Compose language and technology skills when both
apply; do not select a skill from a raw word match alone.

For unfamiliar or version-sensitive technology, first run
`python3 ~/.agents/guidance/capability_gaps.py search-all <technology terms>`.
Delegate a focused research slice to a low-cost child agent. It checks matching
gaps and current official documentation, reports dated evidence and capability
options, and does not install or configure anything.

Surface a reusable missing capability with the verified options. The user alone
chooses installation or configuration. Record it with
`capability_gaps.py add`; remove it only after its command's evidence and
approval gates are satisfied.

#!/bin/sh

# Orca owns the optional status-line renderer. A missing integration is a
# no-op, so this portable configuration remains usable without Orca.
set -eu

orca_statusline="${HOME:-}/.orca/agent-hooks/claude-statusline.sh"
if [ -x "$orca_statusline" ]; then
  exec "$orca_statusline"
fi

cat >/dev/null 2>&1 || :

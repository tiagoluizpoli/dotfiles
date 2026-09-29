#!/bin/sh

# Keep Claude's settings portable while delegating Orca integration to the
# Orca-provided hook on machines where Orca is installed.
set -eu

orca_hook="${HOME:-}/.orca/agent-hooks/claude-hook.sh"
if [ -x "$orca_hook" ]; then
  exec "$orca_hook"
fi

cat >/dev/null 2>&1 || :
printf '{}\n'

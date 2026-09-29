#!/bin/sh
# Herdr owns its generated agent-state hook. Keep this stable Stow-managed
# wrapper separate so reinstalling or updating Herdr cannot overwrite it.

set -eu

herdr_hook="${HOME:-}/.claude/hooks/herdr-agent-state.sh"
if [ -f "$herdr_hook" ]; then
  exec /bin/sh "$herdr_hook" session
fi

#!/usr/bin/env bash
# Install the optional skills used by the pi-agent-swarm sub-agents.
#
#   npm run skills:install
#
# Installs:
#   chrome-cdp     — MIT, via the skills CLI (best-effort / optional)
#
# The deep-research skill is bundled in the package and installed automatically
# by `pi install` — do NOT copy it here (that creates a duplicate).
set -euo pipefail

echo "→ installing chrome-cdp via the skills CLI"

if command -v npx >/dev/null 2>&1; then
  if npx --yes skills add pasky/chrome-cdp-skill --skill chrome-cdp -g; then
    echo "  ✓ chrome-cdp installed"
  else
    echo "  ℹ chrome-cdp not installed (optional) — run manually to retry"
  fi
else
  echo "  ℹ npx not found — skipping chrome-cdp (optional)"
fi

echo "done."
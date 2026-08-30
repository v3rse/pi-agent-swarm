#!/usr/bin/env bash
# Install the optional skills used by the pi-agent-swarm sub-agents.
#
#   npm run skills:install
#
# Installs:
#   1. deep-research  — vendored in this repo (dependency-free, agent-native)
#   2. chrome-cdp     — MIT, via the skills CLI (best-effort / optional)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"
DEST="${PI_AGENT_DIR:-$HOME/.pi/agent}/skills"

echo "→ installing to $DEST"

# 1. deep-research (published in-repo; no external API key)
mkdir -p "$DEST/deep-research"
cp "$SRC/deep-research/SKILL.md" "$DEST/deep-research/SKILL.md"
echo "  ✓ deep-research → $DEST/deep-research/SKILL.md"

# 2. chrome-cdp (optional; MIT)
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
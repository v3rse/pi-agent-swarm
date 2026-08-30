# Changelog

All notable changes to this project are documented here. This is a fork/port of
[`HazAT/pi-interactive-subagents`](https://github.com/HazAT/pi-interactive-subagents);
see the README for attribution and install.

## 1.0.0

First standalone release of `pi-agent-swarm` (fork of `pi-interactive-subagents` v3.7.2).

### Breaking / notable changes

* Herdr-first multiplexer backend — the legacy `cmux` backend was removed; subagents now run in
  herdr panes (tmux/zellij/wezterm remain supported). Surface IDs are herdr pane ids (`w1:pN`).
* Subagent panes use a **column layout**: the first spawn splits right from the main pane and later
  spawns stack down inside it, keeping the main agent visible beside the subagents.

### Fixes

* Fixed subagent launches aborting with `Aborted while waiting for subagent to finish` in any session
  after the first in the same `pi` process (the module-wide poll `AbortController` wasn't reset on
  `session_start`).

### Features

* **Configurable models** — no hard-coded per-agent models. Bundled agents inherit the dispatching
  session's model by default; set a per-agent `model`/`thinking` once via `subagents.agentOverrides`
  in `settings.json`, or per-spawn with the `model` parameter.
* **Updated bundled agents** — planner ships parallel-worktree & dependency-tagging rules; scout can
  write its `context.md` report; researcher/visual-tester are concise report-focused agents.
* **Bundled `deep-research` skill** — a dependency-free, agent-native skill is shipped in the package
  and installed by `pi install` (no external API key). `npm run skills:install` installs the optional
  MIT `chrome-cdp` skill for visual testing.
* `pi install git:github.com/v3rse/pi-agent-swarm` installs the extension **and** the bundled skill.

### CI

* Added a GitHub Actions workflow that runs the unit test suite on push to `main` and on pull requests.
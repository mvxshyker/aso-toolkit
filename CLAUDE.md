# ASO Toolkit

Slash commands that route to Obsidian workflows. All knowledge, logic, and routing lives in the Obsidian vault. This repo holds only what markdown can't do: skill triggers, scripts, and templates.

## Architecture

- **Obsidian vault** (`~/Documents/Obsidian Vault/ASO/`): Router, workflows, knowledge, client IP rules, output
- **This repo**: Slash command skills (thin pointers to Obsidian), scripts, templates

Every `/aso:*` skill reads `~/Documents/Obsidian Vault/ASO/_Router.md` and follows its routing instructions.

## Repo Structure

```
skills/              # Slash command triggers → point to Obsidian router
  aso-copy/          # /aso:copy → store event & promo copy
  aso-nominate/      # /aso:nominate → Apple editorial nomination pitch
scripts/             # Executable code (API calls, data fetching)
templates/           # Output templates (HTML, formatted reports)
agents/              # Sub-agent definitions (when workflows fork)
install.sh           # Copies skills/agents to ~/.claude/
```

## Install

```bash
./install.sh
```

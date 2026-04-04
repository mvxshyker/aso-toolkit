# ASO Toolkit

Slash commands for Claude Code that write ASO copy. Works standalone with general rules, or connects to a knowledge base for client-specific rules.

## Architecture

- **Skills**: Slash commands with general fallback rules baked in
- **Agents**: Sub-agents for verification (copy-checker) and research (ip-researcher)
- **Knowledge base** (optional, `$ASO_VAULT/`): Router, workflows, client IP rules, output storage

Every `/aso:*` skill checks for `$ASO_VAULT/_Router.md`. If found, it follows the vault's routing. If not, it uses the general rules embedded in the skill.

## Repo Structure

```
skills/              # Slash commands (installed to ~/.claude/skills/)
  aso-copy-promo/    # /aso:copy-promo → store event & promo copy
  aso-copy-metadata/ # /aso:copy-metadata → iOS App Store metadata
  aso-nominate/      # /aso:nominate → Apple editorial nomination pitch
agents/              # Sub-agents (installed to ~/.claude/agents/)
install.sh           # Copies skills/agents to ~/.claude/
```

## Install

```bash
./install.sh
```

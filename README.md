# ASO Toolkit

Slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that write App Store Optimization copy — store event descriptions, promo content, and Apple editorial nomination pitches.

All domain knowledge lives in an **Obsidian vault** you maintain. The toolkit routes Claude through your vault's workflows, IP guidelines, and client rules so copy is accurate, on-brand, and within platform character limits.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- An Obsidian vault with the ASO knowledge graph (router, workflows, IP hubs, client rules)

## Install

```bash
git clone https://github.com/mvxshyker/aso-toolkit.git
cd aso-toolkit

# Point to your Obsidian vault
export ASO_VAULT="/path/to/your/obsidian/vault/ASO"

./install.sh
```

Restart Claude Code after installing.

## Commands

| Command | Description |
|---------|-------------|
| `/aso:copy-promo` | Write store event & promo copy (Apple In-App Events + Google Play) |
| `/aso:nominate` | Write Apple editorial nomination pitches |

### Usage

```
/aso:copy-promo Tekken 8 — Kazuya Mishima, 5-star, Challenge event, 500 gem reward
/aso:nominate Marvel Snap — Silver Surfer, 5-star, Summer Cosmic event
```

Each command reads your vault's `_Router.md`, follows the route to the right workflow and client rules, then writes copy that passes all checks.

## How It Works

```
You run /aso:copy-promo with a brief
        |
        v
Skill reads $ASO_VAULT/_Router.md
        |
        v
Follows route -> loads workflow + IP rules + client rules
        |
        v
Researches character lore (aso-ip-researcher agent)
        |
        v
Writes copy following all rules
        |
        v
Verifies against limits & rules (aso-copy-checker agent)
        |
        v
Presents final copy with compliance report
```

## Vault Structure

The toolkit expects your Obsidian vault to have a `_Router.md` at the root that maps actions (`copy`, `nominate`) to workflow files. Workflows link to an `_IP Hub` which maps games to their IP guidelines. Each game hub has child files for specific actions.

```
ASO/
  _Router.md              # Routes actions to workflows
  _IP Hub.md              # Maps games to IP guideline hubs
  Workflows/
    Store Event Copy Guidelines.md
    Apple Event Nomination Guidelines.md
  Clients/
    {publisher}/
      {game}/
        IP Guidelines.md  # Game-specific hub with action table
        Copy Rules.md     # Client copy rules
        Events/           # Saved output
```

You build the knowledge graph — the toolkit just reads it.

## Repo Structure

```
skills/              # Slash command definitions (installed to ~/.claude/skills/)
  aso-copy-promo/    # /aso:copy-promo
  aso-nominate/      # /aso:nominate
agents/              # Sub-agents (installed to ~/.claude/agents/)
  aso-copy-checker   # Validates copy against rules & character limits
  aso-ip-researcher  # Researches character/IP lore via web search
install.sh           # Copies everything to ~/.claude/
```

## License

[MIT](LICENSE)

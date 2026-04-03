# ASO Toolkit

Slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that write App Store Optimization copy — store event descriptions, promo content, and Apple editorial nomination pitches.

## How It Works

Each skill has two parts:

1. **Step 1 (you customize):** Points to your knowledge base. The skill reads a router file, follows `[[wikilinks]]` through your vault, and collects all the rules — general guidelines, platform specs, client IP rules, defaults.

2. **Steps 2-6 (generic, works for everyone):** Validates the brief, researches IP lore if needed, writes copy, verifies it against all loaded rules and character limits, and saves the result.

**You bring the knowledge. The toolkit brings the workflow.**

The skills don't contain any domain knowledge — no copy rules, no character limits, no client defaults. All of that lives in your knowledge base. You can use Obsidian, a folder of markdown files, or any structure where files link to each other. The skills just need a `_Router.md` entry point that maps actions to workflows.

This means you can:
- Add new clients and games without touching the skills
- Change your rules and the skills automatically pick them up
- Structure your knowledge however makes sense for your workflow

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- A knowledge base with a `_Router.md` entry point (see [Knowledge Base Structure](#knowledge-base-structure))

## Install

```bash
git clone https://github.com/mvxshyker/aso-toolkit.git
cd aso-toolkit

# Point to your knowledge base
export ASO_VAULT="/path/to/your/knowledge-base"

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

## Workflow

```
You run /aso:copy-promo with a brief
        |
        v
Step 1: Read $ASO_VAULT/_Router.md, follow wikilinks
        Load general rules + client/IP rules
        |
        v
Step 2: Validate brief against client defaults
        Only ask for what's truly missing
        |
        v
Step 3: Research character lore if IP rules require it
        (aso-ip-researcher agent, runs in background)
        |
        v
Step 4: Write copy following ALL loaded rules
        |
        v
Step 5: Verify against limits & rules
        (aso-copy-checker agent, loops until PASS)
        |
        v
Step 6: Save approved copy to vault
```

## Knowledge Base Structure

The toolkit expects a `_Router.md` at the root that maps actions to workflow files. Workflows link to client/IP rules through `[[wikilinks]]`. The agent follows every link until it has all applicable rules.

```
your-knowledge-base/
  _Router.md                  # Maps actions (copy, nominate) to workflows
  _IP Hub.md                  # Maps games to their IP/client rules
  Knowledge/
    Store Event Copy Guidelines.md      # General copy rules + output format
    Apple Event Nomination Guidelines.md
    Apple App Store Connect Specs.md    # Platform character limits
    Google Play Console Specs.md
  Clients/
    {publisher}/
      {game}/
        IP Guidelines.md      # Game hub — links to action-specific rules
        App Store Event Copy.md   # Client copy rules, defaults, "only ask if missing"
        Events/               # Saved output
```

### Minimal Router Example

```markdown
# ASO Router

| Action | Workflow |
|--------|----------|
| `copy` | [[Store Event Copy Guidelines]] |
| `nominate` | [[Apple Event Nomination Guidelines]] |
```

Each workflow file links to `[[_IP Hub]]` for client-specific rules. The IP Hub maps games to their IP guidelines. Each game's IP guidelines has an action table pointing to the specific rules file. The agent follows the links — you just maintain the graph.

## Repo Structure

```
skills/              # Slash command definitions (installed to ~/.claude/skills/)
  aso-copy-promo/    # /aso:copy-promo
  aso-nominate/      # /aso:nominate
agents/              # Sub-agents (installed to ~/.claude/agents/)
  aso-copy-checker   # Validates copy against rules & character limits
  aso-ip-researcher  # Researches character/IP lore via web search
install.sh           # Copies skills + agents to ~/.claude/
```

## License

[MIT](LICENSE)

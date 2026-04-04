# ASO Toolkit

Slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that write App Store Optimization copy — store event descriptions, promo content, editorial nomination pitches, and app metadata.

Works out of the box with general ASO knowledge. Connect your own knowledge base for client-specific rules, IP guidelines, and custom defaults.

## Install

```bash
git clone https://github.com/mvxshyker/aso-toolkit.git
cd aso-toolkit
./install.sh
```

Restart Claude Code after installing.

## Commands

| Command | Description |
|---------|-------------|
| `/aso:copy-promo` | Write store event & promo copy (Apple In-App Events + Google Play) |
| `/aso:copy-metadata` | Write optimized iOS App Store metadata (name, subtitle, keywords, description) |
| `/aso:nominate` | Write Apple editorial nomination pitches |

## Agents

Skills launch these sub-agents automatically during their workflow:

| Agent | Model | Role |
|-------|-------|------|
| `aso-copy-checker` | Haiku | Verifies written copy against all applicable rules and character limits. Returns a structured pass/fail compliance report per field. |
| `aso-ip-researcher` | Haiku | Researches character lore, abilities, and IP context via web search. Returns a structured lore brief — facts only, no marketing copy. |

## Output

Every approved piece of copy is saved locally so the skills can learn from your past work — avoiding repeated verbs, hooks, and sentence structures across events. Without a vault, output is saved to `output/` in this repo (gitignored, stays local):

```
output/
  {game}/
    Events/         # Approved store event copy
    Nominations/    # Approved nomination pitches
    Metadata/       # Approved metadata sets
```

The more you use the toolkit, the better it gets at producing varied, non-repetitive copy for each game.

## Two Modes

### Quick Start (no setup needed)

Just install and run. The skills use general ASO best practices and platform character limits. You provide game-specific details in your brief. Approved output is saved to `output/` so the skills build context over time.

### Power User (bring your own knowledge base)

Connect a knowledge base for client-specific rules, IP guidelines, character limits, and defaults that the skills load automatically:

```bash
export ASO_VAULT="/path/to/your/knowledge-base"
./install.sh
```

The skills read a `_Router.md` entry point and follow `[[wikilinks]]` through your knowledge graph to collect all applicable rules. You can use Obsidian, a folder of markdown files, or any structure where files link to each other.

This means you can:
- Add new clients and games without touching the skills
- Change your rules and the skills automatically pick them up
- Build a knowledge graph that grows with your workflow

### Knowledge Base Structure

```
your-knowledge-base/
  _Router.md                  # Maps actions (copy, nominate, metadata) to workflows
  _IP Hub.md                  # Maps games to their IP/client rules
  Knowledge/
    Store Event Copy Guidelines.md
    Apple Event Nomination Guidelines.md
    iOS Metadata Guidelines.md
    Apple App Store Connect Specs.md
    Google Play Console Specs.md
  Clients/
    {publisher}/
      {game}/
        IP Guidelines.md
        App Store Event Copy.md
        Events/
```

#### Minimal Router Example

```markdown
# ASO Router

| Action | Workflow |
|--------|----------|
| `copy` | [[Store Event Copy Guidelines]] |
| `nominate` | [[Apple Event Nomination Guidelines]] |
| `metadata` | [[iOS Metadata Guidelines]] |
```

## License

[MIT](LICENSE)

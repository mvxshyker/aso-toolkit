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

### Usage

```
/aso:copy-promo Tekken 8 — Kazuya Mishima, 5-star, Challenge event, 500 gem reward
/aso:copy-metadata Marvel Puzzle Quest — focus on character collection keywords
/aso:nominate Marvel Snap — Silver Surfer, 5-star, Summer Cosmic event
```

## How It Works

Each skill follows the same pattern:

1. **Load knowledge** — from your knowledge base if connected, or general ASO best practices
2. **Validate the brief** — apply defaults, only ask for what's truly missing
3. **Research** — look up character lore or IP context if needed
4. **Write** — apply all loaded rules, print character counts
5. **Verify** — check against platform limits and rules (copy skills)
6. **Save** — to your knowledge base if connected, or present for copy-paste

## Two Modes

### Quick Start (no setup needed)

Just install and run. The skills use general ASO best practices and platform character limits. You provide game-specific details in your brief. Good for one-off copy or trying things out.

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

## Repo Structure

```
skills/              # Slash commands (installed to ~/.claude/skills/)
  aso-copy-promo/    # /aso:copy-promo
  aso-copy-metadata/ # /aso:copy-metadata
  aso-nominate/      # /aso:nominate
agents/              # Sub-agents (installed to ~/.claude/agents/)
  aso-copy-checker   # Validates copy against rules & character limits
  aso-ip-researcher  # Researches character/IP lore via web search
install.sh           # Copies skills + agents to ~/.claude/
```

## License

[MIT](LICENSE)

# Obsidian Knowledge Graph Rules

Rules for structuring, navigating, and maintaining the ASO knowledge graph in Obsidian.

## Architecture

### Separation of Concerns

- **Obsidian vault**: All knowledge, guidelines, writing rules, IP rules, client defaults, examples. The brain.
- **This repo (aso-toolkit)**: Slash command skills with execution logic (steps, research, save), scripts, templates. The hands.
- Skills contain execution steps. Obsidian contains what those steps read.

### No Data Duplication

- Every fact lives in exactly one file.
- Other files reference it with `[[links]]`, never by copying the data.
- Character limits live in platform spec files. Copy guidelines link to them, never restate them.
- If you find the same data in two files, delete one and link to the other.

## Link Structure

### Tree Navigation (DAG)

All knowledge is organized as a directed acyclic graph. Links flow downward from general to specific:

```
_Router → Workflows → _IP Hub → IP Guidelines → Activity Rules → Scoped Sub-rules
```

- **Go as deep as context requires.** If the request names a specific game, traverse to IP Hub and beyond. If it's generic (no game specified), stop at the workflow level. The workflow file alone is sufficient for generic work.
- **Never skip levels.** When traversing, follow each level in order. Router does not link to leaf nodes. Children do not link up to workflows.
- **Children link only to their parent.** A child file says "Child of [[Parent]]" — nothing else.
- **Parents link only to their children.** Via an action/scope table.
- **No cross-links between branches.** Marvel Copy Rules does not link to Monopoly Copy Rules.

### Link Syntax

- `[[File Name]]` — links to an entire file
- `[[File Name#Heading]]` — links to a specific section (use for token efficiency)
- Use heading-level links when pointing to large reference files to signal which section matters.

### Standalone Files

Platform spec files (Apple App Store Connect Specs, Google Play Console Specs) are standalone reference. They are linked TO by other files but do not link out. They are not part of the routing tree.

## File Naming

- Hub/index files: prefix with `_` (e.g., `_Router.md`, `_IP Hub.md`) — sorts to top in Obsidian.
- IP guidelines: `{IP Name} IP Guidelines.md` (e.g., Marvel IP Guidelines, Monopoly IP Guidelines)
- Activity rules: `{IP Name} {Activity} Rules.md` (e.g., Marvel Copy Rules, Marvel Nomination Rules)
- Scoped sub-rules: `{IP Name} {Scope} {Activity}.md` (e.g., Marvel App Store Event Copy)
- Specs: `{Platform} {Source} Specs.md` (e.g., Apple App Store Connect Specs)
- Date-stamp reference files that may go stale: `> Scraped from {source} — {YYYY-MM-DD}`

## Hierarchy Pattern

### Router Level
Maps actions to workflow files. One row per action.

### Workflow Level (Knowledge/)
General rules for an activity (copy writing, nomination pitching). Not client-specific. Links to `[[_IP Hub]]` for client resolution.

### IP Hub Level (Clients/)
Maps games to IP guideline hubs. One row per game. The single place to add new clients.

### IP Guidelines Level (Clients/{publisher}/{game}/)
Game-specific hub. Contains IP-wide rules (asset constraints, brand rules). Has an action table linking to child rule files.

### Activity Rules Level
Game + activity specific rules (defaults, what to ask, what to infer). May have a sub-rules table linking to scoped children.

### Scoped Sub-rules Level
Narrowest scope — rules for a specific copy type within an activity (app store events, descriptions, etc.).

## Adding New Content

### New Client/Game
1. Create `Clients/{publisher}/{game}/` directory
2. Create `{IP} IP Guidelines.md` with asset/brand rules and activity table
3. Create child rule files for each activity
4. Add one row to `_IP Hub.md`

### New Action (e.g., audit, assets)
1. Create workflow file in `Knowledge/`
2. Add `Client-specific rules: [[_IP Hub]]` to it
3. Add one row to `_Router.md`
4. Add child rule files under each client that supports this action
5. Create a skill in `aso-toolkit/skills/`

### New Scoped Sub-rule
1. Create the sub-rule file as child of the activity rules file
2. Add one row to the parent's sub-rules table
3. No changes needed anywhere else — the tree handles routing

## Token Efficiency

- Use `[[File#Heading]]` links when referencing large files to signal the relevant section.
- Keep spec files comprehensive but well-headed so sections can be targeted.
- Workflow files should be concise — rules only, no examples (examples go in client files).
- Client rule files carry defaults and examples because they are narrow-scope and small.

# Phase 6: Keyword Research Core - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Users can provide their keyword data and get expanded, scored, and grouped keyword analysis. Creates commands/aso/keywords.md.

</domain>

<decisions>
## Implementation Decisions

### Keyword Data Input (LOCKED — from requirements discussion)
- User provides keyword list (pasted inline, file path, or CSV) — NOT Claude generating from scratch
- Keywords may optionally include volume/difficulty scores from user's paid tools (AppTweak, Sensor Tower, etc.)
- If user provides scores, preserve and display them alongside Claude's analysis
- If no scores provided, use Apple autocomplete presence as directional popularity signal (no fake numbers)

### Keyword Analysis
- Each keyword scored for relevance (semantic fit to app) with explanation — Claude's genuine strength
- Keywords grouped by intent: navigational, feature-seeking, problem-solving, comparison, category
- Expansion via Apple search autocomplete + Claude's semantic reasoning (related terms, synonyms, long-tail)

### App Context Integration
- Reads .aso-context.json if present for app name, category, and existing metadata
- Still works without context (user provides app description manually)

### Claude's Discretion
- Exact prompt structure within the skill file
- How to parse different keyword input formats (CSV, pasted list, file)
- Apple autocomplete query formulation

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- commands/aso/audit.md — established pattern for command file structure, .aso-context.json reading, platform detection
- rules/aso-domain.md — character limits, platform differences (iOS keyword field vs Google Play description indexing)

### Established Patterns
- 3-path input resolution (context file → explicit input → prompt user) from audit.md
- OBSERVED/ESTIMATED labeling convention
- YAML frontmatter with user_invocable: true

</code_context>

<specifics>
## Specific Ideas

- Keywords command should feel complementary to audit — if user ran audit first, keyword research can reference audit findings
- The user is an ASO expert — output should be dense and actionable, not tutorial-level

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>

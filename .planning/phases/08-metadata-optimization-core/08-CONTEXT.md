# Phase 8: Metadata Optimization Core - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning
**Mode:** Auto-generated (new command, decisions clear from requirements)

<domain>
## Phase Boundary

Users can get optimized metadata variants for every text field, respecting platform constraints. Creates commands/aso/optimize.md with title, subtitle, keyword field, and description optimization plus character limit enforcement.

</domain>

<decisions>
## Implementation Decisions

### From Requirements (LOCKED)
- Title optimization: 3-5 variants, keyword-first placement, platform char limits
- Subtitle/Short Desc optimization: 3-5 variants, no keyword duplication with title on iOS
- iOS keyword field: maximize coverage within 100 chars, all formatting rules
- Description: Google Play keyword-integrated copy, iOS conversion-focused copy
- Character limit enforcement: validate all output, show remaining count

### App Context Integration
- Reads .aso-context.json for current metadata (from /aso:app-new)
- Also accepts explicit metadata input (pasted or from prior audit/keyword reports)
- Can consume keyword list from /aso:keywords output

### Claude's Discretion
- Exact prompt structure
- How to generate variant tradeoff explanations (keyword-heavy vs brand-forward vs balanced)
- How to parse keyword input from prior /aso:keywords reports

</decisions>

<code_context>
## Existing Code Insights

- commands/aso/audit.md, commands/aso/keywords.md — established command patterns
- rules/aso-domain.md — character limits, keyword field rules, platform differences
- .aso-context.json — app metadata including current title, subtitle, description

</code_context>

<specifics>
## Specific Ideas

No specific requirements beyond ROADMAP success criteria.

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>

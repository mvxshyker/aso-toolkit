# Phase 3: Audit Metadata Analysis + App Context - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Users can attach an app via /aso:app-new (stores context in .aso-context.json), then run /aso:audit for detailed, platform-aware analysis of every text metadata field. This phase creates three command files: commands/aso/app-new.md, commands/aso/app-clear.md, and commands/aso/audit.md.

</domain>

<decisions>
## Implementation Decisions

### App Context Storage
- .aso-context.json lives in the working directory (project root) — git-trackable, project-specific
- Fields stored: app_name, store_url, platform, title, subtitle (iOS) / short_description (Android), description, rating, rating_count, category, fetched_at
- /aso:app-new fetches metadata via WebSearch for the store URL, then extracts structured data from results
- /aso:audit auto-uses context silently with note "Using active app: {name}" — no confirmation needed; explicit URL overrides context

### Audit Workflow Design
- Audit sections ordered top-down by ranking weight: Title → Subtitle/Short Desc → Description → Keywords (iOS) → Summary
- Description analysis depth: iOS — readability, feature coverage, CTA presence. Google Play — keyword density (~1/250 chars), front-loading, scannability
- Skill prompt references rules/aso-domain.md for scoring rubric and character limits (not duplicated in skill file)
- Keyword field guidance provides strategy advice (comma rules, no duplication, maximize coverage, example format) — guidance only, since actual field cannot be observed

### Claude's Discretion
- Exact prompt structure within skill files
- Error handling when store URL is not found
- WebSearch query formulation for fetching store listings

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- rules/aso-domain.md — ASO domain knowledge (character limits, platform detection, scoring rubric)
- agents/aso-analyst.md — spawnable agent for competitor research (not used in this phase but available)

### Established Patterns
- YAML frontmatter format for commands: name, description, user_invocable: true, arguments
- Commands in commands/aso/ directory auto-namespace to /aso:*
- Rules file referenced via read instruction in skill prompts

### Integration Points
- commands/aso/ directory creates /aso:* namespace
- .aso-context.json in working directory read by all future /aso:* commands

</code_context>

<specifics>
## Specific Ideas

- /aso:app-new should show a brief summary after saving context: "Attached: {app_name} ({platform}) — {rating} stars, {rating_count} ratings"
- /aso:audit should work both with and without app context — context is a convenience, not a requirement

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

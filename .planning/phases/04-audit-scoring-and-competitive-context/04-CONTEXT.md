# Phase 4: Audit Scoring and Competitive Context - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning
**Mode:** Auto-generated (enhancement to existing command — discuss skipped)

<domain>
## Phase Boundary

The audit produces a quantified score with competitive context so users know exactly where they stand and what matters most. This phase adds 4 new sections to the existing commands/aso/audit.md: Rating/Review Summary, Scoring System, Competitive Context (via aso-analyst subagent), and Actionable Recommendations.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — this extends an existing command with well-defined requirements. Use the scoring rubric from rules/aso-domain.md (50% Metadata / 25% Visibility / 25% Conversion) and spawn agents/aso-analyst.md for competitor data.

Key constraints:
- Scoring rubric weights are defined in rules/aso-domain.md — reference, don't duplicate
- Competitive context uses the aso-analyst subagent (agents/aso-analyst.md) for parallel web search
- Recommendations must be paired with every finding, labeled Critical/High/Medium/Low
- The audit command (commands/aso/audit.md) already exists from Phase 3 — extend it

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- commands/aso/audit.md (316 lines) — Phase 3 deliverable, has 4-section analysis
- rules/aso-domain.md — scoring rubric with weights and category breakdowns
- agents/aso-analyst.md — spawnable agent for competitor research

### Integration Points
- New sections append to the existing audit workflow in commands/aso/audit.md
- Scoring references rules/aso-domain.md rubric
- Competitor context spawns agents/aso-analyst.md

</code_context>

<specifics>
## Specific Ideas

No specific requirements beyond ROADMAP success criteria.

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>

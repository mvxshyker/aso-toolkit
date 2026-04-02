# Phase 5: Audit Output and Reporting - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning
**Mode:** Auto-generated (infrastructure enhancement — discuss skipped)

<domain>
## Phase Boundary

The audit command produces a persistent, well-structured report file and a quick inline summary. This phase adds the output/reporting section to the existing commands/aso/audit.md.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. The audit command already has all analysis and scoring sections. This phase adds:
1. Instructions for Claude to write a structured .md report to the working directory
2. Instructions for Claude to print an inline summary with score, grade, and top findings

Key constraints:
- Report filename should include app name and date for easy identification
- Both file output AND inline summary (user decided "both" during project init)
- commands/aso/audit.md already exists at ~571 lines — extend with output section

</decisions>

<code_context>
## Existing Code Insights

- commands/aso/audit.md (571 lines) — full audit with analysis, scoring, competitors, recommendations
- The "Analysis Summary" section at the end of audit.md already has Quick Stats and top findings — the inline summary can reference this
- .aso-context.json provides app_name for report filename

</code_context>

<specifics>
## Specific Ideas

No specific requirements beyond ROADMAP success criteria.

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>

# Phase 7: Keyword Platform Output - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning
**Mode:** Auto-generated (enhancement to existing command)

<domain>
## Phase Boundary

Keyword research produces platform-specific, ready-to-use output and a clear prioritized list. Extends commands/aso/keywords.md with iOS keyword field string, Google Play guidance, prioritized list, and report file output.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All choices at Claude's discretion — extends existing command with well-defined requirements.

Key deliverables:
- iOS: ready-to-paste 100-char keyword field string (comma-separated, optimized per all rules from aso-domain.md)
- Google Play: keyword integration guidance for description writing
- Prioritized final list highlighting top 10-15 focus keywords
- Report file output (.md) + inline summary (matching audit pattern)

</decisions>

<code_context>
## Existing Code Insights

- commands/aso/keywords.md (389 lines) — has input, expansion, relevance scoring, user-data handling, popularity signals, intent grouping, analysis summary
- commands/aso/audit.md — report output pattern to follow (filename convention, Write tool usage)
- rules/aso-domain.md — iOS keyword field rules (100 chars, comma-separated, no spaces, no duplication)

</code_context>

<specifics>
## Specific Ideas

No specific requirements beyond ROADMAP success criteria.

</specifics>

<deferred>
## Deferred Ideas

None.

</deferred>

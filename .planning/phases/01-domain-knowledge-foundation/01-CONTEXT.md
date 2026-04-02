# Phase 1: Domain Knowledge Foundation - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning
**Mode:** Auto-generated (infrastructure phase — discuss skipped)

<domain>
## Phase Boundary

Every subsequent command inherits verified, consistent ASO domain knowledge from a single source of truth. This phase creates the rules file that encodes character limits, platform differences, scoring rubrics, ranking factor weights, best practices, platform auto-detection logic, and the OBSERVED vs ESTIMATED data labeling convention.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase. Use ROADMAP phase goal, success criteria, and codebase conventions to guide decisions.

Key constraints from research:
- Google Play title limit needs verification (30 vs 50 chars — research says 30 since Sept 2021)
- Rules file must be minimal (200-350 lines per architecture research) since it loads into every session
- File goes in rules/ directory for auto-discovery by Claude Code
- No workflows or tool instructions in rules file — only shared constants and knowledge

</decisions>

<code_context>
## Existing Code Insights

No existing code — greenfield project. The repo structure from SESSION_PROMPT.md specifies:
- rules/aso-domain.md as the rules file location in the source repo
- Installs to ~/.claude/aso-toolkit/rules/aso-domain.md (or ~/.claude/rules/ for auto-discovery)

</code_context>

<specifics>
## Specific Ideas

No specific requirements — infrastructure phase. Refer to ROADMAP phase description and success criteria.

</specifics>

<deferred>
## Deferred Ideas

None — infrastructure phase.

</deferred>

---
phase: 04-audit-scoring-and-competitive-context
plan: 02
subsystem: aso-audit
tags: [aso, competitive-analysis, recommendations, aso-analyst, subagent, prioritization]

# Dependency graph
requires:
  - phase: 04-audit-scoring-and-competitive-context
    plan: 01
    provides: "Rating/Review Summary and ASO Score sections in audit command"
  - phase: 03-audit-command-metadata-analysis
    provides: "Title, Subtitle, Description, and Keyword Field analysis sections"
provides:
  - "Competitive Context section with aso-analyst subagent integration (AUDT-08)"
  - "Prioritized Recommendations section with impact labels Critical/High/Medium/Low (AUDT-09)"
  - "Updated Analysis Summary with ASO Score row and top recommendations"
affects: [05-keyword-research, 06-optimize-command]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Subagent delegation via Agent tool for competitive analysis"
    - "Fallback handling for subagent unavailability and insufficient results"
    - "Impact-ordered recommendations: Critical > High > Medium > Low, then Metadata > Visibility > Conversion"
    - "Actionability standard with good/bad examples embedded in command instructions"

key-files:
  created: []
  modified:
    - "commands/aso/audit.md"

key-decisions:
  - "Competitive Context spawns aso-analyst with 4 parameters (app_name, app_category, platform, target_keywords) rather than raw web search in the audit command itself"
  - "Dual fallback: insufficient results (<3 competitors) shows partial data, agent unavailability skips section entirely"
  - "Recommendations ordered by impact then by scoring rubric weight order (Metadata > Visibility > Conversion)"
  - "Minimum 3 recommendations per audit even for well-optimized listings"

patterns-established:
  - "Subagent output displayed directly in parent command output with OBSERVED/ESTIMATED labels preserved"
  - "Impact level definitions table as a reusable reference for recommendation severity"
  - "Actionability standard: each recommendation must be implementable without further research"

requirements-completed: [AUDT-08, AUDT-09]

# Metrics
duration: 2min
completed: 2026-04-02
---

# Phase 04 Plan 02: Competitive Context and Prioritized Recommendations Summary

**Competitive benchmarking via aso-analyst subagent with impact-prioritized recommendations (Critical/High/Medium/Low) synthesizing all audit sections into an actionable improvement plan**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-02T12:16:47Z
- **Completed:** 2026-04-02T12:19:46Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added Competitive Context section that spawns the aso-analyst subagent with app_name, app_category, platform, and target_keywords for competitor benchmarking
- Added fallback handling for both insufficient competitor results and agent unavailability
- Added Competitive Positioning subsection comparing rating, title strategy, and differentiation opportunities against competitors
- Added Prioritized Recommendations section with impact level definitions (Critical/High/Medium/Low) and action timelines
- Recommendation synthesis covers all 7 analysis sections with Finding/Action/Expected Effect format
- Actionability standard with good/bad examples ensures recommendations are specific and implementable
- Updated Analysis Summary: ASO Score row in Quick Stats, top 3 recommendations in Top Findings, Next Steps referencing /aso:optimize

## Task Commits

Each task was committed atomically:

1. **Task 1: Add Competitive Context section with aso-analyst subagent integration** - `74e6812` (feat)
2. **Task 2: Add Prioritized Recommendations section and update Analysis Summary** - `7cf741e` (feat)

**Plan metadata:** pending (docs: complete plan)

## Files Created/Modified
- `commands/aso/audit.md` - Added Competitive Context section (lines 420-477), Prioritized Recommendations section (lines 479-534), updated Analysis Summary (lines 536-561) with ASO Score row, top recommendations format, and /aso:optimize reference

## Decisions Made
- Competitive Context delegates to the aso-analyst subagent rather than performing inline web searches, keeping the audit command focused on analysis while the agent handles data gathering
- Dual fallback approach: partial data scenario (fewer than 3 competitors) still displays what was found; agent unavailability scenario skips the section entirely with a clear error message
- Recommendations ordered first by impact level, then by scoring rubric weight order (Metadata > Visibility > Conversion) within the same impact level
- Minimum 3 recommendations per audit ensures even well-optimized listings receive actionable feedback
- Analysis Summary updated to be a true synthesis rather than a standalone summary: top findings now reference the Prioritized Recommendations section

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Known Stubs
None - all sections produce complete output when the audit command is executed with app data. The competitive context section has explicit fallback handling for cases where the aso-analyst agent is unavailable.

## Next Phase Readiness
- Phase 4 is now complete: all 4 new sections (Rating/Review, ASO Score, Competitive Context, Prioritized Recommendations) are integrated into the audit command
- The audit command now covers the full pipeline: metadata analysis -> scoring -> competitive benchmarking -> actionable recommendations
- The /aso:optimize reference in Next Steps prepares users for Phase 6 (optimize command)
- The aso-analyst subagent integration pattern is established and reusable by future commands

## Self-Check: PASSED

- FOUND: commands/aso/audit.md
- FOUND: 04-02-SUMMARY.md
- FOUND: commit 74e6812
- FOUND: commit 7cf741e

---
*Phase: 04-audit-scoring-and-competitive-context*
*Completed: 2026-04-02*

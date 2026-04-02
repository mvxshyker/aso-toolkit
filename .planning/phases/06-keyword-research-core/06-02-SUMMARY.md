---
phase: 06-keyword-research-core
plan: 02
subsystem: commands
tags: [aso, keywords, user-data, popularity-signals, intent-grouping, autocomplete]

requires:
  - phase: 06-keyword-research-core
    plan: 01
    provides: "commands/aso/keywords.md with input resolution, keyword expansion, relevance scoring"
  - phase: 01-aso-domain-rules
    provides: "rules/aso-domain.md with data integrity directive, OBSERVED/ESTIMATED labeling convention"
provides:
  - "commands/aso/keywords.md -- complete keyword research command with user-data preservation, popularity signals, intent grouping, and analysis summary"
affects: [07-keyword-research-advanced, 08-optimize-command]

tech-stack:
  added: []
  patterns: [USER-PROVIDED data preservation, Apple autocomplete popularity tiers, 5-category intent classification, Analysis Summary quick-stats pattern]

key-files:
  created: []
  modified: [commands/aso/keywords.md]

key-decisions:
  - "Popularity tiers use 4 levels (High/Medium/Low/Unknown) based on Apple autocomplete presence rather than fabricated numeric scores"
  - "Intent grouping priority order: Navigational > Feature-Seeking > Problem-Solving > Comparison > Category for ambiguous keywords"
  - "Volume/Difficulty columns omitted entirely when no user data provided (no empty columns or dashes)"
  - "Popularity signals section skipped entirely when user provides volume/difficulty data (no redundant directional signals)"

patterns-established:
  - "Conditional section skipping: Popularity Signals section omitted when user-provided data exists"
  - "Intent classification with priority disambiguation: 5 categories with explicit priority order for multi-fit keywords"
  - "Analysis Summary pattern: Quick Stats table + Top 5 list + Next Steps, replicating audit.md structure"

requirements-completed: [KWRD-04, KWRD-05]

duration: 1min
completed: 2026-04-02
---

# Phase 6 Plan 2: Keyword Research User Data, Popularity, and Intent Summary

**User-data preservation with [USER-PROVIDED] labeling, Apple autocomplete popularity tiers, 5-category intent grouping, and analysis summary completing the keyword research command**

## Performance

- **Duration:** 1 min
- **Started:** 2026-04-02T13:04:36Z
- **Completed:** 2026-04-02T13:06:29Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Added User-Provided Data Integration section preserving paid-tool volume/difficulty scores with [USER-PROVIDED] labels
- Added Popularity Signals section with 4-tier Apple autocomplete classification (High/Medium/Low/Unknown) as directional proxy when no user data available
- Added Intent Grouping section with 5 intent categories and strategic gap analysis recommendations
- Added Analysis Summary section with quick stats, top 5 keywords, and next steps following audit.md pattern
- File grew from 205 to 389 lines (188 lines added), within the 320-500 target range

## Task Commits

Each task was committed atomically:

1. **Task 1: Add user-data handling, popularity signals, intent grouping, and analysis summary** - `841a0b7` (feat)

## Files Created/Modified
- `commands/aso/keywords.md` - Extended with User-Provided Data Integration, Popularity Signals, Intent Grouping, and Analysis Summary sections

## Decisions Made
- Popularity tiers use 4 discrete levels (High/Medium/Low/Unknown) based on Apple autocomplete presence and competitor title analysis -- avoids fabricating numeric scores while still providing actionable directional guidance
- Intent classification priority order (Navigational > Feature-Seeking > Problem-Solving > Comparison > Category) resolves ambiguous keywords deterministically
- Volume/Difficulty columns are omitted entirely (not shown with dashes) when user has no paid-tool data -- avoids implying data exists
- Popularity Signals section is skipped with an explicit message when user provides volume/difficulty data -- prevents contradictory or redundant signals
- Replaced the interim "Next Steps" placeholder from Plan 01 with the Analysis Summary's actionable next steps

## Deviations from Plan

None -- plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None -- no external service configuration required.

## Next Phase Readiness
- commands/aso/keywords.md is the complete Phase 6 keyword research command covering all 5 requirements (KWRD-01 through KWRD-05)
- Ready for Phase 7 (keyword-research-advanced) which adds platform-specific output formatting (iOS keyword field string, Google Play integration)
- Ready for Phase 8 (optimize-command) which will consume keyword analysis results
- No blockers

## Self-Check: PASSED

- commands/aso/keywords.md: FOUND
- 06-02-SUMMARY.md: FOUND
- Commit 841a0b7: FOUND

---
*Phase: 06-keyword-research-core*
*Completed: 2026-04-02*

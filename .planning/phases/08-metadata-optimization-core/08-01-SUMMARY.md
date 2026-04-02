---
phase: 08-metadata-optimization-core
plan: 01
subsystem: commands
tags: [aso, optimize, metadata, title, subtitle, short-description, character-limits]

# Dependency graph
requires:
  - phase: 01-domain-knowledge-base
    provides: rules/aso-domain.md with character limits, scoring anchors, keyword field rules
  - phase: 03-audit-metadata-analysis
    provides: audit.md command pattern (input resolution, YAML frontmatter, data labeling)
  - phase: 06-keyword-research-core
    provides: keywords.md command pattern and keyword research report format
provides:
  - /aso:optimize command with input resolution, title optimization, and subtitle/short desc optimization
  - 3-path input resolution pattern (explicit argument, .aso-context.json, fallback prompt)
  - Title variant generation with keyword-first placement and platform character limits
  - iOS subtitle optimization with title word deduplication check
  - Google Play short description optimization within 80-char limit
affects: [08-02, 09-validation-report]

# Tech tracking
tech-stack:
  added: []
  patterns: [variant-generation-table, duplication-check, platform-branched-optimization]

key-files:
  created: [commands/aso/optimize.md]
  modified: []

key-decisions:
  - "No Agent tool in optimize command -- single-context workflow matching keywords.md pattern"
  - "iOS subtitle deduplication check warns per-variant rather than blocking generation"
  - "Greenfield handling for missing subtitle/short description treats absence as opportunity"

patterns-established:
  - "Variant table pattern: # | Variant | Chars | Keywords Covered | Strategy columns"
  - "Per-variant character count display: N/30 characters (remaining remaining)"
  - "Platform-branched optimization: iOS subtitle (30 chars) vs Google Play short desc (80 chars)"

requirements-completed: [OPTM-01, OPTM-02, OPTM-03]

# Metrics
duration: 2min
completed: 2026-04-02
---

# Phase 08 Plan 01: Optimize Command - Title and Subtitle Summary

**Optimize command with 3-path input resolution, 3-5 title variants with keyword-first placement, and platform-branched subtitle/short desc optimization with iOS deduplication check**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-02T16:26:38Z
- **Completed:** 2026-04-02T16:28:42Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Created /aso:optimize command file with YAML frontmatter matching audit.md and keywords.md patterns
- Implemented 3-path input resolution (explicit argument with keyword file detection, .aso-context.json, fallback prompt)
- Title optimization generates 3-5 variants with keyword-first placement, 30-char limits, brand preservation, and Google Play prohibited word checks
- iOS subtitle optimization with title word deduplication warnings and 30-char limit
- Google Play short description optimization with 80-char limit and natural keyword integration
- OBSERVED/ESTIMATED data labeling convention throughout

## Task Commits

Each task was committed atomically:

1. **Task 1: Create /aso:optimize command with input resolution, title optimization, and subtitle/short desc optimization** - `fd4b703` (feat)

## Files Created/Modified
- `commands/aso/optimize.md` - Optimize command with input resolution, title optimization (3-5 variants with keyword-first placement), and subtitle/short desc optimization (platform-branched with iOS deduplication check)

## Decisions Made
- No Agent tool in optimize command -- single-context workflow without subagent delegation, matching the keywords.md pattern
- iOS subtitle deduplication check produces per-variant warnings rather than blocking variant generation, giving users visibility into overlaps while still providing options
- Missing subtitle/short description treated as greenfield opportunity with explicit messaging, not an error condition

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Known Stubs
None - the optimize command is a complete instruction file. Title and subtitle/short desc optimization sections are fully specified. iOS keyword field and description optimization are explicitly scoped for Plan 02 per the plan boundary.

## Next Phase Readiness
- Optimize command structure is established for Plan 02 to extend with iOS keyword field composition and description optimization
- Variant table pattern and character count display pattern are established for reuse
- Platform-branched optimization pattern ready for description section (iOS conversion-focused vs Google Play keyword-integrated)

## Self-Check: PASSED

- commands/aso/optimize.md: FOUND
- 08-01-SUMMARY.md: FOUND
- Commit fd4b703: FOUND

---
*Phase: 08-metadata-optimization-core*
*Completed: 2026-04-02*

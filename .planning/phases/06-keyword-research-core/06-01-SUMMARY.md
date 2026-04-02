---
phase: 06-keyword-research-core
plan: 01
subsystem: commands
tags: [aso, keywords, relevance-scoring, autocomplete, semantic-expansion]

requires:
  - phase: 01-aso-domain-rules
    provides: "rules/aso-domain.md with platform detection, character limits, data labeling convention"
  - phase: 03-audit-command
    provides: "commands/aso/audit.md with 3-path input resolution pattern and .aso-context.json schema"
provides:
  - "commands/aso/keywords.md -- keyword research command with input resolution, expansion, and relevance scoring"
affects: [06-02-keyword-research-core, 07-keyword-research-advanced, 08-optimize-command]

tech-stack:
  added: []
  patterns: [USER-PROVIDED data label for user-supplied metrics, platform-adjusted web search queries, seed-count-based expansion targets]

key-files:
  created: [commands/aso/keywords.md]
  modified: []

key-decisions:
  - "No Agent tool in keywords command -- keyword research is a single-context workflow without subagent delegation"
  - "USER-PROVIDED as third data label alongside OBSERVED/ESTIMATED for user-supplied volume/difficulty scores"
  - "Expansion target scales with seed count: 30-50 for small lists, +50% for lists already at 30+"
  - "Relevance scoring independent of popularity -- no fabricated volume numbers per aso-domain.md Data Integrity rules"
  - "Platform-specific relevance notes guide iOS keyword field vs Android description density strategy"

patterns-established:
  - "USER-PROVIDED label: Third data provenance label for metrics users bring from paid ASO tools"
  - "Scaled expansion targets: Dynamic keyword count goals based on input size rather than fixed thresholds"

requirements-completed: [KWRD-01, KWRD-02, KWRD-03]

duration: 2min
completed: 2026-04-02
---

# Phase 6 Plan 1: Keyword Research Command Summary

**Keyword research command with 3-format input parsing, Apple autocomplete + semantic expansion, and 1-10 relevance scoring with per-keyword explanations**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-02T12:59:40Z
- **Completed:** 2026-04-02T13:02:29Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Created commands/aso/keywords.md (205 lines) as the core keyword research command
- Input resolution handles inline lists, file paths, and CSV with optional volume/difficulty columns
- Keyword expansion via Apple search autocomplete (OBSERVED) and Claude semantic reasoning across 5 dimensions (ESTIMATED)
- Relevance scoring on 1-10 scale with explanations, sorted descending, with platform-specific application notes

## Task Commits

Each task was committed atomically:

1. **Task 1: Create /aso:keywords command file with frontmatter and input resolution** - `308cf4a` (feat)

## Files Created/Modified
- `commands/aso/keywords.md` - Keyword research command with YAML frontmatter, 3-path input resolution, keyword expansion, relevance scoring, and data labeling convention

## Decisions Made
- No Agent in allowed-tools: The keywords command operates in a single conversation context without subagent delegation, unlike audit.md which uses aso-analyst for competitive research
- USER-PROVIDED as a third label: User-supplied volume/difficulty data from paid tools (Sensor Tower, AppTweak) is preserved and labeled distinctly from OBSERVED (web-fetched) and ESTIMATED (Claude-inferred) data
- Expansion targets are dynamic: Small seed lists expand to 30-50 candidates, larger lists expand by 50% -- avoids both under-expansion and over-expansion
- Platform-specific relevance notes added: iOS section references keyword field strategy, Android section references description density, helping users apply scores to the right metadata field

## Deviations from Plan

None -- plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None -- no external service configuration required.

## Next Phase Readiness
- commands/aso/keywords.md is ready for Plan 02 which adds intent grouping, popularity signals, and user-data handling
- The relevance scoring table established in this plan provides the foundation for Plan 02's intent categorization
- No blockers for continuing to 06-02

## Self-Check: PASSED

- commands/aso/keywords.md: FOUND
- 06-01-SUMMARY.md: FOUND
- Commit 308cf4a: FOUND

---
*Phase: 06-keyword-research-core*
*Completed: 2026-04-02*

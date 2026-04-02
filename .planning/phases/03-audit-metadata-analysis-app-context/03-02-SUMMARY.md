---
phase: 03-audit-metadata-analysis-app-context
plan: 02
subsystem: commands
tags: [aso, audit, metadata-analysis, platform-detection, ios, android, app-store]

# Dependency graph
requires:
  - phase: 03-01
    provides: .aso-context.json schema and /aso:app-new command that audit reads from
  - phase: 01
    provides: rules/aso-domain.md with character limits, scoring rubric, platform detection
  - phase: 02
    provides: agents/aso-analyst.md subagent (referenced but not used until Phase 4)
provides:
  - "/aso:audit command with full platform-aware metadata analysis workflow"
  - "4-section analysis covering Title, Subtitle/Short Desc, Description, Keywords (iOS)"
  - "3-path input resolution: explicit argument, .aso-context.json, user prompt"
affects: [04-scoring-competitive-context, 05-report-output]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Platform-branched analysis sections (iOS conversion vs Google Play keyword strategy)"
    - "Ranking-weight ordering for audit sections (Title > Subtitle > Description > Keywords)"
    - "OBSERVED/ESTIMATED labeling on every analysis dimension"

key-files:
  created:
    - commands/aso/audit.md
  modified: []

key-decisions:
  - "Agent in allowed-tools list (prepares for Phase 4 competitive analysis via aso-analyst)"
  - "No disable-model-invocation (allows Claude to auto-invoke when user says 'audit my app')"
  - "Keyword field guidance framed as strategy advice only (field contents unobservable externally)"
  - "Description analysis branches fully by platform: iOS readability/CTA/social-proof vs Google Play keyword-density/front-loading/scannability"

patterns-established:
  - "Command file structure: role/scope, input resolution, data fetching, analysis sections, summary, data labeling"
  - "Platform branching pattern: iOS vs Google Play with fundamentally different strategies per field"
  - "Deferral notes for future phases: 'scoring, competitive context, and report file output will be available in a future update'"

requirements-completed: [AUDT-01, AUDT-02, AUDT-03, AUDT-04, AUDT-05]

# Metrics
duration: 3min
completed: 2026-04-02
---

# Phase 3 Plan 2: /aso:audit Command Summary

**Platform-aware metadata audit command covering title, subtitle/short description, description, and iOS keyword field strategy with ranking-weight ordering and OBSERVED/ESTIMATED labeling**

## Performance

- **Duration:** 3 min
- **Started:** 2026-04-02T11:44:33Z
- **Completed:** 2026-04-02T11:48:00Z
- **Tasks:** 1
- **Files created:** 1

## Accomplishments
- Created commands/aso/audit.md (316 lines) as the core audit command -- the highest-value feature in the toolkit
- 3-path input resolution: explicit store URL/app name, .aso-context.json silent auto-load, fallback user prompt
- 4-section metadata analysis ordered by ranking weight: Title (char usage, keyword presence, brand balance, readability), Subtitle/Short Desc (platform-branched: iOS 30-char vs Google Play 80-char), Description (iOS conversion-focused vs Google Play keyword-density), Keywords (iOS-only strategy guidance)
- Full OBSERVED/ESTIMATED data labeling convention integrated throughout all analysis sections

## Task Commits

Each task was committed atomically:

1. **Task 1: Create /aso:audit command file with metadata analysis workflow** - `1c8b2bc` (feat)

## Files Created/Modified
- `commands/aso/audit.md` - Core audit command: YAML frontmatter, 3-path input resolution, data fetching, 4-section platform-aware metadata analysis, summary table, data labeling convention

## Decisions Made
- Agent included in allowed-tools to prepare for Phase 4 competitive analysis via aso-analyst subagent
- No disable-model-invocation field -- allows Claude to auto-invoke audit when user naturally requests it
- Keyword field section framed entirely as strategic recommendations since actual field contents cannot be observed externally
- Description analysis fully branches by platform: iOS gets readability, feature coverage, CTA, social proof analysis; Google Play gets keyword density (1/250 chars benchmark), front-loading, scannability, natural language flow analysis
- Google Play title limit encoded as 30 chars (matching corrected value in aso-domain.md)

## Deviations from Plan

None -- plan executed exactly as written.

## Known Stubs

None -- the audit command is fully self-contained for metadata analysis. Scoring (Phase 4) and report output (Phase 5) are noted as future additions via deferral text, not stubs.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- /aso:audit is complete for metadata analysis scope
- Phase 4 will add scoring system and competitive context (aso-analyst subagent integration)
- Phase 5 will add structured .md report file output
- The command file is designed with clear section boundaries for extending with scoring and competitive context

## Self-Check: PASSED

- FOUND: commands/aso/audit.md (316 lines, within 200-350 target)
- FOUND: commit 1c8b2bc
- VERIFIED: YAML frontmatter with name, description, allowed-tools, argument-hint
- VERIFIED: 3-path input resolution (explicit, .aso-context.json, user prompt)
- VERIFIED: 4 analysis sections in ranking-weight order (Title@98, Subtitle@136, Description@181, Keywords@250)
- VERIFIED: Platform-branched description analysis (iOS conversion vs Google Play keyword density)
- VERIFIED: iOS-only keyword field guidance with unobservability note
- VERIFIED: OBSERVED/ESTIMATED labeling convention
- VERIFIED: References aso-domain.md (not duplicating content)
- VERIFIED: No scoring system, competitive analysis, or report file output (deferred to Phases 4/5)

---
*Phase: 03-audit-metadata-analysis-app-context*
*Completed: 2026-04-02*

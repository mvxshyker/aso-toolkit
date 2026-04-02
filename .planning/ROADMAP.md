# Roadmap: ASO Toolkit

## Overview

The ASO Toolkit is a zero-infrastructure Claude Code skill pack delivering three slash commands (`/aso:audit`, `/aso:keywords`, `/aso:optimize`) plus shared domain knowledge and a parallel-analysis subagent. The roadmap builds foundation-up: verified domain knowledge first, then the highest-value audit command in two passes (analysis then scoring/output), followed by keyword research and metadata optimization each split into core logic and platform-specific output, capped by distribution infrastructure. Every phase delivers a coherent, testable capability.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Domain Knowledge Foundation** - Rules file encoding ASO domain knowledge, platform detection, data labeling conventions
- [ ] **Phase 2: Subagent Infrastructure** - aso-analyst agent for parallel competitive web research
- [ ] **Phase 3: Audit Metadata Analysis + App Context** - App context commands (/aso:app-new, /aso:app-clear) plus core audit with title, subtitle, description, and keyword field analysis
- [ ] **Phase 4: Audit Scoring and Competitive Context** - Weighted scoring system, competitor comparison, prioritized recommendations
- [ ] **Phase 5: Audit Output and Reporting** - Structured report generation with file output and inline summary
- [ ] **Phase 6: Keyword Research Core** - Keyword input, expansion via autocomplete, relevance scoring, intent grouping
- [ ] **Phase 7: Keyword Platform Output** - iOS keyword field string, Google Play integration guidance, prioritized final list
- [ ] **Phase 8: Metadata Optimization Core** - Title, subtitle, description variant generation with character limit enforcement
- [ ] **Phase 9: Optimization Validation and Output** - Before/after comparison, keyword coverage verification, report output
- [ ] **Phase 10: Distribution and Help** - Install script, README, help command

## Phase Details

### Phase 1: Domain Knowledge Foundation
**Goal**: Every subsequent command inherits verified, consistent ASO domain knowledge from a single source of truth
**Depends on**: Nothing (first phase)
**Requirements**: FOUN-01, FOUN-02, FOUN-03
**Success Criteria** (what must be TRUE):
  1. A rules file exists at the correct path that Claude Code would auto-discover, containing character limits for both iOS and Google Play with last-verified dates and source URLs
  2. Platform auto-detection logic is documented in the rules file: given an Apple URL, Google Play URL, numeric ID, or bundle ID, the correct platform is identified
  3. The rules file contains an explicit directive prohibiting fabrication of search volume data, and defines the OBSERVED vs ESTIMATED labeling convention
  4. Scoring rubric weights and category breakdowns (Metadata, Visibility, Conversion) are defined in the rules file so commands can reference them
**Plans:** 1 plan
Plans:
- [x] 01-01-PLAN.md — Create ASO domain knowledge rules file with verified character limits, platform detection, scoring rubric, data integrity directives, and ranking factors

### Phase 2: Subagent Infrastructure
**Goal**: Any skill can spawn a parallel analyst agent that searches the web for competitor data and returns structured results
**Depends on**: Phase 1
**Requirements**: FOUN-04
**Success Criteria** (what must be TRUE):
  1. An agent file exists at the correct path that Claude Code would auto-discover, with appropriate model selection and tool restrictions in frontmatter
  2. The agent accepts an app name/category and returns a structured comparison table of 3-5 competitors (title, subtitle, rating, review count)
  3. The agent file references the shared rules file for platform detection and output conventions
**Plans:** 1 plan
Plans:
- [x] 02-01-PLAN.md — Create aso-analyst subagent with competitor research strategy, input/output contracts, and data integrity guardrails

### Phase 3: Audit Metadata Analysis + App Context
**Goal**: Users can attach an app via /aso:app-new (stores context in .aso-context.json), then run /aso:audit for detailed, platform-aware analysis of every text metadata field
**Depends on**: Phase 1
**Requirements**: ACTX-01, ACTX-02, ACTX-03, AUDT-01, AUDT-02, AUDT-03, AUDT-04, AUDT-05
**Success Criteria** (what must be TRUE):
  1. /aso:app-new accepts a store URL, web-searches the listing, pulls metadata, and saves to .aso-context.json in working directory
  2. /aso:app-clear deletes .aso-context.json
  3. /aso:audit reads .aso-context.json automatically when present (no URL needed); still accepts explicit URL as override
  4. User can invoke /aso:audit with a store URL or app name and the command begins a structured audit workflow
  5. Title analysis reports character count vs platform limit, keyword presence and positioning, and brand-vs-keyword balance
  6. Subtitle (iOS) or short description (Google Play) analysis reports character usage, keyword coverage, and value proposition clarity
  7. Description analysis applies the correct platform strategy: conversion quality for iOS (not indexed), keyword density and flow for Google Play (indexed)
  8. For iOS apps, keyword field guidance covers 100-char strategy with formatting rules (comma-separated, no spaces, no duplication with title/subtitle)
**Plans:** 2 plans
Plans:
- [x] 03-01-PLAN.md — Create app context commands (/aso:app-new and /aso:app-clear) with .aso-context.json schema and platform detection
- [x] 03-02-PLAN.md — Create /aso:audit command with metadata analysis (title, subtitle, description, keyword field guidance)

### Phase 4: Audit Scoring and Competitive Context
**Goal**: The audit produces a quantified score with competitive context so users know exactly where they stand and what matters most
**Depends on**: Phase 2, Phase 3
**Requirements**: AUDT-06, AUDT-07, AUDT-08, AUDT-09
**Success Criteria** (what must be TRUE):
  1. Rating and review summary shows score, count, distribution shape, and category-relative comparison
  2. Weighted scoring system outputs a 0-100 numeric score with letter grade and category breakdowns (Metadata, Visibility, Conversion)
  3. Top 3-5 competitors' titles, subtitles, and ratings are displayed via the aso-analyst subagent
  4. Every audit finding is paired with a specific, actionable recommendation labeled by impact level (Critical, High, Medium, Low)
**Plans:** 2 plans
Plans:
- [x] 04-01-PLAN.md — Add Rating/Review Summary and Weighted Scoring System sections to audit command
- [x] 04-02-PLAN.md — Add Competitive Context (aso-analyst subagent) and Prioritized Recommendations sections, update Analysis Summary

### Phase 5: Audit Output and Reporting
**Goal**: The audit command produces a persistent, well-structured report file and a quick inline summary
**Depends on**: Phase 4
**Requirements**: AUDT-10
**Success Criteria** (what must be TRUE):
  1. Running /aso:audit writes a structured .md report file to the user's working directory with a clear filename
  2. An inline summary is printed in the conversation showing the overall score, letter grade, and top 3 findings
**Plans:** 1 plan
Plans:
- [x] 05-01-PLAN.md — Add Report Output section with .md file generation via Write tool and update Analysis Summary inline references

### Phase 6: Keyword Research Core
**Goal**: Users can provide their keyword data and get expanded, scored, and grouped keyword analysis
**Depends on**: Phase 1
**Requirements**: KWRD-01, KWRD-02, KWRD-03, KWRD-04, KWRD-05
**Success Criteria** (what must be TRUE):
  1. User can invoke /aso:keywords with a keyword list (pasted inline, file path, or CSV) and optionally include volume/difficulty scores from their paid tools
  2. The command expands the seed list with additional candidates discovered via Apple search autocomplete and Claude's semantic reasoning (related terms, synonyms, long-tail)
  3. Each keyword receives a relevance score with a written explanation of its semantic fit to the app
  4. User-provided volume/difficulty data is preserved and displayed alongside Claude's analysis; when absent, Apple autocomplete presence serves as a directional popularity signal without fabricated numbers
  5. Keywords are grouped by intent category: navigational, feature-seeking, problem-solving, comparison, category
**Plans:** 2 plans
Plans:
- [x] 06-01-PLAN.md — Create /aso:keywords command with input resolution, keyword expansion, and relevance scoring
- [x] 06-02-PLAN.md — Add user-data handling, popularity signals, intent grouping, and analysis summary

### Phase 7: Keyword Platform Output
**Goal**: Keyword research produces platform-specific, ready-to-use output and a clear prioritized list
**Depends on**: Phase 6
**Requirements**: KWRD-06, KWRD-07, KWRD-08, KWRD-09
**Success Criteria** (what must be TRUE):
  1. For iOS, the output includes a ready-to-paste keyword field string (100 chars, comma-separated, optimized per all formatting rules)
  2. For Google Play, the output includes keyword integration guidance explaining how to weave priority keywords into description copy
  3. A prioritized final list highlights the top 10-15 focus keywords, combining user-provided scores with relevance analysis
  4. The keyword report is written as a .md file to the working directory and a summary is printed inline
**Plans**: TBD

### Phase 8: Metadata Optimization Core
**Goal**: Users can get optimized metadata variants for every text field, respecting platform constraints
**Depends on**: Phase 1
**Requirements**: OPTM-01, OPTM-02, OPTM-03, OPTM-04, OPTM-05, OPTM-06
**Success Criteria** (what must be TRUE):
  1. User can invoke /aso:optimize with current metadata and target keywords and receive optimized alternatives
  2. Title optimization generates 3-5 variants respecting the platform character limit with keyword-first placement
  3. Subtitle (iOS) or short description (Google Play) optimization generates 3-5 variants; iOS variants avoid keyword duplication with the title
  4. iOS keyword field composition maximizes unique keyword coverage within 100 chars following all formatting rules (comma-separated, no spaces, no duplication, singular forms preferred)
  5. Description optimization produces Google Play keyword-integrated copy and iOS conversion-focused copy, each appropriate to the platform
  6. All generated output is validated against platform character limits and displays remaining character count
**Plans**: TBD

### Phase 9: Optimization Validation and Output
**Goal**: Users can see exactly what changed, verify keyword coverage, and get a persistent report
**Depends on**: Phase 8
**Requirements**: OPTM-07, OPTM-08, OPTM-09
**Success Criteria** (what must be TRUE):
  1. Before/after comparison shows current vs proposed metadata side-by-side with annotated rationale for each change
  2. Keyword coverage verification confirms all priority keywords are represented across the combined metadata fields (title + subtitle + keyword field on iOS, or title + short description + description on Google Play)
  3. The optimization report is written as a .md file to the working directory and a summary is printed inline
**Plans**: TBD

### Phase 10: Distribution and Help
**Goal**: Users can install the toolkit with one command and know how to use every feature
**Depends on**: Phase 5, Phase 7, Phase 9
**Requirements**: DIST-01, DIST-02, DIST-03
**Success Criteria** (what must be TRUE):
  1. install.sh copies all command files, the rules file, and the agent file to the correct ~/.claude/ directories where Claude Code auto-discovers them (no settings.json modification)
  2. install.sh checks that Claude Code is installed before proceeding and exits with a clear message if not found
  3. README documents what the toolkit is, how to install it, the available /aso:* commands with argument syntax, and includes sample output snippets showing what each command produces
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 9 -> 10

Note: Phases 3, 6, and 8 all depend only on Phase 1 and could theoretically execute in parallel, but sequential execution is recommended because audit establishes data-fetch patterns reused by keywords and optimize.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Domain Knowledge Foundation | 0/1 | Planning complete | - |
| 2. Subagent Infrastructure | 0/1 | Planning complete | - |
| 3. Audit Metadata Analysis | 0/2 | Planning complete | - |
| 4. Audit Scoring and Competitive Context | 0/2 | Planning complete | - |
| 5. Audit Output and Reporting | 0/1 | Planning complete | - |
| 6. Keyword Research Core | 0/2 | Planning complete | - |
| 7. Keyword Platform Output | 0/0 | Not started | - |
| 8. Metadata Optimization Core | 0/0 | Not started | - |
| 9. Optimization Validation and Output | 0/0 | Not started | - |
| 10. Distribution and Help | 0/0 | Not started | - |

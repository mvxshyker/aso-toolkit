# Requirements: ASO Toolkit

**Defined:** 2026-04-02
**Core Value:** Any developer can audit and optimize their app store listing in one command, getting actionable, platform-aware recommendations — not generic advice.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Foundation

- [x] **FOUN-01**: Rules file encodes ASO domain knowledge: character limits, platform differences, scoring rubrics, ranking factor weights, best practices
- [x] **FOUN-02**: Platform auto-detection infers iOS vs Android from URL format (apps.apple.com vs play.google.com) or app ID format (numeric vs bundle ID)
- [x] **FOUN-03**: All difficulty, popularity, and volume estimates are clearly labeled ESTIMATED — observed store data labeled OBSERVED
- [x] **FOUN-04**: aso-analyst subagent can be spawned by any skill for parallel web search and competitor data extraction

### App Context

- [x] **ACTX-01**: /aso:app-new accepts a store URL or app name, web-searches the listing, pulls current metadata (title, subtitle, description, rating, category), and saves context to .aso-context.json in the working directory
- [x] **ACTX-02**: /aso:app-clear deletes .aso-context.json, wiping the active app context
- [x] **ACTX-03**: All /aso:* commands (audit, keywords, optimize) read .aso-context.json automatically — no repeated URL/app inputs needed when context exists

### Store Listing Audit

- [x] **AUDT-01**: User can run /aso:audit with a store URL or app name and get a structured audit report
- [x] **AUDT-02**: Title analysis checks character count vs platform limit, keyword presence, keyword positioning, brand vs keyword balance, readability
- [x] **AUDT-03**: Subtitle (iOS) / Short Description (Google Play) analysis checks character usage, keyword coverage, value proposition clarity
- [x] **AUDT-04**: Description analysis evaluates conversion quality (iOS, not indexed) or keyword density and natural flow (Google Play, indexed)
- [x] **AUDT-05**: iOS keyword field guidance advises on 100-char field strategy: comma-separated, no spaces, no duplication with title/subtitle, maximize unique coverage
- [x] **AUDT-06**: Rating/review summary shows score, count, distribution shape, and category comparison
- [x] **AUDT-07**: Weighted scoring system outputs 0-100 numeric score with letter grade and category breakdowns (Metadata, Visibility, Conversion)
- [x] **AUDT-08**: Light competitor context shows top 3-5 competitors' titles, subtitles, and ratings via web search
- [x] **AUDT-09**: Every finding pairs with a specific, actionable recommendation prioritized by impact (Critical/High/Medium/Low)
- [x] **AUDT-10**: Report written as .md file to working directory AND summary printed inline

### Keyword Research

- [x] **KWRD-01**: User can run /aso:keywords with a user-provided keyword list (pasted, file path, or CSV) containing keywords and optionally volume/difficulty scores from their paid tools
- [x] **KWRD-02**: Keyword expansion discovers additional candidates via Apple search autocomplete and Claude's semantic reasoning (related terms, synonyms, long-tail variations)
- [x] **KWRD-03**: Each keyword scored for relevance (semantic fit to app) with explanation — Claude's genuine analytical strength
- [x] **KWRD-04**: If user provides volume/difficulty data, preserve and display it. If not, use Apple autocomplete presence as a directional popularity signal (no fake numbers)
- [x] **KWRD-05**: Keywords grouped by intent: navigational, feature-seeking, problem-solving, comparison, category
- [x] **KWRD-06**: iOS output includes ready-to-paste keyword field string (100 chars, comma-separated, optimized)
- [x] **KWRD-07**: Google Play output includes keyword integration guidance for description writing
- [x] **KWRD-08**: Prioritized final list with top 10-15 focus keywords clearly highlighted, combining user-provided scores + relevance analysis
- [x] **KWRD-09**: Report written as .md file to working directory AND summary printed inline

### Metadata Optimization

- [ ] **OPTM-01**: User can run /aso:optimize with current metadata + target keywords and get optimized metadata
- [ ] **OPTM-02**: Title optimization generates 3-5 variants respecting platform char limits with keyword-first placement
- [ ] **OPTM-03**: Subtitle (iOS) / Short Description (Google Play) optimization generates 3-5 variants, no keyword duplication with title on iOS
- [ ] **OPTM-04**: iOS keyword field composition maximizes unique keyword coverage within 100 chars following all rules (comma-separated, no spaces, no duplication, prefer singular forms)
- [ ] **OPTM-05**: Description optimization generates Google Play keyword-integrated copy and iOS conversion-focused copy
- [ ] **OPTM-06**: All output validated against platform character limits with remaining-count display
- [ ] **OPTM-07**: Before/after comparison shows current vs proposed side-by-side with annotated change rationale
- [ ] **OPTM-08**: Keyword coverage verification confirms all priority keywords are represented across metadata fields
- [ ] **OPTM-09**: Report written as .md file to working directory AND summary printed inline

### Distribution

- [ ] **DIST-01**: install.sh copies commands, rules, and agents to ~/.claude/ directories where Claude Code auto-discovers them
- [ ] **DIST-02**: install.sh validates Claude Code is installed before proceeding
- [ ] **DIST-03**: README documents what the toolkit is, how to install, available commands with argument syntax, and sample output snippets

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Localization

- **LOCL-01**: Skills accept --locale flag to tailor keyword research and metadata to specific markets
- **LOCL-02**: Multi-locale keyword research generates separate keyword maps per locale

### Visual Analysis

- **VISL-01**: /aso:audit analyzes user-provided screenshots via Claude vision (composition, caption quality, first-3 priority)
- **VISL-02**: /aso:audit analyzes app icon for simplicity, distinctiveness, category fit

### Cross-Command Intelligence

- **XCMD-01**: /aso:keywords auto-detects prior audit report and uses findings to prioritize keyword gaps
- **XCMD-02**: /aso:optimize auto-detects prior keyword report and consumes it as input

### Distribution Extras

- **DXTR-01**: uninstall.sh cleanly removes all installed files
- **DXTR-02**: Example output files (audit-output.md, keyword-report.md) showing sample output

### Advanced

- **ADVN-01**: Review sentiment mining extracts keyword opportunities from user review language
- **ADVN-02**: Promotional text optimization for iOS 170-char field

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Historical rank tracking / time-series | Requires persistent database and scheduled jobs — violates zero infrastructure |
| Proprietary search volume numbers | No access to Apple/Google APIs — presenting fake numbers destroys credibility |
| Review reply automation | Requires App Store Connect / Play Console OAuth tokens |
| A/B testing management | Requires console API access with real consequences |
| Apple Search Ads integration | Requires OAuth, billing account, enterprise-grade integration |
| Screenshot/icon generation | Claude can analyze but not generate production-quality store visuals |
| Bulk/portfolio operations | Context window pressure makes multi-app runs unreliable |
| Real-time rank monitoring | Requires persistent process and notification system |
| Download/revenue estimation | Requires proprietary panel data only Sensor Tower/data.ai possess |
| MCP servers or API integrations | Violates core zero infrastructure constraint |
| Automated store submission | Irreversible consequences, requires OAuth — too risky for CLI tool |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUN-01 | Phase 1 | Complete |
| FOUN-02 | Phase 1 | Complete |
| FOUN-03 | Phase 1 | Complete |
| FOUN-04 | Phase 2 | Complete |
| ACTX-01 | Phase 3 | Complete |
| ACTX-02 | Phase 3 | Complete |
| ACTX-03 | Phase 3 | Complete |
| AUDT-01 | Phase 3 | Complete |
| AUDT-02 | Phase 3 | Complete |
| AUDT-03 | Phase 3 | Complete |
| AUDT-04 | Phase 3 | Complete |
| AUDT-05 | Phase 3 | Complete |
| AUDT-06 | Phase 4 | Complete |
| AUDT-07 | Phase 4 | Complete |
| AUDT-08 | Phase 4 | Complete |
| AUDT-09 | Phase 4 | Complete |
| AUDT-10 | Phase 5 | Complete |
| KWRD-01 | Phase 6 | Complete |
| KWRD-02 | Phase 6 | Complete |
| KWRD-03 | Phase 6 | Complete |
| KWRD-04 | Phase 6 | Complete |
| KWRD-05 | Phase 6 | Complete |
| KWRD-06 | Phase 7 | Complete |
| KWRD-07 | Phase 7 | Complete |
| KWRD-08 | Phase 7 | Complete |
| KWRD-09 | Phase 7 | Complete |
| OPTM-01 | Phase 8 | Pending |
| OPTM-02 | Phase 8 | Pending |
| OPTM-03 | Phase 8 | Pending |
| OPTM-04 | Phase 8 | Pending |
| OPTM-05 | Phase 8 | Pending |
| OPTM-06 | Phase 8 | Pending |
| OPTM-07 | Phase 9 | Pending |
| OPTM-08 | Phase 9 | Pending |
| OPTM-09 | Phase 9 | Pending |
| DIST-01 | Phase 10 | Pending |
| DIST-02 | Phase 10 | Pending |
| DIST-03 | Phase 10 | Pending |

**Coverage:**
- v1 requirements: 38 total
- Mapped to phases: 38
- Unmapped: 0

---
*Requirements defined: 2026-04-02*
*Last updated: 2026-04-02 after adding app context requirements*

# ASO Toolkit

## What This Is

An installable skill pack for Claude Code that gives users `/aso:*` slash commands for App Store Optimization. Users clone the repo, run `install.sh`, and get store listing audits, keyword research, and metadata optimization — all powered by Claude's native capabilities (vision, web search, file I/O). Zero infrastructure: no MCP servers, no API keys, no dependencies.

## Core Value

Any developer can audit and optimize their app store listing in one command, getting actionable, platform-aware recommendations — not generic advice.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Store listing audit with scoring and actionable recommendations
- [ ] Keyword research with difficulty/relevance scoring and intent grouping
- [ ] Metadata optimization respecting platform character limits
- [ ] Shared ASO domain knowledge (rules file)
- [ ] Specialized aso-analyst agent for parallel analysis
- [ ] Install script that auto-registers with Claude Code settings.json
- [ ] README with usage examples and sample output
- [ ] Platform auto-detection (iOS vs Android from URL/ID format)
- [ ] Light competitive comparison (top 3-5 competitors' titles/subtitles/ratings)
- [ ] Both file output and inline summary for all reports

### Out of Scope

- Localization/multi-locale support — English only for v1, add later
- Full competitive matrix — light comparison sufficient, users can audit competitors separately
- MCP servers or API integrations — zero infrastructure constraint
- OAuth or API key requirements — must work with no setup beyond install.sh
- Python or other runtime dependencies — pure markdown skills only
- A/B test management — domain knowledge covers thresholds, but no active test tooling
- Bulk/batch operations across multiple apps — single app per command for v1

## Context

- **Distribution model:** Public GitHub repo (mvxshyker/aso-toolkit). Clone → install → use.
- **Architecture:** Modeled after GSD's approach. Everything installs into `~/.claude/aso-toolkit/` — one dedicated directory.
- **Skill format:** Markdown files with YAML frontmatter. Skills use Claude's native tools (WebSearch, Read, Write, Agent).
- **Target users:** Both indie developers (need explanations) and ASO professionals (need dense, actionable output). Default to clear language, keep output structured enough for experts.
- **Platform handling:** Auto-detect iOS vs Android from URL/app ID format. Fall back to asking user.
- **Output format:** Write structured .md report to working directory AND print summary inline.
- **Competitor analysis:** Light — top 3-5 competitors' titles, subtitles, ratings for context.

## Constraints

- **Zero infrastructure**: No MCP servers, no OAuth, no API keys, no Python. Pure markdown skills leveraging Claude's native capabilities.
- **Install simplicity**: Clone repo, run install.sh, done. install.sh auto-registers paths in ~/.claude/settings.json.
- **Character limits**: iOS — 30 char title, 30 char subtitle, 100 char keyword field. Google Play — 50 char title, 80 char short description. Skills must enforce these.
- **No hallucinated data**: Use web search for real store data. Clearly mark estimates vs. observed data.
- **File size**: Skills are self-contained markdown. Small files, high cohesion.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Zero infrastructure (no MCP/APIs) | Lowest friction install. Clone → use. | — Pending |
| GSD-style directory structure | Proven pattern, single dedicated directory | — Pending |
| Ship aso-analyst agent in v1 | Skills can spawn it for parallel web search/analysis | — Pending |
| English only for v1 | Keep scope tight, add locale support later | — Pending |
| Auto-detect platform from URL | Less friction than requiring --platform flag | — Pending |
| Auto-register in settings.json | Users shouldn't have to manually configure paths | — Pending |
| Both file + inline output | File for reference, inline for quick review | — Pending |
| App context via .aso-context.json | /aso:app-new stores app metadata locally, all commands read it automatically. /aso:app-clear resets. | — Pending |
| No settings.json modification | Rules/commands auto-discovered from ~/.claude/ directories per research | ✓ Good |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-02 after initialization*

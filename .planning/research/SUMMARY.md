# Project Research Summary

**Project:** ASO Toolkit (Claude Code Skill Pack)
**Domain:** Claude Code skill pack for App Store Optimization
**Researched:** 2026-04-02
**Confidence:** HIGH

## Executive Summary

The ASO Toolkit is a Claude Code skill pack — three slash commands (`/aso:audit`, `/aso:keywords`, `/aso:optimize`) plus a subagent and a shared rules file. There is no runtime, no database, no API keys. The "stack" is markdown prompt files in specific `~/.claude/` directories that Claude Code auto-discovers. The recommended implementation pattern is: one namespaced commands directory (`commands/aso/`) creating the `/aso:` prefix automatically, one shared rules file loading ASO domain knowledge into every session, and one `aso-analyst` subagent handling parallel competitive web research. The entire install is a file-copy shell script — no JSON manipulation required.

The recommended build order is strict and dependency-driven: the shared rules file (`aso-domain.md`) must be built first because every command inherits from it. The audit command and subagent are built together next (they are tightly coupled). Keywords and optimize follow independently. Distribution infrastructure (install.sh, README) comes last once all commands are finalized. This order is not arbitrary — it mirrors the architecture's dependency graph and avoids the most common pitfall: skills that contradict each other because they each hardcode their own version of platform constraints.

The most critical risk is a two-headed problem with data integrity: (1) Claude will invent keyword search volume numbers if not explicitly prohibited from doing so, and (2) the project's own `PROJECT.md` currently contains a stale character limit (Google Play title is 30 chars, not 50 — changed September 2021). Both failures destroy user trust immediately if shipped. Both are solvable at Phase 1 by creating a single source-of-truth limits reference and an explicit "no hallucinated data" directive in the rules file. A secondary risk is install script correctness: the install script does NOT need to modify `settings.json` at all (Claude Code auto-discovers files placed in the correct directories), eliminating the entire class of settings corruption bugs.

## Key Findings

### Recommended Stack

The toolkit uses the Claude Code commands convention (`~/.claude/commands/<prefix>/<name>.md`) rather than the newer skills directory convention (`~/.claude/skills/<name>/SKILL.md`). The commands path is the right fit for this project because subdirectory names create command namespaces automatically — `commands/aso/audit.md` becomes `/aso:audit` with no additional configuration. The skills path would require longer, non-namespaced names like `/aso-audit`. Both formats are officially supported and auto-discovered; the commands path wins purely on namespace ergonomics.

The iTunes Search API (`https://itunes.apple.com/lookup?id={ID}`) is the single most valuable data source: public, unauthenticated, returns structured JSON with title, subtitle, ratings, description, and more, at 20 requests/minute. Google Play pages render client-side JavaScript and are not reliably scrapable; skills must treat WebSearch as the primary fallback for Google Play data and design for user-provided metadata as the primary input path.

**Core technologies:**
- `commands/aso/*.md` with YAML frontmatter: user-facing `/aso:*` slash commands — auto-discovered, supports frontmatter control, namespacing via subdirectory
- `rules/aso-domain.md`: shared ASO domain knowledge injected into every session — single source of truth for character limits, scoring rubric, platform differences
- `agents/aso-analyst.md` with `model: sonnet`: parallel competitive research subagent — isolates expensive multi-search web work from main conversation context
- `install.sh` (file copy only): distribution mechanism — copies files to `~/.claude/` directories, no settings.json modification needed
- iTunes Search API (no auth): primary structured data source — returns app metadata as JSON from a public Apple endpoint

### Expected Features

**Must have (table stakes):**
- Platform auto-detection from URL/app ID — blocks all other analysis if wrong; deterministic regex rules cover all cases
- Title and subtitle analysis with character count validation — highest-weight ranking field, fundamental audit starting point
- iOS keyword field strategy (100 chars, strict formatting rules) — hidden field that ASO professionals check immediately
- Description analysis with platform-aware strategy — Google Play description IS indexed (keyword density matters); iOS description is NOT indexed (conversion copy only)
- Ratings and review summary — trust signal; below 4.0 is a credibility problem the audit must surface
- Competitor context via web search (3-5 top competitors) — auditing in a vacuum is meaningless to practitioners
- Weighted scoring system (0-100 with letter grade and category breakdown) — quantified urgency beats vague prose
- Actionable recommendations prioritized by impact (Critical/High/Medium/Low) — every finding must pair with a specific implementation step
- Structured .md report output plus inline summary — developers expect a persistent file artifact, not just terminal output
- Seed keyword expansion with relevance scoring and intent grouping — the core keyword research deliverable
- Platform-specific keyword output format — iOS: ready-to-paste keyword field string; Google Play: description integration guidance
- Title/subtitle/description optimization with 3-5 variants per field — users want options with labeled tradeoffs, not a single answer
- iOS keyword field composition respecting all formatting rules — this is where AI optimization genuinely adds value over manual effort
- Character limit enforcement with hard fail on over-limit output — a tool that generates rejected metadata is broken

**Should have (competitive differentiators):**
- Natural language explanations of WHY each issue exists, not just scores — this is the gap indie developers fall into with paid tools
- Semantic keyword relevance reasoning (understanding conceptual relationship, not just string matching) — Claude's native strength
- Google Play prohibited words flagging ("Best", "#1", "Free", "Top") — policy violation risk that many developers miss
- OBSERVED vs ESTIMATED labeling on all data — transparency builds more trust than false precision
- Before/after comparison with annotated change rationale — users need to understand why changes were made to trust them
- Cross-command intelligence: audit output feeds keywords, keywords feed optimize — connected workflow vs three disconnected tools
- Git-native .md output format — ASO metadata changes should be trackable like code changes

**Defer to v2+:**
- Multi-locale optimization — multiplies complexity per locale; English-only v1 is sufficient to validate core value
- Vision-based screenshot and icon analysis — requires user to provide image files; text metadata is universally useful
- Review sentiment mining for keyword discovery — useful but secondary; store page review data is limited via web fetch
- Cross-command auto-chaining — v1 commands work independently; v2 can auto-detect prior reports
- Promotional text optimization (iOS 170 chars) — not indexed for search; lower priority than indexed fields
- Category and competitor auto-discovery without user input
- Custom store listing page guidance (advanced feature most indie devs don't use)

### Architecture Approach

The system has three component types that must stay in their lanes: Rules (always loaded, passive domain knowledge, 200-350 lines max), Commands (loaded on invocation, contain full workflow instructions), and the Agent (spawned by commands for parallel web research, returns structured summaries). The key discipline is keeping the rules file lean — every line costs context budget in every session even when the user is not doing ASO work. Detailed reference material (platform limit tables, keyword formatting rules) goes in the rules file; step-by-step workflows and tool invocation patterns go in commands.

**Major components:**
1. `rules/aso-domain.md` — Passive domain knowledge: character limits, platform detection logic, scoring rubric weights, output format conventions. Always in context. 200-350 lines.
2. `commands/aso/audit.md` — Primary entry point. Orchestrates platform detection, store data fetch, scoring, agent spawn for competitors, report generation. 300-500 lines.
3. `commands/aso/keywords.md` — Seed expansion, relevance scoring, difficulty estimation, intent grouping, platform-specific output. 250-400 lines.
4. `commands/aso/optimize.md` — Metadata rewrite with character limit enforcement, before/after comparison, variant generation. 200-350 lines.
5. `commands/aso/help.md` — Static command reference card. 80-120 lines.
6. `agents/aso-analyst.md` — Competitive analysis specialist. Searches for 3-5 competitors, extracts structured metadata, returns comparison table. Sonnet model. Not user-invocable directly.
7. `install.sh` / `uninstall.sh` — File copy only. Creates `~/.claude/commands/aso/`, `~/.claude/agents/`, `~/.claude/rules/`. No settings.json modification. Idempotent.

### Critical Pitfalls

1. **Hallucinated keyword data presented as fact** — Neither Apple nor Google publish search volume publicly. Claude will invent plausible statistics. Prevention: First directive in the rules file must explicitly prohibit inventing volume data. Use qualitative tiers (High/Medium/Low/Niche) only, labeled as ESTIMATE. Two-tier output labeling: OBSERVED for scraped data, ESTIMATED for inferred data.

2. **Wrong character limits hardcoded** — `PROJECT.md` currently states Google Play title limit is 50 chars; the actual limit is 30 chars (changed September 2021). This is unverified — flag for explicit verification against official docs before encoding in rules file. Prevention: Single source-of-truth `aso-domain.md` rules file with last-verified dates and official doc URLs for each limit.

3. **install.sh modifying settings.json** — Research confirms this is unnecessary. Commands, agents, and rules are auto-discovered from `~/.claude/` directories. No `commandPaths` or similar registration field exists in settings.json. Prevention: install.sh does file copies only. This eliminates the entire class of settings corruption, deep-merge, and jq dependency bugs.

4. **WebSearch cannot reliably scrape app store pages** — Google Play renders client-side JavaScript; Apple Store pages may be rate-limited. Prevention: Design for user-provided metadata as the primary input path. WebSearch supplements and searches for competitor snippets. Skills must degrade gracefully and never claim "real-time store data" without qualification.

5. **iOS and Google Play treated as identical** — Description is NOT indexed on iOS but IS indexed on Google Play. Keyword field exists on iOS but not Android. Optimization strategy is fundamentally different per platform. Prevention: Platform detection is the first step in every command. Skills branch logic per platform. Rules file has a prominent "Platform Differences" section.

## Implications for Roadmap

Based on combined research, the dependency graph dictates a clear 5-phase structure. The rules file is the foundation everything else builds on. The audit command is the highest-value feature and most complex. Keywords and optimize are independent but lower-complexity. Distribution infrastructure caps the work.

### Phase 1: Domain Foundation
**Rationale:** All three commands depend on the rules file for character limits, scoring rubric, and platform detection logic. Building it first means every subsequent command inherits correct, consistent domain knowledge rather than each command defining its own constants. This is also when the two most critical correctness problems must be solved: the hallucination directive and verified character limits.
**Delivers:** `rules/aso-domain.md` — the shared knowledge layer. Character limits (verified against official docs), platform detection logic, ASO scoring rubric, output format conventions, explicit "no hallucinated data" directive, OBSERVED/ESTIMATED labeling system.
**Addresses:** Platform detection infrastructure, character limit constants, scoring rubric shared across commands
**Avoids:** Pitfall 1 (hallucinated data), Pitfall 2 (wrong character limits), Pitfall 6 (iOS/Android treated identically)
**Research flag:** Verify Google Play title limit (30 chars, not 50 as in PROJECT.md) against official Google docs before encoding. Verification URL: https://support.google.com/googleplay/android-developer/answer/9859152

### Phase 2: Core Audit Command + Subagent
**Rationale:** The audit command is the primary entry point and the feature with the highest standalone value. It also establishes the data-fetch patterns (iTunes API, WebSearch fallbacks, user-provided metadata) that keywords and optimize will reuse. The subagent is built alongside audit because audit is the command that spawns it — they are tightly coupled.
**Delivers:** `commands/aso/audit.md` + `agents/aso-analyst.md`. Full store listing audit with scoring, competitive context, and .md report output.
**Uses:** iTunes Search API, WebSearch, Claude Agent tool, YAML frontmatter with `allowed-tools`
**Implements:** Primary data flow (platform detection → store fetch → scoring → agent spawn → report generation)
**Avoids:** Pitfall 4 (WebSearch limitations — user-provided data primary, WebSearch supplement), Pitfall 8 (generic output — scoring rubric grounds output in user's specific metadata)
**Research flag:** Test WebSearch behavior with real iOS and Google Play URLs. Confirm iTunes API response structure matches expected fields.

### Phase 3: Keyword Research Command
**Rationale:** Keywords is the natural second user workflow. It can optionally consume audit output (audit gaps inform keyword priorities) but works independently. Building it after audit means the data-fetch and output-format patterns are already established and can be replicated.
**Delivers:** `commands/aso/keywords.md`. Seed keyword expansion, relevance scoring, difficulty estimation (qualitative tiers), intent grouping, platform-specific output format (iOS keyword field string vs. Google Play integration guidance).
**Addresses:** Keyword field composition constraints (iOS formatting rules), difficulty/popularity estimation with honest labeling, prioritized top-15 list
**Avoids:** Pitfall 5 (iOS keyword field formatting — validation step before output), Pitfall 1 (hallucinated search volume — qualitative tiers only)
**Research flag:** Standard domain — iOS keyword field rules are well-documented. No additional research phase needed.

### Phase 4: Metadata Optimization Command
**Rationale:** Optimize is most powerful when it can consume audit and keywords output, but it also works with user-provided raw metadata. Building it after both audit and keywords means the input contracts (what an audit report looks like, what a keyword list looks like) are stable and can be referenced accurately.
**Delivers:** `commands/aso/optimize.md`. Title/subtitle/description rewrites with 3-5 variants per field, iOS keyword field composition, character limit enforcement (hard fail on over-limit), before/after comparison with annotated rationale.
**Addresses:** Character limit enforcement, variant generation with labeled tradeoffs, keyword coverage verification across all fields
**Avoids:** Pitfall 2 (wrong limits — inherits from rules file), Pitfall 6 (platform-specific strategy — iOS keyword puzzle vs. Google Play natural language)
**Research flag:** Google Play prohibited words list ("Best", "#1", "Free", "Top") — include validation step. Verify current policy at https://support.google.com/googleplay/android-developer/answer/9859152

### Phase 5: Distribution and Help
**Rationale:** Help text and install scripts require all commands to be finalized. Help must reference accurate command names, argument formats, and example outputs. Install must know all file paths being distributed. Building last means nothing becomes stale.
**Delivers:** `commands/aso/help.md`, `install.sh`, `uninstall.sh`, `README.md`. Complete, installable, documented skill pack.
**Uses:** File copy only (no settings.json manipulation), directory creation with existence checks, idempotent install
**Implements:** Install path: `~/.claude/commands/aso/` + `~/.claude/agents/aso-analyst.md` + `~/.claude/rules/aso-domain.md`
**Avoids:** Pitfall 3 (install script destroys settings.json — avoided entirely by file-copy-only approach), Pitfall 10 (jq dependency — not needed when not touching JSON)
**Research flag:** Standard patterns — file copy shell scripts are well-understood. No additional research needed.

### Phase Ordering Rationale

- **Rules file first** because it is the shared dependency of all three commands. Building any command before the rules file means the command must define its own constants — creating divergence risk and future maintenance debt.
- **Audit before keywords/optimize** because audit establishes the data-fetch patterns (how to get store metadata via iTunes API and WebSearch), output format conventions, and report structure that the other commands either consume or replicate. Audit is also the highest-value standalone feature.
- **Keywords before optimize** because the keywords command's output format (the prioritized keyword list) is the primary input to the optimizer. Stable keyword output means optimize can write accurate input-parsing logic.
- **Distribution last** because help text, install paths, and README accuracy all depend on finalized command names, argument formats, and file paths. Any command changes after distribution infrastructure is written require updating the distribution files.
- **Agent built with audit (Phase 2)** because the audit command is the primary spawner. Building the agent independently without the calling command risks designing an input/output contract that doesn't match actual usage.

### Research Flags

Phases needing verification or deeper research during planning:
- **Phase 1:** Explicit verification of Google Play title limit (30 vs 50 chars) against official Google Play Console docs before encoding. The conflict between PROJECT.md (50 chars) and research findings (30 chars, changed 2021) must be resolved with a primary source before writing the rules file. Consider also verifying iOS limits against current App Store Connect documentation.
- **Phase 2:** Test actual WebSearch and WebFetch behavior with real app store URLs before finalizing the data-fetch strategy in the audit command. The skill must be designed around observed WebSearch limitations, not assumed capabilities.

Phases with standard patterns (no additional research phase needed):
- **Phase 3:** iOS keyword field rules are extensively documented and stable. Standard keyword research methodology is well-established across ASO industry sources.
- **Phase 4:** Metadata optimization patterns are well-documented. Character limit enforcement is straightforward once Phase 1 limits are verified.
- **Phase 5:** Shell script file copy is a well-understood pattern. No novel architecture required.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Claude Code commands/agents/rules format verified against official docs and direct inspection of `~/.claude/`. All frontmatter fields confirmed. Auto-discovery behavior confirmed. |
| Features | HIGH | Table stakes derived from competitive analysis of paid ASO tools (AppTweak, Sensor Tower, ASODesk) plus direct evaluation of what Claude's native capabilities can deliver. Anti-features clearly bounded by infrastructure constraints. |
| Architecture | HIGH | Component types and responsibilities verified against official Claude Code docs. Build order derived from dependency graph analysis, not preference. Key install.sh simplification (no settings.json manipulation needed) confirmed by direct inspection of settings.json structure. |
| Pitfalls | HIGH | All critical pitfalls verified against official docs or directly observed behavior (hallucination patterns, WebSearch limitations, settings.json structure). Character limit discrepancy is a confirmed problem, not speculation. |

**Overall confidence:** HIGH

### Gaps to Address

- **Google Play title limit (30 vs 50 chars):** The PROJECT.md states 50 chars. Research findings from multiple 2025-2026 ASO industry sources say 30 chars (changed September 2021). Both researchers flagged this conflict. This must be resolved against the official Google Play metadata policy page before encoding in the rules file. Resolution approach: check https://support.google.com/googleplay/android-developer/answer/9859152 at the start of Phase 1.

- **WebSearch reliability for store pages:** Research flagged that Google Play pages are JavaScript-rendered and may not yield structured data via WebFetch. The audit command design must be tested with real URLs before finalizing the data-fetch strategy. The user-provided metadata fallback path should be the primary design, not an afterthought.

- **iTunes API response field coverage:** The STACK.md lists expected response fields from the iTunes API, but the actual field names and availability should be verified with a live API call during Phase 2 implementation. Field names matter for the parsing logic in the audit command.

- **Skill description discovery behavior:** The PITFALLS.md recommends testing whether natural language prompts ("audit my app listing") correctly trigger skills without explicit `/aso:*` invocation. This should be verified during or after Phase 2 with the actual installed commands.

- **Google Play prohibited words list:** The research mentions "Best", "#1", "Free", "Top" as prohibited by policy since 2021. The complete current list should be verified against official Google Play policy documentation before encoding in the optimize command's validation step.

## Sources

### Primary (HIGH confidence)
- [Claude Code Skills/Commands Documentation](https://code.claude.com/docs/en/slash-commands) — Skill format, frontmatter fields, directory structure, auto-discovery
- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents) — Agent format, frontmatter fields, model selection, tool restrictions, delegation patterns
- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings) — Settings scopes, file-based discovery conventions
- [iTunes Search API Documentation](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html) — Public API structure, no auth required
- [Apple Developer: Creating Your Product Page](https://developer.apple.com/app-store/product-page/) — Official iOS character limits
- Direct inspection of `~/.claude/commands/`, `~/.claude/agents/`, `~/.claude/rules/`, `~/.claude/settings.json` — File format, discovery behavior, settings structure
- [Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) — Description format, discovery optimization, frontmatter conventions

### Secondary (MEDIUM confidence)
- [ASOMobile: ASO in 2026 Complete Guide](https://asomobile.net/en/blog/aso-in-2026-the-complete-guide-to-app-optimization/) — Ranking factor weights, metadata strategy, 2025-2026 algorithm shifts
- [MobileAction: App Store Ranking Factors 2026](https://www.mobileaction.co/blog/app-store-ranking-factors/) — Factor weights, retention signal importance
- [AppTweak: Google Play Metadata Policy Changes](https://www.apptweak.com/en/aso-blog/how-to-prepare-for-new-google-metadata-policy-changes) — Google Play title limit reduction to 30 chars (September 2021)
- [AppTweak: How to Optimize Your iOS Keyword Field](https://www.apptweak.com/en/aso-blog/how-to-optimize-your-ios-keyword-field) — iOS keyword field formatting rules
- [AppTweak: Keyword Research Guide 2026](https://www.apptweak.com/en/aso-blog/app-store-keyword-research-aso) — 4-phase keyword methodology
- [Radaso: ASO Audit Comprehensive Guide](https://radaso.com/blog/app-store-optimization-aso-audit-your-comprehensive-guide) — 10-dimension audit framework
- [RespectASO GitHub](https://github.com/respectlytics/respectaso) — Open-source ASO tool using iTunes Search API (AGPL-3.0), reference implementation

### Tertiary (LOW confidence — needs validation)
- ASO ranking factor weights (download velocity, retention, crash rate) — Estimated from industry analysis, not officially published by Apple or Google. Use as directional guidance only.
- WebSearch reliability for app store pages — Flagged as potentially unreliable; must be tested with real URLs during Phase 2.

---
*Research completed: 2026-04-02*
*Ready for roadmap: yes*

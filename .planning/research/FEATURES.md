# Feature Landscape

**Domain:** App Store Optimization (ASO) skill pack for Claude Code
**Researched:** 2026-04-02
**Overall Confidence:** MEDIUM-HIGH

## Context: What We Are and Are Not

This is NOT a SaaS dashboard competing with AppTweak ($69-599/mo), Sensor Tower (enterprise pricing), or data.ai. This is a Claude Code skill pack -- three slash commands that leverage Claude's native capabilities (web search, vision, file I/O, reasoning) to deliver ASO analysis directly in the terminal. Zero infrastructure, no API keys, no databases.

**Our data sources:** Claude's WebSearch (can fetch live app store listings, competitor data, category trends), WebFetch (can scrape Apple App Store pages which return rich metadata including title, subtitle, rating, rating count, description, developer, category, version, size, languages, privacy data), and the user's own knowledge of their app.

**What we cannot do:** Historical rank tracking over time, proprietary search volume APIs, automated A/B testing, review reply automation, Apple Search Ads integration, bulk operations across app portfolios. These require persistent infrastructure.

**Key data reality:** Apple App Store pages return rich structured data via WebFetch (title, subtitle, rating with distribution, description, developer, category, version, size, languages, content rating, privacy labels). Google Play pages render client-side JavaScript and return only configuration data to WebFetch -- we rely on WebSearch for Google Play metadata. Neither platform exposes search volume or keyword ranking data publicly. The iTunes Search API is public and free (no auth, ~20 calls/min) but returns app catalog data, not ASO metrics.

---

## Table Stakes

Features users expect. Missing any of these and the skill pack feels incomplete or toy-like.

### /aso:audit Table Stakes

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Title analysis (length, keyword presence, readability) | Every ASO tool starts here. Title is the highest-weight ranking factor on both platforms. | Low | Check char count vs platform limit (iOS 30 chars, Google Play 30 chars as of 2021 policy change). Assess keyword positioning (earlier = more weight), brand vs keyword balance, readability. |
| Subtitle / Short Description analysis | Second most important text field. ASO professionals check this immediately. | Low | iOS subtitle: 30 chars, Apple combines title+subtitle keywords. Google Play short desc: 80 chars, indexed for search. Assess keyword coverage, value proposition clarity. |
| Description analysis | Users expect full-text audit. Google Play indexes the full description for ranking. | Medium | iOS description: 4,000 chars, NOT indexed for search -- audit for conversion quality. Google Play description: 4,000 chars, IS indexed -- audit for keyword density (~1 exact match per 250 chars) and natural integration. |
| Keyword field guidance (iOS only) | ASO professionals know about the hidden 100-char keyword field. If we ignore it, credibility drops immediately. | Low | Cannot observe competitor keyword fields (Apple hides them), but MUST advise on strategy: comma-separated, no spaces after commas, no duplicates with title/subtitle (Apple auto-combines), maximize unique term coverage. |
| Rating and review summary | Rating is the first trust signal users see. Below 4.0 means significant credibility problems. | Low | Fetch live rating and count from store page. Assess: score vs category average, volume adequacy, distribution shape (healthy = heavy 5-star skew). Icon/screenshots can impact conversion by 20-30%, but rating is the trust gate. |
| Platform-specific rules | iOS and Google Play have fundamentally different indexing, different limits, different ranking algorithms. Treating them the same is a disqualifying error. | Low | Auto-detect from URL/app ID. iOS indexes: title, subtitle, keyword field. Google Play indexes: title, short description, full description. Different character limits, different optimization strategies. |
| Scoring / grading system | Users expect a quantified assessment, not just prose. "Your listing scores 67/100" gives urgency that "your title could be better" does not. | Medium | Weighted scoring across all audit dimensions. Must feel calibrated: title weight > description weight. Letter grade + numeric score. Provide category breakdown (Metadata: B+, Visibility: C, etc.). |
| Actionable recommendations | "Here's what's wrong" without "here's what to do" is useless. Every paid ASO tool pairs problems with solutions. | Low | Every finding must pair with a specific, implementable recommendation. Prioritize by impact (Critical > High > Medium > Low). Include the "why" -- users need to understand the reasoning to trust the advice. |
| Competitor context (light) | Auditing in a vacuum is meaningless. Users need to know how their listing compares to what's actually ranking. | Medium | Fetch 3-5 top competitors in the same category via web search. Extract: titles, subtitles, ratings, rating counts. Show side-by-side. NOT a full competitive matrix -- just enough context to calibrate the audit. |
| Structured report output | Developers expect file output they can reference later, share with teammates, or track in git. | Low | Write .md report to working directory with timestamp. Include all findings, scores, recommendations. Also print inline summary for immediate review. |

### /aso:keywords Table Stakes

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Seed keyword expansion | User provides 3-5 seed terms, tool expands to 30-50+ candidates. Every keyword tool does this. | Medium | Use Claude's semantic knowledge + web search for related terms, synonyms, long-tail variations, user-language terms. Expand in multiple directions: features, benefits, use cases, problems solved. |
| Relevance assessment | Not every keyword is relevant. Irrelevant keywords waste precious character space. Must filter aggressively. | Medium | Claude excels here -- can reason about whether "meditation timer" is relevant to a sleep app by understanding the semantic relationship, not just string matching. Score on a scale, explain reasoning. |
| Difficulty / competition estimate | Users expect some signal about how hard it is to rank. Every paid tool provides this metric. | High | We CANNOT access proprietary APIs. Use heuristic: search for keyword via web, analyze top-ranking apps' authority (rating count, brand recognition, age). Provide qualitative tiers (Low/Medium/High/Very High competition) with methodology explanation. MUST clearly label as ESTIMATE. |
| Popularity / search volume signal | Users want to know if anyone actually searches for a term. | High | No access to Apple's Search Popularity API. Provide qualitative tiers (High/Medium/Low/Niche) based on: auto-complete presence, number of competing apps, category size, common sense reasoning about user behavior. MUST clearly label as ESTIMATE, not data. |
| Keyword grouping by intent | Pro ASO practitioners group keywords by user intent. A flat list is amateur. | Medium | Group by: navigational ("spotify app"), feature-seeking ("playlist maker"), problem-solving ("focus music for studying"), comparison ("best music app free"), category ("music streaming app"). Claude's language understanding makes this natural. |
| Platform-specific output format | iOS keyword field (100 chars, comma-separated, no spaces, no duplicates with title/subtitle) has completely different constraints than Google Play (natural language in description). | Low | iOS output: ready-to-paste keyword field string. Google Play output: keyword integration guidance for description writing. Must be immediately actionable, not just a raw list. |
| Prioritized final list | A raw keyword dump is not useful. Must rank by actionability. | Medium | Combine relevance + estimated difficulty + estimated popularity into a priority ranking. Top 10-15 "focus keywords" clearly called out. Show the full list but highlight what matters most. |

### /aso:optimize Table Stakes

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Title optimization (multiple variants) | Core deliverable. The title is the single most impactful metadata field. | Medium | Respect char limits (iOS 30, Google Play 30). Place highest-value keyword earlier (more ranking weight). Balance brand name vs keywords. Provide 3-5 variants with different tradeoff explanations. |
| Subtitle / Short Description optimization | Directly follows title. These form the "visible metadata pair" users see in search results. | Medium | iOS subtitle (30 chars): extend title keywords -- Apple combines them, so no duplication. Google Play short desc (80 chars): more room for descriptive keyword-rich copy. 3-5 variants each. |
| iOS keyword field composition | The 100-char keyword field is a genuine constraint optimization puzzle. Maximizing coverage within exactly 100 characters is hard and valuable. | High | Rules: comma-separated, no spaces after commas, no duplicates with title or subtitle (Apple auto-combines all three), single words preferred (Apple creates combinations), no plurals if singular covers both. This is where AI optimization genuinely shines. |
| Description optimization | Important for Google Play (indexed) and for conversion on both platforms. | Medium | Google Play: keyword integration at natural density (~1 per 250 chars), front-load key information, structure for scannability. iOS: conversion-focused copy since not indexed -- focus on benefits, social proof, feature highlights. |
| Character limit enforcement | Hard requirement. Over-limit metadata gets rejected by app stores. A tool that generates over-limit output is broken. | Low | Validate every output against platform limits. Display character count and remaining chars. Reject and regenerate if over limit. |
| Before/after comparison | Users need to see what changed and why each change was made. | Low | Show current vs proposed side-by-side. Annotate each change with rationale: "Added 'meditation' keyword (high relevance, medium competition)" |
| Multiple variant generation | Users want options with different tradeoffs, not a single "right answer." | Medium | Generate 3-5 variants per field. Label tradeoffs: "Variant A: Maximum keyword coverage / Variant B: Brand-forward / Variant C: Balanced." Let user choose. |

---

## Differentiators

Things our AI-powered approach enables that traditional dashboard tools cannot do well or at all. These are the reasons someone would use this tool instead of (or alongside) paid ASO tools.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Natural language explanations | Paid tools show scores and charts. We explain WHY something is wrong in plain English with specific fix instructions. This is the gap indie developers fall into -- they see a "keyword difficulty: 73" and don't know what to do with it. | Low | Claude's native strength. Every finding gets explanation a non-expert can act on. "Your title uses 18 of 30 characters -- you're leaving 12 characters of keyword real estate unused." |
| Instant keyword-to-metadata pipeline | In paid tools, keyword research and metadata writing are separate workflows in separate UI tabs. We can go from research to optimized metadata in one command chain. | Medium | /aso:keywords output feeds directly into /aso:optimize. The keyword research report can be consumed by the optimizer. One continuous workflow vs tab-switching. |
| Semantic keyword reasoning | Paid tools use API-derived scores and string matching. Claude can reason about whether "white noise machine" is relevant to a "baby sleep sounds" app -- understanding the conceptual relationship, user intent overlap, and market positioning nuance. | Low | Genuinely better at relevance scoring than keyword-match algorithms. Can explain its reasoning, which builds trust. |
| Live competitive intelligence without API keys | No subscription, no API key, no account creation. Claude searches the web for competitor listings in real time and extracts structured data. | Medium | Fetch competitor store pages, extract titles/subtitles/ratings/descriptions. Data is always current (not cached from a database crawl). Trade-off: less structured than API data, but zero setup friction. |
| Description copywriting (not just keyword insertion) | Paid tools suggest keywords to include. We write actual compelling copy that integrates keywords naturally while maintaining persuasive flow. | Medium | Claude can write conversion-optimized descriptions that read as genuine marketing copy while hitting keyword targets. This bridges the gap between "ASO tool" and "copywriter" -- a combination that normally requires both a tool subscription AND a content writer. |
| Platform strategy adaptation (not just char limits) | The difference between iOS and Google Play is NOT just character limits. The entire optimization strategy differs: iOS is a constrained optimization problem (keyword field puzzle), Google Play is a natural language problem (description SEO). | Medium | We don't just change the character count -- we change the approach. iOS output emphasizes keyword field packing and title/subtitle keyword coverage. Google Play output emphasizes description keyword density and natural language flow. |
| Zero-cost, local-first operation | No $69-599/mo subscription. No data sent to third-party analytics platforms. Works anywhere Claude Code works. | Low | For indie devs and small teams who cannot justify tool subscriptions. The entire ASO workflow for the cost of their existing Claude subscription. |
| Git-native workflow | Reports saved as .md files in the working directory. Can be committed, diffed, tracked over time, shared in PRs, reviewed in code review. | Low | Developers live in git. ASO metadata changes should be trackable like code changes. "Here's the diff between our March and April ASO optimization" is a powerful workflow. |
| Review sentiment synthesis for keyword discovery | Claude can analyze reviews (from store page or user-provided) and extract keyword opportunities from the language real users actually use to describe the app. | Medium | Users describe problems and features in their own words -- those words are keyword opportunities that pure API-based tools miss. "I love using this to fall asleep" reveals "fall asleep" as a keyword opportunity for a meditation app. |
| Cross-command intelligence flow | /aso:audit findings inform /aso:keywords priorities which feed /aso:optimize generation. A coherent analysis pipeline, not three disconnected tools. | Medium | Audit identifies gaps ("no keywords related to 'productivity' despite being a task manager"), keyword research fills them, optimizer writes metadata incorporating them. Each command's output enriches the next. |

---

## Anti-Features

Things to deliberately NOT build. These would add complexity without proportional value, violate our constraints, or mislead users with unreliable data.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Historical rank tracking / time-series data | Requires persistent database, scheduled jobs, cron-like infrastructure. Fundamentally incompatible with "pure markdown skills, zero infrastructure" constraint. | Recommend users re-run audits periodically and diff the .md output files in git. Mention that paid tools (AppTweak, Sensor Tower) handle this if they need it. |
| Proprietary search volume numbers | We have NO access to Apple's Search Popularity API or Google's internal search data. Presenting fabricated numbers as data would destroy credibility with any ASO professional. | Provide qualitative tiers (High/Medium/Low/Niche) with clear methodology explanation. Label ALL estimates as estimates. Transparency about limitations builds more trust than fake precision. |
| Review reply automation | Requires App Store Connect / Google Play Console API access, OAuth tokens, persistent connection. Way beyond "clone + install" scope. | Analyze review sentiment and suggest reply templates/strategies the user can manually post through their console. |
| A/B testing management | Requires App Store Connect Product Page Optimization API or Google Play Console Store Listing Experiments. Requires auth, has real consequences. | Recommend what to A/B test and why ("Test title variant A vs B because competitors in your category emphasize X"). Provide the variants; user sets up the test manually. |
| Apple Search Ads integration | Requires Apple Search Ads API, OAuth, billing account. Enterprise-grade integration. | Note which keywords from our research might perform well in paid search. "These 5 keywords have high relevance but high organic competition -- consider Apple Search Ads." |
| Screenshot / icon generation | Image generation is a fundamentally different capability. Claude can analyze visuals but cannot generate production-quality app store screenshots. | Audit existing visuals if user provides them (Claude vision). Recommend best practices: screenshot count, caption placement, first-3 priority, icon simplicity guidelines. |
| Multi-locale optimization | English-only for v1. Localization multiplies complexity enormously -- keyword research per locale, cultural adaptation of messaging, locale-specific competition analysis. Each locale is almost a full re-run. | Mention localization importance in audit. Note when an app's language support suggests localization opportunity. Flag as explicit future capability. |
| Bulk / portfolio operations | Optimizing 50 apps at once requires batching, rate limiting, queue management, aggregation. Context window pressure alone makes this unreliable. | Single app per command. Users can run commands sequentially for multiple apps. Each run is independent and self-contained. |
| Real-time rank monitoring / alerts | Requires persistent process, notification system, scheduled checks, state management. Antithetical to stateless skill pack model. | Snapshot-in-time analysis. Recommend re-running periodically (monthly for stable apps, bi-weekly during optimization campaigns). |
| Download / revenue estimation | Requires proprietary panel data that only Sensor Tower/data.ai possess. Any estimate we produce would be unreliable guesswork dressed up as analysis. | Focus on what we CAN assess with confidence: metadata quality, keyword coverage, competitive positioning, conversion optimization. These are actionable without download numbers. |
| MCP server or API integrations | Violates the core "zero infrastructure" constraint. MCP servers require running processes, configuration, potential auth tokens. | Use Claude's native tools (WebSearch, WebFetch, Read, Write) exclusively. The entire skill pack runs through Claude's built-in capabilities. |
| Automated store submission | Submitting metadata to App Store Connect or Google Play Console has irreversible consequences and requires OAuth. Far too risky for a CLI tool. | Output optimized metadata as copyable text with character counts verified. User manually pastes into their developer console. |

---

## Feature Dependencies

```
Platform Detection ──> ALL features
  (every analysis depends on knowing iOS vs Android to apply correct rules)

/aso:audit
  ├── Store page fetching (WebSearch/WebFetch)
  │     ├──> Title/subtitle/description extraction
  │     ├──> Rating and review count extraction
  │     └──> Competitor data extraction
  ├── Platform detection
  │     ├──> Character limit validation rules
  │     ├──> Indexing rules (which fields affect ranking)
  │     └──> Platform-specific best practices
  ├── ASO domain knowledge (rules file)
  │     ├──> Scoring rubric and weights
  │     ├──> Best practice benchmarks
  │     └──> Recommendation templates
  └── Scoring system
        └──> Aggregates all audit dimension scores

/aso:keywords
  ├── App context (user-provided description OR from prior audit)
  │     └──> Relevance scoring baseline
  ├── Web search
  │     ├──> Competitor keyword extraction (from titles/descriptions)
  │     ├──> Related term / auto-complete discovery
  │     └──> Competition assessment (who ranks for what)
  ├── Platform detection
  │     └──> Output format (iOS keyword field vs Google Play guidance)
  └── ASO domain knowledge
        └──> Difficulty estimation heuristics

/aso:optimize
  ├── Keyword list (from /aso:keywords OR user-provided)
  │     └──> Target keywords for metadata generation
  ├── Current metadata (from /aso:audit OR user-provided)
  │     └──> Before/after comparison baseline
  ├── Platform detection
  │     ├──> Character limits per field
  │     └──> Strategy selection (keyword puzzle vs copywriting)
  └── ASO domain knowledge
        └──> Optimization rules (no duplication, keyword placement weight, etc.)

Cross-Command Flow (v1: manual, v2: could auto-chain):
  /aso:audit ──report.md──> /aso:keywords (audit gaps inform keyword priorities)
  /aso:keywords ──keywords.md──> /aso:optimize (keyword list feeds metadata gen)
  /aso:audit ──report.md──> /aso:optimize (current metadata as improvement baseline)
```

### Shared Components (Not User Features, But Required Infrastructure)

| Component | Used By | Purpose |
|-----------|---------|---------|
| Platform detection logic | All three skills | Parse URL/ID format to determine iOS vs Android |
| Character limit constants | audit, optimize | iOS: 30 title / 30 subtitle / 100 keyword field / 170 promo text / 4000 desc. Google Play: 30 title / 80 short desc / 4000 desc |
| ASO domain knowledge (rules file) | All three skills | Best practices, ranking factors, scoring rubrics, platform differences |
| Store page fetching patterns | audit, keywords | Common approach to extracting structured data from live store pages via WebSearch/WebFetch |
| Report output formatting | All three skills | Consistent .md output structure with inline summary |
| aso-analyst agent | All three skills | Spawnable agent for parallel web search and competitor analysis |

---

## MVP Recommendation

### Must Ship (v1 Core)

**Priority 1 -- /aso:audit** (most immediately useful, lowest barrier to entry, requires only a store URL from user)
1. Platform auto-detection from URL/app ID
2. Title + subtitle analysis with character count, keyword assessment, readability check
3. Description analysis (conversion-focused for iOS, keyword-density for Google Play)
4. iOS keyword field strategy guidance (cannot observe competitor fields, but advise on user's own)
5. Rating/review summary (score, count, distribution shape, category comparison)
6. Competitor context (top 3-5 competitors' titles, subtitles, ratings via web search)
7. Weighted scoring system (0-100 with letter grade + category breakdowns)
8. Actionable recommendations prioritized by impact (Critical/High/Medium/Low)
9. .md file output + inline summary

**Priority 2 -- /aso:keywords** (high value, builds naturally on audit findings)
1. Seed keyword expansion (user provides seeds, Claude expands via reasoning + web search)
2. Relevance scoring with explanations (semantic fit to app's purpose)
3. Difficulty estimation (heuristic-based, clearly labeled as ESTIMATE)
4. Popularity signal (qualitative tiers: High/Medium/Low/Niche, methodology explained)
5. Intent grouping (navigational, feature-seeking, problem-solving, comparison, category)
6. Platform-specific output (iOS: keyword field-ready string; Google Play: integration guidance)
7. Prioritized final list with top 10-15 focus keywords clearly highlighted

**Priority 3 -- /aso:optimize** (highest individual value but depends on the others for best results)
1. Title optimization (3-5 variants respecting char limits, keyword-first placement)
2. Subtitle / Short Description optimization (3-5 variants, no duplication with title on iOS)
3. iOS keyword field composition (100 chars, maximize unique keyword coverage, respect all rules)
4. Description optimization (Google Play: keyword-integrated copy; iOS: conversion-focused copy)
5. Character limit enforcement with remaining-count display for every output
6. Before/after comparison with annotated change rationale
7. Keyword coverage verification (confirm all priority keywords are represented across fields)

### Defer to v2

| Feature | Reason to Defer |
|---------|----------------|
| Multi-locale support | Multiplies complexity per locale. English-only v1 is sufficient to validate core value. Each locale needs its own keyword research. |
| Vision-based screenshot/icon analysis | Requires user to provide image files. Core text metadata analysis is universally useful and testable. Add visual analysis once text skills are proven. |
| Review sentiment mining for keyword discovery | Useful but secondary to core keyword research. Store page review data is limited via web fetch. Better as a v2 enhancement. |
| Cross-command auto-chaining | v1 skills work independently (user manually feeds output between commands). v2 can auto-detect prior reports and consume them. |
| Promotional text optimization (iOS) | 170 chars, not indexed for search. Lower priority than the indexed fields that directly affect ranking. |
| In-app event / in-app purchase metadata optimization | Niche feature used mainly by larger publishers. Not table stakes for the target audience. |
| Category and competitor auto-discovery | v1 requires user to know their competitors or category. v2 could auto-discover based on app description and category. |
| Custom store listing page guidance | Apple's custom product pages and Google's custom store listings are advanced features most indie devs don't use. |

---

## Prioritization Matrix

| Feature | User Impact | Build Effort | Data Availability | Ship in v1? |
|---------|------------|-------------|-------------------|-------------|
| Platform auto-detection | Critical (blocks everything) | Low | YES (URL patterns) | YES |
| ASO domain knowledge rules file | Critical (blocks everything) | Medium | N/A (our expertise) | YES |
| Title/subtitle analysis | Critical | Low | YES (store page scrape) | YES |
| Character limit validation | Critical | Low | YES (known constants) | YES |
| Actionable recommendations | Critical | Low | N/A (our expertise) | YES |
| iOS keyword field composition | Critical | High | N/A (optimization problem) | YES |
| Title/subtitle generation | Critical | Medium | N/A (Claude generation) | YES |
| Description analysis | High | Medium | YES (store page scrape) | YES |
| Competitor titles/ratings | High | Medium | YES (web search) | YES |
| Scoring system | High | Medium | N/A (our rubric) | YES |
| Seed keyword expansion | High | Medium | PARTIAL (reasoning + web search) | YES |
| Relevance scoring | High | Low | N/A (Claude reasoning) | YES |
| Description optimization | High | Medium | N/A (Claude generation) | YES |
| Before/after comparison | High | Low | YES (current + proposed) | YES |
| Multiple variant generation | High | Low | N/A (Claude generation) | YES |
| Keyword intent grouping | Medium | Medium | N/A (Claude reasoning) | YES |
| Difficulty estimation | Medium | High | PARTIAL (heuristic only) | YES, with ESTIMATE labels |
| Popularity signal | Medium | High | LOW (no API access) | YES, qualitative tiers only |
| Report file output | Medium | Low | N/A | YES |
| Rating/review summary | Medium | Low | YES (store page) | YES |
| Screenshot/icon analysis | Medium | Medium | PARTIAL (needs user files) | DEFER to v2 |
| Review sentiment mining | Medium | Medium | PARTIAL (limited from web) | DEFER to v2 |
| Multi-locale | High (eventually) | Very High | YES (per locale) | DEFER to v2 |
| Cross-command auto-chaining | Medium | Medium | N/A | DEFER to v2 |

---

## Sources

- [AppTweak: Best ASO Tools 2026](https://www.apptweak.com/en/aso-blog/best-aso-tools) -- Feature comparison across major platforms (AppTweak, Sensor Tower, ASODesk, AppFollow)
- [AppFollow: Top 10 ASO Tools 2026](https://appfollow.io/blog/aso-tools) -- Detailed feature breakdown by category (keyword research, metadata, creative, reviews)
- [Radaso: ASO Audit Comprehensive Guide](https://radaso.com/blog/app-store-optimization-aso-audit-your-comprehensive-guide) -- Complete 10-dimension audit framework
- [AppTweak: Keyword Research Guide 2026](https://www.apptweak.com/en/aso-blog/app-store-keyword-research-aso) -- 4-phase keyword methodology, metrics (relevancy, volume, difficulty, chance)
- [MobileAction: Complete ASO Checklist 2026](https://www.mobileaction.co/blog/complete-aso-checklist/) -- 8-point ASO checklist
- [RespectASO: Free Keyword Research Methodology](https://respectlytics.com/blog/free-aso-keyword-research/) -- Open-source keyword scoring: popularity from 6 signals, difficulty from 7 weighted factors
- [RespectASO GitHub](https://github.com/respectlytics/respectaso) -- Open-source ASO tool using Apple's public iTunes Search API (AGPL-3.0)
- [Apple iTunes Search API Documentation](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html) -- Public API, no auth, ~20 calls/min
- [ASOMobile: ASO in 2026 Complete Guide](https://asomobile.net/en/blog/aso-in-2026-the-complete-guide-to-app-optimization/) -- Current best practices, character limits, ranking factors
- [Gummicube: Maximizing ASO Without Keyword Stuffing](https://www.gummicube.com/blog/maximizing-aso-without-keyword-stuffing) -- Keyword density guidelines
- [LiteASO: Best ASO Tools 2026](https://liteaso.com/blog/best-aso-tools-2026) -- AI-native ASO platform with MCP integration (competitive context)
- [AppDrift](https://appdrift.co/) -- AI-powered ASO metadata generation in 60 seconds (competitive context)
- [Appfigures: App Name Optimization](https://appfigures.com/resources/guides/app-name-optimization) -- Title/subtitle keyword placement best practices
- [BoostYourApp: ASO Tools Comparison 2026](https://boostyour.app/blog/competitor-research/aso-tools-comparison) -- Free vs paid tool landscape

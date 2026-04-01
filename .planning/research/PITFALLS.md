# Domain Pitfalls

**Domain:** Claude Code skill pack for App Store Optimization
**Researched:** 2026-04-02

---

## Critical Pitfalls

Mistakes that cause rewrites, broken installs, or user trust failures.

### Pitfall 1: Hallucinated Keyword Data Presented as Fact

**What goes wrong:** The skill tells a user their keyword has "12,400 monthly searches" or "difficulty score: 34" when no such data was retrieved. Claude invents plausible-sounding numbers from its training data rather than admitting it cannot access search volume APIs.

**Why it happens:** Neither Apple nor Google publish keyword search volume publicly. Professional ASO tools (Sensor Tower, AppTweak, AppFollow) derive estimates from proprietary crawling and Apple's relative "popularity score." Claude has no access to any of these data sources. When prompted to "research keywords," Claude defaults to fabricating convincing statistics rather than saying "I cannot determine exact search volume."

**Consequences:** Users make keyword decisions based on invented data. They may optimize for low-volume terms or skip high-volume ones. This destroys trust in the entire toolkit the moment a user cross-references with a real ASO tool.

**Prevention:**
- Every skill prompt must include an explicit directive: "NEVER invent or estimate search volume, difficulty scores, or ranking positions. If data cannot be retrieved via WebSearch, state 'search volume data unavailable -- use Sensor Tower, AppTweak, or App Store Connect analytics for volume estimates.'"
- Distinguish clearly between what CAN be observed (competitor titles, subtitle text, ratings, review counts -- all scrapable from public store pages) and what CANNOT (search volume, keyword difficulty, conversion rates).
- Use a two-tier labeling system in all output: "OBSERVED" for data scraped from live store pages and "ESTIMATED" for anything inferred. Never present estimated data without the label.

**Detection:** Test every skill with a prompt like "research keywords for a fitness app" and verify the output contains zero invented statistics. If any number appears without a cited WebSearch source URL, it is hallucinated.

**Which phase should address it:** Phase 1 (foundations). The shared ASO rules file must establish the "no hallucinated data" constraint before any skill is written. Every downstream skill inherits this rule.

**Confidence:** HIGH -- verified through Claude WebSearch tool documentation and ASO industry knowledge. Apple/Google do not expose volume data publicly.

---

### Pitfall 2: Wrong Character Limits Hardcoded in Skills

**What goes wrong:** Skills enforce incorrect character counts, causing users to either truncate good titles unnecessarily or exceed actual limits and get rejected by App Store Connect or Google Play Console.

**Why it happens:** Character limits have changed over time, and many sources (including the current PROJECT.md) contain outdated numbers. Specifically:

| Field | PROJECT.md Says | Actual Current Limit | Status |
|-------|-----------------|---------------------|--------|
| iOS Title | 30 chars | 30 chars | Correct |
| iOS Subtitle | 30 chars | 30 chars | Correct |
| iOS Keyword Field | 100 chars | 100 chars | Correct |
| Google Play Title | **50 chars** | **30 chars** | **WRONG** |
| Google Play Short Description | 80 chars | 80 chars | Correct |

Google Play reduced app titles from 50 to 30 characters on September 29, 2021. The PROJECT.md has a stale number. Additionally, skills omit important limits that users need:

| Field | Limit | Commonly Overlooked |
|-------|-------|---------------------|
| iOS Promotional Text | 170 chars | Yes -- updateable without new binary |
| iOS Description | 4,000 chars | Sometimes |
| Google Play Long Description | 4,000 chars | Yes -- this is indexed for keywords, unlike iOS |
| iOS In-App Purchase Name | 35 chars | Yes |
| iOS In-App Purchase Description | 55 chars | Yes |

**Consequences:** A user trusts the skill's "50-character Google Play title" guidance, writes a 48-character title, and Google Play Console rejects it. Or worse: they publish it (if grandfathered) and wonder why their title gets truncated in search results.

**Prevention:**
- Create a single source-of-truth reference file (`limits.md` or equivalent) with all character limits and last-verified dates.
- Include URLs to official documentation as inline comments so limits can be re-verified.
- Apple: https://developer.apple.com/app-store/product-page/
- Google: https://support.google.com/googleplay/android-developer/answer/9859152
- The shared ASO rules file should reference this limits file, not hardcode numbers in each skill.
- Fix PROJECT.md immediately: Google Play title limit is 30, not 50.

**Detection:** Grep all skills for hardcoded numbers (30, 50, 80, 100, 170, 4000). Every instance should reference the central limits file, not define its own constant.

**Which phase should address it:** Phase 1 (foundations). The limits reference file is part of the shared domain knowledge that every skill depends on.

**Confidence:** HIGH -- verified against Apple Developer documentation (official) and multiple ASO industry sources confirming Google Play's 2021 policy change.

---

### Pitfall 3: Install Script Destroys Existing settings.json

**What goes wrong:** The install.sh overwrites or corrupts the user's `~/.claude/settings.json`, breaking their existing hooks, plugins, permissions, and status line configuration.

**Why it happens:** A naive install script might:
1. Write a fresh `settings.json` that only includes ASO toolkit paths, obliterating all existing configuration.
2. Use shallow JSON merge (`+` in jq) instead of deep merge (`*`), replacing entire objects like `hooks` or `enabledPlugins` instead of merging into them.
3. Fail to handle the case where `settings.json` does not yet exist.
4. Fail to handle the case where `settings.json` is malformed JSON (a user hand-edited it badly).
5. Not back up the original file before modification.

The real-world `~/.claude/settings.json` observed in this environment contains hooks (SessionStart, PostToolUse, PreToolUse), statusLine, enabledPlugins, effortLevel, and skipDangerousModePermissionPrompt. Any of these being wiped would break the user's entire Claude Code setup.

**Consequences:** User runs `install.sh`, their GSD hooks stop working, their Telegram plugin disconnects, their status line vanishes. They blame the ASO toolkit and uninstall it. Worst case: they don't notice until mid-session and lose work context.

**Prevention:**
- NEVER overwrite settings.json. Always read-merge-write.
- Use `jq` with deep merge operator (`*`): `jq -s '.[0] * .[1]' existing.json additions.json`.
- But even deep merge has pitfalls with arrays -- settings.json uses arrays for hooks and permissions. Deep merge replaces arrays; it does not concatenate them. You must use array-aware merging: check if the hook/path already exists before appending.
- Create a timestamped backup before any modification: `cp ~/.claude/settings.json ~/.claude/settings.json.backup.$(date +%s)`.
- Handle all edge cases: file missing (create new), file empty (create new), file malformed (warn and abort, do not attempt repair), jq not installed (fail with clear error message).
- Test the idempotency: running `install.sh` twice should produce identical results to running it once.
- Provide an `uninstall.sh` that cleanly removes only what was added.

**Detection:** After writing install.sh, test against a settings.json that contains hooks, plugins, statusLine, and permissions. Diff the before/after to verify nothing was removed or altered.

**Which phase should address it:** Phase 2 or Phase 3 (when install infrastructure is built). But the design constraints must be documented in Phase 1.

**Confidence:** HIGH -- directly observed the target environment's complex settings.json. Claude Code documentation confirms arrays are concatenated and deduplicated during merge at the application level, but install scripts doing raw file manipulation must handle this explicitly.

---

### Pitfall 4: WebSearch Cannot Reliably Scrape App Store Pages

**What goes wrong:** Skills assume WebSearch can fetch any app store listing and extract structured data (title, subtitle, description, ratings, reviews). In practice, Apple App Store and Google Play Store pages are JavaScript-heavy, behind rate limiting, and may return incomplete or blocked responses.

**Why it happens:** WebSearch is a search engine query tool, not a web scraper. WebFetch can retrieve page content but has "low reliability" for JS-rendered content. App store pages specifically use dynamic rendering, anti-bot protections, and CDN-level blocking. The skill says "fetch the app listing" but Claude actually runs a web search and synthesizes results from whatever snippets appear in search results -- not from the actual store page.

**Consequences:** The audit skill claims to analyze a user's app listing but actually works from incomplete, stale, or second-hand data. Competitor analysis returns partial information. Users discover the tool's "analysis" doesn't match what they see in App Store Connect or Play Console.

**Prevention:**
- Design skills to work with TWO data sources in priority order:
  1. User-provided metadata (ask the user to paste their App Store Connect / Play Console metadata, or point to a local `metadata.json` file).
  2. WebSearch as supplement (search for "site:apps.apple.com [app name]" or "site:play.google.com [app name]" to get publicly visible snippets).
- Never claim "real-time store data" -- always label WebSearch results as "publicly visible listing data, which may differ from your App Store Connect view."
- For competitor analysis, WebSearch is more reliable (searching for competitor names returns snippets of their titles, ratings, etc.) than trying to scrape full competitor pages.
- Include a fallback instruction: "If WebSearch cannot retrieve the store listing, ask the user to paste their title, subtitle, description, and keyword field."

**Detection:** Test each skill with a real app URL. Verify the output clearly distinguishes between user-provided data and web-retrieved data. Check that skills degrade gracefully when WebSearch returns incomplete results.

**Which phase should address it:** Phase 1 (design pattern), Phase 2 (implementation of the audit skill).

**Confidence:** HIGH -- verified through Claude Code WebSearch/WebFetch documentation and known limitations of JS-rendered page scraping.

---

## Moderate Pitfalls

Mistakes that cause poor user experience, wasted effort, or subtly wrong output.

### Pitfall 5: iOS Keyword Field Formatting Rules Ignored

**What goes wrong:** The skill generates keyword field suggestions with spaces after commas, repeated words, plural forms, or brand names -- all of which waste precious characters or violate Apple's guidelines.

**Why it happens:** Claude's natural language tendency is to write "fitness, workout, health" (with spaces after commas). The iOS keyword field treats spaces as wasted characters. Additionally, Claude may not know these rules:
- Commas separate keywords but do NOT count toward the 100-character limit (disputed -- some sources say they do count; the safer assumption is they count).
- No spaces after commas. Spaces within multi-word phrases are fine: `fitness,home workout,yoga`.
- Do not repeat words already in your title or subtitle (Apple indexes those automatically).
- Use singular forms only (Apple auto-indexes plurals).
- Do not include "app", "free", "iPhone", "iPad", "new", "best" (Apple indexes these automatically -- they are "free keywords").
- Do not include trademarked terms you don't own.
- Special characters like `-`, `@`, `*` are replaced with spaces by Apple, wasting characters.

**Prevention:**
- The keyword optimization skill must include a formatting validation step that checks output against all rules above before presenting to the user.
- Include a "character count" for the generated keyword field, showing remaining capacity.
- Include explicit examples of correct vs. incorrect format in the skill prompt.

**Detection:** Generate keyword suggestions for any app and manually verify: no spaces after commas, no repeated words from title/subtitle, no plurals, no "free keywords."

**Which phase should address it:** Phase 2 (keyword research skill).

**Confidence:** HIGH -- verified across multiple ASO sources and Apple Developer Forums.

---

### Pitfall 6: Treating iOS and Google Play as Identical

**What goes wrong:** Skills apply the same optimization strategy to both platforms, missing fundamental differences in how each indexes and weights metadata.

**Key differences that skills MUST account for:**

| Aspect | iOS App Store | Google Play |
|--------|---------------|-------------|
| Keyword indexing | Title + Subtitle + Hidden Keyword Field only | Title + Short Description + Long Description (all text is indexed) |
| Hidden keyword field | Yes (100 chars) | No equivalent |
| Description indexed? | NO -- description is NOT indexed for search | YES -- long description IS indexed |
| Keyword density matters? | No (binary: indexed or not) | Yes (2-3% density recommended, avoid >3%) |
| Algorithm type | Lexical matching (moving toward semantic in 2025-2026) | Semantic + lexical hybrid |
| Title limit | 30 chars | 30 chars |
| Subtitle/short desc | 30 char subtitle | 80 char short description |

**Consequences:** A user optimizing for iOS gets told to "stuff keywords in the description" (useless on iOS, where description is not indexed). A user optimizing for Google Play is told to "use the keyword field" (which doesn't exist on Google Play).

**Prevention:**
- Platform detection must happen FIRST in every skill flow. Auto-detect from URL format or app ID, with fallback to asking the user.
- Skills must branch their optimization logic per platform. The shared ASO rules file should contain a clear "Platform Differences" section.
- Template output should be platform-specific: iOS output includes keyword field recommendations; Google Play output includes long description keyword density analysis.

**Detection:** Run each skill with an iOS app URL and a Google Play URL. Verify the output is materially different between platforms.

**Which phase should address it:** Phase 1 (platform detection + rules), Phase 2 (every skill).

**Confidence:** HIGH -- well-documented platform differences across all ASO sources.

---

### Pitfall 7: Skill Descriptions Too Vague for Reliable Discovery

**What goes wrong:** Users type a natural language request like "help me optimize my app listing" and Claude doesn't invoke the ASO skill because the description doesn't match. Or worse, Claude invokes the wrong skill.

**Why it happens:** Claude Code's skill discovery relies on the `description` field in YAML frontmatter. Descriptions are truncated to 250 characters in the skill listing. The total budget for all skill descriptions scales to 2% of context window (~8,000 chars fallback). If the user has many skills installed, ASO skill descriptions compete for space.

Additionally, per the official best practices: "Always write in third person. The description is injected into the system prompt, and inconsistent point-of-view can cause discovery problems." Using "I help you..." or "Use this to..." instead of "Analyzes app store listings..." breaks discovery.

**Prevention:**
- Front-load the critical use case in the first 100 characters of every description.
- Use third-person voice: "Audits an app store listing and provides..." not "Helps you audit..."
- Include trigger keywords that users would naturally say: "app store", "play store", "ASO", "keywords", "metadata", "optimization", "listing", "audit."
- Keep each description under 250 characters (the hard truncation point per skill).
- Test discovery by typing natural prompts without using `/aso:*` -- does Claude still find the right skill?

**Detection:** Install the skills, then test with prompts like "analyze my app store listing", "help with app keywords", "optimize my app metadata." Verify correct skill activation.

**Which phase should address it:** Phase 1 (skill frontmatter design), validated in every subsequent phase.

**Confidence:** HIGH -- verified from official Claude Code skills documentation and best practices guide.

---

### Pitfall 8: Output Too Generic to Be Actionable

**What goes wrong:** The skill produces advice like "Use relevant keywords in your title" or "Write a compelling description" -- advice any blog post gives. Users wanted specific, concrete recommendations for THEIR app.

**Why it happens:** Without sufficient context about the user's specific app, Claude defaults to generic ASO best practices from its training data. The skill prompt doesn't enforce specificity or require grounding in the user's actual metadata.

**Prevention:**
- Every skill must collect concrete inputs before generating output: the app's current title, subtitle, description, keyword field, category, and target audience.
- Output must reference the user's actual metadata: "Your current title 'FitTracker' uses 10 of 30 characters. Consider: 'FitTracker: Workout Planner' (28 chars) to capture 'workout' and 'planner' keywords."
- Include a scoring rubric that evaluates the user's SPECIFIC listing, not generic checklists.
- Competitor analysis should name actual competitors found via WebSearch, not hypothetical ones.

**Detection:** Run the audit skill with a real app. Check whether every recommendation references the app's actual metadata. If any recommendation could apply to any app without modification, it is too generic.

**Which phase should address it:** Phase 2 (audit skill), Phase 3 (keyword and metadata skills).

**Confidence:** MEDIUM -- based on general LLM behavior patterns and ASO tool user expectations. Specific skill prompt engineering needed to verify.

---

## Minor Pitfalls

### Pitfall 9: Skill Files Exceed 500-Line Recommendation

**What goes wrong:** SKILL.md becomes a monolith containing all ASO domain knowledge, examples, platform rules, and output templates. Claude loads the entire file into context even for simple queries, wasting tokens and crowding out conversation history.

**Prevention:** Keep each SKILL.md under 500 lines. Move reference material (character limits, platform differences, keyword rules) into separate files using progressive disclosure. SKILL.md should be the "table of contents" that points to `reference/limits.md`, `reference/ios-rules.md`, `reference/google-play-rules.md`.

**Which phase should address it:** Phase 1 (architecture design).

---

### Pitfall 10: jq Dependency Not Checked in Install Script

**What goes wrong:** install.sh uses `jq` to merge settings.json, but `jq` is not installed on the user's system. The script fails silently or with a cryptic error.

**Prevention:** Check for `jq` at the top of install.sh. If missing, either: (a) fall back to a pure-bash JSON approach for simple merges, (b) offer to install jq via Homebrew/apt, or (c) fail with a clear message: "jq is required. Install with: brew install jq". Also consider whether `python3 -c 'import json; ...'` is a more universally available alternative on macOS/Linux.

**Which phase should address it:** Phase 2 or 3 (install script implementation).

---

### Pitfall 11: No Uninstall Path

**What goes wrong:** Users want to remove the ASO toolkit but there's no clean way to do it. They must manually find and remove paths from settings.json, delete the skill directory, and hope they didn't miss anything.

**Prevention:** Ship an `uninstall.sh` alongside `install.sh`. It should: remove the skill directory, remove only the entries it added to settings.json (not touch other entries), and confirm what was removed.

**Which phase should address it:** Same phase as install.sh.

---

### Pitfall 12: Google Play Prohibited Keywords Not Flagged

**What goes wrong:** The skill suggests a Google Play title containing "Best", "#1", "Free", or "Top" -- words explicitly prohibited by Google Play metadata policy since 2021. These can trigger listing rejection or removal.

**Prevention:** Include a prohibited-words checklist in the Google Play optimization path. Flag any output containing these terms before presenting to the user.

**Which phase should address it:** Phase 2 (metadata optimization skill).

**Confidence:** HIGH -- confirmed by Google Play policy documentation and AppTweak analysis.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation | Severity |
|-------------|---------------|------------|----------|
| Phase 1: Shared rules + domain knowledge | Hardcoding stale character limits | Single-source limits reference file with verification dates | Critical |
| Phase 1: Shared rules | Missing "no hallucinated data" directive | First line of rules file must state this constraint | Critical |
| Phase 1: Platform detection | Regex too brittle for URL parsing | Handle edge cases: regional URLs, deep links, numeric IDs, bundle IDs | Moderate |
| Phase 2: Audit skill | WebSearch returns incomplete store data | Design for user-provided data first, WebSearch as supplement | Critical |
| Phase 2: Keyword skill | iOS keyword field formatting wrong | Validation step checks: no spaces after commas, no repeats, singular forms | Moderate |
| Phase 2: Keyword skill | Inventing search volume numbers | Explicit "volume data unavailable" message when no source found | Critical |
| Phase 2: Metadata skill | Same advice for iOS and Google Play | Platform-branched logic with different optimization strategies | Moderate |
| Phase 3: Install script | Overwrites existing settings.json | Deep merge with array awareness, backup, idempotency, edge case handling | Critical |
| Phase 3: Install script | jq not available | Dependency check with clear fallback or error message | Minor |
| Phase 3: Uninstall | No clean removal path | Ship uninstall.sh alongside install.sh | Minor |
| All phases: Skill descriptions | Vague descriptions cause mis-triggering | Front-load keywords, use third person, stay under 250 chars | Moderate |
| All phases: Output quality | Generic advice instead of specific recommendations | Require concrete input data before generating any output | Moderate |

## "Looks Done But Isn't" Checklist

These are items that pass a superficial review but fail in real-world usage:

- [ ] **Keyword skill generates suggestions** -- but did it verify none of them repeat words from the title/subtitle?
- [ ] **Audit skill scores a listing** -- but does the score change meaningfully between a good listing and a bad one, or does everything get 6-7/10?
- [ ] **Character count is shown** -- but does it count the same way the store counts? (Unicode characters, emoji, combining marks can differ)
- [ ] **Install script works on a fresh machine** -- but does it work on a machine with existing hooks, plugins, and custom settings?
- [ ] **Platform detection works for standard URLs** -- but what about `https://apps.apple.com/de/app/...` (regional), `id123456789` (bare ID), Play Store deep links?
- [ ] **Competitor analysis returns results** -- but are they actually competitors in the same category, or just apps with similar names?
- [ ] **The skill runs without errors** -- but does the output fit in a terminal without horizontal scrolling? Is the markdown valid?
- [ ] **Skills work when invoked with `/aso:audit`** -- but do they also trigger correctly from natural language like "audit my app listing"?
- [ ] **The skill says "30 character limit"** -- but did it account for the fact that emojis in titles count as 2+ characters on some platforms?
- [ ] **WebSearch found the app** -- but is the data from the current version, or a cached/outdated search result?

## Sources

- [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/skills) -- Official skill authoring reference
- [Skill authoring best practices - Claude API Docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) -- Official best practices
- [Claude Code settings - Claude Code Docs](https://code.claude.com/docs/en/settings) -- Settings file structure and merge behavior
- [Creating Your Product Page - Apple Developer](https://developer.apple.com/app-store/product-page/) -- Official iOS character limits
- [Google Play Metadata Policy Changes - AppTweak](https://www.apptweak.com/en/aso-blog/how-to-prepare-for-new-google-metadata-policy-changes) -- Google Play title limit reduction to 30 chars
- [How to Optimize Your iOS Keyword Field - AppTweak](https://www.apptweak.com/en/aso-blog/how-to-optimize-your-ios-keyword-field) -- iOS keyword field formatting rules
- [ASO mistakes that are killing your app growth - MobileAction](https://www.mobileaction.co/blog/aso-mistakes/) -- Common ASO errors
- [App Store Keyword Search Volume - Appalize](https://www.appalize.com/blog/aso-strategies/app-store-keyword-search-volume-how-to-measure-use-it) -- Why volume data is unreliable
- [WebSearch tool issues - GitHub #2647](https://github.com/anthropics/claude-code/issues/2647) -- WebSearch AI-generated summary provenance confusion
- [Claude Code permissions issues - GitHub #18160](https://github.com/anthropics/claude-code/issues/18160) -- Settings.json permission bugs

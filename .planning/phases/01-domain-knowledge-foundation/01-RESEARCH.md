# Phase 1: Domain Knowledge Foundation - Research

**Researched:** 2026-04-02
**Domain:** ASO domain knowledge encoding, Claude Code rules file system, app store metadata specifications
**Confidence:** HIGH

## Summary

Phase 1 creates a single rules file (`rules/aso-domain.md`) that encodes verified ASO domain knowledge as the foundation for all subsequent phases. The file must contain accurate character limits for both iOS and Google Play, platform auto-detection logic, a scoring rubric for audits, and explicit directives about data labeling (OBSERVED vs ESTIMATED) and anti-hallucination.

The most critical research finding is confirming the Google Play title limit: **30 characters, not 50**. Google reduced this from 50 to 30 on September 29, 2021. The PROJECT.md and SESSION_PROMPT.md both contain the stale 50-character figure. The rules file must encode the correct 30-character limit.

The rules file installs to `~/.claude/rules/` at the user level, where Claude Code auto-discovers it and loads it into every session. The file should target 200-350 lines to minimize context budget impact on non-ASO sessions. It contains only reference data (character limits, detection patterns, rubric weights, terminology), not workflows or tool invocations.

**Primary recommendation:** Create `rules/aso-domain.md` with five sections: Platform Character Limits (with verification dates and source URLs), Platform Detection Logic, Scoring Rubric (three-category weighted system), Data Integrity Directives (no-fabrication rule, OBSERVED/ESTIMATED labeling), and ASO Ranking Factors by platform.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
None explicitly locked. Auto-generated infrastructure phase -- all implementation choices at Claude's discretion.

### Claude's Discretion
All implementation choices are at Claude's discretion -- pure infrastructure phase. Use ROADMAP phase goal, success criteria, and codebase conventions to guide decisions.

Key constraints from research:
- Google Play title limit needs verification (30 vs 50 chars -- research says 30 since Sept 2021)
- Rules file must be minimal (200-350 lines per architecture research) since it loads into every session
- File goes in rules/ directory for auto-discovery by Claude Code
- No workflows or tool instructions in rules file -- only shared constants and knowledge

### Deferred Ideas (OUT OF SCOPE)
None -- infrastructure phase.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| FOUN-01 | Rules file encodes ASO domain knowledge: character limits, platform differences, scoring rubrics, ranking factor weights, best practices | Verified character limits from official Apple/Google docs. Scoring rubric weights derived from industry ASO audit frameworks (0-100 scale, three categories). Ranking factors documented with per-platform weights. |
| FOUN-02 | Platform auto-detection infers iOS vs Android from URL format or app ID format | URL patterns verified against official linking docs (Apple Developer, Android Developer). Numeric ID = iOS, reverse-domain package name = Android. Regional URL variants documented. |
| FOUN-03 | All difficulty/popularity/volume estimates clearly labeled ESTIMATED; observed store data labeled OBSERVED | Anti-hallucination directive researched. Apple/Google do not publish keyword search volume publicly. Two-tier labeling system (OBSERVED/ESTIMATED) documented with clear definitions. |
</phase_requirements>

## Project Constraints (from CLAUDE.md)

Extracted from `CLAUDE.md`:
- **Zero infrastructure**: No MCP servers, no OAuth, no API keys, no Python. Pure markdown skills.
- **Install simplicity**: Clone repo, run install.sh, done.
- **Character limits must be enforced** (CLAUDE.md still has stale 50-char Google Play limit -- rules file must correct this)
- **No hallucinated data**: Use web search for real store data. Clearly mark estimates vs observed data.
- **File size**: Skills are self-contained markdown. Small files, high cohesion.
- **GSD Workflow Enforcement**: Before using Edit, Write, or other file-changing tools, start work through a GSD command.

## Standard Stack

This phase has no libraries, frameworks, or packages. It produces a single markdown file.

### Core

| Component | Format | Purpose | Why Standard |
|-----------|--------|---------|--------------|
| Rules file | Markdown (`.md`) in `rules/` directory | Shared ASO domain knowledge loaded into every Claude Code session | Claude Code auto-discovers `.md` files in `~/.claude/rules/` and project `.claude/rules/`. This is the official mechanism for persistent, always-loaded knowledge. |

### File Location

| Location | Purpose | Loading Behavior |
|----------|---------|------------------|
| `rules/aso-domain.md` (source repo) | Source of truth in the git repository | Not loaded directly -- must be installed |
| `~/.claude/rules/aso-domain.md` (installed) | User-level rules, loaded into every session on every project | Auto-discovered and loaded at session start, before project rules |
| `.claude/rules/aso-domain.md` (project-level alternative) | Would load only in this project | Loaded only when working in the aso-toolkit repo |

**Decision:** The install.sh (Phase 10) copies to `~/.claude/rules/` so the ASO knowledge is available across all projects. During development, the file lives in `rules/` in the source repo.

**Confidence: HIGH** -- Verified against official Claude Code memory documentation at code.claude.com/docs/en/memory. User-level rules in `~/.claude/rules/` are loaded before project rules.

### What NOT to Use

| Anti-Pattern | Why Not |
|--------------|---------|
| CLAUDE.md for domain knowledge | CLAUDE.md is for project-level instructions. Domain knowledge shared across all projects belongs in `~/.claude/rules/`. |
| Multiple rules files | Each rules file adds to every session's context budget. A single focused file (200-350 lines) minimizes overhead. |
| YAML/JSON data format | Rules files must be markdown. Claude reads them as natural language context, not structured data. |
| Inline character limits in each skill | DRY violation. Central rules file is the single source of truth; skills reference it. |

## Architecture Patterns

### Recommended File Structure

```
aso-toolkit/
  rules/
    aso-domain.md          # THIS PHASE: domain knowledge rules file
  commands/                # Later phases
  agents/                  # Later phases
  install.sh               # Phase 10
```

### Pattern 1: Rules File as Reference Data

**What:** The rules file contains only factual reference data -- character limits, detection patterns, rubric weights, terminology definitions, and explicit directives. No workflows, no tool invocations, no step-by-step instructions.

**When to use:** Always. This is the only pattern for rules files because they load into every session.

**Why:** A rules file that contains workflow instructions wastes context on non-ASO sessions. Commands (loaded on demand) contain the workflows; rules contain the knowledge those workflows reference.

**Structure of the rules file:**

```markdown
# ASO Domain Knowledge

## Data Integrity [MUST section]
- Anti-hallucination directive
- OBSERVED vs ESTIMATED labeling definitions

## Platform Character Limits [reference table]
- iOS limits with source URLs and verification dates
- Google Play limits with source URLs and verification dates

## Platform Detection [logic reference]
- URL pattern matching rules
- App ID format rules

## Scoring Rubric [reference weights]
- Category definitions and weights
- Per-factor scoring criteria

## Ranking Factors [domain knowledge]
- Per-platform factor weights
- Key platform differences

## Terminology [definitions]
- ASO-specific terms used across commands
```

### Pattern 2: Verification Dates on Character Limits

**What:** Every character limit includes a last-verified date and an official source URL so future maintainers can re-verify.

**When to use:** Always, for every hardcoded limit.

**Example:**

```markdown
| Field | Limit | Source | Verified |
|-------|-------|--------|----------|
| iOS Title | 30 chars | developer.apple.com/app-store/product-page/ | 2026-04-02 |
```

**Why:** Character limits change (Google Play title went from 50 to 30 in 2021). Without verification metadata, stale limits persist undetected.

### Anti-Patterns to Avoid

- **Fat rules file (>400 lines):** Every line costs context budget in every session, even non-ASO ones. Target 200-350 lines.
- **Workflow instructions in rules:** Rules are passive knowledge. "When the user asks for X, do Y" belongs in command files, not rules.
- **Hardcoded limits without sources:** Unattributed numbers cannot be verified and will go stale.
- **Duplicating rules content in commands:** Commands should reference the rules file's knowledge, not copy-paste it.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Character limit database | Custom JSON schema with limit lookups | Markdown table in rules file | Claude reads markdown natively; no parsing needed. Tables are clear and maintainable. |
| Platform detection engine | Regex library or detection script | Documented pattern-matching rules in markdown | Claude applies pattern matching from natural language descriptions. No code needed. |
| Scoring calculator | Weighted average function | Documented weights in the rules file | Claude performs arithmetic inline. The rules file defines the weights; commands apply them. |

**Key insight:** This is a Claude Code skill pack. There is no runtime code. The "implementation" is writing precise, well-structured markdown that Claude interprets correctly.

## Common Pitfalls

### Pitfall 1: Stale Google Play Title Limit

**What goes wrong:** Encoding 50-character Google Play title limit (the pre-2021 figure). Users write 45-char titles that Google Play Console rejects.
**Why it happens:** Multiple project docs (PROJECT.md, SESSION_PROMPT.md, STACK.md) contain the stale 50-char figure.
**How to avoid:** Use 30 characters. Verified against official Google Play Console Help documentation and the Android Developers Blog announcement from April 2021 confirming enforcement from September 29, 2021.
**Warning signs:** Any reference to "50 chars" for Google Play title.
**Confidence: HIGH** -- Multiple official sources confirm 30-char limit since Sept 2021.

### Pitfall 2: iOS Keyword Field -- Characters vs Bytes

**What goes wrong:** Stating "100 bytes" (per the App Store Connect API reference) when the practical limit is 100 characters for English keywords. Non-English characters (CJK, accented) historically consumed more bytes, but Apple now measures in characters for all languages.
**Why it happens:** Apple's API reference page says "100 bytes" while their product page says "100 characters." A 2013 change unified the limit to 100 characters across all languages.
**How to avoid:** Document as "100 characters" with a note that Apple's API reference technically says "100 bytes" but the practical limit is 100 characters for all languages including non-Latin scripts (changed ~2013). For English-only ASO, characters and bytes are equivalent.
**Warning signs:** Keyword suggestions that work in English but truncate in other languages.
**Confidence: MEDIUM** -- Apple's own docs are inconsistent. The product page (developer.apple.com/app-store/product-page/) says "100 characters." The API reference says "100 bytes." Industry consensus is 100 characters.

### Pitfall 3: Hallucinated Search Volume Data

**What goes wrong:** The rules file fails to include an explicit anti-hallucination directive, and downstream commands generate fake keyword volume numbers.
**Why it happens:** Claude's default behavior when asked for "keyword research" is to produce plausible-sounding statistics. Without an explicit prohibition, this is the path of least resistance.
**How to avoid:** The rules file MUST contain a prominent directive (first section): "NEVER fabricate, estimate, or invent search volume, difficulty scores, or ranking positions. If data cannot be retrieved from a verifiable source, state it is unavailable."
**Warning signs:** Any numeric volume/difficulty in output without a cited source URL.
**Confidence: HIGH** -- Neither Apple nor Google publish keyword search volume publicly. No free API provides this data.

### Pitfall 4: Rules File Too Large

**What goes wrong:** The rules file grows beyond 350 lines, consuming context budget on every session, even when users are not doing ASO work.
**Why it happens:** Temptation to put ASO best practices, workflow hints, examples, and detailed explanations into the always-loaded file.
**How to avoid:** Strict content filter: only put factual reference data (limits, patterns, weights, definitions) in the rules file. Best practices, examples, and workflows go in command files (loaded on demand).
**Warning signs:** File exceeds 350 lines. Contains any of: "Step 1:", "When the user asks", "Use WebSearch to", or example outputs.

### Pitfall 5: Scoring Rubric Too Vague to Produce Differentiated Scores

**What goes wrong:** The rubric defines categories (Metadata, Visibility, Conversion) but not specific criteria, so Claude gives everything a 6-7/10 score regardless of quality.
**Why it happens:** Vague rubric criteria like "Title quality" without defining what constitutes a 9/10 vs 3/10 title.
**How to avoid:** Include brief scoring anchors for each factor: what earns a high score (9-10), medium (5-7), and low (0-3). Keep anchors to 1-2 lines each to stay within the line budget.
**Warning signs:** All test audits produce scores in the 60-75 range regardless of listing quality.

## Code Examples

This phase produces markdown, not code. Below are verified patterns for the rules file content.

### Character Limits Table (Verified)

```markdown
## Platform Character Limits

### iOS (App Store Connect)
<!-- Source: developer.apple.com/app-store/product-page/ | Verified: 2026-04-02 -->

| Field | Limit | Indexed | Notes |
|-------|-------|---------|-------|
| App Name (Title) | 30 chars | YES (highest weight) | Most critical metadata field |
| Subtitle | 30 chars | YES | Visible in search results |
| Keyword Field | 100 chars | YES (hidden) | Comma-separated, no spaces after commas, no duplication with title/subtitle |
| Description | 4,000 chars | NO | Write for conversion, not algorithm. Not indexed by Apple. |
| Promotional Text | 170 chars | NO | Updatable without new app version |
| What's New | 4,000 chars | NO | Release notes |
| In-App Purchase Name | 35 chars | - | Displayed on product page |
| In-App Purchase Description | 55 chars | - | Displayed on product page |

### Google Play Console
<!-- Source: support.google.com/googleplay/android-developer/answer/9898842 | Verified: 2026-04-02 -->
<!-- Title limit reduced from 50 to 30 chars on 2021-09-29 per android-developers.googleblog.com/2021/04/ -->

| Field | Limit | Indexed | Notes |
|-------|-------|---------|-------|
| Title | 30 chars | YES (highest weight) | Reduced from 50 chars in Sept 2021 |
| Short Description | 80 chars | YES | Visible by default on listing |
| Full Description | 4,000 chars | YES | Unlike iOS, this IS indexed for search |
| What's New (Release Notes) | 500 chars | NO | Per-release update notes |
```

**Source verification:**
- iOS limits: Apple Developer "Creating Your Product Page" (developer.apple.com/app-store/product-page/) -- **HIGH confidence**
- Google Play limits: Google Play Console Help metadata docs and Android Developers Blog 2021 announcement -- **HIGH confidence**

### Platform Detection Logic

```markdown
## Platform Detection

Given user input, detect the platform using this priority order:

### URL Patterns
| Pattern | Platform | Example |
|---------|----------|---------|
| `apps.apple.com/*` | iOS | https://apps.apple.com/us/app/myapp/id123456789 |
| `apps.apple.com/{country}/app/*` | iOS | https://apps.apple.com/de/app/myapp/id123456789 |
| `itunes.apple.com/*` | iOS (legacy) | https://itunes.apple.com/app/id123456789 |
| `play.google.com/store/apps/details?id=*` | Android | https://play.google.com/store/apps/details?id=com.example.app |

### ID Patterns
| Pattern | Platform | Example |
|---------|----------|---------|
| Pure digits (typically 9-10 chars) | iOS | 284882215 |
| Reverse-domain notation (contains dots) | Android | com.facebook.Facebook |

### Ambiguous Input
| Pattern | Action |
|---------|--------|
| App name (plain text) | Ask user to specify platform, or search both stores |
| Unknown URL format | Ask user to clarify |
```

**Source verification:**
- Apple URL format: Apple Developer Technical Q&A QA1633 and current apps.apple.com URL structure -- **HIGH confidence**
- Google Play URL format: Android Developer linking documentation (developer.android.com/distribute/marketing-tools/linking-to-google-play) -- **HIGH confidence**

### Scoring Rubric Weights

```markdown
## ASO Scoring Rubric

Score: 0-100 scale. Each factor scored 0-10, multiplied by weight, summed.

### Category Weights

| Category | Weight | Factors Included |
|----------|--------|-----------------|
| Metadata | 50% | Title (20%), Subtitle/Short Desc (15%), Keywords/Description (15%) |
| Visibility | 25% | Ratings & Reviews (15%), Ranking Signals (10%) |
| Conversion | 25% | Screenshots (15%), Icon (5%), Description Quality (5%) |

### Platform-Specific Adjustments
- iOS: Keywords factor = Keyword Field optimization (15%)
- Android: Keywords factor = Full Description keyword density (15%)
- iOS: Description Quality = conversion copywriting (not indexed)
- Android: Description Quality = keyword integration + readability (indexed)
```

**Source derivation:** Composite of multiple ASO audit frameworks (Eronred aso-skills, ASODev, SimiCart, RadASO). The 50/25/25 split between Metadata/Visibility/Conversion is the industry-standard pattern, with Metadata weighted highest because it is the only fully controllable factor. Specific factor weights (Title 20%, etc.) derived from the Eronred aso-skills audit framework (the most detailed publicly documented rubric found).

**Confidence: MEDIUM** -- No single industry standard exists. These weights represent the consensus across 5+ audit frameworks reviewed. The planner should document that weights are configurable and may be tuned.

### Data Integrity Directives

```markdown
## Data Integrity

### CRITICAL: No Fabricated Data
NEVER invent, estimate, or hallucinate:
- Search volume numbers
- Keyword difficulty scores  
- Ranking positions
- Download counts
- Conversion rates

If data cannot be retrieved from a verifiable web source, state: "Data unavailable -- use [Sensor Tower / AppTweak / App Store Connect Analytics] for verified metrics."

### Data Labeling Convention
All data in reports must carry one of two labels:

| Label | Definition | Examples |
|-------|------------|---------|
| OBSERVED | Retrieved from a live, verifiable source (web search, iTunes API, store page) | App title, rating, review count, description text |
| ESTIMATED | Inferred by Claude based on analysis, not retrieved from a data source | Keyword relevance score, optimization priority, competitive strength |

Never present ESTIMATED data without the label. Never omit the label.
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Google Play 50-char title | 30-char title | Sept 29, 2021 | All Google Play title guidance must use 30 chars |
| iOS keyword field 100 bytes (non-Latin penalty) | 100 characters (all languages) | ~2013 | Non-Latin keyword strategies have same capacity as English |
| Download volume = primary ranking signal | Retention + engagement = growing signal | 2024-2025 (gradual) | ASO scoring should note retention as emerging factor |
| Keyword-only search queries | Natural language queries via Apple Intelligence / Google Guided Search | 2025-2026 | Long-tail keyword strategies gaining importance |
| Static CPPs (paid search only) | CPPs appear in organic search (iOS) | 2025 | Noted for future phases, not Phase 1 |

**Deprecated/outdated:**
- Google Play 50-char title limit: Use 30 chars. The 50-char figure appears in PROJECT.md, SESSION_PROMPT.md, and STACK.md -- all need correction or supersession by the rules file.
- iOS keyword field "100 bytes": Practically 100 characters since ~2013 for all languages.

## Open Questions

1. **Do commas count toward the iOS 100-character keyword limit?**
   - What we know: Apple's product page says "100 characters total." Some sources claim commas are excluded; others say they count. The safest assumption is that commas DO count (treat total input length including commas as the limit).
   - Recommendation: Document as "100 characters total including commas" with a note that some sources claim commas are excluded. This is the conservative approach -- users will never exceed the limit.

2. **Should the rules file include Google Play prohibited words?**
   - What we know: Google prohibits "Best", "#1", "Free", "Top" and similar promotional words in titles. This is policy, not a character limit.
   - Recommendation: Include a brief prohibited-words list. It is factual reference data (not a workflow) and prevents downstream commands from suggesting policy-violating titles. Fits within the 200-350 line budget.

3. **iOS Description 4,000-character limit source**
   - What we know: The official product page does not explicitly state the description limit. The App Store Connect reference page confirms 4,000 characters. Multiple third-party sources confirm 4,000.
   - Recommendation: Use 4,000 chars. Confidence is HIGH despite the product page omission -- the App Store Connect reference is authoritative.

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Manual validation (no runtime code in this phase) |
| Config file | None -- markdown-only phase |
| Quick run command | `wc -l rules/aso-domain.md` (verify line count 200-350) |
| Full suite command | Manual checklist verification (see below) |

### Phase Requirements to Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| FOUN-01 | Rules file contains character limits, platform differences, scoring rubric, ranking factors, best practices | manual + automated | `grep -c "iOS\|Google Play\|Title\|Subtitle\|Keyword" rules/aso-domain.md` | Wave 0 |
| FOUN-02 | Platform auto-detection logic documented: Apple URL, Google Play URL, numeric ID, bundle ID | manual + automated | `grep -c "apps.apple.com\|play.google.com\|numeric\|bundle" rules/aso-domain.md` | Wave 0 |
| FOUN-03 | Anti-fabrication directive and OBSERVED/ESTIMATED labeling defined | manual + automated | `grep -c "OBSERVED\|ESTIMATED\|fabricat\|hallucin\|NEVER" rules/aso-domain.md` | Wave 0 |

### Sampling Rate
- **Per task commit:** `wc -l rules/aso-domain.md` (line count check)
- **Per wave merge:** Full manual checklist
- **Phase gate:** All success criteria verified before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `rules/aso-domain.md` -- the primary deliverable of this phase (does not exist yet)
- [ ] Verification script: a simple grep-based check that all required sections exist

## Sources

### Primary (HIGH confidence)
- [Creating Your Product Page - Apple Developer](https://developer.apple.com/app-store/product-page/) -- iOS character limits (30 title, 30 subtitle, 100 keywords, 170 promo text, 35/55 IAP)
- [Platform Version Information - App Store Connect Reference](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/) -- iOS limits (confirms 4,000 desc, 4,000 what's new, keywords "100 bytes")
- [Updated Guidance to Improve App Quality - Android Developers Blog](https://android-developers.googleblog.com/2021/04/updated-guidance-to-improve-your-app.html) -- Google Play title reduced to 30 chars
- [Metadata - Play Console Help](https://support.google.com/googleplay/android-developer/answer/9898842) -- Google Play metadata fields and limits
- [Linking to Google Play - Android Developers](https://developer.android.com/distribute/marketing-tools/linking-to-google-play) -- Google Play URL format (`play.google.com/store/apps/details?id=<package_name>`)
- [Technical Q&A QA1633 - Apple Developer](https://developer.apple.com/library/archive/qa/qa1633/_index.html) -- Apple App Store URL format
- [Claude Code Memory Documentation](https://code.claude.com/docs/en/memory) -- Rules file format, `.claude/rules/` auto-discovery, user-level rules at `~/.claude/rules/`
- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings) -- Configuration scopes, user/project/local hierarchy

### Secondary (MEDIUM confidence)
- [ASO Audit - Eronred aso-skills](https://www.mintlify.com/Eronred/aso-skills/skills/aso-audit) -- Scoring rubric weights (Title 20%, Subtitle 15%, etc., 0-100 scale)
- [Google Play Metadata Policy Changes - AppTweak](https://www.apptweak.com/en/aso-blog/how-to-prepare-for-new-google-metadata-policy-changes) -- Confirmed 30-char title enforcement since Sept 2021
- [iOS Keyword Field Optimization - AppTweak](https://www.apptweak.com/en/aso-blog/how-to-optimize-your-ios-keyword-field) -- Keyword field formatting rules
- [ASO in 2026 Complete Guide - ASOMobile](https://asomobile.net/en/blog/aso-in-2026-the-complete-guide-to-app-optimization/) -- Current ranking factors and retention shift
- [SimiCart ASO Audit Tool](https://simicart.com/blog/free-aso-audit-tool/) -- ASO audit scoring methodology (0-100 scale)
- [RadASO Comprehensive ASO Audit Guide](https://radaso.com/blog/app-store-optimization-aso-audit-your-comprehensive-guide) -- Audit methodology and category breakdown

### Tertiary (LOW confidence)
- [Apple now allows all 100 characters for keywords in foreign languages (2013)](https://www.ibabbleon.com/copywriter-translator/2013/06/apple-finally-allows-100-characters-of-keywords-in-all-languages-of-the-app-store/) -- Historical change from bytes to characters for keyword field. OLD source but explains the discrepancy.

## Metadata

**Confidence breakdown:**
- Character limits (iOS): HIGH -- verified against official Apple Developer product page and App Store Connect reference
- Character limits (Google Play): HIGH -- verified against official Google Play Console Help and Android Developers Blog
- Platform detection patterns: HIGH -- verified against official Apple and Google linking documentation
- Scoring rubric weights: MEDIUM -- composite of multiple industry frameworks, no single authoritative standard
- Ranking factors: MEDIUM -- industry consensus, not officially published by Apple or Google
- Rules file format/loading: HIGH -- verified against official Claude Code docs (code.claude.com/docs/en/memory)

**Research date:** 2026-04-02
**Valid until:** 2026-07-02 (character limits are stable; re-verify if Apple/Google announce policy changes)

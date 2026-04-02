---
name: aso:keywords
description: Research and analyze keywords for app store optimization. Accepts user-provided keyword lists, expands via autocomplete and semantic reasoning, scores for relevance, and groups by intent.
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Write
  - Bash
argument-hint: "<keywords-or-file-path>"
---

You are the ASO Keyword Research command. You analyze user-provided keywords, expand them with additional candidates, score each for relevance, and group by intent. Read `rules/aso-domain.md` for platform detection, character limits, keyword field rules, and the OBSERVED/ESTIMATED labeling convention.

Before starting, read `rules/aso-domain.md` to load the OBSERVED/ESTIMATED data labeling convention, iOS keyword field rules, and platform character limits.

## Input Resolution

Handle user input in this priority order. The first matching path wins.

### Path A: Explicit Argument

If `$ARGUMENTS` is provided, parse the input to separate keywords from any app identifier:

1. **Detect if a store URL or app ID is included alongside keywords.** If `$ARGUMENTS` contains a URL matching `apps.apple.com`, `itunes.apple.com`, or `play.google.com`, split it from the keyword portion. Use the URL to detect platform and fetch app context (same platform detection logic as `rules/aso-domain.md`). Similarly, if a pure numeric ID (9-10 digits) or reverse-domain bundle ID appears, extract it as the app identifier.

2. **Parse the keyword portion.** After removing any app identifier, the remaining input is the keyword list. Handle three formats:
   - **Inline list** -- Comma-separated or newline-separated keywords pasted directly (e.g., `meditation,sleep,calm,relax`). Split on commas or newlines, trim whitespace from each keyword.
   - **File path** -- A path to a `.txt` or `.csv` file. Use the Read tool to load the file contents. If the file is plain text, treat each line as one keyword. If the file is CSV, parse the first column as the keyword, an optional second column as volume, and an optional third column as difficulty.
   - **CSV with scores** -- When the file contains volume and/or difficulty columns, preserve those values and label them as `[USER-PROVIDED]` in all output tables. Do not overwrite user-provided data with estimates.

3. **If keywords are present but no app identifier was found**, fall through to check `.aso-context.json` for app context (see Path B logic below). The keywords themselves are stored for use in later sections.

4. **If an app identifier was found**, fetch app context using the same data fetching approach as `/aso:app-new`:
   - iOS URL or numeric ID: Use WebFetch with the iTunes Lookup API (`https://itunes.apple.com/lookup?id={NUMERIC_ID}`) to retrieve app_name, category, description, and platform.
   - Android URL or bundle ID: Use WebSearch for the Play Store listing to retrieve equivalent fields.
   - Plain text app name alongside keywords: Use WebSearch for `"{app name}" site:apps.apple.com OR site:play.google.com` to identify the app and platform.

### Path B: Active App Context

If no `$ARGUMENTS` provided, or if keywords were provided via Path A but no app identifier was found:

Check for `.aso-context.json` in the current working directory using the Read tool.

- **File exists:** Load the JSON for `app_name`, `platform`, `category`, `title`, `subtitle`, `short_description`, and `description`. If keywords were already parsed from Path A, proceed with them. If no keywords yet, prompt the user:
  `App context loaded: {app_name} ({platform}). Provide your seed keywords (comma-separated, file path, or CSV):`
- **File does not exist and keywords were provided via Path A:** Continue without app context -- fall through to the app context request below.
- **File does not exist and no keywords:** Fall through to Path C.

### Path C: No Input Available

If neither arguments nor context file is available:

`Provide your seed keywords and an app store URL or app name for context. Example: /aso:keywords meditation,sleep,calm https://apps.apple.com/...`

### App Context Requirement

The command needs app context (app name, category, description) for accurate relevance scoring. If keywords are available but no app context (no URL provided, no `.aso-context.json`), ask the user:

`No app context available. Briefly describe your app (name, category, what it does) so I can score keyword relevance accurately:`

### Post-Resolution Confirmation

After resolving both keywords and app context, confirm:

`Researching keywords for: {app_name} ({platform}) | Seed keywords: {count} provided`

---

## Keyword Expansion

Expand the user's seed list using two complementary methods. The goal is to discover keywords the user may not have considered while staying relevant to the app's category and features.

### 1. Apple Search Autocomplete [OBSERVED]

For each seed keyword (process up to 10 seeds to avoid excessive web searches), use WebSearch to query:

- `{keyword} app site:apps.apple.com` -- Extract related terms that appear in competitor titles and subtitles from the search results.
- `{keyword}` combined with common modifiers: "best", "free", "top", and "for {use case}" variations -- Capture long-tail phrases that users actually search for.

Record each discovered term with its source: `Source: Apple autocomplete [OBSERVED]`

**Query strategy by seed type:**
- Single-word seeds (e.g., "meditation"): Run the base query plus 2-3 modifier queries ("best meditation app", "meditation for beginners").
- Multi-word seeds (e.g., "guided meditation"): Run the base query only -- the phrase itself is already a long-tail variation.
- Brand-adjacent seeds (e.g., "headspace alternative"): Run the base query and note any competitor names that appear in results for competitive keyword mapping.

**Platform adjustment:** If the platform is Android, substitute `site:play.google.com` for the search queries. The method and labeling remain the same -- the point is discovering real search terms from store listings.

### 2. Claude Semantic Expansion [ESTIMATED]

For each seed keyword, generate related terms across these dimensions:

- **Synonyms** -- Alternative words with the same meaning (e.g., "meditation" -> "mindfulness", "zen", "contemplation")
- **Long-tail variations** -- Multi-word phrases incorporating the seed (e.g., "meditation" -> "guided meditation for sleep", "morning meditation routine")
- **Feature-adjacent terms** -- Keywords for features related to the seed's domain (e.g., "meditation" -> "breathing exercises", "sleep sounds", "relaxation timer")
- **Problem-solving phrases** -- What users are trying to accomplish (e.g., "meditation" -> "reduce stress", "fall asleep faster", "improve focus")
- **Category terms** -- Broader category descriptors (e.g., "meditation" -> "wellness app", "mental health", "self care")

Label each generated term: `Source: semantic expansion [ESTIMATED]`

### 3. Deduplication

After combining seeds, autocomplete discoveries, and semantic expansions:

- Remove exact duplicates (case-insensitive).
- Merge near-duplicates -- singular/plural forms, minor spelling variants -- keeping the more common form.
- Retain the original seed keywords even if they appear in expansion results. Mark them as `Source: user seed` to distinguish from discovered terms.

### Expansion Target

- If the seed list contains fewer than 30 keywords, expand to 30-50 total candidates (including originals).
- If the seed list already contains 30 or more keywords, expand by approximately 50% rather than to a fixed target.

### Post-Expansion Confirmation

`Expanded {seed_count} seeds to {total_count} keyword candidates ({expanded_count} new terms discovered)`

---

## Relevance Scoring

Score every keyword (both seed and expanded) for relevance to the app. Relevance measures how well a keyword matches what the app actually does -- it answers "would a user searching this keyword be satisfied finding this app?"

### Scoring Scale [ESTIMATED]

| Score | Meaning |
|-------|---------|
| 9-10 | Core feature or primary use case of the app |
| 7-8 | Strongly related feature or common user need the app addresses |
| 5-6 | Moderately related -- relevant audience but not a direct feature |
| 3-4 | Tangentially related -- same broad category but weak fit |
| 1-2 | Irrelevant or misleading -- would attract wrong users |

### Scoring Inputs

Base the relevance assessment on all available app context:

- **App description** (from `.aso-context.json` or user-provided description) -- Does the keyword appear in or align with what the app describes as its functionality?
- **App category** -- Is the keyword typical for this category of apps?
- **Title and subtitle keywords** -- Keywords already in the title/subtitle are assumed core to the app's identity.
- **Feature alignment** -- Does the keyword describe something the app actually does, or something adjacent that the app does not offer?

### Output Table

Present all keywords in a single table sorted by relevance score (highest first):

| Keyword | Relevance | Explanation | Source |
|---------|-----------|-------------|--------|
| {keyword} | {score}/10 | {One-sentence explanation of semantic fit to the app} | {user seed / Apple autocomplete [OBSERVED] / semantic expansion [ESTIMATED]} |
| ... | ... | ... | ... |

If the user provided volume or difficulty scores with their keywords, add those columns to the table and label them `[USER-PROVIDED]`:

| Keyword | Relevance [ESTIMATED] | Volume [USER-PROVIDED] | Difficulty [USER-PROVIDED] | Explanation | Source |
|---------|----------------------|----------------------|---------------------------|-------------|--------|
| ... | ... | ... | ... | ... | ... |

### Score Distribution Guidance

A well-scored keyword list should have a distribution, not uniform scores. Expect roughly:

- 20-30% of keywords scoring 8-10 (core terms)
- 40-50% scoring 5-7 (related terms worth targeting)
- 20-30% scoring 1-4 (weak fits to consider dropping)

If all keywords score 7+, the expansion likely stayed too narrow. If most score below 5, the seeds may not align well with the app's actual functionality.

### Relevance vs Popularity

Relevance scoring is independent of popularity or search volume. A keyword can be highly relevant (9/10) but have low search volume, or have massive volume but poor relevance (2/10). This section measures only semantic fit.

Popularity signals are addressed separately -- if the user provides volume data, it is displayed alongside relevance but scored independently. Without user-provided volume data, do not estimate or fabricate search volume numbers. Reference: Data Integrity section in `rules/aso-domain.md`.

`All relevance scores are analytical assessments based on the app's description, category, and feature set. [ESTIMATED]`

### Platform-Specific Relevance Notes

**iOS:** Keywords scoring 7+ are strong candidates for the title, subtitle, or keyword field. Reference the iOS Keyword Field Rules in `rules/aso-domain.md` -- the 100-character keyword field should prioritize high-relevance terms not already covered by the title and subtitle.

**Android:** Keywords scoring 7+ should appear in the title, short description, or be naturally integrated into the full description. Unlike iOS, Google Play indexes the full description for search -- so even moderately relevant keywords (5-6) can be strategically placed in the description body at a density of roughly 1 mention per 250 characters.

**Both platforms:** Keywords scoring 3 or below are candidates for removal from the target list. Targeting irrelevant keywords wastes metadata space and may attract users who will not retain, hurting engagement signals that both platforms use for ranking.

---

## User-Provided Data Integration

When the user's keyword input includes volume and/or difficulty scores from their paid ASO tools (AppTweak, Sensor Tower, data.ai, etc.), handle them with strict preservation.

### Rules

1. **Preserve exactly** -- Never modify, round, re-estimate, or reinterpret user-provided volume or difficulty numbers. Display them in their original form exactly as the user supplied them.
2. **Label as [USER-PROVIDED]** -- User-provided data is distinct from OBSERVED (data fetched from a live source) and ESTIMATED (Claude's analytical assessments). User-provided data comes from the user's paid tools and is trusted as-is.
3. **Display alongside Claude's analysis** -- The keyword table must show both Claude's relevance score [ESTIMATED] and the user's volume/difficulty [USER-PROVIDED] when provided. These are independent assessments that complement each other.

### Enhanced Table Format (User Provides Scores)

When the user's keyword input includes volume and/or difficulty columns, use this expanded table format:

| Keyword | Relevance [ESTIMATED] | Volume [USER-PROVIDED] | Difficulty [USER-PROVIDED] | Explanation | Source |
|---------|----------------------|----------------------|---------------------------|-------------|--------|
| meditation | 10/10 | 62 | 43 | Core app feature, exact match to primary use case | Seed |
| mindfulness | 9/10 | -- | -- | Strong synonym for app's central theme | Expansion |
| sleep tracker | 8/10 | 35 | 28 | Key feature the app offers | Apple autocomplete |

- A `--` in Volume or Difficulty means the user provided scores for some keywords but not this one. Preserve the column and show the gap.
- If the user provides only volume (no difficulty) or only difficulty (no volume), include the column they provided and omit the other entirely.

### Table Format Without User Scores

When the user does NOT provide volume or difficulty data:

- Do NOT fabricate numbers. Do NOT estimate numeric volume or difficulty.
- Omit the Volume and Difficulty columns entirely -- no empty columns, no dashes, no placeholder values.
- The Popularity Signals section below provides directional guidance instead.
- Use the standard relevance table format from the Relevance Scoring section above.

### Data Source Reference

User-provided scores originate from the user's paid ASO tools. These tools have access to proprietary search volume and competition data that cannot be replicated from public sources. Treat [USER-PROVIDED] data as the most authoritative source when available. Reference: Data Integrity section in `rules/aso-domain.md`.

---

## Popularity Signals

When the user has NOT provided volume or difficulty data, provide directional popularity signals using Apple autocomplete presence as a proxy. This section is skipped entirely if user-provided volume/difficulty data is available.

**If user provided volume/difficulty data:** Print the following and skip to Intent Grouping:

`Popularity signals skipped -- using your provided volume/difficulty data.`

### Method

For the top 20 keywords by relevance score, check Apple autocomplete presence as a directional popularity signal:

1. Use WebSearch to query: `{keyword} site:apps.apple.com` (or `site:play.google.com` for Android)
2. Examine search results for indicators of popularity:
   - Does the keyword appear in autocomplete suggestions?
   - How many top apps target this term in their title or subtitle?
   - Is the term common in the app category's listings?
3. Classify each keyword into a popularity tier based on the signals found.

### Popularity Tiers [ESTIMATED]

| Tier | Signal | Interpretation |
|------|--------|----------------|
| High | Appears in autocomplete, multiple top apps target this term in titles/subtitles | Likely high search volume -- competitive keyword, harder to rank for |
| Medium | Appears in autocomplete or found in several app titles/subtitles | Moderate search interest -- achievable ranking with good metadata |
| Low | Not in autocomplete, few apps target this term | Niche -- lower volume but potentially lower competition, easier to rank |
| Unknown | Could not determine from available signals | Insufficient signal -- recommend user check paid tools for verification |

### Popularity-Enhanced Table

Add a Popularity column to the keyword table for the top 20 keywords checked:

| Keyword | Relevance | Popularity [ESTIMATED] | Explanation | Source |
|---------|-----------|----------------------|-------------|--------|
| meditation | 10/10 | High | Core feature, highly competitive category term | Seed |
| sleep tracker | 8/10 | Medium | Feature term found in several competitor subtitles | Apple autocomplete |
| zen timer | 6/10 | Low | Niche term, few apps targeting it directly | Semantic expansion |

Keywords beyond the top 20 (lower relevance) do not receive a popularity check. Mark them as `Popularity: --` in the table.

### Important Caveats

Include these caveats in the output when displaying popularity signals:

- "Popularity tiers are directional estimates based on Apple autocomplete presence and competitor analysis. They are NOT search volume numbers."
- "For accurate volume and difficulty data, use a paid ASO tool (AppTweak, Sensor Tower, data.ai) and re-run `/aso:keywords` with your data file."
- "Popularity signals are most useful for relative comparison between keywords in your list -- ranking keywords against each other -- not as absolute volume indicators."

Reference: Data Integrity section in `rules/aso-domain.md` -- popularity tiers are [ESTIMATED] and must not be presented as observed data.

---

## Intent Grouping

Group ALL keywords (seed + expanded) into intent categories. Every keyword must appear in exactly one group. No keyword should be omitted or duplicated across groups.

### Intent Categories

| Intent Category | Definition | Example Keywords |
|-----------------|------------|-----------------|
| Navigational | User searching for a specific app by name or brand | "spotify", "calm app", "headspace" |
| Feature-Seeking | User searching for a specific capability or function | "sleep tracker", "guided meditation", "breathing exercises" |
| Problem-Solving | User searching for a solution to a problem | "can't sleep", "reduce anxiety", "focus at work" |
| Comparison | User evaluating options or alternatives | "best meditation app", "calm vs headspace", "free yoga app" |
| Category | User browsing a general app category | "wellness app", "health and fitness", "mindfulness apps" |

### Classification Guidance

- **Navigational** includes any keyword containing a known app or brand name, even if combined with generic terms ("calm meditation" is navigational because it contains the brand "Calm").
- **Feature-Seeking** keywords describe a specific function or capability the user wants. These are the strongest conversion keywords because the user wants exactly what the app offers.
- **Problem-Solving** keywords describe the user's situation or goal, not a specific feature. These often have high install intent because the user is actively seeking a solution.
- **Comparison** keywords contain comparative language: "best", "top", "vs", "alternative to", "free", "cheap". Users are evaluating options.
- **Category** keywords describe a broad app category or genre. These are high-volume but lower-conversion because the user's intent is not specific.

When a keyword could fit multiple categories, choose the most specific one. Priority: Navigational > Feature-Seeking > Problem-Solving > Comparison > Category.

### Output Format

For each intent group, list keywords sorted by relevance score (highest first). Include relevance score and volume/popularity if available:

### Navigational
| Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} |
|---------|-----------|-----------------------------------------------------|
| {keyword} | {score}/10 | {value} |

### Feature-Seeking
| Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} |
|---------|-----------|-----------------------------------------------------|
| {keyword} | {score}/10 | {value} |

### Problem-Solving
| Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} |
|---------|-----------|-----------------------------------------------------|
| {keyword} | {score}/10 | {value} |

### Comparison
| Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} |
|---------|-----------|-----------------------------------------------------|
| {keyword} | {score}/10 | {value} |

### Category
| Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} |
|---------|-----------|-----------------------------------------------------|
| {keyword} | {score}/10 | {value} |

If a group has zero keywords, display it with a note: "No keywords in this category. Consider adding {intent type} terms to broaden your keyword strategy."

### Group Summary

After all groups, provide an intent distribution summary:

`Intent Distribution: Feature-Seeking ({N}), Problem-Solving ({N}), Category ({N}), Comparison ({N}), Navigational ({N})`

Identify which intent group has the most keywords and which has gaps. Provide a strategic recommendation:

- If Feature-Seeking dominates: "Your keyword list is feature-focused. Consider adding problem-solving terms -- users searching for solutions ('how to sleep better') often have higher install intent."
- If Problem-Solving dominates: "Strong problem-solving coverage. Consider adding feature-seeking terms to capture users who already know what they want ('meditation timer', 'sleep sounds')."
- If Category dominates: "Your keywords are broad. Consider adding more specific feature-seeking and problem-solving terms for higher conversion."
- If Navigational dominates: "Heavy brand/competitor focus. Expand into feature-seeking and problem-solving keywords to capture users who don't yet know which app they want."
- If Comparison dominates: "Good competitive positioning. Add feature-seeking terms to capture users past the comparison stage."
- If any group is empty: Note the gap and suggest 2-3 example keywords for that intent category relevant to the app.

---

## iOS Keyword Field String

This section generates a ready-to-paste iOS keyword field string. It applies ONLY to iOS apps.

**If the app's platform is Android:** Print the following and skip to the next section:

`iOS keyword field not applicable -- see Google Play Keyword Integration below.`

### Construction Rules

Reference: iOS Keyword Field Rules in `rules/aso-domain.md`. The rules are restated here for generation convenience:

1. **Comma-separated, NO spaces after commas** -- Spaces consume characters. Write `keyword1,keyword2` not `keyword1, keyword2`.
2. **Do NOT include words already in the app's Title or Subtitle** -- Apple auto-indexes title + subtitle + keyword field together. Repeating words wastes space.
3. **Prefer singular forms over plural** -- Apple indexes both singular and plural from the singular form. Use "tracker" not "trackers".
4. **Do NOT include competitor brand names** -- Policy violation risk. Apple may reject the update.
5. **Omit prepositions and articles** -- "the", "a", "for", "and", "of", "in", "to", "with" waste space.
6. **Use every available character** -- Unused space is wasted ranking opportunity. Target 95-100 characters used.

### Keyword Selection

From the scored keyword list (Relevance Scoring section output), select keywords for the field using this priority:

1. **Tier 1: Relevance 8-10 keywords NOT already in the title or subtitle.** These are the highest-value terms. If user provided volume data [USER-PROVIDED], use volume as a tiebreaker within this tier (higher volume first). If popularity tiers are available [ESTIMATED], prefer High/Medium over Low/Unknown within this tier.
2. **Tier 2: Relevance 6-7 keywords NOT already in the title or subtitle.** Fill remaining space with these secondary terms, applying the same tiebreaker logic.
3. **Word decomposition:** Convert multi-word phrases to individual words (e.g., "guided meditation" contributes "guided" and "meditation" as separate terms). Only include a word if it is not already covered by another keyword in the field or by the title/subtitle.
4. **Singular conversion:** Convert all plural forms to singular (e.g., "exercises" becomes "exercise").
5. **Strip filler:** Remove prepositions, articles, and filler words before inserting into the string.
6. **Deduplication:** If a word is already present in the keyword string (from a previous keyword's decomposition), do not add it again.

### Generated Keyword String

Build and display the keyword field string following the construction rules above:

```
keyword1,keyword2,keyword3,related,term,synonym
```

After the string, display the character count:

`{N}/100 characters used ({remaining} remaining)`

- **If the string exceeds 100 characters:** Trim keywords from the lowest-priority end (lowest relevance tier, then lowest volume/popularity within that tier) until the string fits within 100 characters. Note which keywords were removed and why.
- **If the string is under 90 characters:** Note: `"Consider adding more terms to maximize coverage -- {remaining} characters available."`
- **If the string is between 90 and 100 characters:** No additional note needed -- this is optimal usage.

### Coverage Report

After the generated string, show what the combined title + subtitle + keyword field covers:

1. **Unique searchable terms:** Count how many unique searchable words the combined metadata produces (title words + subtitle words + keyword field words, deduplicated). Display as: `"{N} unique searchable terms from combined metadata (title + subtitle + keyword field)"`
2. **High-relevance overflow:** Identify any keywords with relevance 8+ that could NOT fit in the keyword field. List them with their relevance score.
3. **Swap suggestions:** If critical keywords (relevance 9-10) were excluded due to space, note: `"Overflow -- consider swapping with lower-priority terms in the keyword field:"` and list the specific swap recommendations (which low-priority keyword to remove, which high-priority keyword to add).

`Keyword field string is an optimized recommendation based on relevance analysis and formatting rules. [ESTIMATED]`

---

## Google Play Keyword Integration

This section provides keyword integration guidance for Google Play (Android) app descriptions. It applies ONLY to Google Play (Android) apps.

**If the app's platform is iOS:** Print the following and skip to the next section:

`Google Play integration not applicable -- see iOS Keyword Field String above.`

### Integration Strategy

Google Play indexes the full description for search. Unlike iOS (which has a dedicated keyword field), Android keyword optimization happens by naturally weaving keywords into the description text. There is no hidden keyword field -- every keyword must appear in user-visible metadata.

**Benchmark:** Approximately 1 exact keyword match per 250 characters of description (reference: `rules/aso-domain.md`). For a 2,000-character description, target 8 keyword instances. For a 4,000-character description (maximum), target up to 16 keyword instances.

### Priority Keywords for Description

From the scored keyword list, select the top 15-20 keywords with relevance 6+ that should appear in the full description. Present as a table sorted by priority:

| Priority | Keyword | Relevance | Suggested Placement |
|----------|---------|-----------|---------------------|
| 1 | {keyword} | {X}/10 | First paragraph (front-load) |
| 2 | {keyword} | {X}/10 | First paragraph |
| ... | ... | ... | Feature list / mid-description / closing |

**Placement guidance by relevance tier:**

- **Relevance 9-10:** First paragraph. Front-load these keywords -- the opening 250 characters carry the most ranking weight. Place the single most important keyword in the first sentence.
- **Relevance 7-8:** Feature descriptions or mid-description paragraphs. These keywords should appear naturally when describing the app's capabilities.
- **Relevance 6:** Closing section or secondary feature mentions. Lower-priority terms that still deserve inclusion for long-tail search coverage.

If user provided volume data [USER-PROVIDED], include it as a column and factor it into priority ordering (higher volume = higher priority within the same relevance tier).

### Title and Short Description Keywords

Separately list the top 3-5 keywords that should appear in the Google Play title (30-character limit) and short description (80-character limit). These should be the highest-relevance, most competitive keywords from the analysis.

**Title keywords (top 3):**
| Keyword | Relevance | Rationale |
|---------|-----------|-----------|
| {keyword} | {X}/10 | {Why this keyword belongs in the title} |

**Short description keywords (top 5):**
| Keyword | Relevance | Rationale |
|---------|-----------|-----------|
| {keyword} | {X}/10 | {Why this keyword belongs in the short description} |

Note: Title and short description keywords should also appear in the full description for reinforcement -- Google Play rewards consistency across all metadata fields.

### Density Guidance

For a typical 2,000-4,000 character description:

- **Target:** 8-16 keyword instances across the full description (benchmark: ~1 per 250 characters)
- **Per-keyword frequency:** Each priority keyword should appear 1-3 times:
  - 1 time: Sufficient for most keywords
  - 2 times: Appropriate for primary keywords (relevance 9-10)
  - 3 times maximum: Only for the single most important keyword
- **Naturalness requirement:** Keywords must read naturally within sentences. Never keyword-stuff -- Google Play penalizes unnatural repetition and may reject the listing.
- **Distribution:** Spread keywords across the entire description. Avoid clustering all keywords in one paragraph.

`Keyword integration guidance is based on relevance analysis and Google Play indexing behavior. [ESTIMATED]`

---

## Prioritized Focus Keywords

This section applies to BOTH platforms. It synthesizes the keyword analysis into a clear "here are your top keywords" summary, combining relevance scoring with volume/popularity and intent signals.

### Selection Criteria

Combine relevance score with available data to produce a priority ranking:

1. **Primary sort:** Relevance score (highest first)
2. **Secondary sort (when user provided volume [USER-PROVIDED]):** Volume (higher first within the same relevance tier)
3. **Secondary sort (when popularity tiers [ESTIMATED] available, no user volume):** Popularity tier (High > Medium > Low > Unknown within the same relevance tier)
4. **Tiebreaker:** Intent category priority -- Feature-Seeking and Problem-Solving keywords rank above Category and Comparison keywords at the same relevance and volume/popularity level. Rationale: Feature-Seeking and Problem-Solving keywords signal higher conversion intent (the user wants what the app offers or is actively seeking a solution).

### Top 10-15 Focus Keywords

Present the prioritized list as a table. Select 10-15 keywords. If the total keyword list has fewer than 15 high-quality candidates (relevance 6+), include fewer rather than padding with weak keywords.

| Rank | Keyword | Relevance | {Volume [USER-PROVIDED] or Popularity [ESTIMATED]} | Intent | Why Focus |
|------|---------|-----------|-----------------------------------------------------|--------|-----------|
| 1 | {keyword} | {X}/10 | {value} | {intent category} | {One sentence: why this keyword deserves focus -- combines relevance reasoning with competitive/volume signal} |
| 2 | {keyword} | {X}/10 | {value} | {intent category} | {explanation} |
| ... | ... | ... | ... | ... | ... |

**Column notes:**
- The fourth column header adapts based on available data: show "Volume [USER-PROVIDED]" if the user provided volume scores, otherwise show "Popularity [ESTIMATED]" if popularity tiers were generated, otherwise omit the column.
- Intent category values come from the Intent Grouping section (Navigational, Feature-Seeking, Problem-Solving, Comparison, Category).

### Strategic Summary

After the table, provide a 2-3 sentence strategic overview covering:

1. **Intent balance:** Which intent categories dominate the focus list and whether this is ideal for the app's growth stage.
2. **Competitive positioning:** Whether the list skews toward competitive keywords (high-volume/high-relevance) or niche keywords (lower-volume but high-relevance and lower competition).
3. **One actionable recommendation:** A specific next step for keyword strategy refinement (e.g., "Add more problem-solving terms to capture users searching for solutions" or "Consider targeting lower-competition long-tail variants of your top 3 keywords").

---

## Analysis Summary

Concise summary of the keyword research results, following the pattern established in `/aso:audit`.

### Quick Stats

| Metric | Count |
|--------|-------|
| Seed keywords | {N} |
| Expanded keywords | {N} |
| Total candidates | {N} |
| High relevance (7+) | {N} |
| Intent groups covered | {N}/5 |

### Top 5 Keywords

List the top 5 keywords by relevance score. When user-provided volume data is available, factor it into the ranking (relevance first, volume as tiebreaker). When popularity signals are available, note the tier alongside relevance:

1. **{keyword}** -- Relevance: {X}/10{, Volume: {Y} [USER-PROVIDED] | Popularity: {tier} [ESTIMATED]} -- {one-line explanation of why this keyword matters for the app}
2. **{keyword}** -- Relevance: {X}/10{, ...} -- {explanation}
3. **{keyword}** -- Relevance: {X}/10{, ...} -- {explanation}
4. **{keyword}** -- Relevance: {X}/10{, ...} -- {explanation}
5. **{keyword}** -- Relevance: {X}/10{, ...} -- {explanation}

### Next Steps

- "Full keyword research report saved to your working directory (see Report Output below)."
- "Platform-specific output (iOS keyword field string or Google Play integration guidance) is included above."
- "To optimize your metadata using these keywords, run `/aso:optimize`."
- "To audit your current store listing against these keywords, run `/aso:audit`."

---

## Report Output

After completing the analysis and printing the Analysis Summary above, save the full keyword research as a Markdown report file.

### Filename Convention

Build the filename from the app name and current date:

`{app_name_slug}-keyword-research-{YYYY-MM-DD}.md`

Where:
- `{app_name_slug}` is the app name lowercased with spaces replaced by hyphens, non-alphanumeric characters (except hyphens) removed, and consecutive hyphens collapsed to one (e.g., "My App: Pro Edition!" becomes `my-app-pro-edition`)
- `{YYYY-MM-DD}` is today's date

Example: `calm-keyword-research-2026-04-02.md`

### Report Contents

Use the **Write tool** to save the file to the current working directory. The report must contain ALL of the following sections from this keyword research, in order:

1. **Header** -- App name, platform, date, seed count, total keyword count
2. **Quick Stats Table** -- The same table from Analysis Summary
3. **Relevance Scoring Table** -- Full scored keyword table
4. **Intent Grouping** -- All intent group tables with distribution summary
5. **iOS Keyword Field String** (iOS only) -- Generated keyword string with coverage report
6. **Google Play Keyword Integration** (Android only) -- Priority keyword table with placement guidance
7. **Prioritized Focus Keywords** -- Top 10-15 focus keyword table with strategic summary
8. **Footer** -- "Generated by /aso:keywords on {YYYY-MM-DD}"

Format the header as:

```markdown
# Keyword Research: {App Name}

**Platform:** {iOS / Android}
**Date:** {YYYY-MM-DD}
**Seed Keywords:** {N} | **Total Candidates:** {N} | **High Relevance (7+):** {N}
```

### Post-Save Confirmation

After writing the file, print:

`Report saved: ./{filename}`

---

## Data Labeling Convention

Follow the OBSERVED/ESTIMATED labeling convention from `rules/aso-domain.md` throughout all output:

- **OBSERVED** -- Data retrieved from a live, verifiable source (store listing page, iTunes API, web search results). Cite the source.
- **ESTIMATED** -- Analytical assessments, relevance scores, strategic recommendations, and any conclusions inferred by Claude. Explain the reasoning basis.
- **USER-PROVIDED** -- Data supplied by the user in their keyword list (volume scores, difficulty scores, or other metrics from their paid ASO tools). Display as-is without modification.

Never present an estimate as observed data. Never fabricate search volume, difficulty scores, or ranking data -- reference the Data Integrity section of `rules/aso-domain.md`.

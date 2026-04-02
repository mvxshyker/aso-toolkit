---
name: aso:audit
description: Audit an app store listing with detailed metadata analysis. Analyzes title, subtitle, description, and keyword strategy against platform-specific best practices.
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Write
  - Bash
  - Agent
argument-hint: "<store-url-or-app-name>"
---

You are the ASO Audit command. You perform a comprehensive analysis of an app's store listing metadata, evaluating each text field against platform-specific best practices defined in `rules/aso-domain.md`.

This audit covers metadata analysis: title, subtitle/short description, description text, and keyword field strategy. Scoring, competitive context, and report file output are handled by subsequent commands and will be integrated into this workflow in a future update.

Before starting, read `rules/aso-domain.md` to load platform character limits, the OBSERVED/ESTIMATED data labeling convention, keyword field rules, and the scoring rubric reference.

## Input Resolution

Handle user input in this priority order. The first matching path wins.

### Path A: Explicit Argument

If `$ARGUMENTS` is provided (a store URL, app ID, or app name):

1. **Detect the platform** using the Platform Detection section in `rules/aso-domain.md`:
   - URL containing `apps.apple.com` or `itunes.apple.com` --> iOS. Extract the numeric ID with pattern `/id(\d+)`.
   - URL containing `play.google.com/store/apps` --> Android. Extract the package ID from the `id=` query parameter.
   - Pure numeric string (9-10 digits) --> iOS. Use as the Apple app ID directly.
   - Reverse-domain ID (e.g., `com.example.app`) --> Android. Use as the Google Play package name.
   - Plain text app name --> platform unknown. Use WebSearch for `"$ARGUMENTS" site:apps.apple.com OR site:play.google.com`. If results are ambiguous (both platforms found), present options and ask the user to pick.

2. **Fetch metadata** using the Data Fetching section below.

3. Print: `Auditing: {app_name} ({platform})`

### Path B: Active App Context

If no `$ARGUMENTS` provided, check for `.aso-context.json` in the current working directory using the Read tool.

- **File exists:** Load the JSON. Use the stored `platform`, `title`, `subtitle`, `short_description`, `description`, `rating`, `rating_count`, and `category` fields. Print: `Using active app: {app_name}` -- no confirmation prompt, proceed directly to analysis.
- **File does not exist:** Fall through to Path C.

### Path C: No Input Available

If neither an argument nor `.aso-context.json` is available, ask the user:
`Provide an App Store or Google Play URL, or an app name to audit.`

### Required Data After Input Resolution

After resolving input, the audit must have at minimum: **platform** (ios or android), **title**, and **description**. The subtitle (iOS) or short_description (Android) is used if available but the audit can proceed without it -- flag its absence as a finding. Rating and category are used when available but are not required for metadata analysis.

## Data Fetching

Skip this section entirely if metadata was loaded from `.aso-context.json` (data is already available).

### iOS -- With Numeric App ID

Use WebFetch to call the iTunes Lookup API:
`https://itunes.apple.com/lookup?id={NUMERIC_ID}`

Map response fields:
- `title` = `trackName`
- `description` = `description`
- `rating` = `averageUserRating`
- `rating_count` = `userRatingCount`
- `category` = `primaryGenreName`

The iTunes API does **not** return the subtitle. Use WebSearch for the App Store page (`site:apps.apple.com "{trackName}"`) and extract the subtitle from the page content.

### iOS -- From URL

Extract the numeric ID from the URL path using regex `id(\d+)`, then call the iTunes Lookup API as above.

### Android

Use WebSearch: `site:play.google.com/store/apps/details "{app name or package ID}"`

Extract from the listing page: title, short description, full description, rating, rating count, category.

### App Name (No URL or ID)

Use WebSearch: `"{app name}" app store listing`

Identify the platform from search results. Extract metadata from the most relevant store listing page found. If both platforms appear, ask the user to choose.

### Post-Fetch Confirmation

After fetching, confirm what was retrieved:
`Retrieved metadata: title ({char_count} chars), subtitle/short desc ({char_count} chars), description ({char_count} chars)`

If any field could not be retrieved, note it: `Note: {field_name} not available from source.`

---

## Title Analysis

> Ranking weight context: Title carries the highest weight in both iOS and Google Play ranking algorithms. Analyze this field first and most thoroughly.

### 1. Character Usage [OBSERVED]

Report: `{current_length}/{limit} characters used ({remaining} remaining)`

Reference `rules/aso-domain.md` for the platform-specific limit:
- iOS: 30 characters
- Google Play: 30 characters

Flag levels:
- **CRITICAL** -- Title exceeds the character limit (will be truncated or rejected)
- **HIGH opportunity** -- More than 10 characters unused (significant keyword real estate wasted)
- **Good** -- Between 0-10 characters remaining (well-utilized)

### 2. Keyword Presence [ESTIMATED]

Identify keywords present in the title:
- List each keyword or keyword phrase found
- Assess whether high-value keywords are **front-loaded** (appearing in the first half of the title). Front-loaded keywords receive more ranking weight on both platforms.
- Identify obvious **missing keywords** for the app's apparent category. Base this on the app's description and category context.

### 3. Brand vs Keyword Balance [ESTIMATED]

Evaluate the title structure:
- **Pure brand name** with no keywords: Flag as a missed opportunity -- unless the brand is globally recognizable (e.g., Spotify, Netflix, Instagram). Well-known brands can rely on brand search volume alone.
- **Keyword-stuffed** with no brand identity: Flag as a readability concern and potential policy risk. Titles that read as keyword lists damage conversion and may violate store guidelines.
- **Balanced approach** (e.g., "BrandName - Key Feature" or "BrandName: Descriptor"): Note as good practice.
- **Google Play only:** Check against the prohibited words list from `rules/aso-domain.md` -- no "Best", "#1", "Free", "Top", ALL CAPS words (unless brand name), emojis, or misleading performance claims. Flag any violations as CRITICAL (risk of listing suspension).

### 4. Readability [ESTIMATED]

Assess whether the title reads as a natural phrase or name. Keyword stuffing that creates nonsensical word strings damages conversion rate even if it improves search ranking. A title should be something a user would naturally say when recommending the app.

---

## Subtitle / Short Description Analysis

> Ranking weight context: The subtitle (iOS) or short description (Android) is the second most important text metadata field for search ranking.

Branch analysis by platform:

### iOS Subtitle (30 characters)

**1. Character Usage [OBSERVED]:**
Report: `{current_length}/30 characters used ({remaining} remaining)`
- Flag significant underuse (more than 10 characters unused) as a missed keyword opportunity.

**2. Keyword Coverage [ESTIMATED]:**
- List keywords present in the subtitle.
- Check for **duplication with the title**. Apple combines title + subtitle for search indexing, so repeating the same keywords across both fields wastes characters. Flag any duplicated keywords as: `Wasted -- already indexed via title: "{keyword}"`
- Identify keywords in the subtitle that are unique (not in the title) -- these extend the app's search footprint.

**3. Value Proposition [ESTIMATED]:**
- **Strong:** Communicates a clear benefit or what the app does (e.g., "Track your sleep naturally")
- **Weak:** Generic descriptor ("The best app"), redundant with title, or uses vague language
- Does the subtitle make a user want to tap and learn more?

### Google Play Short Description (80 characters)

**1. Character Usage [OBSERVED]:**
Report: `{current_length}/80 characters used ({remaining} remaining)`
- 80 characters provides more room than the iOS subtitle -- assess whether this space is well-utilized or wasted.

**2. Keyword Coverage [ESTIMATED]:**
- List search-relevant keywords present in the short description.
- The short description IS indexed on Google Play -- keyword presence directly affects ranking.
- Are keywords integrated naturally into the text, or awkwardly stuffed?

**3. Value Proposition Clarity [ESTIMATED]:**
- This is the first text users see on the Google Play listing page -- does it compel a tap?
- Does it communicate the core app value in one scannable line?
- Is it specific enough to differentiate from competitors?

### Missing Field [CRITICAL]

If the subtitle (iOS) or short description (Android) is missing or empty, flag as **CRITICAL**:
`No subtitle/short description found. This field directly impacts search ranking and is the second most important text metadata field.`

---

## Description Analysis

> Ranking weight context: Description strategy differs fundamentally by platform. iOS descriptions are NOT indexed for search (write for conversion). Google Play descriptions ARE indexed (write for both keywords and conversion).

Branch analysis by platform:

### iOS Description (4,000 characters, NOT indexed for search)

Since Apple does NOT index the description for search ranking, analyze purely for conversion quality:

**1. First 3 Lines Test [ESTIMATED]:**
The store listing truncates the description after approximately 3 lines. Evaluate whether the first 3 lines:
- State the core value proposition clearly?
- Create urgency or curiosity to expand and read more?
- Avoid wasting space on the developer name, generic welcome text, or boilerplate?

**2. Readability and Scannability [ESTIMATED]:**
- Are there short paragraphs or bullet points? A wall of text without visual breaks hurts readability.
- Is the language **benefit-focused** ("Track your sleep and wake up refreshed") vs **feature-focused** ("Sleep tracking feature included")?
- Estimated reading level: aim for grade 6-8 for broad accessibility. Flag overly technical or complex language.

**3. Feature Coverage [ESTIMATED]:**
- List the key features mentioned in the description.
- Are features presented as user benefits or as technical specifications?
- Are there obvious missing features for this type of app?

**4. Call to Action (CTA) [ESTIMATED]:**
- **Strong CTA:** Description ends with a clear prompt to install (e.g., "Download now and start tracking your goals today")
- **Weak CTA:** Trails off with a feature list or ends abruptly
- **Missing CTA:** No call to action at all -- flag as MEDIUM opportunity

**5. Social Proof [ESTIMATED]:**
- Are there mentions of awards, press coverage, user count, testimonials, or ratings?
- **Present:** Note what social proof is included and whether it is specific (good) or vague (weak)
- **Missing:** Flag as opportunity: "Consider adding social proof: user count, awards, press mentions, or notable reviews"

### Google Play Description (4,000 characters, IS indexed for search)

Since Google Play DOES index the full description for search ranking, analyze for keyword integration AND readability:

**1. Keyword Density [ESTIMATED]:**
Identify likely target keywords from the app's title, short description, and category. Count instances of these keywords in the description.
- **Benchmark:** Approximately 1 exact keyword match per 250 characters of description (ESTIMATED guideline from ASO industry consensus)
- **Too few:** Missing ranking opportunity. Keywords that appear only once in 4,000 characters have weak signal.
- **Too many:** Keyword stuffing risk. Google may penalize listings with unnatural keyword repetition.
- Calculate and report: `{keyword_count} keyword instances in {char_count} chars = 1 per {chars_per_keyword} chars`

**2. Front-Loading [ESTIMATED]:**
- Are the most important keywords present in the first 1-2 paragraphs?
- Google weights early description content more heavily for ranking.
- The first paragraph should contain the primary target keywords integrated naturally.

**3. Scannability [ESTIMATED]:**
- Short paragraphs (3-4 sentences max)?
- Bullet points or feature lists for easy scanning?
- Headers, emoji separators, or visual structure?
- Wall of text with no breaks = poor scannability

**4. Natural Language Flow [ESTIMATED]:**
- Do keywords read naturally within sentences, or are they awkwardly inserted?
- **Natural:** "Track your daily steps and monitor your fitness goals with personalized coaching"
- **Stuffed:** "step counter fitness tracker pedometer walking app exercise step counting"
- Google's algorithm increasingly rewards natural language over keyword stuffing.

**5. First 3 Lines + CTA [ESTIMATED]:**
Apply the same conversion analysis as iOS: Does the opening hook the reader? Does the description end with a clear CTA?

---

## Keyword Field Guidance -- iOS Only

> This section applies ONLY to iOS apps. For Android apps, skip this section entirely -- Google Play has no hidden keyword field.

**Important framing:** The actual keyword field contents cannot be observed from outside the app's App Store Connect account. All guidance in this section is strategic recommendations based on what CAN be observed (title, subtitle, description) and ASO best practices from `rules/aso-domain.md`. Label all suggestions as ESTIMATED.

### 1. Formatting Rules Reminder

Reference the iOS Keyword Field Rules in `rules/aso-domain.md`:
- Comma-separated, NO spaces after commas (spaces consume characters)
- Do NOT repeat words already in the Title or Subtitle -- Apple automatically combines title + subtitle + keyword field for search indexing
- Prefer singular forms over plural (Apple indexes both singular and plural from singular)
- Do not include competitor brand names (policy violation risk)
- Avoid prepositions and articles ("the", "a", "for", "and") -- they waste space
- Use every available character -- unused space in the keyword field is wasted ranking opportunity

### 2. Coverage Strategy

Based on the app's title, subtitle, and description, identify keywords that are NOT already covered by the title or subtitle:
- Suggest high-value keywords from the app's category and feature set
- Include synonyms, related terms, and common user search phrases
- Estimate how many unique terms can fit in 100 characters (typically 15-25 short keywords depending on word length)
- Provide an example keyword string showing the comma-separated format:
  `keyword1,keyword2,keyword3,related term,synonym,feature name,...`

### 3. Opportunity Assessment

Identify keyword gaps -- terms that are relevant to the app but not present in the title or subtitle:
- Suggest the top 5-8 keywords that should be prioritized for the keyword field
- Frame as recommendations: "Consider including: {keyword1}, {keyword2}, {keyword3}, ..."
- Explain the reasoning for each suggested keyword (category relevance, feature match, user search intent)

`Keyword field contents cannot be observed externally. These are strategic recommendations based on visible metadata and ASO best practices. [ESTIMATED]`

---

## Analysis Summary

After completing all analysis sections above, provide a concise summary.

### Quick Stats Table [OBSERVED]

| Field | Length | Limit | Usage |
|-------|--------|-------|-------|
| Title | {n} chars | {limit} chars | {percent}% |
| Subtitle / Short Desc | {n} chars | {limit} chars | {percent}% |
| Description | {n} chars | 4,000 chars | {percent}% |

### Top Findings

List the 3 most impactful findings from the analysis, ordered by priority. Each finding should name the field, the issue, and why it matters for ranking or conversion.

### Next Steps

"For scoring, competitive context, and a full report file, these features will be available in a future update."

---

## Data Labeling Convention

Follow the OBSERVED/ESTIMATED labeling convention from `rules/aso-domain.md` throughout all output:

- **OBSERVED** -- Character counts, ratings, review counts, description text, and any data retrieved from a live source (store page, iTunes API). Cite the source.
- **ESTIMATED** -- Keyword assessments, quality evaluations, readability scores, strategic recommendations, and any analytical conclusions. Explain the reasoning basis.
- **When in doubt, label as ESTIMATED** -- the safer default.

Never present an estimate as observed data. Never omit the label on analytical assessments.

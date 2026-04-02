# ASO Domain Knowledge

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

### Google Play Console
<!-- Source: support.google.com/googleplay/android-developer/answer/9898842 | Verified: 2026-04-02 -->
<!-- Title limit reduced from 50 to 30 chars on 2021-09-29 per android-developers.googleblog.com/2021/04/ -->

| Field | Limit | Indexed | Notes |
|-------|-------|---------|-------|
| Title | 30 chars | YES (highest weight) | Reduced from 50 chars in Sept 2021 |
| Short Description | 80 chars | YES | Visible by default on listing |
| Full Description | 4,000 chars | YES | Unlike iOS, this IS indexed for search |
| What's New | 500 chars | NO | Per-release update notes |

### iOS Keyword Field Rules

- Comma-separated values, no spaces after commas
- Do not repeat words already in Title or Subtitle
- Prefer singular forms over plural (Apple indexes both)
- 100 characters total including commas
- Do not use competitor brand names (policy violation risk)
- Avoid prepositions and articles (waste of space)
- Use every available character -- unused space is wasted opportunity

### Google Play Prohibited Title Words

The following are prohibited by Google Play policy in app titles:
- "Best", "#1", "Free", "Top"
- Emojis or special characters used for attention
- Misleading performance claims ("Fastest", "Most Popular")
- ALL CAPS words (unless brand name)

Violation risk: Google may reject the update or suspend the listing.

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

| Input Type | Action |
|------------|--------|
| App name (plain text) | Ask user to specify platform, or search both stores |
| Unknown URL format | Ask user to clarify |

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

### Letter Grades

| Score Range | Grade |
|-------------|-------|
| 95-100 | A+ |
| 90-94 | A |
| 85-89 | B+ |
| 80-84 | B |
| 75-79 | C+ |
| 70-74 | C |
| 60-69 | D |
| Below 60 | F |

### Scoring Anchors

**Title (20% weight)**
- 9-10: Primary keyword first, within char limit, readable brand integration
- 5-7: Keywords present but not front-loaded, or slight readability issues
- 0-3: No target keywords, exceeds limit, or keyword-stuffed gibberish

**Subtitle / Short Description (15% weight)**
- 9-10: Unique keywords not in title, compelling value prop, within limit
- 5-7: Some keyword overlap with title, generic phrasing
- 0-3: Duplicates title words, empty, or exceeds limit

**Keywords / Description (15% weight)**
- 9-10: Maximizes unique keyword coverage, follows formatting rules, zero waste
- 5-7: Some duplication or unused capacity
- 0-3: Major formatting errors, heavy duplication, mostly wasted space

**Ratings & Reviews (15% weight)**
- 9-10: Rating 4.5+ with 10,000+ reviews, recent review activity
- 5-7: Rating 4.0-4.4 with moderate review count
- 0-3: Rating below 3.5, few reviews, or no recent activity

**Screenshots (15% weight)**
- 9-10: All slots used, feature callouts, localized, first 3 show core value
- 5-7: Some slots used, basic screenshots without callouts
- 0-3: Minimal screenshots, no callouts, outdated UI shown

**Icon (5% weight)**
- 9-10: Distinctive, readable at small sizes, consistent with brand, no text clutter
- 5-7: Recognizable but generic, minor readability issues at small sizes
- 0-3: Cluttered, unreadable at small sizes, or uses stock imagery

**Ranking Signals (10% weight)**
- 9-10: Top 10 in category, strong download velocity, positive trending
- 5-7: Top 100 in category, moderate download volume
- 0-3: No category ranking, declining downloads, or new app with no traction

**Description Quality (5% weight)**
- 9-10: Clear value prop in first 3 lines, scannable formatting, strong CTA
- 5-7: Adequate description but buried value prop or wall of text
- 0-3: No description, boilerplate only, or keyword-stuffed unreadable text

## ASO Ranking Factors

| Factor | iOS Weight | Android Weight | Notes |
|--------|-----------|---------------|-------|
| Title keywords | Very High | Very High | Most important metadata field on both platforms |
| Subtitle (iOS) / Short Desc (Android) | High | High | Secondary metadata signal |
| Keyword field (iOS only) | High | N/A | Hidden indexed field, iOS exclusive |
| Full description keywords | None | Medium | iOS does NOT index description; Google Play DOES |
| Download volume & velocity | High | High | Installs relative to category peers |
| Ratings (4.0+ threshold) | High | High | Below 4.0 significantly hurts conversion and ranking |
| Review count & recency | Medium | Medium | Fresh reviews signal active user base |
| Retention & engagement | Medium-High | Medium-High | Growing signal since 2024-2025 |
| Update frequency | Medium | Medium | Signals active maintenance |
| Crash rate / stability | Medium | Medium | Quality signal, especially on Android |

Ranking factor weights are not published by Apple or Google. The above reflects industry consensus as of 2026.

## Terminology

- **ASO (App Store Optimization):** The process of improving an app's visibility and conversion rate within app store search results and browse pages.
- **Keyword Field:** iOS-exclusive hidden metadata field (100 chars) indexed by Apple's search algorithm. Not visible to users.
- **Short Description:** Google Play metadata field (80 chars) visible by default on the store listing. Indexed for search.
- **Organic Installs:** Downloads that originate from store search or browse, not from paid ads or direct links.
- **Conversion Rate (Store Listing):** Percentage of store listing visitors who install the app. Influenced by screenshots, icon, ratings, and description.
- **Keyword Density:** Frequency of a keyword in text relative to total word count. Relevant for Google Play Full Description (indexed), not for iOS Description (not indexed).
- **Long-Tail Keywords:** Multi-word search phrases with lower volume but higher intent and lower competition. Example: "budget meal planner" vs "food app."
- **Search Visibility:** A composite measure of how often an app appears in search results across its target keywords.
- **Category Ranking:** An app's position within its primary and secondary store categories, based on download velocity and engagement.
- **Custom Product Pages (CPP):** iOS feature allowing up to 35 unique store listing variants, each with different screenshots, promotional text, and app previews. Used for targeted ad campaigns and, as of 2025, surfaced in organic search.
- **Impressions:** Number of times an app appeared in search results or browse pages. Available in App Store Connect Analytics and Google Play Console.
- **Tap-Through Rate (TTR):** Percentage of impressions that result in a user tapping to view the full store listing. Influenced primarily by icon, title, and subtitle.
- **Install Rate:** Percentage of store listing views that convert to installs. Distinguished from TTR -- TTR measures browse-to-view, Install Rate measures view-to-install.
- **Localization:** Adapting store listing metadata (title, subtitle, keywords, description, screenshots) for specific markets and languages. Each locale has independent character limits.
- **A/B Testing (Store Listing Experiments):** Native store feature for testing listing variants. Google Play supports up to 5 variants. Apple supports product page optimization with up to 3 treatments.
- **Promotional Text (iOS):** 170-character field that appears above the description. Can be updated without submitting a new app version. Not indexed for search.
- **Feature Graphic (Android):** Required 1024x500 image displayed at the top of the Google Play listing. High-impact conversion asset.
- **App Preview Video:** Short video (15-30 seconds) auto-playing on the store listing. iOS supports up to 3 per locale. Google Play supports 1 per listing.

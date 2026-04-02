<!-- GSD:project-start source:PROJECT.md -->
## Project

**ASO Toolkit**

An installable skill pack for Claude Code that gives users `/aso:*` slash commands for App Store Optimization. Users clone the repo, run `install.sh`, and get store listing audits, keyword research, and metadata optimization — all powered by Claude's native capabilities (vision, web search, file I/O). Zero infrastructure: no MCP servers, no API keys, no dependencies.

**Core Value:** Any developer can audit and optimize their app store listing in one command, getting actionable, platform-aware recommendations — not generic advice.

### Constraints

- **Zero infrastructure**: No MCP servers, no OAuth, no API keys, no Python. Pure markdown skills leveraging Claude's native capabilities.
- **Install simplicity**: Clone repo, run install.sh, done. install.sh auto-registers paths in ~/.claude/settings.json.
- **Character limits**: iOS — 30 char title, 30 char subtitle, 100 char keyword field. Google Play — 50 char title, 80 char short description. Skills must enforce these.
- **No hallucinated data**: Use web search for real store data. Clearly mark estimates vs. observed data.
- **File size**: Skills are self-contained markdown. Small files, high cohesion.
<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->
## Technology Stack

## Executive Summary
## Recommended Stack
### Core: Claude Code Skill Format
| Component | Format | Purpose | Why |
|-----------|--------|---------|-----|
| Skill definitions | `SKILL.md` with YAML frontmatter | Define `/aso:*` slash commands | Official Claude Code standard. Skills are the current recommended format over raw commands -- they support directories for supporting files, frontmatter for invocation control, and `$ARGUMENTS` substitution. Confirmed from official docs at code.claude.com. |
| Agent definition | `.md` with YAML frontmatter in `agents/` | Define `aso-analyst` subagent | Subagents run in isolated context windows with custom system prompts and tool restrictions. Ideal for parallel web search tasks that would bloat the main conversation. |
| Rules file | `.md` in `rules/` or CLAUDE.md | Shared ASO domain knowledge | Rules inject knowledge into every session without requiring explicit invocation. Platform constraints (character limits, ranking factors) belong here. |
| Install script | `install.sh` (bash) | Copy files to `~/.claude/` locations | Shell script is the standard distribution mechanism. GSD uses a manifest-based approach; simpler packs use direct file copy with symlinks. |
| Supporting files | `.md` reference docs within skill directories | Templates, examples, domain reference | Official docs recommend keeping SKILL.md under 500 lines and moving detailed reference to separate files Claude loads on demand. |
### Skill File Format (Detailed Specification)
#### YAML Frontmatter Fields
| Field | Use in ASO Toolkit | Value |
|-------|-------------------|-------|
| `name` | Slash command name | `aso-audit`, `aso-keywords`, `aso-optimize` |
| `description` | When Claude auto-loads skill | Critical -- front-load key use case. Max 250 chars before truncation. |
| `argument-hint` | Autocomplete hint | `[app-url-or-id]`, `[seed-keyword]` |
| `disable-model-invocation` | Prevent auto-triggering | `true` for all `/aso:*` commands. Users should explicitly invoke ASO tools, not have Claude guess. |
| `allowed-tools` | Tool whitelist | `Read, Write, Bash, WebSearch, WebFetch, Glob, Grep` per skill needs |
| `model` | Model routing | Omit (inherit session model). ASO analysis benefits from whatever model the user has. |
| `context` | Subagent isolation | `fork` only for skills that spawn the aso-analyst agent |
| `effort` | Reasoning depth | Omit for most; `high` for audit skill (needs thorough analysis) |
#### String Substitutions Available
| Variable | Use Case |
|----------|----------|
| `$ARGUMENTS` | App URL, app ID, or seed keyword passed by user |
| `$ARGUMENTS[0]`, `$0` | First positional argument (app identifier) |
| `$ARGUMENTS[1]`, `$1` | Second positional argument (platform override) |
| `${CLAUDE_SKILL_DIR}` | Path to skill directory -- use for referencing bundled templates and reference docs |
| `` !`command` `` | Shell preprocessing -- runs before Claude sees content. Useful for platform detection scripts. |
### Agent File Format
| Field | Value | Why |
|-------|-------|-----|
| `name` | `aso-analyst` | Matches PROJECT.md spec |
| `description` | Detailed ASO-focused | Claude uses this to decide when to delegate |
| `tools` | Explicit whitelist | Needs web search and file write, but NOT Edit (should create reports, not modify user code) |
| `model` | `sonnet` | Good balance of capability and speed for web research. Haiku is too limited for ASO analysis. Opus is overkill. |
| `maxTurns` | 20 | Prevents runaway research loops. Enough for 3-5 competitors with web searches. |
| `memory` | Omit | No persistent memory needed. Each analysis is independent. |
### Installation Architecture
| Approach | Used By | Pros | Cons |
|----------|---------|------|------|
| **Plugin format** (marketplace.json + plugin.json) | everything-claude-code | Standard distribution, namespaced, `enabledPlugins` toggle | Heavier, requires plugin infrastructure |
| **Direct copy** (install.sh copies to ~/.claude/) | GSD, simpler packs | Simple, no plugin overhead, files are first-class | No namespace, manual cleanup |
### ASO Data Sources (What Skills Should Query)
#### Tier 1: Direct API Access (No Auth Required)
| Source | Endpoint | Data Available | Rate Limit | Confidence |
|--------|----------|---------------|------------|------------|
| **iTunes Search API** | `https://itunes.apple.com/lookup?id={NUMERIC_ID}` | Title (trackName), description, rating, review count, genres, screenshots URLs, icon, bundle ID, release date, version, price, file size, content rating, supported devices, release notes | 20 req/min per IP | HIGH -- Tested live, returns full JSON. No auth. |
| **iTunes Search API** | `https://itunes.apple.com/search?term={QUERY}&entity=software` | Search results with same fields as lookup | 20 req/min per IP | HIGH -- Public endpoint, documented by Apple. |
#### Tier 2: Web Search (Claude's WebSearch Tool)
| Query Pattern | Data Retrieved | Reliability | Confidence |
|---------------|---------------|-------------|------------|
| `site:apps.apple.com/*/app/* {app-name}` | App Store listing page with title, subtitle, description, screenshots | HIGH -- Apple's public pages are consistently structured | HIGH |
| `site:play.google.com/store/apps/details {app-name}` | Play Store listing with title, short description, full description, rating | HIGH -- Google's public pages | HIGH |
| `{app-name} app store reviews` | User review sentiment, common complaints | MEDIUM -- Results vary | MEDIUM |
| `{category} best apps {year}` | Competitor lists, category leaders | MEDIUM -- SEO content quality varies | MEDIUM |
| `{keyword} app` + store site restriction | Competitor keyword analysis | LOW-MEDIUM -- Indirect signal | MEDIUM |
#### Tier 3: Competitor Discovery via Web Search
| Method | Query Pattern | What It Reveals |
|--------|---------------|-----------------|
| Category browsing | `"top {category} apps" site:apple.com OR site:play.google.com` | Direct competitors |
| Review sites | `"best {category} apps 2026" -site:reddit.com` | Curated competitor lists |
| App store search | Search for seed keywords on store pages | Who ranks for target keywords |
### Platform Detection Logic
| Input Pattern | Platform | Detection Rule |
|---------------|----------|----------------|
| `https://apps.apple.com/*` | iOS | URL domain match |
| `https://itunes.apple.com/*` | iOS | URL domain match (legacy) |
| `https://play.google.com/store/apps/*` | Android | URL domain match |
| Numeric ID (e.g., `284882215`) | iOS | Pure digits, typically 9-10 chars |
| Reverse domain (e.g., `com.facebook.Facebook`) | Android | Contains dots, starts with `com.`/`org.`/`net.` |
| App name (e.g., `"Facebook"`) | Unknown | Requires user clarification or search both |
### Platform Character Limits (Hardcoded in Skills)
#### iOS (App Store Connect)
| Field | Limit | Indexed for Search | Notes |
|-------|-------|-------------------|-------|
| Title | 30 chars | YES (highest weight) | Most important metadata field |
| Subtitle | 30 chars | YES (secondary weight) | Visible in search results |
| Keyword Field | 100 chars | YES (indexed, not displayed) | Comma-separated, no spaces after commas |
| Description | 4,000 chars | NO (not indexed by Apple) | Write for users, not algorithm |
| Promotional Text | 170 chars | NO | Can be updated without new app version |
| What's New | 4,000 chars | NO | Release notes |
#### Android (Google Play Console)
| Field | Limit | Indexed for Search | Notes |
|-------|-------|-------------------|-------|
| Title | 50 chars | YES (highest weight) | 20 chars more than iOS |
| Short Description | 80 chars | YES | Visible by default on listing |
| Full Description | 4,000 chars | YES (unlike iOS!) | ~1 exact keyword match per 250 chars recommended |
| Developer Name | N/A | YES (partial) | |
### ASO Ranking Factors (Domain Knowledge for Rules File)
| Factor | iOS Weight | Android Weight | Confidence |
|--------|-----------|---------------|------------|
| Title keywords | Very High | Very High | HIGH |
| Subtitle keywords (iOS) / Short desc (Android) | High | High | HIGH |
| Keyword field (iOS only) | High | N/A | HIGH |
| Full description keywords | None (not indexed) | Medium | HIGH |
| Download volume & velocity | High | High | HIGH |
| Ratings (4.0+ threshold) | High | High | HIGH |
| Review count & recency | Medium | Medium | MEDIUM |
| Retention & engagement (post-2025) | Medium-High | Medium-High | MEDIUM |
| Update frequency | Medium | Medium | MEDIUM |
| Crash rate / stability | Medium | Medium | MEDIUM |
| Revenue performance | Low-Medium | Low-Medium | LOW |
## Repo Directory Structure
## What NOT to Use
| Anti-Pattern | Why Not |
|--------------|---------|
| MCP servers | PROJECT.md explicitly excludes. Zero infrastructure constraint. |
| API keys / OAuth | No setup beyond install.sh. iTunes API needs no auth. |
| Python/Node runtime dependencies | Pure markdown skills only. No `pip install`, no `npm install`. |
| Database or caching layer | Stateless analysis. Each run is independent. |
| `.claude/commands/` flat files | Deprecated pattern. Skills (`.claude/skills/<name>/SKILL.md`) are the current standard and support directories. |
| `settings.json` modification | Skills in `~/.claude/skills/` are auto-discovered. No manual registration needed. |
| Paid ASO APIs (Sensor Tower, data.ai, etc.) | Violates zero-dependency constraint. Use iTunes API + web search instead. |
| Plugin format (marketplace.json) | Overkill for a focused skill pack. Direct skill directory installation is simpler and more transparent. |
| `model: opus` for subagent | Overkill and expensive for web research tasks. Sonnet is the right balance. |
| `user-invocable: false` on ASO skills | Users should explicitly invoke ASO tools. These are task commands, not background knowledge. |
## Alternatives Considered
| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Skill location | `~/.claude/skills/aso-*/` | `.claude/commands/aso/` | Commands are the old pattern. Skills support directories, frontmatter control, auto-discovery. |
| Agent model | `sonnet` | `haiku` | Haiku is fast but too limited for nuanced ASO analysis and web research synthesis. |
| Agent model | `sonnet` | `opus` | Opus is overkill and expensive for structured web research. Sonnet handles it well. |
| Install method | Direct copy to `~/.claude/skills/` | Plugin system | Plugin adds complexity. The install audience (devs) can handle a simple `install.sh`. |
| Data source | iTunes Search API + WebSearch | Paid ASO tool APIs | Zero-dependency constraint. iTunes API is free, public, unauthenticated, and returns structured data. |
| Domain knowledge | Rules file (always loaded) | Inline in each skill | DRY. Character limits and ranking factors are shared across all skills. Extract once. |
| Platform detection | In-skill logic | Separate detection skill | Simple enough to inline. A regex check in each skill is 5 lines, not worth a separate skill. |
## Installation
# From the repo root
# What install.sh does (no npm, no pip, no dependencies):
# 1. Copies skills/ contents to ~/.claude/skills/
# 2. Copies agents/ contents to ~/.claude/agents/
# 3. Optionally copies rules/ to project .claude/rules/ or ~/.claude/rules/
# 4. Verifies installation
## Sources
### Official Documentation (HIGH confidence)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/slash-commands) -- Skill format, frontmatter fields, directory structure, auto-discovery
- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents) -- Agent format, frontmatter fields, model selection, tool restrictions
- [iTunes Search API Documentation](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html) -- Public API, no auth required
- [Google Play Store Listing Best Practices](https://support.google.com/googleplay/android-developer/answer/13393723) -- Official metadata guidelines
- [Apple App Store Metadata](https://performance-partners.apple.com/search-api) -- iTunes Search/Lookup API
### ASO Domain Knowledge (MEDIUM confidence)
- [ASO in 2026: Complete Guide (ASOMobile)](https://asomobile.net/en/blog/aso-in-2026-the-complete-guide-to-app-optimization/) -- Ranking factors, metadata strategy
- [App Store Ranking Factors 2026 (MobileAction)](https://www.mobileaction.co/blog/app-store-ranking-factors/) -- Factor weights, retention shift
- [Complete Guide to iOS ASO 2026 (Adalo)](https://www.adalo.com/posts/complete-guide-ios-app-store-aso-2026) -- Character limits, Apple Intelligence impact
- [Google Play Store Listings 2026 (InspiringApps)](https://www.inspiringapps.com/blog/google-play-store-listing) -- Character limits, policy guidelines
- [Free ASO Keyword Research 2026 (Respectlytics)](https://respectlytics.com/blog/free-aso-keyword-research/) -- Free data sources
- [Top Free ASO Tools (ConsultMyApp)](https://www.consultmyapp.com/blog/the-top-10-free-aso-tools-you-should-be-using-right-now) -- Tool landscape
### Skill Pack Patterns (HIGH confidence, direct inspection)
- GSD skill pack at `~/.claude/get-shit-done/` -- Directory structure, workflow patterns, command formatting
- Claude Code agents at `~/.claude/agents/` -- Agent file format, frontmatter examples
- Claude Code commands at `~/.claude/commands/` -- Command file format, legacy patterns
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->

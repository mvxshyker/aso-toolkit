---
name: aso:copy-metadata
description: Write optimized iOS App Store metadata — app name, subtitle, keywords, description, promotional text.
argument-hint: "<game name + context or focus area>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Copy — iOS Metadata

## Step 1: Load Knowledge + Version Check

Check for updates: read `~/.aso-toolkit/VERSION`, then fetch `https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/VERSION`. If the remote version is newer, print: "Update available ({remote}). Run `/aso:update`." — then continue normally.

If `$ASO_VAULT` is set and `$ASO_VAULT/_Router.md` exists, read it. Follow the `metadata` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

If no vault is configured, apply the general rules below. Ask the user for any game-specific rules they want applied.

### Fields

| Field | Limit | Indexed | Notes |
|-------|-------|---------|-------|
| App Name | 30 chars | Yes (highest weight) | Brand + primary keyword |
| Subtitle | 30 chars | Yes | Secondary keywords, value proposition |
| Keywords | 100 chars | Yes | Comma-separated, no spaces after commas |
| Description | 4,000 chars | No | Not indexed — write for conversion, not keywords |
| Promotional Text | 170 chars | No | Updatable without new version — use for timely hooks |

### Keyword Rules

- Do not repeat words already in App Name or Subtitle in the Keywords field.
- Use singular or plural — not both (Apple indexes both forms).
- No competitor brand names.
- Separate with commas, no spaces after commas.

### Output Format

```
=== iOS METADATA ===
App Name: [text] ([count])
Subtitle: [text] ([count])
Keywords: [text] ([count])
Description:
[text]
([count])
Promotional Text: [text] ([count])
```

Print character count in parentheses after every field.

## Step 2: Check Existing Output

Search for existing output matching the brief (same game/locale). Check both the vault Metadata folder and `~/.aso-toolkit/output/`. If a match is found, show it to the user and ask:

1. **Anything to improve?** — user describes what's wrong. Fix those parts, save the feedback (see Step 6), replace the old output.
2. **Rewrite from scratch** — delete the old output, continue to Step 3 as a fresh run.

## Step 3: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 4: Collect Keyword Data

Metadata requires keyword data. If not provided in the brief, ask the user for it.

## Step 5: Write the Metadata

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 6: Approve, Save, Evolve

Present the final metadata and ask the user:

1. **Approve** — save the output
2. **Anything to improve?** — user describes what's wrong. Fix those parts, then ask again.

Loop until approved. On approval, save the output:

- **With vault:** `$ASO_VAULT/Clients/{publisher}/{game}/Metadata/{locale} {date}.md`
- **Without vault:** `~/.aso-toolkit/output/{game}/Metadata/{locale} {date}.md`

Create directories if they don't exist.

If the user gave any feedback during this step, ask: is this **general** or **specific** to this game?

- **General** → ask "Update the skill?" If yes, append the rule to the Keyword Rules section of this skill file (`~/.claude/skills/aso-copy-metadata/SKILL.md`).
- **Game-specific + vault** → append to the client's metadata rules file in the vault.
- **Game-specific + no vault** → append to the Keyword Rules section of this skill file.

Format each entry as a numbered rule: what to do or avoid, and why.

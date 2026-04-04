---
name: aso:copy-promo
description: Write store event and promo copy for Apple In-App Events and Google Play Promotional Content.
argument-hint: "<client brief — event details>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion, Agent
---

# ASO Copy — Store Event & Promo Content

## Step 1: Load Knowledge + Version Check

Check for updates: read `~/.aso-toolkit/VERSION`, then fetch `https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/VERSION`. If the remote version is newer, print: "Update available ({remote}). Run `/aso:update`." — then continue normally.

If `$ASO_VAULT` is set and `$ASO_VAULT/_Router.md` exists, read it. Follow the `copy` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

If no vault is configured, apply the general rules below. Ask the user for any game-specific or IP-specific rules they want applied.

### General Copy Rules

1. **No Placeholders.** Every field must be final, publish-ready copy.
2. **Ask if Missing Info.** If the brief is missing key details (character name, event type) — STOP and ask before writing.
3. **Family-Friendly Only.** No violent, dark, or aggressive words. No "death," "die," "kill," "hate." Use playful, energetic alternatives.
4. **Reproduce Incentives Exactly.** Use the reward/incentive text exactly as provided in the brief. Do not calculate, combine, or reinterpret quantities.
5. **No Game Name in Copy.** Never include the game name in any copy field. The game name is already visible as metadata on the store page.

### Localization Rules

All copy gets translated into 10+ languages. Protect translation quality:
- Simple, linear sentences: subject-verb-object. One idea per sentence.
- NO em-dashes (—) or mid-sentence parenthetical asides.
- NO idioms, puns, or English-specific wordplay.
- NO ambiguous pronouns. Repeat the noun instead of "it" or "they."
- Maximum two adjectives before a noun.

### Character Limits

Subtract 5 characters from every platform limit for localization headroom. The result is your hard limit.

**Apple In-App Event:**

| Field | Platform Limit | Hard Limit |
|-------|---------------|------------|
| Event Name | 30 | 25 |
| Short Description | 50 | 45 |
| Long Description | 120 | 115 |

**Google Play Promo Content:**

| Field | Platform Limit | Hard Limit |
|-------|---------------|------------|
| Title | 80 | 75 |
| Description | 500 | 495 |

### Output Format

```
=== APPLE IN-APP EVENT ===
Event Name: [text] ([count])
Short Description: [text] ([count])
Long Description: [text] ([count])

=== GOOGLE PLAY PROMO CONTENT ===
Title: [text] ([count])
Description: [text] ([count])
```

Print character count in parentheses after every field.

## Step 2: Check Existing

Search for existing output matching the brief (same character/event). Check both the vault Events folder and `~/.aso-toolkit/output/`. If a match is found, show it to the user and ask:

1. **Anything to improve?** — user describes what's wrong. Fix those parts, save the feedback (see Step 7), replace the old output.
2. **Rewrite from scratch** — delete the old output, continue to Step 3 as a fresh run.

## Step 3: Validate

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 4: Research

If the loaded rules require real-world lore, launch four research agents **in parallel**:

1. `aso-research-lore` — origin, abilities, personality, relationships
2. `aso-research-ingame` — in-game abilities, tier, meta role
3. `aso-research-visual` — visual identity, thematic keywords, marketing angles
4. `aso-research-cultural` — movies, TV, comics, fan sentiment, editorial hooks

Pass each agent: the subject, game name, and any event context from the brief.

When all four complete, launch `aso-research-synthesizer` with the four briefs. Use the synthesized output to write the copy — follow its "best copy angle" and "must-use details."

## Step 5: Write

Apply ALL loaded rules simultaneously. Use the synthesized research — especially the "best copy angle" and "must-use details." Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 6: Verify

Launch the `aso-copy-checker` agent with the full copy block and paths to every rules file you loaded. Loop until PASS. Present the final copy with the compliance report.

## Step 7: Approve, Save, Evolve

Present the final copy and ask the user:

1. **Approve** — save the output
2. **Anything to improve?** — user describes what's wrong. Fix those parts, then ask again.

Loop until approved. On approval, save the output:

- **With vault:** `$ASO_VAULT/Clients/{publisher}/{game}/Events/{event-name} {date}.md`
- **Without vault:** `~/.aso-toolkit/output/{game}/Events/{event-name} {date}.md`

Create directories if they don't exist. Before writing new copy, read the last 5 saved events for the same game to avoid repeating verbs, hooks, and sentence structures.

If the user gave any feedback during this step, ask: is this **general** (all games) or **specific** to this game?

- **General** → ask "Update the skill?" If yes, append the rule to the General Copy Rules section of this skill file (`~/.claude/skills/aso-copy-promo/SKILL.md`).
- **Game-specific + vault** → append to the client's copy rules file in the vault.
- **Game-specific + no vault** → append to the General Copy Rules section of this skill file.

Format each entry as a numbered rule: what to do or avoid, and why.

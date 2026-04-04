---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate — Apple Editorial Nomination Pitch

## Step 1: Load Knowledge + Version Check

Check for updates: read `~/.aso-toolkit/VERSION`, then fetch `https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/VERSION`. If the remote version is newer, print: "Update available ({remote}). Run `/aso:update`." — then continue normally.

If `$ASO_VAULT` is set and `$ASO_VAULT/_Router.md` exists, read it. Follow the `nominate` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

If no vault is configured, apply the general rules below. Ask the user for any game-specific rules they want applied.

### General Rules

1. **No Placeholders.** Every field must be final, publish-ready.
2. **Never fabricate details.** If brief is missing key info (event type, star rating, localization languages), ask before writing.
3. **No dates or numbers.** Never include specific months, dates, or numbers in any field.
4. **No game name.** The game name is already visible as store metadata.
5. **No repetition between fields.** Do not repeat the same keywords or phrases across Event Name, Helpful Details, and Description.

### Character Limits

| Field | Hard Limit |
|-------|------------|
| Helpful Details | 500 chars |
| Description | 500 chars |

Always print character count in parentheses after Helpful Details and Description.

### Nomination Structure

| Field | Notes |
|-------|-------|
| Event Name | Name of the existing in-app event being nominated |
| Related In-App Events | Any related events, or "None" |
| New Event Submission | Yes or No |
| Helpful Details | Three bullet points: content quality, localization reach, cultural/release moment |
| Description | Single editorial paragraph: game + event name, event type, gameplay hook, reward, one differentiator, audience fit |

### Writing Rules

1. **Helpful Details are factual.** Never invent localization languages, premiere dates, or approvals not in the brief.
2. **Description is a pitch, not player copy.** Third person about the game and event. Do not address the player ("you"). Write as if presenting to an editorial curator.
3. **Localization languages go in Helpful Details only**, not in Description.
4. **One differentiator rule.** Description leads with one strong editorial hook, not a list.
5. **Tone:** Professional, editorial, confident. No exclamation marks. No hyperbole.

### Output Format

```
=== NOMINATION PITCH ===

Event Name: [text]

Related In-App Events: [text or "None"]

New Event Submission: [Yes / No]

Helpful Details:
- [Content quality point]
- [Localization point]
- [Cultural / release moment point]
([character count])

Description:
[Single editorial paragraph]
([character count])
```

## Step 2: Resolve Events + Check Existing

### Bulk mode (no arguments)

If `$ARGUMENTS` is empty, scan all saved events:
- **With vault:** read the Events index for each game
- **Without vault:** scan `~/.aso-toolkit/output/*/Events/`

Cross-reference with saved nominations. List events that have no nomination yet. Ask the user which ones to nominate (multi-select or "all"). Process each one sequentially through Steps 3-6.

### Single mode

If `$ARGUMENTS` names an event, search for existing event copy:
- **With vault:** search the Events folders
- **Without vault:** search `~/.aso-toolkit/output/*/Events/`

If a matching event is found, show it and ask: "Use this event as context for the nomination?" If yes, use the event copy (character, event type, lore details) as input — skip research for details already in the event file.

Then check for existing nominations for this event. If found, offer:
1. **Anything to improve?** — fix and evolve
2. **Rewrite from scratch** — delete and start fresh

## Step 3: Validate

The user's brief is: $ARGUMENTS

If event context was loaded in Step 2, use it — the event file has the character name, star rating, event type, and lore details. Only ask for what's still missing per the client's "Only Ask If Missing" section.

## Step 4: Research (If Needed)

If event context was loaded in Step 2, skip research for details already covered. Only launch research agents for gaps — e.g., cultural relevance for the editorial pitch if not in the event file.

If no event context, launch four research agents **in parallel**:

1. `aso-research-lore` — origin, abilities, personality, relationships
2. `aso-research-ingame` — in-game abilities, tier, meta role
3. `aso-research-visual` — visual identity, thematic keywords, marketing angles
4. `aso-research-cultural` — movies, TV, comics, fan sentiment, editorial hooks

When all four complete, launch `aso-research-synthesizer` with the four briefs.

## Step 5: Write the Nomination Pitch

Apply ALL loaded rules simultaneously. Use the event copy context and/or synthesized research — especially "cultural relevance" and "editorial angle" for the pitch. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 6: Approve, Save, Evolve

Present the final pitch and ask the user:

1. **Approve** — save the output
2. **Anything to improve?** — user describes what's wrong. Fix those parts, then ask again.

Loop until approved. On approval, save the output:

- **With vault:** `$ASO_VAULT/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`
- **Without vault:** `~/.aso-toolkit/output/{game}/Nominations/{event-name} {date}.md`

Create directories if they don't exist.

If the user gave any feedback during this step, ask: is this **general** or **specific** to this game?

- **General** → ask "Update the skill?" If yes, append the rule to the Writing Rules section of this skill file (`~/.claude/skills/aso-nominate/SKILL.md`).
- **Game-specific + vault** → append to the client's nomination rules file in the vault.
- **Game-specific + no vault** → append to the Writing Rules section of this skill file.

Format each entry as a numbered rule: what to do or avoid, and why.

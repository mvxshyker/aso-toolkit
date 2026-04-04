---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate — Apple Editorial Nomination Pitch

## Step 1: Load Knowledge

If `$ASO_VAULT` is set and `$ASO_VAULT/_Router.md` exists, read it. Follow the `nominate` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

If no vault is configured, apply the general rules below. Ask the user for any game-specific rules they want applied.

### Nomination Structure

| Field | Notes |
|-------|-------|
| Event Name | Name of the existing in-app event being nominated |
| Related In-App Events | Any related events, or "None" |
| New Event Submission | Yes or No |
| Helpful Details (~500 chars) | Three bullet points: content quality, localization reach, cultural/release moment |
| Description (500 chars) | Single editorial paragraph: game + event name, event type, gameplay hook, reward, one differentiator, audience fit |

### Writing Rules

1. **Character counts are hard limits.** Description never exceeds 500 chars. Always print count after each field.
2. **Helpful Details are factual.** Never invent localization languages, premiere dates, or approvals not in the brief.
3. **Description is a pitch, not player copy.** Third person about the game and event. Do not address the player ("you"). Write as if presenting to an editorial curator.
4. **Never fabricate details.** If brief is missing key info (event type, star rating, localization languages), ask before writing.
5. **Localization languages go in Helpful Details only**, not in Description.
6. **One differentiator rule.** Description leads with one strong editorial hook, not a list.
7. **Tone:** Professional, editorial, confident. No exclamation marks. No hyperbole.

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

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research (If Required by IP Rules)

If the loaded rules require real-world lore, use WebSearch to find lore, abilities, origin, and context for the character. The nomination must reference real IP context — not generic filler.

## Step 4: Write the Nomination Pitch

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Save

After the user approves, save the output:

- **With vault:** `$ASO_VAULT/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`
- **Without vault:** `output/{game}/Nominations/{event-name} {date}.md` (relative to the aso-toolkit repo root)

Create directories if they don't exist.

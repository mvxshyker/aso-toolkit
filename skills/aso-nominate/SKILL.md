---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate — Apple Editorial Nomination Pitch

## Step 0: Load Feedback

Read `~/.aso-toolkit/feedback/general.md` and `~/.aso-toolkit/feedback/{game}.md` if they exist. Apply any learned rules alongside the other rules. These files contain lessons from previous sessions.

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

## Step 2: Check Existing Output

Search for existing output matching the brief (same event/character). Check both the vault Nominations folder and `~/.aso-toolkit/output/`. If a match is found, show it to the user and ask:

1. **Anything to improve?** — user describes what's wrong. Fix those parts, save the feedback (see Step 6), replace the old output.
2. **Rewrite from scratch** — delete the old output, continue to Step 3 as a fresh run.

## Step 3: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 4: Research (If Required by IP Rules)

If the loaded rules require real-world lore, use WebSearch to find lore, abilities, origin, and context for the character. The nomination must reference real IP context — not generic filler.

## Step 5: Write the Nomination Pitch

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 6: Approve and Save

Present the final pitch and ask the user:

1. **Approve** — save the output and continue
2. **Anything to improve?** — user describes what's wrong. Fix those parts, then ask again.

Loop until approved. On approval, save the output:

- **With vault:** `$ASO_VAULT/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`
- **Without vault:** `~/.aso-toolkit/output/{game}/Nominations/{event-name} {date}.md`

Create directories if they don't exist.

If the user gave any feedback during this step, save it as a rule:

1. Ask: is this feedback **general** (all games) or **specific** to this game?
2. **General** → append to `~/.aso-toolkit/feedback/general.md`
3. **Game-specific + vault** → append to the client's nomination rules file in the vault
4. **Game-specific + no vault** → append to `~/.aso-toolkit/feedback/{game}.md`

Format each entry as a rule: what to do or avoid, and why.

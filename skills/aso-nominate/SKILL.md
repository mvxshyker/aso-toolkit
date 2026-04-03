---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate — Apple Editorial Nomination Pitch

## Step 1: Load Knowledge

Read `$ASO_VAULT/_Router.md`. Follow the `nominate` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research (If Required by IP Rules)

If the loaded rules require real-world lore, use WebSearch to find lore, abilities, origin, and context for the character. The nomination must reference real IP context — not generic filler.

## Step 4: Write the Nomination Pitch

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Save to Vault

After the user approves, save output to:
`$ASO_VAULT/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`

Create the Nominations directory if it doesn't exist.

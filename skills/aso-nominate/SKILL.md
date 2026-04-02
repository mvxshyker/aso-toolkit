---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate — Apple Editorial Nomination Pitch

## Step 1: Load Knowledge

Read the router at `~/Documents/Obsidian Vault/ASO/_Router.md`. Follow the `nominate` route.

1. Read the workflow file linked in the router (`Apple Event Nomination Guidelines`).
2. The workflow links to `_IP Hub`. Read it.
3. Match the game from the user's brief to a row in the IP Hub. Read that game's IP Guidelines hub.
4. The IP hub has an action table. Read the `nominate` child file.

You now have: general nomination rules + client-specific nomination rules. Apply both.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research the Character

Use WebSearch to find lore, abilities, origin, and fighting style for the character. The nomination must reference real IP context — not generic filler.

## Step 4: Write the Nomination Pitch

Follow ALL rules from both the general workflow and the client child file simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Save to Vault

After the user approves, save output to:
`~/Documents/Obsidian Vault/ASO/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`

Create the Nominations directory if it doesn't exist.

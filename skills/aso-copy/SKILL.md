---
name: aso:copy
description: Write store event and promo copy for Apple In-App Events and Google Play Promotional Content.
argument-hint: "<brief — character name, star rating, event type, any reward details>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Copy — Store Event & Promo Content

## Step 1: Load Knowledge

Read the router at `~/Documents/Obsidian Vault/ASO/_Router.md`. Follow the `copy` route.

1. Read the workflow file linked in the router (`Store Event Copy Guidelines`).
2. The workflow links to `_IP Hub`. Read it.
3. Match the game from the user's brief to a row in the IP Hub. Read that game's IP Guidelines hub.
4. The IP hub has an action table. Read the `copy` child file.

You now have: general copy rules + client-specific copy rules. Apply both.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research the Character

Use WebSearch to find lore, abilities, origin, and fighting style for the character. The IP rules require real lore — not generic filler.

## Step 4: Write the Copy

Follow ALL rules from both the general workflow and the client child file simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Save to Vault

After the user approves, save output to:
`~/Documents/Obsidian Vault/ASO/Clients/{publisher}/{game}/Events/{character-name} {date}.md`

Create the Events directory if it doesn't exist.

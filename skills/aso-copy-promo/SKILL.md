---
name: aso:copy-promo
description: Write store event and promo copy for Apple In-App Events and Google Play Promotional Content.
argument-hint: "<client brief — event details>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion, Agent
---

# ASO Copy — Store Event & Promo Content

## Step 1: Load Knowledge

Read the router at `$ASO_VAULT/_Router.md`. Follow the `copy` route.

1. Read the workflow file linked in the router (`Store Event Copy Guidelines`).
2. The workflow links to `_IP Hub`. Read it.
3. Match the game from the user's brief to a row in the IP Hub. Read that game's IP Guidelines hub.
4. The IP hub has an action table. Read the `copy` child file.

You now have: general copy rules + client-specific copy rules. Apply both.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research (If Required by IP Rules)

If the client's IP rules require real-world lore or reference material, launch the `aso-ip-researcher` agent in the background with:
- **Subject**: the character, theme, or setting from the brief
- **Game**: the matched game name
- **Context**: any cultural moment or event context from the brief

Continue to Step 4 while the agent works. Use its lore brief when writing copy. Never use generic filler when the IP rules demand accuracy.

## Step 4: Write the Copy

Wait for the `aso-ip-researcher` results if still running. Then write copy following ALL rules from both the general workflow and the client child file simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Verify the Copy

Launch the `aso-copy-checker` agent with:
- **Copy block**: the full output you just wrote
- **General rules path**: path to Store Event Copy Guidelines
- **Client rules path**: path to the client-specific copy rules file
- **Apple specs path**: path to Apple App Store Connect Specs
- **Google specs path**: path to Google Play Console Specs

If the checker returns FAIL: read its violation report, fix the copy yourself, and re-run the checker. Loop until PASS. Present the final copy to the user with the compliance report.

## Step 6: Save to Vault

After the user approves, save output to:
`$ASO_VAULT/Clients/{publisher}/{game}/Events/{event-name} {date}.md`

Create the Events directory if it doesn't exist.

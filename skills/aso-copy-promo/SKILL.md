---
name: aso:copy-promo
description: Write store event and promo copy for Apple In-App Events and Google Play Promotional Content.
argument-hint: "<client brief — event details>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion, Agent
---

# ASO Copy — Store Event & Promo Content

## Step 1: Load Knowledge

Read `$ASO_VAULT/_Router.md`. Follow the `copy` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Research (If Required by IP Rules)

If the loaded rules require real-world lore, launch the `aso-ip-researcher` agent in the background with the subject, game, and any event context from the brief. Continue to Step 4 while it works.

## Step 4: Write the Copy

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Verify the Copy

Launch the `aso-copy-checker` agent with the full copy block and paths to every rules file you loaded. Loop until PASS. Present the final copy with the compliance report.

## Step 6: Save to Vault

After the user approves, save output to:
`$ASO_VAULT/Clients/{publisher}/{game}/Events/{event-name} {date}.md`

Create the Events directory if it doesn't exist.

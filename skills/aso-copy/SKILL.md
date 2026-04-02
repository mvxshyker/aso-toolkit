---
name: aso:copy
description: Write store event and promo copy for Apple In-App Events and Google Play Promotional Content.
argument-hint: "<brief — character name, star rating, event type, any reward details>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Copy

Action: `copy`

Read the router at `~/Documents/Obsidian Vault/ASO/_Router.md` and follow its instructions for the `copy` action.

The user's brief is: $ARGUMENTS

After the user approves, save output to:
`~/Documents/Obsidian Vault/ASO/Clients/{publisher}/{game}/Events/{character-name} {date}.md`

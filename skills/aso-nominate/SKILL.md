---
name: aso:nominate
description: Write Apple In-App Event nomination pitches to win editorial featuring.
argument-hint: "<brief — event name, character name, star rating, cultural moment if any>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Nominate

Action: `nominate`

Read the router at `~/Documents/Obsidian Vault/ASO/_Router.md` and follow its instructions for the `nominate` action.

The user's brief is: $ARGUMENTS

After the user approves, save output to:
`~/Documents/Obsidian Vault/ASO/Clients/{publisher}/{game}/Nominations/{event-name} {date}.md`

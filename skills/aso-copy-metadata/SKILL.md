---
name: aso:copy-metadata
description: Write optimized iOS App Store metadata — app name, subtitle, keywords, description, promotional text.
argument-hint: "<game name + context or focus area>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, WebFetch, AskUserQuestion
---

# ASO Copy — iOS Metadata

## Step 1: Load Knowledge

If `$ASO_VAULT` is set and `$ASO_VAULT/_Router.md` exists, read it. Follow the `metadata` route. Read every file the vault links you to — follow all `[[wikilinks]]` until you've collected the general rules and any client/IP-specific rules for the game in the brief.

If no vault is configured, use general ASO best practices and Apple App Store metadata limits. Ask the user for any game-specific rules they want applied.

## Step 2: Validate the Brief

The user's brief is: $ARGUMENTS

Check against the client's "Only Ask If Missing" section. Apply all defaults the client file provides. Only ask for what it explicitly says to ask for.

## Step 3: Collect Keyword Data

Metadata requires keyword data. If not provided in the brief, ask the user for it.

## Step 4: Write the Metadata

Apply ALL loaded rules simultaneously. Write in the exact output format specified in the guidelines. Print character counts after every field.

## Step 5: Save (Optional)

If a vault is configured, save output to:
`$ASO_VAULT/Clients/{publisher}/{game}/Metadata/{locale} {date}.md`

Create the Metadata directory if it doesn't exist. If no vault, present the final metadata for the user to copy.

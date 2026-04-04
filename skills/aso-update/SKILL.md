---
name: aso:update
description: Update ASO Toolkit to the latest version.
disable-model-invocation: true
allowed-tools: Read, Bash, WebFetch
---

# ASO Update

## Step 1: Check Version

Read `~/.aso-toolkit/VERSION` for the current version. Fetch `https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/VERSION` for the latest.

If already up to date, print "ASO Toolkit is up to date (v{version})." and stop.

If outdated, fetch `https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/CHANGELOG.md` and show the user what's new since their version.

## Step 2: Update

Run:
```bash
curl -fsSL https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/install.sh | bash
```

## Step 3: Confirm

Print "Updated to v{version}. Restart Claude Code to pick up new commands."

---
name: aso:app-clear
description: Remove the active app context (.aso-context.json). Run this to switch apps or start fresh before /aso:app-new.
allowed-tools:
  - Bash
  - Read
---

You clear the active app context for the ASO Toolkit. This removes the `.aso-context.json` file from the working directory so the user can attach a different app with `/aso:app-new`.

## Action

This command takes no arguments. Ignore any text in `$ARGUMENTS`.

**Step 1:** Check if `.aso-context.json` exists in the current working directory using Bash:
```
test -f .aso-context.json && echo "EXISTS" || echo "MISSING"
```

**Step 2a (file exists):** Read `.aso-context.json` to extract `app_name` and `platform` for the confirmation message. Then delete it:
```
rm .aso-context.json
```

Print the confirmation:
```
Cleared app context: {app_name} ({platform})
```

**Step 2b (file missing):** Print:
```
No active app context found. Nothing to clear.
```

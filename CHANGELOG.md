# Changelog

## v1.1.0 — 2026-04-04

### New
- `/aso:update` — self-update skill, shows changelog and re-installs
- Version check on every skill run — notifies when update is available
- CHANGELOG.md for tracking releases

### Improved
- Feedback loop: approve/improve merged into one step
- Existing output detection: rewrite or fix when same brief is run again
- Feedback saved to `~/.aso-toolkit/feedback/` and loaded on next run
- No game name in copy (new general rule)
- 5-char localization headroom (was 10)
- One-line remote install: `curl ... | bash`
- Output saved to `~/.aso-toolkit/output/` (works without cloning)
- Install prints all file locations

---

## v1.0.0 — 2026-04-04

Initial public release.

### Skills
- `/aso:copy-promo` — store event & promo copy (Apple + Google)
- `/aso:copy-metadata` — iOS App Store metadata
- `/aso:nominate` — Apple editorial nomination pitches

### Agents
- `aso-copy-checker` — compliance verification (Haiku)
- `aso-ip-researcher` — character lore research (Haiku)

### Features
- One-line install: `curl -fsSL .../install.sh | bash`
- Works without a knowledge base (general ASO rules baked in)
- Optional vault/knowledge base for client-specific rules
- Feedback loop: skills learn from corrections
- Version check: update notice on each run
- Output saved to `~/.aso-toolkit/output/` for diversity checks

# Changelog

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

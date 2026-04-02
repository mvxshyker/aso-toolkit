---
phase: 1
slug: domain-knowledge-foundation
status: draft
nyquist_compliant: true
wave_0_complete: true
created: 2026-04-02
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | grep/file checks (no runtime — pure markdown project) |
| **Config file** | none |
| **Quick run command** | `grep -c "## Character Limits" rules/aso-domain.md` |
| **Full suite command** | `grep "30 chars" rules/aso-domain.md && grep "OBSERVED" rules/aso-domain.md && grep "ESTIMATED" rules/aso-domain.md && grep "apps.apple.com" rules/aso-domain.md && grep "play.google.com" rules/aso-domain.md` |
| **Estimated runtime** | ~1 second |

---

## Sampling Rate

- **After every task commit:** Run quick command
- **After every plan wave:** Run full suite command
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 1 second

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 1-01-01 | 01 | 1 | FOUN-01 | file check | `test -f rules/aso-domain.md && grep -c "## Character Limits" rules/aso-domain.md` | ❌ W0 | ⬜ pending |
| 1-01-02 | 01 | 1 | FOUN-02 | grep | `grep "apps.apple.com" rules/aso-domain.md && grep "play.google.com" rules/aso-domain.md` | ❌ W0 | ⬜ pending |
| 1-01-03 | 01 | 1 | FOUN-03 | grep | `grep "OBSERVED" rules/aso-domain.md && grep "ESTIMATED" rules/aso-domain.md` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements. No test framework needed — all verification is file existence and content checks via grep.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Rules file loads in Claude session | FOUN-01 | Requires live Claude Code session | Install via install.sh, start new session, check /aso:* commands visible |

---

## Validation Sign-Off

- [x] All tasks have automated verify commands (grep-based)
- [x] Sampling continuity: all tasks have automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 1s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-04-02

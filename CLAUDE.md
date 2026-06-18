# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repo.

## Project

iOS e-commerce app for browsing and purchasing Apple Watch products. Swift, iOS 17.5+, SwiftUI + SwiftData, Apple Pay (PassKit), TipKit. MVVM with `@Observable`, Decorator + Strategy patterns. Localized into 11 languages.

## Agent skills

### Issue tracker

Issues live as GitHub issues at `arthurkahwa/apple_watch_store`; use the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical vocabulary — `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — `CONTEXT.md` + `docs/adr/` at the repo root (created lazily by `/grill-with-docs`). See `docs/agents/domain.md`.

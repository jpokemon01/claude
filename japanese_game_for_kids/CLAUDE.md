# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `japanese_game_for_kids/` directory.

## Overview

A browser-based game for a 3-year-old to learn Japanese vocabulary. Open `index.html` directly in a browser (works offline, no build step, no dependencies).

## Deployment

Served by the weekly_reports Vercel project via a copy at `weekly_reports/japanese_game/index.html` — reachable at the `/japanese_game/` path on the weekly reports domain. **`japanese_game_for_kids/index.html` is the source of truth:** after editing it, re-copy it to `weekly_reports/japanese_game/index.html` and push to `main` to redeploy. There is also a Claude Artifact version (`artifact.html`).

## How It Works

- Single self-contained file: `index.html` (HTML + CSS + JavaScript)
- Audio uses the browser's Web Speech API with a Japanese (`ja-JP`) voice — Chrome and Edge on Windows include one by default
- Two modes: **カード (Flashcards)** — tap a card to see the emoji and hear the word; **クイズ (Quiz)** — hear a word, tap the matching picture out of 3, earn stars and confetti
- Four categories: どうぶつ (animals), たべもの (food), いろ (colors), かず (numbers 1–5)
- Designed for a toddler: giant tap targets, no reading required, no failure states, gentle retry on wrong answers

## Vocabulary Data

Words live in the `japanese_words` table in the shared Supabase project `takeo-apps` (`https://pujgfojebzyetxypwytg.supabase.co`), the same project that holds the weekly_reports `reports` table. Schema and seed data: `schema.sql` (already run in the Supabase SQL Editor on 2026-07-04).

- Columns: `category` (one of `animals`/`food`/`colors`/`numbers`), `emoji`, `ja`, `en`, `sort_order`
- RLS enabled with a public **read-only** policy — the game fetches with the anon key via plain `fetch()`; no write path from the browser
- **To add/edit words:** use the Supabase dashboard Table Editor; the game picks up changes on next page load. Keep at least 3 words per category (the quiz shows 3 choices)
- The `WORDS` object in `index.html` is the offline fallback, used whenever the database is unreachable; keep it in sync-ish with the table for offline play
- `artifact.html` (Claude Artifact version) always uses the embedded words — the Artifact CSP blocks external requests, so it cannot reach Supabase

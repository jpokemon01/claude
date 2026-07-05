# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `portuguese_game/` directory.

## Overview

A browser-based Brazilian Portuguese learning app for Takeo (adult learner, fluent in Japanese and English). Single self-contained `index.html` — no build step, no dependencies. Designed around memory support: spaced repetition, dual-language meanings (English + Japanese), large readable type, and slow-playback audio.

## Features

- **Learn** — flashcards by category: Portuguese word spoken aloud (pt-BR Web Speech), tap to reveal EN + JA meanings, grade yourself Hard/Easy
- **Review** — spaced repetition (Leitner boxes, intervals 1/3/7/14/30 days); Hard or wrong answers reset a word to frequent review. Progress stored in `localStorage` per device
- **Quiz** — 10 questions, 4 choices, both directions (PT→meaning and meaning→PT); wrong answers feed back into Review
- Categories — basic: cumprimentos (greetings), numeros, comida (food), viagem (travel), frases (phrases), semana (days of the week); advanced: verbos (verbs), conversa (full sentences), negocios (business/trade vocabulary for the Brazil trade company)

## Deployment

Served by the weekly_reports Vercel project via a copy at `weekly_reports/portuguese_game/index.html` — reachable at `/portuguese_game/` on the same domain as the Japanese game. **`portuguese_game/index.html` is the source of truth:** after editing, re-copy to `weekly_reports/portuguese_game/index.html` and push to `main`.

## Vocabulary Data

Words live in the `portuguese_words` table in the shared Supabase project `takeo-apps` (`https://pujgfojebzyetxypwytg.supabase.co`). Schema and seed data: `schema.sql` (run once in the Supabase SQL Editor).

- Columns: `category` (cumprimentos/numeros/comida/viagem/frases/semana/verbos/conversa/negocios), `pt`, `en`, `ja`, `note` (optional word-by-word breakdown shown on the card back), `sort_order`
- `schema.sql` drops and rebuilds the table with full seed data — safe to re-run anytime (learning progress lives in localStorage, not in this table)
- RLS enabled, public read-only policy; game fetches with the anon key, falls back to the embedded word list when offline
- Add/edit words in the Supabase Table Editor; keep at least 4 words per category (quiz shows 4 choices)
- Spaced-repetition progress is keyed by the `pt` text — renaming a word's `pt` resets its review history

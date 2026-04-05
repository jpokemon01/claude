# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `weekly_reports/` directory.

## Overview

A single-page static web app for creating and managing weekly work reports. No build step — open `index.html` directly in a browser or deploy via Vercel.

## Deployment

- **Hosting:** Vercel — auto-deploys on push to `main` (root directory set to `weekly_reports/` in Vercel project settings)
- **Database:** Supabase at `https://pujgfojebzyetxypwytg.supabase.co`, table: `reports`
- RLS must be **disabled** on the `reports` table for the anon key to work

## Architecture

The Supabase JS client is loaded via CDN in `index.html`. All app logic is in `app.js`.

Two views toggled via `.hidden` CSS class:
- `#list-view` — displays report cards fetched from Supabase
- `#form-view` — create/edit form

### Data model

JS (camelCase) ↔ Supabase `reports` table (snake_case):

| JS | DB column |
|---|---|
| `id` | `id` (text, PK) |
| `weekStart` | `week_start` |
| `weekEnd` | `week_end` |
| `completed` | `completed` |
| `planned` | `planned` |
| `blockers` | `blockers` |
| `notes` | `notes` |
| `createdAt` | `created_at` |
| `updatedAt` | `updated_at` |

`toRow()` / `fromRow()` in `app.js` handle JS ↔ DB mapping.

### Key functions in `app.js`

- `loadReports()` — async fetch from Supabase, populates `reports` array, calls `renderList()`
- `renderList()` — renders cards from in-memory `reports`, wires click → `openForm(id)`
- `openForm(id?)` — populates form for edit (with id) or new report (without)
- `saveReport()` — async upsert via `db.from('reports').upsert(...)`
- `deleteReport()` — async delete via `db.from('reports').delete().eq('id', id)`
- `exportReport()` — generates `.txt` blob download (no DB call)

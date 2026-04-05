# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains a static weekly report web application deployed on Vercel, backed by Supabase (PostgreSQL).

## Deployment

- **Hosting:** Vercel, connected to the `jpokemon01/claude` GitHub repo (`main` branch)
- **Root Directory:** Set to `weekly_reports` in the Vercel project settings (not via `vercel.json`)
- Pushing to `main` triggers an automatic redeploy
- **Database:** Supabase project at `https://pujgfojebzyetxypwytg.supabase.co`

## Architecture

The app is a single-page static site in `weekly_reports/` with no build step. The Supabase JS client is loaded via CDN in `index.html`.

- **`index.html`** — two views toggled with `.hidden`: `#list-view` (report cards) and `#form-view` (create/edit form)
- **`style.css`** — scoped to the two views; responsive breakpoint at 600px
- **`app.js`** — all logic; communicates with Supabase for all CRUD operations

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

`toRow()` / `fromRow()` in `app.js` handle the mapping between JS and DB shapes.

### Key functions in `app.js`

- `loadReports()` — async fetch from Supabase, populates local `reports` array, calls `renderList()`
- `renderList()` — renders report cards from in-memory `reports`, wires click → `openForm(id)`
- `openForm(id?)` — populates form for edit (with id) or new report (without)
- `saveReport()` — async upsert to Supabase via `db.from('reports').upsert(...)`
- `deleteReport()` — async delete from Supabase via `db.from('reports').delete().eq('id', id)`
- `exportReport()` — generates a `.txt` blob and triggers download (no DB call)

### Supabase RLS

Row Level Security must be **disabled** on the `reports` table (or a permissive policy added) for the anon key to read/write data.

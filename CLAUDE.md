# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains a static weekly report web application deployed on Vercel.

## Deployment

- **Hosting:** Vercel, connected to the `jpokemon01/claude` GitHub repo (`main` branch)
- **Root Directory:** Set to `weekly_reports` in the Vercel project settings (not via `vercel.json`)
- Pushing to `main` triggers an automatic redeploy

## Architecture

The app is a single-page, zero-dependency static site in `weekly_reports/`:

- **`index.html`** — two views toggled with `.hidden`: `#list-view` (report cards) and `#form-view` (create/edit form)
- **`style.css`** — scoped to the two views; responsive breakpoint at 600px
- **`app.js`** — all logic; reports are stored as JSON in `localStorage` under the key `weekly_reports`

### Data model (stored per report in localStorage)
```
{ id, weekStart, weekEnd, completed, planned, blockers, notes, createdAt, updatedAt }
```

### Key functions in `app.js`
- `renderList()` — sorts and renders report cards, wires click → `openForm(id)`
- `openForm(id?)` — populates form for edit (with id) or new report (without)
- `saveReport()` — upserts by id into the `reports` array, persists, returns to list
- `exportReport()` — generates a `.txt` blob and triggers download

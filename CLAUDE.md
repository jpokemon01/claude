# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains two sub-projects:

- **`weekly_reports/`** — A static weekly report web application deployed on Vercel, backed by Supabase (PostgreSQL)
- **`business_processing/`** — Business research and process documentation (not deployed)
- **`brazil_trade_company/`** — Research and documentation for establishing and operating an export/import trading company in Brazil (not deployed)

## Instructions for Each Project Directory

- Create `CLAUDE.md` for each project directory
- Create `Skill.md` for each project directory
- Create `minutes.md` for each project directory — contents are the conversation between Claude and the user

## Deployment

- **Hosting:** Vercel, connected to the `jpokemon01/claude` GitHub repo (`main` branch)
- **Root Directory:** Set to `weekly_reports` in the Vercel project settings (not via `vercel.json`)
- Pushing to `main` triggers an automatic redeploy
- **Database:** Supabase project at `https://pujgfojebzyetxypwytg.supabase.co`

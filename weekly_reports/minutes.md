# Minutes — weekly_reports

Development log and decision record for the weekly_reports project.

---

## 2026-04-05

### Work Done
- Created initial static web app (`index.html`, `style.css`, `app.js`) with localStorage persistence
- Integrated Supabase for persistent cross-device storage
- Fixed date range display to show year on both start and end dates
- Fixed Vercel 404 error — root directory must be set to `weekly_reports/` in Vercel project settings (not via `vercel.json`)
- Added `CLAUDE.md`, `Skill.md`, `minutes.md` to project directory

### Decisions
- **No build step:** Kept as plain HTML/CSS/JS for simplicity; Supabase loaded via CDN
- **Vercel root directory:** Configured in dashboard, not `vercel.json` (schema validation error with `root` property)
- **RLS disabled:** Supabase Row Level Security disabled on `reports` table to allow anon key access
- **snake_case ↔ camelCase:** `toRow()` / `fromRow()` helpers handle DB ↔ JS field mapping

# Minutes — business_processing

Research log and decision record for the business_processing directory.

---

## 2026-04-05

### Research Completed
- Investigated end-to-end process for importing Japanese goods (manga, toys, children's clothing) to Brazil
- Documented tax structure: manga benefits from 0% tax (constitutional book immunity); toys and clothing face ~55–65% effective tax burden
- Documented INMETRO certification requirements per product category
- Documented SISCOMEX customs flow and RADAR importer registration
- Documented labeling requirements in Portuguese and IP considerations for manga

### Decisions
- **PDF generation:** Used `reportlab` (pure Python) instead of `weasyprint` — weasyprint requires system-level GTK/Pango libraries unavailable on Windows without additional setup
- **Guide format:** Structured as reference tables + process steps for quick lookup by a business user

### Key Findings
- Manga is the most financially viable import category (0% taxes, no INMETRO required)
- Toys require per-model INMETRO certification (BRL 8,000–25,000, 3–6 months) — significant barrier for small importers with diverse SKUs
- First shipment timeline: 5–8 months; ongoing shipments: 65–90 days
- Recommended freight forwarders: Kintetsu World Express Brasil, Nippon Express do Brasil (both Japanese-owned)

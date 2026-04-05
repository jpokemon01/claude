# Minutes — business_processing

Conversation log between the user and Claude for the business_processing project.

---

## 2026-04-05

**User:** would you create depository under CLAUDE for business_processing?

**Claude:** Created `business_processing/` directory.

---

**User:** would you investigate for importing Japanese goods like comics, toys, and children's clothes to Brazil. What kind of tasks are necessary from start to end?

**Claude:** Researched and produced a comprehensive guide covering:
- Critical path timeline (5–8 months for first shipment)
- Tax structure by category: manga 0% (constitutional book immunity), toys/clothing ~55–65% of CIF
- INMETRO certification requirements (toys: Portaria 563/2016 — BRL 8,000–25,000 per model; clothing: Portaria 144/2015)
- Required documentation (Commercial Invoice, Packing List, B/L, LI, DI/DUIMP, INMETRO cert)
- SISCOMEX customs flow and RADAR importer registration
- Portuguese labeling requirements
- IP considerations for manga (avoid titles with active Brazilian licenses; prohibited: sexual content involving minors)
- Shipping options (sea freight Santos ~35–45 days; air freight GRU ~3–5 days)
- Recommended service providers: Kintetsu World Express Brasil, Nippon Express, JETRO São Paulo

**User:** (confirmed to save research as document)

**Claude:** Created `japan_brazil_import_guide.md` in `business_processing/` and pushed to GitHub.

---

**User:** could you make pdf file for japan_brazil_import_guide.md?

**Claude:** Attempted `weasyprint` — failed on Windows (requires GTK/Pango system libraries). Switched to `reportlab`. Created `generate_pdf.py` which parses the markdown and renders styled PDF with tables, headings, and bullet points. Generated `japan_brazil_import_guide.pdf` and pushed both files to GitHub.

---

**User:** what is the best import goods for profit from Japan to Brazil?

**Claude:** Analyzed all categories by profit potential:
- **Tier 1:** Manga (0% tax, no INMETRO) and Japanese stationery (low tax, premium brand value, no cert) — best for small importers
- **Tier 2:** Adult collectibles/figures (high margin, dedicated buyer base), Japanese beauty/skincare (high demand, needs ANVISA)
- **Tier 3:** Toys and children's clothing (55–65% tax burden + INMETRO — only viable at volume)
- Recommended starting point: manga + stationery (lowest barrier, strong demand from Brazil's 1.5M Japanese-Brazilian community)

---

**User:** what does INMETRO certification?

**Claude:** Explained INMETRO (Instituto Nacional de Metrologia, Qualidade e Tecnologia) — Brazil's national product safety certification body. Key points:
- Required for all toys (children under 14) and children's clothing before legal sale in Brazil
- Per product model — each SKU needs its own certificate
- Cost: BRL 8,000–25,000 per toy model; 3–6 months; 1–3 year validity
- Testing done by OCP (accredited certification body) against ABNT standards
- INMETRO seal must appear on product label
- Manga, stationery, adult collectibles: not required

---

**User:** what is ANVISA registration?

**Claude:** Explained ANVISA (Agência Nacional de Vigilância Sanitária) — Brazil's equivalent of the US FDA. Key points:
- Required for food, beverages, cosmetics, supplements, medicines before import/sale
- Two tiers: Notificação (low-risk, 1–3 months) and Registro (high-risk, 6–24 months)
- Per product SKU; only a Brazilian CNPJ holder can apply
- Japanese snacks/instant noodles and skincare: ANVISA required
- Manga, stationery, toys, clothing: not required

---

**User:** Would you tell me more specific items for Japanese stationery for the profit?

**Claude:** Provided detailed stationery analysis:
- **Tier 1 (highest margin):** Gel pens (Pilot Juice, Zebra Mildliner, Uni Signo — 3–4x markup), Uni Kuru Toga mechanical pencil (unique rotating mechanism), Pentel GraphGear 1000
- **Tier 2 (premium):** Hobonichi Techo planner (¥2,400 → BRL 200–350), Midori MD Notebook, MT washi tape (very light, high collectibility)
- **Recommended first shipment:** ~5–8 kg air freight — Mildliner sets, Kuru Toga, MT washi tape, Hobonichi, MD Notebook; estimated retail value BRL 12,000–18,000 on BRL 3,000–5,000 total cost
- Best wholesale sources: Tokyu Hands/Loft (sampling), Amazon Japan (small orders), JETRO matchmaking (wholesale distributors)

---

**User:** what is the best items export from Brazil to Japan?

**Claude:** Analyzed Brazil → Japan export opportunities:
- **Tier 1:** Specialty coffee (Japan = world's 3rd largest market; specialty beans 2–5x margin), Cachaça (unique to Brazil, growing premium spirits market), Açaí (dominant global supplier, strong health trend in Japan)
- **Tier 2:** Brazilian gemstones (Paraíba tourmaline, Imperial Topaz, Alexandrite), Green propolis (already established market in Japan), Exotic freeze-dried fruits
- **Tier 3:** Leather goods, certified hardwood, Brazilian musical instruments
- **Best starting point:** Specialty coffee + gemstones (low regulatory barrier, premium pricing, strong provenance story)

---

**User:** which gemstones are profitable to export from Brazil to Japan?

**Claude:** Detailed gemstone analysis:
- **Tier 1 (highest value):** Paraíba Tourmaline (¥500,000–5,000,000+/carat, rarest colored gem, needs GRS certificate of Brazilian origin), Imperial Topaz (exclusive to Ouro Preto, ¥50,000–500,000/ct), Alexandrite (strong color change, ¥200,000–2,000,000+/ct — considered magical/lucky in Japan)
- **Tier 2:** Aquamarine Santa Maria color (¥10,000–200,000/ct), various Tourmaline colors, Morganite (large Brazilian crystals)
- **Tier 3:** Amethyst, Citrine Madeira, Cat's Eye Chrysoberyl (superstition-driven demand in Japan)
- GIA/GRS certification essential — Japanese buyers will not pay top price without certificate
- Recommended entry: Tokyo International Mineral Fair (Shinjuku, June annually)

---

**User:** would you find out what is the best specialty coffee to export Japan for the profit?

**Claude:** Researched comprehensively:
- **Best regions:** Mantiqueira de Minas (84–91 SCA, floral/elegant — best pour-over), Chapada Diamantina (84–89+, fruit-forward — appeals to Ethiopian/Kenyan lovers), Cerrado Mineiro (82–88, Designation of Origin seal legible to Japanese buyers)
- **Best varieties:** Yellow Bourbon (top COE lots at USD $126/lb), Geisha (highest price ceiling), washed processing (rare from Brazil → 20–40% premium)
- **Japan green coffee prices:** 84–86 SCA = USD $12–18/kg; 87–89 = USD $18–40/kg; COE winners = auction price
- **Key buyers:** Wataru & Co. (best first importer contact), Sucafina Japan, Maruyama Coffee, Onibus Coffee, Fuglen Tokyo
- **Market entry:** SCAJ 2026 (Tokyo Big Sight, Oct 14–17), Algrano platform, APEX-Brasil subsidy program
- **Per FCL gross margin (85 SCA Yellow Bourbon):** BRL 140,000–300,000
- Japan import duty on green coffee: 0%

---

**User:** would you create pdf file for brazil_coffee_japan_export_guide.md?

**Claude:** Updated `generate_pdf.py` to accept any markdown file as a command-line argument (output PDF uses same base name). Generated `brazil_coffee_japan_export_guide.pdf` and pushed to GitHub.

---

**User:** Please tell me how to become export coffee from Brazil to Japan?

**Claude:** Provided a practical step-by-step guide:
- **Step 1 (Month 1–2):** Register CNPJ, RADAR (exporter ID), and Cecafé membership for ICO Certificate of Origin
- **Step 2 (Month 1–3):** Secure coffee supply — own farm, source micro-lots from Mantiqueira de Minas / Chapada Diamantina / Cerrado Mineiro, or trade through cooperatives
- **Step 3 (Month 2–4):** Hire Q-Grader for SCA cupping report (minimum 84 SCA target); enter Cup of Excellence if eligible
- **Step 4 (Month 2–6):** Obtain JAS Organic (via USDA equivalence, +15–30% Japan price), Cerrado DO certification, or Rainforest Alliance as appropriate
- **Step 5 (Month 3–6):** Contact Wataru & Co. or Sucafina Japan (importers, easiest entry); list farm on Algrano; approach Onibus Coffee and Maruyama Coffee directly
- **Step 6 (Month 4–5):** Send 250g green sample packs to 10–15 Japanese buyers via DHL (budget USD $300–500)
- **Step 7 (Oct 2026):** Apply to APEX-Brasil for subsidized SCAJ 2026 exhibition (Tokyo Big Sight, Oct 14–17)
- **Step 8:** Export via Port of Santos with documents: Commercial Invoice, ICO Certificate of Origin, Phytosanitary Certificate (MAPA), SISCOMEX Registro de Exportação, SCA report
- Japan import duty on green coffee: 0%; transit time: 20–28 days; per FCL gross margin: BRL 140,000–300,000

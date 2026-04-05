# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `business_processing/` directory.

## Overview

Business research and process documentation. Not deployed. Contains guides, analysis documents, and supporting scripts.

## Contents

- **`japan_brazil_import_guide.md`** — End-to-end guide for importing Japanese goods (manga, toys, children's clothing) to Brazil: taxes, INMETRO certification, customs procedures, labeling, IP considerations
- **`japan_brazil_import_guide.pdf`** — PDF version of the above
- **`brazil_coffee_japan_export_guide.md`** — Comprehensive guide for exporting Brazilian specialty coffee to Japan: regions, varieties, processing methods, buyers, pricing, logistics, margins
- **`brazil_coffee_japan_export_guide.pdf`** — PDF version of the above
- **`brazil_gemstone_japan_export_guide.md`** — Risk/return analysis for exporting Brazilian gemstones to Japan: aquamarine, Imperial Topaz, Alexandrite, Paraíba Tourmaline, certifications, market entry
- **`brazil_gemstone_japan_export_guide.pdf`** — PDF version of the above
- **`imperial_topaz_sourcing_ouro_preto.md`** — Where to buy Imperial Topaz in Brazil: Ouro Preto shops, mines, Belo Horizonte and São Paulo dealers, quality grades, buying tips
- **`imperial_topaz_sourcing_ouro_preto.pdf`** — PDF version of the above
- **`aquamarine_sourcing_brazil.md`** — Where to buy Santa Maria color aquamarine in Brazil: Teófilo Otoni (gem capital), Governador Valadares, Belo Horizonte, São Paulo; color grading, price guide, export process
- **`aquamarine_sourcing_brazil.pdf`** — PDF version of the above
- **`gemstone_shipping_customs_brazil_japan.md`** — Shipping costs, insurance, Brazil export requirements, Japan import duties, declaration rules, and cost breakdown for gemstone export
- **`gemstone_shipping_customs_brazil_japan.pdf`** — PDF version of the above
- **`generate_pdf.py`** — Python script to generate a PDF from any markdown file in this directory

## Regenerating or Creating PDFs

```
pip install reportlab markdown2
python business_processing/generate_pdf.py business_processing/<filename>.md
```

If no argument is given, defaults to `japan_brazil_import_guide.md`. Output PDF is saved alongside the input `.md` file with the same base name.

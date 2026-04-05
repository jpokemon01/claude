# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `brazil_trade_company/` directory.

## Overview

Research and documentation for establishing and operating an export/import trading company in Brazil. Not deployed.

## Instructions

- Create `CLAUDE.md` for this directory
- Create `Skill.md` for this directory
- Create `minutes.md` for this directory — contents are the conversation between Claude and the user

## Contents

- **`establishing_trading_company_brazil.md`** — Complete guide for a foreign national (Japanese) to set up an export/import Ltda/SLU in Brazil: CPF, CNPJ, RADAR, tax regime, banking, product licenses, costs, timeline
- **`establishing_trading_company_brazil.pdf`** — PDF version of the above
- **`us_vs_japanese_owner_brazil_company.md`** — Comparison of owning a Brazilian company as a US citizen vs. Japanese national: FATCA impact on banking, IRS filing obligations (Form 5471, FBAR, Form 8938), what is the same
- **`us_vs_japanese_owner_brazil_company.pdf`** — PDF version of the above

## Generating PDFs

```
python business_processing/generate_pdf.py brazil_trade_company/<filename>.md
```

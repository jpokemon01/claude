# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `purchase_iphone/` directory.

## Overview

Research and documentation for purchasing iPhones. Not deployed.

## Instructions

- Create `CLAUDE.md` for this directory
- Create `Skill.md` for this directory
- Create `minutes.md` for this directory — contents are the conversation between Claude and the user

## Contents

- **`ebay_iphone15_buying_checklist.md`** — Checklist for buying an unlocked iPhone 15 on eBay for Metro PCS: unlock status, model numbers, IMEI/blacklist check, iCloud lock, seller reputation, battery health, red flags, Metro PCS activation steps
- **`ebay_iphone15_buying_checklist.pdf`** — PDF version of the above

## Generating PDFs

```
python business_processing/generate_pdf.py purchase_iphone/<filename>.md
```

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `transfer_to_iphone/` directory.

## Overview

Research and documentation for transferring data to a new iPhone. Not deployed.

## Instructions

- Create `CLAUDE.md` for this directory
- Create `Skill.md` for this directory
- Create `minutes.md` for this directory — contents are the conversation between Claude and the user

## Contents

- **`android_to_iphone_metro_pcs_guide.md`** — Step-by-step guide for moving from Android (Metro PCS) to unlocked iPhone 15: Android backup, Move to iOS app, Metro eSIM activation, iPhone setup, what doesn't transfer automatically, post-switch checklist
- **`android_to_iphone_metro_pcs_guide.pdf`** — PDF version of the above

## Generating PDFs

```
python business_processing/generate_pdf.py transfer_to_iphone/<filename>.md
```

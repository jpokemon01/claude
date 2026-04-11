# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `teach_john_forward_email/` directory.

## Overview

Research and documentation for teaching John how to forward email. Not deployed.

## Instructions

- Create `CLAUDE.md` for this directory
- Create `Skill.md` for this directory
- Create `minutes.md` for this directory — contents are the conversation between Claude and the user

## Contents

- **`how_to_forward_email_guide.md`** — Beginner-friendly step-by-step guide for forwarding email to takeo_inoue_re@yahoo.com. Covers iPhone Mail, Android Gmail, Gmail on computer, and Outlook. Written for someone with no email knowledge.
- **`how_to_forward_email_guide.pdf`** — PDF version of the above

## Generating PDFs

```
python business_processing/generate_pdf.py teach_john_forward_email/<filename>.md
```

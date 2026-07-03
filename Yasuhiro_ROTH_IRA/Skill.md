# Skill.md — Yasuhiro_ROTH_IRA

Skills and knowledge relevant to this directory.

## Roth IRA Knowledge

- Roth IRA eligibility rules and contribution limits
- Tax advantages and withdrawal rules
- Investment options within a Roth IRA
- Account setup and management

## Financial Planning

- Retirement planning strategies
- Tax-free growth and compounding
- Comparison with Traditional IRA and 401(k)

## Automated Monthly Reporting (`generate_monthly_report.py`)

- Python with the `anthropic` SDK — Claude vision API to extract portfolio data (holdings, prices, cost basis) from brokerage screenshots
- Month-over-month portfolio comparison using cached JSON data (`portfolio_data.json`) from prior months
- Web search integration for market context and narrative commentary
- Report output as `.txt` and PDF (via `business_processing/generate_pdf.py`)
- Monthly data folders named `YYYYMM` (e.g., `202606`) containing screenshots, `comments.txt`, cached data, and generated reports

"""
Yasuhiro Roth IRA - Monthly Report Generator
Usage: python generate_monthly_report.py 202606
       python generate_monthly_report.py  (uses current month automatically)

Steps:
  1. Reads JPG screenshots from the target month directory
  2. Uses Claude vision API to extract portfolio data (including cost basis)
  3. Loads previous and two-months-ago data for comparison
  4. For stocks newly purchased in the previous month, uses cost basis as reference price
  5. Uses web search to find market context and generates narrative commentary
  6. Generates a .txt report and a PDF
"""

import sys
import os
import json
import base64
import re
import subprocess
import time
from datetime import date
from pathlib import Path
import anthropic

# ── paths ──────────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).parent          # Yasuhiro_ROTH_IRA/
PDF_SCRIPT = BASE_DIR.parent / "business_processing" / "generate_pdf.py"

# ── helpers ────────────────────────────────────────────────────────────────────

def month_dir(yyyymm: str) -> Path:
    return BASE_DIR / yyyymm

def prev_month(yyyymm: str) -> str:
    y, m = int(yyyymm[:4]), int(yyyymm[4:])
    m -= 1
    if m == 0:
        m, y = 12, y - 1
    return f"{y}{m:02d}"

def encode_image(path: Path) -> str:
    with open(path, "rb") as f:
        return base64.standard_b64encode(f.read()).decode("utf-8")

def find_screenshots(folder: Path) -> list[Path]:
    return sorted(
        p for p in folder.iterdir()
        if p.suffix.lower() in (".jpg", ".jpeg", ".png") and not p.name.startswith(".")
    )

def load_comments(folder: Path) -> str | None:
    comments_file = folder / "comments.txt"
    if comments_file.exists():
        text = comments_file.read_text(encoding="utf-8").strip()
        return text if text else None
    return None

def load_json_cache(folder: Path) -> dict | None:
    cache = folder / "portfolio_data.json"
    if cache.exists():
        return json.loads(cache.read_text(encoding="utf-8"))
    return None

def save_json_cache(folder: Path, data: dict):
    cache = folder / "portfolio_data.json"
    cache.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"  Saved cache -> {cache.name}")

# ── Claude vision extraction ───────────────────────────────────────────────────

EXTRACTION_PROMPT = """
You are a financial data extractor. The image shows a brokerage account portfolio screen.

Extract ALL holdings into this exact JSON structure — no markdown, no explanation, just raw JSON:

{
  "total_account_value": 0.00,
  "total_market_value": 0.00,
  "total_gain_loss": 0.00,
  "total_gain_loss_pct": 0.00,
  "equities": [
    {
      "symbol": "XXXX",
      "description": "Company Name",
      "qty": 0,
      "price": 0.00,
      "mkt_val": 0.00,
      "cost_basis": 0.00,
      "gain_loss": 0.00,
      "gain_loss_pct": 0.00
    }
  ],
  "etfs": [
    {
      "symbol": "XXXX",
      "description": "ETF Name",
      "qty": 0,
      "price": 0.00,
      "mkt_val": 0.00,
      "cost_basis": 0.00,
      "gain_loss": 0.00,
      "gain_loss_pct": 0.00
    }
  ]
}

Rules:
- Include EVERY row visible — do not skip any
- cost_basis is the "Cost Basis" column value (total cost paid for all shares)
- Use negative numbers for losses
- qty can be fractional (e.g. 0.6015)
- If a field is not visible use null
- Return ONLY the JSON, nothing else
"""

def extract_portfolio_from_images(images: list[Path], client: anthropic.Anthropic) -> dict:
    print(f"  Sending {len(images)} image(s) to Claude vision...")

    content = []
    for img in images:
        media_type = "image/png" if img.suffix.lower() == ".png" else "image/jpeg"
        content.append({
            "type": "image",
            "source": {
                "type": "base64",
                "media_type": media_type,
                "data": encode_image(img),
            }
        })
    content.append({"type": "text", "text": EXTRACTION_PROMPT})

    response = client.messages.create(
        model="claude-fable-5",
        max_tokens=4096,
        messages=[{"role": "user", "content": content}]
    )

    raw = "".join(
        block.text for block in response.content if getattr(block, "type", None) == "text"
    ).strip()
    raw = re.sub(r"^```[a-z]*\n?", "", raw)
    raw = re.sub(r"\n?```$", "", raw)

    try:
        return json.loads(raw)
    except json.JSONDecodeError as e:
        print(f"  WARNING: JSON parse error: {e}")
        print(f"  Raw response:\n{raw[:500]}")
        raise

def get_portfolio(yyyymm: str, client: anthropic.Anthropic) -> dict | None:
    folder = month_dir(yyyymm)
    if not folder.exists():
        return None
    cache = load_json_cache(folder)
    if cache:
        print(f"  [{yyyymm}] Using cached portfolio_data.json")
        return cache
    images = find_screenshots(folder)
    if not images:
        print(f"  [{yyyymm}] No screenshots found — skipping")
        return None
    print(f"  [{yyyymm}] Found: {[p.name for p in images]}")
    data = extract_portfolio_from_images(images, client)
    save_json_cache(folder, data)
    return data

# ── report generation ──────────────────────────────────────────────────────────

def symbol_map(holdings: list) -> dict:
    return {h["symbol"]: h for h in (holdings or [])}

def fmt_pct(val):
    if val is None:
        return "N/A"
    return f"{val:+.1f}%"

def fmt_dollar(val):
    if val is None:
        return "N/A"
    return f"${val:,.2f}"

def ref_price(holding: dict, two_ago_syms: set) -> tuple[float | None, str]:
    """
    Returns (price, label) to use as the 'from' reference in comparisons.
    - If stock existed two months ago -> use market price (normal month-over-month)
    - If stock is NEW (not in two months ago) -> use cost_basis per share as reference
      because the stock was purchased during the previous month
    """
    sym = holding["symbol"]
    if sym not in two_ago_syms:
        # newly purchased last month — use cost basis per share
        cb = holding.get("cost_basis")
        qty = holding.get("qty") or 1
        if cb and qty:
            return cb / qty, "cost"
    return holding.get("price"), "price"

def format_holding_line(i: int, sym: str, cur: dict, prev: dict | None,
                        two_ago_syms: set, is_new_this_month: bool) -> str:
    if is_new_this_month:
        cb = cur.get("cost_basis")
        qty = cur.get("qty") or 1
        entry = (cb / qty) if cb and qty else cur.get("price")
        current_price = cur.get("price")
        gl_pct = cur.get("gain_loss_pct") or 0
        if entry and current_price:
            chg_pct = (current_price - entry) / entry * 100
            gl_label = "loss" if chg_pct < 0 else "gain"
            return (f"({i:>2}) {sym:<6}  NEW  entry~{fmt_dollar(entry)} -> {fmt_dollar(current_price)}"
                    f"  ({chg_pct:+.1f}%)  qty: {cur.get('qty')}  {gl_label}")
        gl_label = "loss" if gl_pct < 0 else "gain"
        return (f"({i:>2}) {sym:<6}  NEW  entry~{fmt_dollar(entry)} -> {fmt_dollar(current_price)}"
                f"  ({fmt_pct(gl_pct)})  qty: {cur.get('qty')}  {gl_label}")

    if prev is None:
        return f"({i:>2}) {sym:<6}  (no previous data)"

    from_price, from_label = ref_price(prev, two_ago_syms)
    to_price = cur.get("price")

    if from_price and to_price:
        price_chg = to_price - from_price
        price_pct = price_chg / from_price * 100
        price_str = f"{fmt_dollar(from_price)}({from_label}) -> {fmt_dollar(to_price)}  ({price_pct:+.1f}%)"
    else:
        price_str = f"N/A -> {fmt_dollar(to_price)}"

    qty_prev = prev.get("qty") or 0
    qty_cur  = cur.get("qty") or 0
    qty_chg  = qty_cur - qty_prev
    if qty_chg < 0:
        qty_note = f" | sold {abs(qty_chg):.4g} (realized profit)"
    elif qty_chg > 0:
        qty_note = f" | bought {qty_chg:.4g} more"
    else:
        qty_note = ""

    return f"({i:>2}) {sym:<6}  {price_str}  qty: {qty_prev}->{qty_cur}{qty_note}"

def generate_narrative_commentary(current: dict, previous: dict,
                                   two_ago: dict | None, yyyymm: str,
                                   client: anthropic.Anthropic,
                                   user_comments: str | None = None) -> str:
    """Uses Claude with web search to write the overall market commentary section."""
    prev_yyyymm = prev_month(yyyymm)
    year, month = int(yyyymm[:4]), int(yyyymm[4:])
    month_name = date(year, month, 1).strftime("%B %Y")
    prev_month_name = date(int(prev_yyyymm[:4]), int(prev_yyyymm[4:]), 1).strftime("%B %Y")

    cur_total  = current.get("total_account_value") or 0
    prev_total = previous.get("total_account_value") or 0
    mom_gain   = cur_total - prev_total
    mom_pct    = (mom_gain / prev_total * 100) if prev_total else 0

    cur_eq   = symbol_map(current.get("equities", []))
    prev_eq  = symbol_map(previous.get("equities", []))
    cur_etf  = symbol_map(current.get("etfs", []))
    prev_etf = symbol_map(previous.get("etfs", []))
    two_ago_syms = set()
    if two_ago:
        two_ago_syms = set(symbol_map(two_ago.get("equities", []))) | set(symbol_map(two_ago.get("etfs", [])))

    all_prev_syms = set(prev_eq) | set(prev_etf)
    all_cur_syms  = set(cur_eq) | set(cur_etf)
    new_positions = sorted(all_cur_syms - all_prev_syms)
    exited        = sorted(all_prev_syms - all_cur_syms)

    # top movers
    movers = []
    for sym, cur in {**cur_eq, **cur_etf}.items():
        prev = prev_eq.get(sym) or prev_etf.get(sym)
        if prev:
            from_p, _ = ref_price(prev, two_ago_syms)
            to_p = cur.get("price")
            if from_p and to_p and from_p > 0:
                pct = (to_p - from_p) / from_p * 100
                movers.append((sym, pct, cur.get("description", "")))
    movers.sort(key=lambda x: -abs(x[1]))
    top_movers_text = "\n".join(
        f"  {sym} ({desc}): {pct:+.1f}%"
        for sym, pct, desc in movers[:8]
    )

    all_symbols = sorted(all_cur_syms | all_prev_syms)

    if user_comments:
        user_comments_section = "Yasuhiro's own notes (incorporate these into the commentary naturally):\n" + user_comments + "\n\n"
    else:
        user_comments_section = ""

    prompt = f"""You are writing a monthly Roth IRA portfolio commentary for a personal investor named Yasuhiro.

Portfolio summary for {month_name}:
- Previous month ({prev_month_name}) total: ${prev_total:,.2f}
- This month total: ${cur_total:,.2f}
- Month-over-month change: {mom_gain:+,.2f} ({mom_pct:+.1f}%)
- Total unrealized gain/loss: {fmt_dollar(current.get('total_gain_loss'))} ({fmt_pct(current.get('total_gain_loss_pct'))})

Top movers this month:
{top_movers_text}

New positions added: {', '.join(new_positions) if new_positions else 'none'}
Positions exited: {', '.join(exited) if exited else 'none'}
All holdings: {', '.join(all_symbols)}

Instructions:
1. Use web search to find what happened in the stock market and geopolitical events in {month_name} that affected this portfolio
2. Search for news about the biggest movers (especially {', '.join(s for s,_,_ in movers[:4])})
3. Write a natural, first-person commentary in the same casual style as this example:

---EXAMPLE STYLE---
Iran war caused to have very bad last March by losing 25%, but since then recovered by 29%

Now Iran war calms down and oil price is stable.
This is causing to AI data center stocks going up. (Bull market)

Thank you for Yasuhiro informed me for steep increase price for NAND.
Therefore, It was easy to decide purchasing SNDK (NAND stock).
Also I underestimated the performance for SNDK. It increased 54% just a month.

I also additionally bought MRAM (next generation memory stock) and price increased rapidly 300% just a month.
(Next SNDK?)

I am continuously trying to stabilize the capital gain by buying additional the Nasdaq Index ETF.
(Performance is better comparing other index ETF SP500 or DOW)
---END EXAMPLE---

{user_comments_section}Rules for the commentary:
- Write 4-8 short paragraphs, casual and personal tone
- Mention the key market events/news that explain the portfolio performance
- Comment on the biggest winners and losers with explanation WHY they moved
- Mention new purchases and the reasoning
- Note any strategy changes or upcoming events to watch
- Do NOT include the data table or numbers section — just the narrative
- Write ONLY the commentary text, no headers, no JSON
"""

    print("  Calling Claude with web search for market context...")

    messages = [{"role": "user", "content": prompt}]
    tools = [{"type": "web_search_20260209", "name": "web_search"}]
    all_text_blocks = []

    def api_call_with_retry(**kwargs):
        # stream to keep the connection alive — the server-side web search
        # loop can run for minutes, and non-streaming connections get dropped
        for attempt in range(5):
            try:
                with client.messages.stream(**kwargs) as stream:
                    return stream.get_final_message()
            except anthropic.RateLimitError:
                wait = 65 * (attempt + 1)
                print(f"  Rate limit hit — waiting {wait}s before retry {attempt + 1}/5...")
                time.sleep(wait)
            except (anthropic.APIConnectionError, anthropic.InternalServerError) as e:
                wait = 10 * (attempt + 1)
                print(f"  Transient API error ({type(e).__name__}) — waiting {wait}s before retry {attempt + 1}/5...")
                time.sleep(wait)
        raise RuntimeError("API retry exhausted")

    # web_search is a server-side tool: the API runs the searches itself.
    # Only pause_turn needs a continuation (re-send with the assistant turn
    # appended); never send tool_result blocks for server tool calls.
    for _ in range(8):
        response = api_call_with_retry(
            model="claude-fable-5",
            max_tokens=8000,
            tools=tools,
            messages=messages
        )

        for block in response.content:
            if getattr(block, "type", None) == "text" and block.text.strip():
                all_text_blocks.append(block.text.strip())

        if response.stop_reason == "pause_turn":
            messages.append({"role": "assistant", "content": response.content})
            continue
        break

    commentary = "\n\n".join(all_text_blocks)
    return commentary or "(Commentary generation failed — please write manually)"


def generate_report_text(current: dict, previous: dict,
                         two_ago: dict | None, yyyymm: str,
                         commentary: str = "",
                         user_comments: str | None = None) -> str:
    prev_yyyymm = prev_month(yyyymm)
    two_ago_yyyymm = prev_month(prev_yyyymm)
    year, month = int(yyyymm[:4]), int(yyyymm[4:])

    cur_total  = current.get("total_account_value") or 0
    prev_total = previous.get("total_account_value") or 0
    mom_gain   = cur_total - prev_total

    cur_eq   = symbol_map(current.get("equities", []))
    prev_eq  = symbol_map(previous.get("equities", []))
    cur_etf  = symbol_map(current.get("etfs", []))
    prev_etf = symbol_map(previous.get("etfs", []))

    two_ago_eq  = symbol_map(two_ago.get("equities", [])) if two_ago else {}
    two_ago_etf = symbol_map(two_ago.get("etfs", [])) if two_ago else {}
    two_ago_syms = set(two_ago_eq) | set(two_ago_etf)

    all_prev_syms = set(prev_eq) | set(prev_etf)
    all_cur_syms  = set(cur_eq) | set(cur_etf)
    new_this_month    = all_cur_syms - all_prev_syms
    exited_this_month = all_prev_syms - all_cur_syms

    lines = []
    lines.append(f"Monthly Roth IRA Report — {year}/{month:02d}")
    lines.append("=" * 60)
    lines.append("")
    if user_comments:
        lines.append("Takeo's Comments (fund manager):")
        lines.append(user_comments)
        lines.append("")
        lines.append("-" * 60)
        lines.append("")
    if commentary:
        lines.append(commentary)
        lines.append("")
        lines.append("-" * 60)
        lines.append("")
    lines.append("Unrealized profit / loss:")
    lines.append(f"  Last month ({prev_yyyymm}):  {fmt_dollar(prev_total)}")
    lines.append(f"  This month ({yyyymm}):        {fmt_dollar(cur_total)}")
    lines.append(f"  Month-over-month:             {fmt_dollar(mom_gain)}")
    lines.append("")
    lines.append(f"Total portfolio gain/loss: {fmt_dollar(current.get('total_gain_loss'))} "
                 f"({fmt_pct(current.get('total_gain_loss_pct'))})")
    lines.append("")

    # ── Equities ──
    lines.append(f"Noticeable remarks — Equities  ({prev_yyyymm} -> {yyyymm}):")
    i = 1
    # sort by absolute gain/loss % descending, new positions last within existing
    sorted_eq = sorted(cur_eq.items(),
                       key=lambda x: (x[0] in new_this_month,
                                      -(x[1].get("gain_loss_pct") or 0)))
    for sym, cur in sorted_eq:
        prev = prev_eq.get(sym)
        is_new = sym in new_this_month
        lines.append(format_holding_line(i, sym, cur, prev, two_ago_syms, is_new))
        i += 1
    for sym in sorted(exited_this_month & set(prev_eq)):
        lines.append(f"({i:>2}) {sym:<6}  EXITED — sold all shares")
        i += 1

    lines.append("")

    # ── ETFs ──
    lines.append(f"Noticeable remarks — ETFs  ({prev_yyyymm} -> {yyyymm}):")
    i = 1
    sorted_etf = sorted(cur_etf.items(),
                        key=lambda x: (x[0] in new_this_month,
                                       -(x[1].get("gain_loss_pct") or 0)))
    for sym, cur in sorted_etf:
        prev = prev_etf.get(sym)
        is_new = sym in new_this_month
        lines.append(format_holding_line(i, sym, cur, prev, two_ago_syms, is_new))
        i += 1
    for sym in sorted(exited_this_month & set(prev_etf)):
        lines.append(f"({i:>2}) {sym:<6}  EXITED — sold all")
        i += 1

    lines.append("")
    lines.append("My strategy from now on:")
    lines.append("* Increasing the percentage for index ETF (Try not to take too much risk)")
    lines.append("* Keep watching every business day for high risk stocks")
    lines.append("")
    lines.append("(Auto-generated by generate_monthly_report.py)")
    lines.append(f"(Two-months-ago reference: {two_ago_yyyymm if two_ago else 'not available'})")

    return "\n".join(lines)

# ── main ───────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) > 1:
        yyyymm = sys.argv[1]
    else:
        yyyymm = date.today().strftime("%Y%m")

    prev_yyyymm     = prev_month(yyyymm)
    two_ago_yyyymm  = prev_month(prev_yyyymm)

    print(f"\nGenerating report for: {yyyymm}")
    print(f"  Comparing against:   {prev_yyyymm}")
    print(f"  Two months ago:      {two_ago_yyyymm} (used to detect newly purchased stocks)")

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        print("\nERROR: ANTHROPIC_API_KEY environment variable not set.")
        print("  Set it with:  $env:ANTHROPIC_API_KEY = 'your-key-here'")
        sys.exit(1)

    client = anthropic.Anthropic(api_key=api_key)

    print("\n[1/4] Extracting portfolio data from screenshots...")
    current  = get_portfolio(yyyymm, client)
    previous = get_portfolio(prev_yyyymm, client)
    two_ago  = get_portfolio(two_ago_yyyymm, client)

    if not current:
        print(f"ERROR: No data found for {yyyymm}. Add screenshots to {month_dir(yyyymm)}/")
        sys.exit(1)
    if not previous:
        print(f"ERROR: No data found for {prev_yyyymm}.")
        sys.exit(1)

    user_comments = load_comments(month_dir(yyyymm))
    if user_comments:
        print(f"  Found comments.txt — will include in report")

    print("\n[2/4] Generating narrative commentary with web search...")
    commentary = generate_narrative_commentary(current, previous, two_ago, yyyymm, client, user_comments)

    print("\n[3/5] Generating comparison report...")
    report_text = generate_report_text(current, previous, two_ago, yyyymm, commentary, user_comments)

    # name the file after the screenshot date if detectable
    screenshots = find_screenshots(month_dir(yyyymm))
    date_tag = yyyymm + "01"
    for p in screenshots:
        m = re.search(r"(\d{4}-\d{2}-\d{2})", p.name)
        if m:
            date_tag = m.group(1).replace("-", "")
            break

    report_path = month_dir(yyyymm) / f"report_{date_tag}_auto.txt"
    report_path.write_text(report_text, encoding="utf-8")
    print(f"  Report saved -> {report_path.name}")

    print("\n[4/5] Generating PDF...")
    result = subprocess.run(
        ["python", str(PDF_SCRIPT), str(report_path)],
        capture_output=True, text=True
    )
    if result.returncode == 0:
        print(f"  {result.stdout.strip()}")
    else:
        print(f"  PDF generation failed:\n{result.stderr}")

    print(f"\n[5/5] Done! Files in {month_dir(yyyymm).name}/:")
    for f in sorted(month_dir(yyyymm).iterdir()):
        print(f"  {f.name}")


if __name__ == "__main__":
    main()

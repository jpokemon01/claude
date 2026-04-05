import re
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
)
from reportlab.lib.enums import TA_LEFT

MD_PATH = r"c:/Users/Takeo Inoue/Documents/GITHUB/claude/business_processing/japan_brazil_import_guide.md"
PDF_PATH = r"c:/Users/Takeo Inoue/Documents/GITHUB/claude/business_processing/japan_brazil_import_guide.pdf"

BLUE = colors.HexColor("#2563eb")
LIGHT_BLUE = colors.HexColor("#eff6ff")
GRAY = colors.HexColor("#374151")
LIGHT_GRAY = colors.HexColor("#f3f4f6")
BORDER = colors.HexColor("#d1d5db")

styles = getSampleStyleSheet()

H1 = ParagraphStyle("H1", parent=styles["Normal"], fontSize=18, textColor=BLUE,
                    spaceAfter=6, spaceBefore=12, fontName="Helvetica-Bold")
H2 = ParagraphStyle("H2", parent=styles["Normal"], fontSize=13, textColor=BLUE,
                    spaceAfter=4, spaceBefore=14, fontName="Helvetica-Bold")
H3 = ParagraphStyle("H3", parent=styles["Normal"], fontSize=11, textColor=GRAY,
                    spaceAfter=3, spaceBefore=10, fontName="Helvetica-Bold")
BODY = ParagraphStyle("Body", parent=styles["Normal"], fontSize=9.5,
                      spaceAfter=4, leading=14, fontName="Helvetica")
BULLET = ParagraphStyle("Bullet", parent=BODY, leftIndent=14, bulletIndent=4)
ITALIC = ParagraphStyle("Italic", parent=BODY, fontSize=8.5,
                        textColor=colors.HexColor("#6b7280"), fontName="Helvetica-Oblique")

def inline_fmt(text):
    text = re.sub(r'\*\*(.+?)\*\*', r'<b>\1</b>', text)
    text = re.sub(r'`(.+?)`', r'<font face="Courier" size="8.5">\1</font>', text)
    text = re.sub(r'\*(.+?)\*', r'<i>\1</i>', text)
    return text

def parse_md(path):
    with open(path, encoding="utf-8") as f:
        lines = f.readlines()

    story = []
    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")

        # H1
        if line.startswith("# "):
            story.append(Paragraph(inline_fmt(line[2:]), H1))
            story.append(HRFlowable(width="100%", thickness=1.5, color=BLUE, spaceAfter=6))
            i += 1
        # H2
        elif line.startswith("## "):
            story.append(Spacer(1, 4))
            story.append(Paragraph(inline_fmt(line[3:]), H2))
            i += 1
        # H3
        elif line.startswith("### "):
            story.append(Paragraph(inline_fmt(line[4:]), H3))
            i += 1
        # HR
        elif line.strip() == "---":
            story.append(HRFlowable(width="100%", thickness=0.5, color=BORDER,
                                    spaceBefore=6, spaceAfter=6))
            i += 1
        # Table
        elif line.startswith("|"):
            table_lines = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                table_lines.append(lines[i].rstrip("\n"))
                i += 1
            rows = []
            for tl in table_lines:
                if re.match(r'^\|\s*[-:]+', tl):
                    continue
                cells = [c.strip() for c in tl.strip("|").split("|")]
                rows.append(cells)
            if rows:
                col_count = max(len(r) for r in rows)
                # pad rows
                rows = [r + [""] * (col_count - len(r)) for r in rows]
                # build paragraphs inside cells
                fmt_rows = []
                for ri, row in enumerate(rows):
                    style = ParagraphStyle("th" if ri == 0 else "td",
                                          parent=styles["Normal"],
                                          fontSize=8.5, leading=12,
                                          fontName="Helvetica-Bold" if ri == 0 else "Helvetica",
                                          textColor=colors.white if ri == 0 else colors.black)
                    fmt_rows.append([Paragraph(inline_fmt(c), style) for c in row])
                col_w = (A4[0] - 40*mm) / col_count
                t = Table(fmt_rows, colWidths=[col_w] * col_count, repeatRows=1)
                ts = TableStyle([
                    ("BACKGROUND", (0, 0), (-1, 0), BLUE),
                    ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, LIGHT_GRAY]),
                    ("GRID", (0, 0), (-1, -1), 0.4, BORDER),
                    ("VALIGN", (0, 0), (-1, -1), "TOP"),
                    ("TOPPADDING", (0, 0), (-1, -1), 4),
                    ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                    ("LEFTPADDING", (0, 0), (-1, -1), 6),
                    ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ])
                t.setStyle(ts)
                story.append(t)
                story.append(Spacer(1, 6))
        # Bullet
        elif line.startswith("- "):
            story.append(Paragraph("• " + inline_fmt(line[2:]), BULLET))
            i += 1
        # Italic/small (lines starting with *)
        elif line.startswith("*") and line.endswith("*") and not line.startswith("**"):
            story.append(Paragraph(line.strip("*"), ITALIC))
            i += 1
        # Empty line
        elif line.strip() == "":
            story.append(Spacer(1, 4))
            i += 1
        # Normal paragraph
        else:
            story.append(Paragraph(inline_fmt(line), BODY))
            i += 1

    return story

doc = SimpleDocTemplate(
    PDF_PATH, pagesize=A4,
    leftMargin=20*mm, rightMargin=20*mm,
    topMargin=20*mm, bottomMargin=20*mm
)
doc.build(parse_md(MD_PATH))
print("PDF created:", PDF_PATH)

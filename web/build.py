#!/usr/bin/env python3
"""Builds DWT_Lernskript.html from the Typst source plus web/style.css and web/app.js.

Also (re)compiles DWT_Skript.pdf from the same source in the same run — so the PDF
embedded as a download in the HTML is always built from the exact same content, never a
stale copy — and embeds it as a base64 data URI so the download button works from a single
file with no sibling PDF required, whether opened via file:// or served from a host.

Math is authored in native Typst and exported to inline MathML, which modern browsers
render with no JavaScript or web fonts — keeping the output a single self-contained file.

Usage: python3 web/build.py   (run from the repository root, or anywhere — paths are
resolved relative to this script's location)
"""
import base64
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "web"
SOURCE = ROOT / "DWT_Skript.typ"
OUTPUT = ROOT / "DWT_Lernskript.html"
PDF_OUTPUT = ROOT / "DWT_Skript.pdf"

BODY_TAG_RE = re.compile(r"<body[^>]*>(.*)</body>", re.DOTALL)


def compile_typst(output_path: Path, *extra_args: str) -> str:
    result = subprocess.run(
        ["typst", "compile", *extra_args, str(SOURCE), str(output_path)],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        raise SystemExit(f"typst compile failed with exit code {result.returncode}")
    return result.stderr


# Warnings Typst is expected to emit for THIS document during HTML export: the
# page/pagebreak/spacing constructs that only apply to the PDF path, plus the
# standing "HTML export is experimental" banner. Matching the SPECIFIC ignored
# construct (not the generic "was ignored" phrase) means a new kind of silently
# dropped element — a table, grid, figure, … that fails to export — still aborts
# the build instead of vanishing from the page unnoticed.
_EXPECTED_WARNINGS = (
    "html export is under active development",
    "page set rule was ignored during HTML export",
    "pagebreak was ignored during HTML export",
    "v was ignored during HTML export",
    "h was ignored during HTML export",
)


def compile_typst_html(tmp_path: Path) -> str:
    stderr = compile_typst(tmp_path, "--features", "html", "-f", "html")
    unexpected = [
        line
        for line in stderr.splitlines()
        if line.startswith("warning:")
        and not any(expected in line for expected in _EXPECTED_WARNINGS)
    ]
    if unexpected:
        sys.stderr.write("\n".join(unexpected) + "\n")
        raise SystemExit("typst compile produced unexpected warnings; see above")
    return tmp_path.read_text(encoding="utf-8")


def extract_body(html: str) -> str:
    match = BODY_TAG_RE.search(html)
    if not match:
        raise SystemExit("could not find <body>...</body> in Typst HTML output")
    return match.group(1)


def main() -> None:
    tmp_path = WEB / "_body.html"
    try:
        typst_html = compile_typst_html(tmp_path)
        body = extract_body(typst_html)
    finally:
        # Always remove the intermediate, even if compile/extract aborts, so a
        # failed build never leaves a stray _body.html behind in web/.
        tmp_path.unlink(missing_ok=True)

    compile_typst(PDF_OUTPUT)
    pdf_base64 = base64.b64encode(PDF_OUTPUT.read_bytes()).decode("ascii")

    shell = (WEB / "shell.html").read_text(encoding="utf-8")
    style = (WEB / "style.css").read_text(encoding="utf-8")
    script = (WEB / "app.js").read_text(encoding="utf-8")

    # Single-pass substitution over the shell only, so an injected value that
    # happens to contain another placeholder token is never rescanned/expanded
    # (order-independent, unlike chained str.replace). A function replacement
    # also means backslashes/base64 in the values are inserted literally.
    replacements = {
        "__TYPST_BODY__": body,
        "__STYLE__": style,
        "__SCRIPT__": script,
        "__PDF_BASE64__": pdf_base64,
    }
    token_re = re.compile("|".join(re.escape(token) for token in replacements))
    output = token_re.sub(lambda m: replacements[m.group(0)], shell)
    OUTPUT.write_text(output, encoding="utf-8")
    print(f"Wrote {OUTPUT} ({len(output):,} bytes, PDF embedded: {len(pdf_base64):,} base64 chars)")


if __name__ == "__main__":
    main()

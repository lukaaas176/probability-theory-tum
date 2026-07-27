# Probability Theory (DWT) — Lernskript

A compact study script for the *~~Discrete~~ Probability Theory* course (TUM, Summer Semester 2026, N. Kilbertus), covering the full curriculum from probability spaces and distributions through random variables, expectation and inequalities, convergence and limit theorems, up to statistical inference (estimation, testing, and the Bayesian view) — with a chapter-by-chapter quiz in exam style.

Not official course material — a supplementary study aid based on the lecture notes, the exercise sheets, and past exams. It doesn't replace attending the lecture.

## What's here

One [Typst](https://typst.app/) source (`DWT_Skript.typ` + `kapitel/*.typ` + `vorlage.typ`) builds two outputs from the same content, so they never drift out of sync:

- **PDF** — the print-ready script (`typst compile DWT_Skript.typ`).
- **Interactive HTML** — a single self-contained page (`python3 web/build.py`) with a chapter reader, a click-to-reveal quiz with self-rated recall tracking, a per-chapter reading-progress indicator, light/dark themes, and a PDF download embedded in the same file. Progress is stored in `localStorage` and mirrored into the page's own URL (bookmark or copy the link to keep a snapshot); nothing is sent anywhere — the whole thing runs offline via `file://` or from any static host.

**Math** is authored in native Typst and rendered as MathML in the browser — no JavaScript math library, no web fonts, nothing to load. The page stays a single self-contained file.

See `docs/superpowers/specs/2026-07-23-dwt-lernskript-design.md`, `PRODUCT.md`, and `DESIGN.md` for the design rationale.

## Building

Requires [Typst](https://typst.app/) (0.15.1) and Python 3.

```sh
# PDF only
typst compile DWT_Skript.typ DWT_Skript.pdf

# Interactive HTML (also rebuilds the PDF, so the embedded download stays in sync)
python3 web/build.py
```

## Deploying the HTML version (Cloudflare Workers)

`wrangler.toml` configures a static-assets Worker serving `dist/index.html`. `web/cloudflare-build.sh` installs Typst and runs the build for you, so a plain Git-connected deploy works:

1. Push this repo to GitHub.
2. In the Cloudflare dashboard, create a Worker → connect it to the GitHub repo.
3. Set **Build command** to `bash web/cloudflare-build.sh` and **Build output directory** to `dist` (mirrors `wrangler.toml`, but the dashboard fields are the more reliable source of truth for Git-connected builds).
4. Deploy. Every push to the connected branch rebuilds and redeploys.

To deploy manually instead: `npx wrangler login`, then `bash web/cloudflare-build.sh && npx wrangler deploy`.

## Acknowledgement

A heartfelt thank-you to Niki Kilbertus for the exceptional work invested in the lecture and the excellent official lecture notes. Those notes are a clear, comprehensive, self-contained resource and are fully sufficient for learning the course material. This supplementary script is not meant to replace them; it is simply an attempt to support learners who benefit from a more compact, chapter-oriented presentation with highlighted takeaways and quizzes.

## AI assistance and human review

This project was created with substantial AI assistance. The chapter material was summarized and structured from N. Kilbertus's lecture notes, the exercise sheets, and past exams. The current revision was prepared using **GPT-5.6 Sol via OpenCode**. The Typst dual PDF/HTML build system, the interactive HTML layer (`web/style.css`, `web/app.js`, `web/build.py`), and this README were also AI-assisted.

AI-generated summaries can omit important context, misstate definitions or results, and contain other errors. Humans subsequently reviewed the material and corrected the issues they identified, but human review does not guarantee completeness or correctness. This remains an unofficial supplementary study aid: when in doubt, consult the official course materials, which remain authoritative.

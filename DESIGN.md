---
name: Probability Theory Interactive Lernskript
description: A single self-contained HTML study companion to the Probability Theory Typst script — chapter reader plus self-rated quiz recall, with native-MathML equations.
---

# Design System: Probability Theory Interactive Lernskript

## 1. Overview

**Creative North Star: "The Quiet Study Guide"**

This system carries the printed Skript's own visual language into the browser rather than inventing a new one. The PDF establishes a restrained, functional palette and an academic serif tone; the web page inherits both. Density comes from the content itself — 16 chapters of dense probability and statistics — so the design gets out of the way: mostly neutral surfaces, color reserved strictly for the semantic roles it already carries in print, and motion that's felt rather than watched.

Because the deliverable is one self-contained HTML file meant to open via `file://` with zero setup, every typeface is a system font stack and mathematics renders as native **MathML** — no math library, no embedded fonts, nothing fetched. This system rejects gamified quiz-app conventions; the one deliberate exception is a one-off confetti burst on finishing a chapter's quiz, restricted to the app's own functional accent colors.

**Key Characteristics:**
- Restrained, functional color — the four accent hues never become decoration
- Serif headings + sans body, rooted in the PDF's academic type culture
- Native MathML for equations — correct, dependency-free, dark-mode-aware
- Single self-contained file, system fonts only, no embedding
- Dark mode as a first-class second palette, not a CSS inversion

## 2. Colors

Mostly neutral paper/ink surfaces so 16 dense chapters can be read for hours without fatigue; four functional accents carry the callout semantics unchanged from the printed Skript.

### Functional accents
- **Skript Blue** (#1d4e89): definitions, chapter/section headings, links, sidebar navigation.
- **Theorem Violet** (#6d28d9): theorems, lemmas, corollaries, propositions — the formal-results hue.
- **Solution Green** (#0f7a3d): revealed-answer accent, "know"/"sure" rating states.
- **Key-fact Orange** (#b5560a): Key-fact callouts, "again" rating state.

### Neutral
- Light-mode warm paper/ink pair and a dark-mode surface/ink pair, contrast-checked to WCAG AA. Examples and remarks use these neutrals (not a fifth hue), and proofs are subtler still.

### Named Rules
**The Functional-Only Rule.** Each accent appears only in its established semantic role (definition / theorem / solution / key fact) plus its natural UI extension (links, rating states, nav). Examples, remarks and proofs deliberately stay neutral to keep the color budget tight.

## 3. Typography

**Display/Heading Font:** Georgia, "Iowan Old Style", "Times New Roman", serif (system stack).
**Body Font:** system-ui, "Segoe UI", Helvetica, Arial, sans-serif (system stack).
**Math:** native MathML, styled to inherit the surrounding ink color; block equations get a horizontal scroll container so wide expressions never stretch the page.

### Named Rules
**The No-Embedded-Fonts Rule.** Every typeface is a system font stack; math is MathML, not an image or an embedded math font. If a font isn't guaranteed present on the reader's OS, it doesn't belong here.

## 4. Elevation

Flat by default — no drop shadows, consistent with the PDF's flat, print-native language. Depth is conveyed through background-color shifts and hairline borders.

## 5. Components

- **Callouts** — full 1px hairline border in the accent hue on all four sides, a subtle accent-tinted background, and a small non-stripe leading dot ahead of the title (definitions/theorems/key facts). Examples/remarks are neutral; proofs drop the dot and end with a trailing ∎.
- **Quiz** — reveal-answer button toggles a Solution-Green answer box; three self-rating buttons (again / know / sure) mirror confidence via fill strength within the existing hues.
- **Sidebar** — chapter list grouped by Part, with a per-chapter reading-progress bar and an "N/M questions" mastery count.

## 6. Do's and Don'ts

### Do:
- **Do** keep each accent in its established role — definitions blue, theorems violet, solutions green, key facts orange.
- **Do** keep examples, remarks and proofs neutral — the color budget is four functional hues, not six.
- **Do** let MathML inherit text color so equations read correctly in both light and dark themes.
- **Do** use only system font stacks — this file must open standalone via `file://`.

### Don't:
- **Don't** turn any accent into a decorative surface color.
- **Don't** add mascots, streak badges, or bright playful gradients.
- **Don't** use confetti anywhere except the single chapter-complete moment.
- **Don't** embed or `@font-face` any custom font, or pull in a client-side math library — breaks the single-file, zero-setup principle.

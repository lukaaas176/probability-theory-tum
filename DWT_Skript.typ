// Probability Theory — compact study script with chapter quizzes.
// Created as a study aid based on the lecture notes (N. Kilbertus, TUM,
// Summer Semester 2026), the exercise sheets and the past exams.

#set page(paper: "a4", margin: (x: 2.2cm, y: 2.5cm), numbering: "1", number-align: center)
#set text(lang: "en", size: 10.5pt)
#set par(justify: true, leading: 0.62em)
#set heading(numbering: "1.1")

// Math: numbering of displayed equations off; typeset natively in the PDF,
// emitted as MathML on HTML export (see vorlage.typ).
#set math.equation(numbering: none)

#import "vorlage.typ": *

#show heading.where(level: 1): it => {
  // Resets the chapter-local quiz-block counter at the start of every chapter
  // so quizid() values stay chapter-local (see blockcounter in vorlage.typ).
  // Also fires on part dividers (also level 1) — harmless.
  blockcounter.update(0)
  pagebreak(weak: true)
  v(0.4em)
  text(size: 19pt, weight: "bold", fill: rgb("#1d4e89"))[#it]
  v(0.6em)
}
#show heading.where(level: 2): it => {
  v(0.6em)
  text(size: 13.5pt, weight: "bold", fill: rgb("#1d4e89"))[#it]
  v(0.2em)
}
#show heading.where(level: 3): it => {
  text(size: 11.5pt, weight: "bold", style: "italic")[#it]
}
#show link: it => text(fill: rgb("#1d4e89"), it)

// ==================== Title page ====================
// Typst's HTML export discards the entire content of #align() blocks (not just
// the alignment), so a dedicated HTML branch without align() is used here;
// centering is handled by the CSS in the web build instead.
#context {
  if target() == "html" {
    html.elem("header", attrs: (class: "titlepage"))[
      #html.elem("h1", attrs: (class: "title"))[#html.elem("s")[Discrete] Probability Theory]
      #html.elem("p", attrs: (class: "subtitle"))[Technical University of Munich · Summer Semester 2026 · Niki Kilbertus]
      #html.elem("p", attrs: (class: "tagline"))[Compact study script to work through, with exam-style chapter quizzes]
      #html.elem("p", attrs: (class: "disclaimer"))[
        Based on the lecture notes for #emph[Probability Theory] (N. Kilbertus, TUM), the
        exercise sheets and the past exams. Not official course material — a supplementary
        study aid that does not replace attending the lecture.
      ]
    ]
  } else {
    align(center)[
      #v(2.8cm)
      #text(size: 24pt, weight: "bold")[#strike[Discrete] Probability Theory]
      #v(0.3cm)
      #text(size: 13pt)[Technical University of Munich · Summer Semester 2026 · Niki Kilbertus]
      #v(1.2cm)
      #line(length: 40%, stroke: 1pt + accent)
      #v(1.2cm)
      #text(size: 13pt, style: "italic")[Compact study script to work through \ with exam-style chapter quizzes]
      #v(3.5cm)
      #text(size: 10pt, fill: gray)[
        Based on the lecture notes for #emph[Probability Theory] (N. Kilbertus, TUM), \
        the exercise sheets and the past exams. Not official course material — \
        a supplementary study aid that does not replace attending the lecture.
      ]
    ]
  }
}

#pagebreak()

#heading(level: 2, numbering: none)[How to use this script]

This script condenses the material of the #emph[Probability Theory] lecture into 16 chapters,
grouped into four parts. It follows the structure of the official lecture notes but presents the
material compactly and with an eye on the exam.

The colored boxes have fixed meanings:
- Blue boxes are #emph[definitions] — the exact notions with which everything else is phrased.
- Violet boxes are #emph[theorems, lemmas and corollaries] — the central statements, often with a short proof.
- Grey boxes are #emph[examples] and #emph[remarks] — they make the theory concrete.
- Orange boxes (#emph[Key fact]) highlight the core statements typically needed in exams.
- Green boxes contain the #emph[quiz solutions] — reveal them only after your own attempt.

Recommended approach per chapter:
+ Read the text once end to end to get the overall thread.
+ Work through definitions and theorems precisely; for every theorem, ask #emph[why] it holds.
+ At the end of each chapter, do the #emph[quiz] #emph[before] reading the green solution boxes. The
  questions are phrased in the style of real exam and exercise problems.
+ When unsure, reread the relevant section and repeat the question a few days later (spaced repetition).

#pagebreak()
// In the web build a JS-generated sidebar handles navigation (see web/); Typst's
// own outline() is not needed there.
#context if target() != "html" {
  outline(indent: auto, title: "Contents")
}

// ==================== Part I: Foundations of probability ====================
#part("I", "Foundations of probability", "Probability spaces, distributions, random variables, independence and conditional probability")

#include "kapitel/01_what_is_probability.typ"
#include "kapitel/02_probability_spaces.typ"
#include "kapitel/03_discrete_distributions.typ"
#include "kapitel/04_continuous_and_random_variables.typ"
#include "kapitel/05_independence_conditional.typ"

// ==================== Part II: Working with distributions ====================
#part("II", "Working with distributions", "Expectation, variance, probability inequalities, transformations and limit theorems")

#include "kapitel/06_expectation_variance.typ"
#include "kapitel/07_inequalities.typ"
#include "kapitel/08_computations.typ"
#include "kapitel/09_convergence_limit_theorems.typ"

// ==================== Part III: Statistical inference ====================
#part("III", "Statistical inference", "Statistical models, point estimation, hypothesis testing, interval estimation and the Bayesian view")

#include "kapitel/10_statistical_models.typ"
#include "kapitel/11_point_estimation.typ"
#include "kapitel/12_hypothesis_testing.typ"
#include "kapitel/13_interval_estimation.typ"
#include "kapitel/14_bayesian_frequentist.typ"

// ==================== Part IV: Reference & exam prep ====================
#part("IV", "Reference & exam prep", "A distribution reference sheet and exam training with past exams")

#include "kapitel/15_distribution_reference.typ"
#include "kapitel/16_exam_training.typ"

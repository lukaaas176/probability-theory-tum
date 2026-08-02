// Shared template: colors, math environments, callout boxes and quiz functions.
// Imported by DWT_Skript.typ and by every chapter file.
//
// Each function below branches via `target()` between the PDF path (colored
// boxes via block()) and an HTML path emitting class-tagged <div>/<p> elements
// via html.elem(). Typst silently drops style properties (fill, size, ...) on
// HTML export anyway; the entire visual system of the web version comes from
// the separate CSS instead (see web/style.css). Math is typeset natively in
// Typst and emitted as MathML on HTML export, which modern browsers render with
// no extra JavaScript or fonts.
//
// NOTE: the emitted HTML class names (callout-definition, callout-satz,
// callout-beweis, callout-beispiel, callout-bemerkung, callout-merke, quiz-*,
// teil-desc) are intentionally kept identical to the sibling LinAlg project so
// that web/style.css and web/app.js port over unchanged. The Typst function
// names are English; the class strings are a stable web contract, not prose.

#let blue = rgb("#1d4e89")     // Blue:   definitions, headings, links
#let accent2 = rgb("#0f7a3d")  // Green:  solutions (quiz)
#let accent3 = rgb("#b5560a")  // Orange: key facts
#let accent4 = rgb("#6d28d9")  // Violet: theorems, lemmas, corollaries, propositions

// -------------------- Definition (blue) --------------------
#let definition(title: none, body) = context {
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-definition"))[
      #if title != none [#html.elem("strong", attrs: (class: "callout-title"))[#title]]
      #body
    ]
  } else {
    block(
      fill: rgb("#eef4fb"),
      stroke: (left: 3pt + blue),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[#if title != none [*#title* #linebreak()] #body]
  }
}

// -------------------- Theorem / Lemma / Corollary / Proposition (violet) --------------------
// `name` is an optional byname (e.g. "Bayes") shown as "Theorem (Bayes)". All
// result boxes share the violet HTML class `callout-satz`; the kind lives in
// the title text.
#let _resultat(kind, name, body) = context {
  let titel = if name != none { kind + " (" + name + ")" } else { kind }
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-satz"))[
      #html.elem("strong", attrs: (class: "callout-title"))[#titel]
      #body
    ]
  } else {
    block(
      fill: rgb("#f4effb"),
      stroke: (left: 3pt + accent4),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[*#titel.* #body]
  }
}

#let theorem(name: none, body) = _resultat("Theorem", name, body)
#let lemma(name: none, body) = _resultat("Lemma", name, body)
#let corollary(name: none, body) = _resultat("Corollary", name, body)
#let proposition(name: none, body) = _resultat("Proposition", name, body)

// -------------------- Proof (subtle, with ∎) --------------------
#let proof(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-beweis"))[
      #html.elem("strong", attrs: (class: "callout-title"))[Proof.]
      #body
      #html.elem("span", attrs: (class: "qed"))[∎]
    ]
  } else {
    block(
      width: 100%,
      breakable: true,
      inset: (left: 9pt, top: 4pt, bottom: 4pt),
      stroke: (left: 1.5pt + gray),
    )[#text(style: "italic")[Proof.] #body #h(1fr) ∎]
  }
}

// -------------------- Example / Remark (neutral) --------------------
#let example(title: none, body) = context {
  let titel = if title != none { "Example (" + title + ")" } else { "Example" }
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-beispiel"))[
      #html.elem("strong", attrs: (class: "callout-title"))[#titel]
      #body
    ]
  } else {
    block(
      fill: rgb("#f3f2ef"),
      stroke: (left: 3pt + rgb("#8f8578")),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[*#titel.* #body]
  }
}

#let remark(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-bemerkung"))[
      #html.elem("strong", attrs: (class: "callout-title"))[Remark.]
      #body
    ]
  } else {
    block(
      fill: rgb("#f3f2ef"),
      stroke: (left: 3pt + rgb("#8f8578")),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[*Remark.* #body]
  }
}

// -------------------- Key fact (orange) --------------------
#let keyfact(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (class: "callout callout-merke"))[
      #html.elem("strong", attrs: (class: "callout-title"))[Key fact:]
      #body
    ]
  } else {
    block(
      fill: rgb("#fff6e5"),
      stroke: (left: 3pt + accent3),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[*Key fact:* #body]
  }
}

// -------------------- Quiz --------------------
#let qcounter = counter("quiz")
#let quizstart() = qcounter.update(0)

// Counts quiz and exam blocks within a chapter. Reset to 0 at the start of every
// chapter by the level-1 heading show rule in DWT_Skript.typ so that quizid()
// values stay chapter-local: adding a quiz block in one chapter no longer
// shifts the IDs (and stored progress) of later chapters. Needed because a
// single chapter (e.g. exam training) may contain several blocks,
// each restarting its own question numbering (qcounter) — without this second
// counter two blocks in the same chapter would produce identical quizid()s.
#let blockcounter = counter("quizblockindex")

// Stable question id "ch<chapter>-b<blockindex>-q<questionindex>", e.g. "ch2-b3-q1".
// Based on Typst's own heading counter and blockcounter (not a global question
// counter) so inserting/removing questions in one chapter doesn't shift the IDs
// of other chapters.
#let quizid(question: none) = {
  let chnum = counter(heading).at(here()).first()
  let blockidx = blockcounter.at(here()).first()
  let questionidx = if question == none { str(qcounter.display()) } else { str(question) }
  "ch" + str(chnum) + "-b" + str(blockidx) + "-q" + questionidx
}

#let question(q) = {
  qcounter.step()
  context {
    if target() == "html" {
      html.elem("p", attrs: (class: "quiz-question", "data-qid": quizid()))[*Question #qcounter.display():* #q]
    } else {
      block(above: 0.9em, below: 0.35em, breakable: true)[*Question #qcounter.display():* #q]
    }
  }
}

#let answer(body, qid: none) = context {
  let answerid = if qid == none { quizid() } else { qid }
  if target() == "html" {
    html.elem("div", attrs: (class: "quiz-answer", "data-qid": answerid))[*Solution:* #body]
  } else {
    block(
      fill: rgb("#eafbee"),
      stroke: (left: 3pt + accent2),
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      breakable: true,
    )[*Solution:* #body]
  }
}

#let subquestions(..items) = context {
  let rows = items.pos()
  if target() == "html" {
    html.elem("span", attrs: (class: "quiz-subquestions"))[
      #for item in rows {
        html.elem("span", attrs: (class: "quiz-subquestion"))[#item]
      }
    ]
  } else {
    block(above: 0.45em, below: 0.2em)[
      #stack(dir: ttb, spacing: 0.45em, ..rows)
    ]
  }
}

#let quizblock(title: "Quiz", body) = {
  quizstart()
  blockcounter.step()
  context {
    let chnum = counter(heading).at(here()).first()
    if target() == "html" {
      html.elem("section", attrs: (class: "quiz-section", "data-chapter": str(chnum)))[
        == #title
        #body
      ]
    } else {
      block(breakable: true)[
        #v(0.4em)
        #line(length: 100%, stroke: 0.6pt + gray)
        == #title
        #body
      ]
    }
  }
}

#let examblock(title: "Exam", problems) = {
  quizstart()
  blockcounter.step()
  context {
    let chnum = counter(heading).at(here()).first()
    let exambody = [
      == #title
      #for problem in problems {
        question(problem.question)
      }
      #if target() == "html" {
        html.elem("div", attrs: (class: "quiz-solutions"))[
          === Solutions
          #for (index, problem) in problems.enumerate() {
            answer(
              [*Question #(index + 1).* #problem.solution],
              qid: quizid(question: index + 1),
            )
          }
        ]
      } else {
        [
          === Solutions
          #for (index, problem) in problems.enumerate() {
            answer(
              [*Question #(index + 1).* #problem.solution],
              qid: quizid(question: index + 1),
            )
          }
        ]
      }
    ]
    if target() == "html" {
      html.elem("section", attrs: (class: "quiz-section", "data-chapter": str(chnum)))[#exambody]
    } else {
      block(breakable: true)[
        #v(0.4em)
        #line(length: 100%, stroke: 0.6pt + gray)
        #exambody
      ]
    }
  }
}

// -------------------- Part divider --------------------
#let part(nr, title, desc) = {
  pagebreak(weak: true)
  heading(numbering: none, outlined: true)[#text(fill: blue)[Part #nr — #title]]
  context {
    if target() == "html" {
      html.elem("p", attrs: (class: "teil-desc"))[#desc]
    } else {
      text(style: "italic", size: 10.5pt)[#desc]
    }
  }
  v(0.5em)
}

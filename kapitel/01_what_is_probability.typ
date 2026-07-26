#import "../vorlage.typ": *

= What is probability?

"What is probability?" has occupied scholars for centuries. This course does not try to settle the philosophical debate; instead it builds the mathematical machinery with which we can talk about — and compute with — probability in a consistent, quantitative way. The name of the course still contains the word #emph[discrete], but that word is struck through on purpose: computer science was once thought of as inherently discrete, but randomized algorithms, machine learning and AI have made #emph[continuous] probability just as important, so this course covers both.

== A very short history

Although gambling is thousands of years old, modern probability is usually traced to a 1654 correspondence between Blaise Pascal and Pierre de Fermat about the #emph[problem of points] (how to split the stakes of an interrupted game of chance fairly). Pierre-Simon Laplace's 1812 #emph[Théorie analytique des probabilités] unified much of the early theory, and in 1933 Andrey Kolmogorov gave probability the axiomatic foundation we still use today — and which the next chapters build on.

== Where does randomness come from?

Before formalizing anything, it is worth asking what the "randomness" in our models actually refers to. It has several quite different sources.

#remark[
Different situations locate randomness in different places:
- #emph[Physical mechanism.] Tossing a coin, spinning a roulette wheel, blindly drawing a card. We assume the mechanism makes certain outcomes equally likely — yet if we knew the exact forces and initial conditions, the result would be perfectly determined.
- #emph[Ignorance about a fixed system.] A doctor asked "what is the probability this coma patient wakes up?" faces no random mechanism at all; the uncertainty is about a fixed but unknown state of the world.
- #emph[Subjective / collective belief.] A prediction market price aggregates many people's (biased) beliefs into a single number.
- #emph[Quantum mechanics.] Often invoked as a source of "true" randomness: individual measurement outcomes cannot be predicted, even though the probabilities of the outcomes can.
]

#example(title: "which sequences are random?")[
Consider the digit sequences `2849607135` and `0868308472`. One was produced by a human-prompted language model, the other by a seeded pseudo-random number generator. Neither is "random" in any absolute sense: once the seed (or the model weights and prompt) is fixed, the output is fully determined. Randomness is not a property we can read off a finished sequence — it is a statement about our knowledge of how the sequence was produced.
]

== What our models actually express

The examples above suggest a unifying view: a probability is never attached to an event #emph[in the abstract], but always relative to a state of knowledge.

#keyfact[
There is no probability of something happening #emph[per se] — only a probability of something happening #emph[given what we currently know]. Probabilities encode uncertainty or ignorance about certain aspects of a system, expressed consistently and quantitatively #emph[before] observation. Assigning a probability model is therefore a modeling choice, not a physical measurement.
]

#remark[
One is tempted to conclude that if only we knew enough about the underlying mechanism, nothing would be "truly" random and all uncertainty could be banished — though the quantum-mechanics bullet above is a reminder that even complete knowledge may not remove all randomness. The view that the universe is fully determined by its state is called #emph[determinism]. In practice we never have that complete knowledge, so we encode our ignorance with probabilities regardless — which is exactly what the rest of this course makes precise, starting with Kolmogorov's axioms in Chapter 2.
]

Chapter 2 turns these intuitions into mathematics: a #emph[probability space], the triple that pins down what the possible outcomes are, which events we can assign probabilities to, and how those probabilities behave.

#quizblock(title: "Quiz — What is probability?")[
#question[According to the course's guiding view, why is it imprecise to ask "what is the probability that event $A$ happens?" without qualification?]
#answer[Because a probability is always relative to a state of knowledge: there is no probability of something happening #emph[per se], only a probability given what we currently know. A probability model encodes our uncertainty about a system, so the assignment depends on the information we condition on.]

#question[Name three distinct sources that the "randomness" in a probability model can refer to.]
#answer[Any three of: (i) a physical mechanism assumed to make outcomes equally likely (coin toss, card draw); (ii) ignorance about a fixed but unknown state of the world (the coma-patient question); (iii) subjective or collective belief (a prediction-market price); (iv) genuine quantum indeterminacy of measurement outcomes.]

#question[A friend shows you the sequence `0868308472` and asks whether it is "random". What is the right thing to say?]
#answer[Randomness is not a property of the finished sequence but of our knowledge about how it was generated. If it came from a pseudo-random generator with a known seed (or a language model with known weights/prompt), it is fully deterministic; without that knowledge it may serve as "random" for practical purposes. So the answer depends on what is known about its origin, not on the digits themselves.]

#question[What does #emph[determinism] claim, and why do we still use probabilities even if it were true?]
#answer[Determinism claims the universe's future is fully fixed by its present state (up to quantum effects). Even so, we almost never possess that complete knowledge, so in practice we cannot banish uncertainty — we encode our ignorance with probabilities, which is what the mathematical theory formalizes.]

#question[Who gave probability theory its modern axiomatic foundation, and in what year?]
#answer[Andrey Kolmogorov, in 1933. His axioms (a sample space, a $sigma$-algebra of events, and a normalized, countably additive measure) are the basis for the probability spaces introduced in the next chapter.]
]

#import "../vorlage.typ": *

= Probability spaces

Chapter 1 argued informally that every probabilistic model rests on three ingredients: the outcomes we care about, the events to which we want to assign probabilities, and the rule that assigns those probabilities. Kolmogorov's 1933 axiomatization packages these three ingredients into a single object, the #emph[probability space]
$
(Omega, cal(A), PP),
$
a triple consisting of a sample space $Omega$, a $sigma$-algebra $cal(A)$ of events, and a probability measure $PP$. This chapter defines each component precisely and derives the computation rules that every probability obeys. The pay-off is uniformity: this three-part language covers finite, countably infinite and uncountable models with #emph[the same] definitions, so we never have to start over when we leave the comfort of finite outcome spaces.

== The sample space and outcomes

#definition(title: "Sample space, outcome")[
The *sample space* (or *outcome space*) $Omega$ is the set of all possible *outcomes* of the random experiment we wish to model. A single element $omega in Omega$ is called an *outcome* or *sample*. By convention $Omega$ is always assumed to be *non-empty*.
]

The sample space is a #emph[modelling choice]: we deliberately let $Omega$ contain only "the outcomes we care about", and no more. Two experiments with the same physical apparatus may be described by very different sample spaces depending on the question we ask.

#example(title: "a deck of cards")[
Drawing one card from a well-shuffled $52$-card deck is naturally modelled by a sample space with $|Omega| = 52$, one outcome per card. If instead only the value of the card matters and the suit is irrelevant, we would rather choose $Omega = {2, 3, dots, 10, J, Q, K, A}$ with $|Omega| = 13$ — even though nothing about the physical drawing has changed. Neither the table the card lands on nor which corner it was picked up at is part of $Omega$: those are aspects of the experiment we choose not to care about.
]

#example(title: "countably infinite and uncountable spaces")[
Reshuffling after every draw and asking #emph[how many draws until the ace of hearts appears] gives a countably infinite space $Omega = NN_(>0) = {1, 2, 3, dots}$. Asking #emph[at what time in the next hour a bus arrives] gives an uncountable space $Omega = [0, 1]$. The abstract machinery below is designed precisely so that all three cases — finite, countably infinite, uncountable — are treated identically.
]

== Events

For a finite or countable sample space, "the probability of drawing a King" is not the probability of a single outcome but of a whole #emph[collection] of outcomes (the four kings). Such a collection is a subset of the sample space and is a candidate event; once an event space is fixed, its admitted subsets are the events to which probabilities may be assigned.

#definition(title: "Candidate and admitted events")[
A *candidate event* is a subset $A subset.eq Omega$. Once a measurable space $(Omega, cal(A))$ is fixed, an *(admitted) event* is a member $A in cal(A)$. For finite and countable spaces we commonly choose $cal(A)=cal(P)(Omega)$, in which case every candidate event is admitted. An outcome $omega$ #emph[realizes] $A$ if $omega in A$. A singleton ${omega}$ is an *elementary candidate event*; when admitted, it is an elementary event. The whole space $Omega$ is the *certain event* and the empty set $emptyset$ is the *impossible event*.
]

Logical statements about outcomes translate directly into set operations on events — this dictionary is used constantly and worth memorizing:

- "$A$ occurs" corresponds to the observed outcome satisfying $omega in A$;
- "$A$ *and* $B$ occur" corresponds to $A inter B$;
- "$A$ *or* $B$ occurs" corresponds to $A union B$;
- "$A$ does *not* occur" corresponds to the complement $A^c = Omega backslash A$;
- "$A$ but not $B$" corresponds to $A backslash B$;
- "$A$ and $B$ are *mutually exclusive* (cannot co-occur)" corresponds to $A inter B = emptyset$.

Note the three-level hierarchy that will run through the whole theory: an *outcome* $omega$ is an element of $Omega$; a *candidate event* $A$ is an element of the power set $cal(P)(Omega)$; and the collection $cal(A)$ of #emph[admitted events] is a subset of $cal(P)(Omega)$, with an event satisfying $A in cal(A)$.

#definition(title: "Set-theory notation (recap)")[
We collect the notation used throughout the course, condensed here for quick reference.
- The *power set* $cal(P)(Omega) := { A : A subset.eq Omega }$ is the set of all subsets of $Omega$ (also written $2^Omega$).
- For $A, B subset.eq Omega$ the *relative complement* is $A backslash B := { omega in Omega : omega in A "and" omega in.not B }$, and the *complement* of $A$ is $A^c := Omega backslash A$.
- *Intersection* $A inter B := { omega : omega in A "and" omega in B }$ and *union* $A union B := { omega : omega in A "or" omega in B }$; the sets are *disjoint* if $A inter B = emptyset$. A disjoint union is sometimes stressed by writing $A union.plus B$.
- For a family $(A_i)_(i in NN)$ we write $union.big_(i in NN) A_i = { omega : exists i in NN "with" omega in A_i }$ and $inter.big_(i in NN) A_i = { omega : forall i in NN, omega in A_i }$; this extends verbatim to an arbitrary index set $I$.
- $subset.eq$ denotes "subset" (equality allowed) and $subset.neq$ "proper subset" (equality not allowed). We write $[n] := {1, dots, n}$.
- Throughout, $NN = {0, 1, 2, dots}$, i.e. $0$ #emph[is] a natural number, and $NN_(>0) = {1, 2, dots}$.
]

#lemma(name: "de Morgan's laws")[
For any family $(A_i)_(i in I)$ of subsets of $Omega$,
$
(union.big_(i in I) A_i)^c = inter.big_(i in I) A_i^c
quad quad "and" quad quad
(inter.big_(i in I) A_i)^c = union.big_(i in I) A_i^c .
$
]

These laws let us trade unions for intersections (and back) whenever we complement — the reason closure under complements and countable unions will automatically give closure under countable intersections below.

== $sigma$-algebras

For finite and countable sample spaces we happily used the full power set $cal(P)(Omega)$ as our collection of events: every subset could be assigned a probability. In the uncountable world this breaks down.

#remark[
Suppose $Omega = [0, 1]$ and we want a "uniform" $PP$ with $PP([a, b]) = b - a$. Vitali's construction shows that #emph[no] such $PP$ can be defined on #emph[all] of $cal(P)([0, 1])$ while also being non-negative, normalized, countably additive and translation invariant: there exist pathological *non-measurable sets* to which no consistent "length" can be assigned. The fix is pragmatic: restrict attention to a smaller — but still very rich — collection of "well-behaved" subsets. That collection is a $sigma$-algebra.
]

#definition(title: [$sigma$-algebra])[
A collection $cal(A) subset.eq cal(P)(Omega)$ is a *$sigma$-algebra on $Omega$* if
+ $Omega in cal(A)$;
+ it is closed under complements: $A in cal(A) => A^c in cal(A)$;
+ it is closed under countable unions: for every sequence $(A_i)_(i in NN)$ in $cal(A)$ we have $union.big_(i in NN) A_i in cal(A)$.
]

The three axioms are exactly what is needed so that the set operations we perform on events never lead us out of the admitted collection.

#corollary(name: [$sigma$-algebras are closed under set operations])[
Let $cal(A)$ be a $sigma$-algebra on $Omega$ and $A, B in cal(A)$. Then
$
emptyset in cal(A), quad A union B in cal(A), quad A inter B in cal(A), quad A backslash B in cal(A), quad A triangle B in cal(A),
$
and for any countable family $(A_i)_(i in NN)$ in $cal(A)$ also $inter.big_(i in NN) A_i in cal(A)$.
]

#proof[
Since $Omega in cal(A)$, complementation gives $emptyset = Omega^c in cal(A)$. Finite unions are countable unions with all but finitely many sets equal to $emptyset$, so $A union B in cal(A)$. Countable intersections follow from de Morgan: $inter.big_i A_i = (union.big_i A_i^c)^c in cal(A)$, since each $A_i^c in cal(A)$, their union is in $cal(A)$, and so is its complement; as with finite unions, padding a two-set family with $Omega$ (the neutral element for intersection) gives the finite case $A inter B in cal(A)$. Finally $A backslash B = A inter B^c in cal(A)$, and the *symmetric difference* $A triangle B := (A backslash B) union (B backslash A)$ is measurable by the preceding closure properties.
]

#example(title: [$sigma$-algebras])[
On any $Omega$:
- ${emptyset, Omega}$ is the smallest $sigma$-algebra, the *trivial $sigma$-algebra*.
- The power set $cal(P)(Omega)$ is the largest $sigma$-algebra. For finite or countable $Omega$ this is the standard choice.
- For a single event $A subset.eq Omega$, the smallest $sigma$-algebra containing $A$ is ${emptyset, Omega, A, A^c}$ (in the notation introduced below, $sigma({A})$).
]

How do we build a $sigma$-algebra containing some desired events without listing everything by hand? We intersect all candidates.

#proposition(name: [intersection of $sigma$-algebras])[
Let $I$ be a non-empty index set (finite, countable or uncountable) and let $cal(A)_alpha$ be a $sigma$-algebra on $Omega$ for every $alpha in I$. Then the intersection $inter.big_(alpha in I) cal(A)_alpha$ is again a $sigma$-algebra on $Omega$.
]

#lemma(name: [generated $sigma$-algebra])[
For any system of subsets $cal(E) subset.eq cal(P)(Omega)$,
$
sigma(cal(E)) := inter.big { cal(A) : cal(A) "is a" sigma"-algebra on" Omega "with" cal(E) subset.eq cal(A) }
$
is the *smallest* $sigma$-algebra on $Omega$ containing $cal(E)$. We call $cal(E)$ a *generator* of $sigma(cal(E))$, and $sigma(cal(E))$ the *$sigma$-algebra generated by $cal(E)$*.
]

The intersection is well defined because $cal(P)(Omega)$ is always one such $sigma$-algebra, so we intersect a non-empty family, which by the previous proposition is a $sigma$-algebra; being an intersection, it is contained in every member and hence smallest.

The single most important generated $sigma$-algebra is the one we use on $RR^n$.

#definition(title: [Borel $sigma$-algebra])[
Let $Omega = RR^n$ for some $n in NN_(>0)$. The $sigma$-algebra generated by the open boxes
$
cal(B)^n := sigma( { (a_1, b_1) times dots times (a_n, b_n) : a_i < b_i "for all" i in [n] } )
$
is called the *Borel $sigma$-algebra on $RR^n$*. For $n = 1$ we simply write $cal(B)$.
]

#remark[
Equivalently $cal(B)^n = sigma(cal(O)^n)$, the $sigma$-algebra generated by the open sets (the standard topology). The same $cal(B)^n$ is obtained from many other generators — half-open boxes with rational endpoints, closed sets, compact sets, and so on. Crucially $cal(B)^n$ contains the standard sets used throughout this course (including all open, closed and countable sets) yet is strictly smaller than $cal(P)(RR^n)$. Larger useful $sigma$-algebras exist, but the Borel sets are sufficient for this course.
]

#lemma(name: [induced $sigma$-algebra])[
Let $(Omega, cal(A))$ be a measurable space and let $B subset.eq Omega$ be non-empty. Then
$
cal(A)|_B := {A inter B : A in cal(A)}
$
is a $sigma$-algebra on $B$, called the *induced $sigma$-algebra*, *trace $sigma$-algebra*, or *restriction of $cal(A)$ to $B$*. If $cal(E) subset.eq cal(P)(Omega)$, then $sigma(cal(E))|_B = sigma({E inter B : E in cal(E)})$. Thus a subset $B subset.eq RR^n$ is equipped by course convention with the restricted Borel $sigma$-algebra $cal(B)^n|_B$.
]

== Measurable spaces

A sample space together with an admissible collection of events already deserves a name, even before any probabilities are assigned.

#definition(title: "Measurable space, measurable set")[
A *measurable space* is a pair $(Omega, cal(A))$ where $Omega$ is a set and $cal(A)$ is a $sigma$-algebra on $Omega$. The elements of $cal(A)$ are called *measurable sets*.
]

#remark[
The word "measurable" signals the goal: to *measure* the size of subsets in a rigorous way. We have a firm intuition for measuring the length of subsets of $RR$, the area of subsets of $RR^2$, and the volume of subsets of $RR^3$; the abstract framework makes this precise even for corner cases (what "length" should a single point, or a wild uncountable set, have?). Probability will be one such notion of size. By course convention, continuous spaces $Omega subset.eq RR^n$ are equipped with the (restricted) Borel $sigma$-algebra and countable spaces with their full power set.
]

== Probability measures and the Kolmogorov axioms

A #emph[measure] assigns a non-negative "size" to every measurable set, additively over disjoint pieces.

#definition(title: "Measure, measure space")[
Let $(Omega, cal(A))$ be a measurable space. A map $mu : cal(A) -> [0, oo]$ is a *measure* if
+ $mu(emptyset) = 0$;
+ *non-negativity*: $mu(A) >= 0$ for all $A in cal(A)$;
+ *$sigma$-additivity*: for every countable family $(A_i)_(i in NN)$ of #emph[pairwise disjoint] sets in $cal(A)$,
  $
  mu(union.big_(i in NN) A_i) = sum_(i in NN) mu(A_i) .
  $
The triple $(Omega, cal(A), mu)$ is then a *measure space*.
]

#remark[
$sigma$-additivity is required only for #emph[countable] disjoint families; for uncountable families the sum is not even well defined. For instance, each singleton ${x} subset.eq [0, 1]$ has length $0$, yet the uncountable union $union.big_(x in [0,1]) {x} = [0, 1]$ has length $1$ — so additivity #emph[cannot] extend to uncountable unions.
]

A probability measure is simply a measure normalized to total mass one.

#definition(title: "Probability measure, probability space")[
Let $(Omega, cal(A))$ be a measurable space. A measure $PP : cal(A) -> [0, oo]$ is a *probability measure* if
$
PP(Omega) = 1 .
$
The triple $(Omega, cal(A), PP)$ is then called a *probability space*, and $cal(A)$ is its *event space* (the set of events of interest). Being a measure — hence additive — together with normalization forces $PP(A) in [0, 1]$ for every event $A$ (see the monotonicity rule below).
]

#definition(title: "Almost surely")[
A property depending on the outcome $omega in Omega$ holds *almost surely* (*a.s.*) if the event on which it holds has probability $1$. Equivalently, it may fail only on a *null event*, an event of probability $0$.
]

Unwinding the definition, a probability measure is exactly a map satisfying Kolmogorov's three axioms. Everything else in this chapter is a #emph[consequence] of them.

#keyfact[
A *probability measure* $PP$ on a measurable space $(Omega, cal(A))$ satisfies *Kolmogorov's axioms*:
+ *(K1) non-negativity*: $PP(A) >= 0$ for every event $A in cal(A)$;
+ *(K2) normalization*: $PP(Omega) = 1$;
+ *(K3) countable ($sigma$-) additivity*: for pairwise disjoint events $A_1, A_2, dots in cal(A)$,
  $
  PP(union.big_(i=1)^oo A_i) = sum_(i=1)^oo PP(A_i) .
  $
The triple $(Omega, cal(A), PP)$ is a *probability space*. Intuitively, $PP$ #emph[measures the likelihood] of events, exactly the way length, area or volume measure the size of subsets.
]

== Computation rules

The axioms may look sparse, but they already pin down all the elementary rules of probability. The following properties hold for #emph[any] measure; the finiteness caveat in one of them vanishes for probabilities because $PP(A) <= 1 < oo$ always.

#proposition(name: "computation rules")[
Let $(Omega, cal(A), PP)$ be a probability space, $A, B in cal(A)$ and $(A_i)_(i in NN)$ a sequence in $cal(A)$. Then
+ $PP(emptyset) = 0$;
+ *complement rule*: $PP(A^c) = 1 - PP(A)$;
+ *finite additivity*: if $A inter B = emptyset$ then $PP(A union B) = PP(A) + PP(B)$;
+ *difference rule*: if $A subset.eq B$ then $PP(B backslash A) = PP(B) - PP(A)$;
+ *monotonicity*: if $A subset.eq B$ then $PP(A) <= PP(B)$ (and hence $PP(A) <= 1$);
+ *inclusion--exclusion (two events)*: $PP(A union B) = PP(A) + PP(B) - PP(A inter B)$;
+ *union bound / $sigma$-subadditivity*: $PP(union.big_(i=1)^oo A_i) <= sum_(i=1)^oo PP(A_i)$;
+ *continuity from below*: if $A_1 subset.eq A_2 subset.eq dots$ then $PP(union.big_(i=1)^oo A_i) = lim_(n -> oo) PP(A_n)$;
+ *continuity from above*: if $A_1 supset.eq A_2 supset.eq dots$ then $PP(inter.big_(i=1)^oo A_i) = lim_(n -> oo) PP(A_n)$.
]

#proof[
For (i), $Omega$ and $emptyset$ are disjoint with union $Omega$, so by (K3) $1 = PP(Omega) = PP(Omega) + PP(emptyset)$, giving $PP(emptyset) = 0$. Finite additivity (iii) is (K3) applied to $A, B, emptyset, emptyset, dots$. For the complement rule (ii), $A$ and $A^c$ are disjoint with $A union A^c = Omega$, so $1 = PP(Omega) = PP(A) + PP(A^c)$. For (iv) and (v), $A subset.eq B$ gives the disjoint decomposition $B = A union.plus (B backslash A)$, hence $PP(B) = PP(A) + PP(B backslash A) >= PP(A)$, and rearranging yields the difference rule. For inclusion--exclusion (vi), decompose $A union B = A union.plus (B backslash (A inter B))$ and use the difference rule on $A inter B subset.eq B$: $PP(A union B) = PP(A) + PP(B) - PP(A inter B)$. Properties (vii)--(ix) are the general measure facts specialized to $PP$; the finiteness hypothesis needed for continuity from above is automatic here since $PP(A_1) <= 1 < oo$.
]

#keyfact[
The four rules you reach for constantly: *complement* $PP(A^c) = 1 - PP(A)$, *monotonicity* $A subset.eq B => PP(A) <= PP(B)$, *inclusion--exclusion* $PP(A union B) = PP(A) + PP(B) - PP(A inter B)$, and the *union bound* $PP(union.big_i A_i) <= sum_i PP(A_i)$. The complement rule in particular turns hard "at least one" events into easy "none" events.
]

Inclusion--exclusion generalizes to any finite number of events, the sign alternating with the number of sets being intersected.

#theorem(name: "inclusion--exclusion")[
For events $A_1, dots, A_n in cal(A)$,
$
PP(union.big_(i=1)^n A_i) = sum_(k=1)^n (-1)^(k-1) sum_(1 <= i_1 < dots < i_k <= n) PP(A_(i_1) inter dots inter A_(i_k)) .
$
For $n = 3$ this reads
$
PP(A union B union C) = PP(A) + PP(B) + PP(C) - PP(A inter B) - PP(A inter C) - PP(B inter C) + PP(A inter B inter C) .
$
]

== Cumulative distribution functions

A probability measure on the real line can be encoded by a single real-valued function. This is the representation used by every later occurrence of “cdf”.

#definition(title: "Cumulative distribution function (cdf)")[
Let $P$ be a probability measure on $(RR, cal(B))$. Its *cumulative distribution function* (*cdf*) is
$
F_P : RR -> [0, 1], quad x |-> F_P (x) := P((-oo, x]) .
$
When the measure is clear we write simply $F$. A point $x$ with $P({x}) > 0$ is called an *atom* of $P$.
]

#proposition(name: "properties of cdfs")[
Every cdf $F$ satisfies:
+ *monotonicity:* $x <= y => F(x) <= F(y)$;
+ *right-continuity:* if a sequence $(x_n)$ decreases to $x$, then $F(x_n) -> F(x)$;
+ *left limits:* $F(x^-) := sup_(t < x) F(t) = P((-oo, x))$ exists;
+ *jumps equal point masses:* $F(x) - F(x^-) = P({x})$, so the discontinuities are exactly the atoms;
+ *boundary limits:* $lim_(x -> -oo) F(x) = 0$ and $lim_(x -> oo) F(x) = 1$.
]

#proof[
Monotonicity follows from $(-oo,x] subset.eq (-oo,y]$. Right-continuity and the left-limit identity are continuity from above and below of the probability measure, respectively. The disjoint decomposition $(-oo,x] = (-oo,x) union.plus {x}$ gives the jump formula. The boundary limits follow from $union.big_(n=1)^oo (-oo,n] = RR$ and $inter.big_(n=1)^oo (-oo,-n] = emptyset$ by continuity from below and above.
]

#theorem(name: "cdf--measure correspondence")[
A function $F : RR -> [0, 1]$ is the cdf of a unique probability measure on $(RR, cal(B))$ if and only if it is non-decreasing, right-continuous, and satisfies
$
lim_(x -> -oo) F(x) = 0, quad lim_(x -> oo) F(x) = 1.
$
Consequently, two probability measures on $(RR, cal(B))$ are equal if and only if their cdfs are equal.
]

#example(title: "at least one six")[
Roll a fair die $n$ times, modelled by $Omega = {1, dots, 6}^n$ with the uniform measure $PP(A) = |A| \/ |Omega|$. Let $A$ be the event "at least one six". Computing $PP(A)$ directly is awkward, but its complement $A^c =$ "no six at all" is easy: there are $5^n$ six-free rolls, so $PP(A^c) = 5^n \/ 6^n = (5\/6)^n$. By the complement rule
$
PP(A) = 1 - (5/6)^n .
$
For $n = 4$ this is $1 - (5\/6)^4 = 671\/1296 approx 0.518$ — a hair above one half, the classical result behind an old gambling puzzle.
]

#remark[
On a finite space with the *uniform* (Laplace) measure, every computation collapses to counting: $PP(A) = |A| \/ |Omega|$, so probability questions become combinatorics. The axiomatic machinery only truly earns its keep once $Omega$ is uncountable, where singletons have probability $0$ yet events still carry positive probability — the theme of Chapter 4.
]

#quizblock(title: "Quiz — Probability spaces")[
#question[State the three defining axioms of a $sigma$-algebra $cal(A)$ on $Omega$.]
#answer[(i) $Omega in cal(A)$; (ii) closed under complements, $A in cal(A) => A^c in cal(A)$; (iii) closed under countable unions, $(A_i)_(i in NN)$ in $cal(A) => union.big_(i in NN) A_i in cal(A)$. From these one also gets $emptyset in cal(A)$ and closure under countable intersections (via de Morgan).]

#question[Why do we restrict to a $sigma$-algebra instead of just using the full power set $cal(P)(Omega)$ as the event space?]
#answer[For uncountable $Omega$ (e.g. $[0,1]$) it is impossible to define a non-negative, normalized, countably additive and translation-invariant $PP$ on #emph[all] subsets: there exist non-measurable (Vitali-type) sets. Restricting to a $sigma$-algebra excludes these pathologies while still containing every event we care about. For finite or countable $Omega$ we may safely take $cal(A) = cal(P)(Omega)$.]

#question[True or false? $cal(A) = {emptyset, {1,2}, {1,4}, {2,3}, {3,4}, {1,2,3,4}}$ is a $sigma$-algebra on $Omega = {1,2,3,4}$. Justify.]
#answer[False. $Omega = {1,2,3,4} in cal(A)$, and $cal(A)$ is in fact closed under complementation — the complementary pairs present are exactly $emptyset <-> {1,2,3,4}$, ${1,2} <-> {3,4}$, ${1,4} <-> {2,3}$ — so that axiom causes no trouble. What fails is closure under unions: ${1,2}, {1,4} in cal(A)$ but
$ {1,2} union {1,4} = {1,2,4} in.not cal(A) . $
A single such counterexample already suffices to disprove the claim (further non-complementary failures: ${1,2} union {2,3} = {1,2,3} in.not cal(A)$ and ${1,4} union {3,4} = {1,3,4} in.not cal(A)$). Unions of complementary pairs stay inside $cal(A)$ because each equals $Omega$, for example ${1,2} union {3,4} = Omega$ and ${1,4} union {2,3} = Omega$.

As a consistency check: every finite algebra of sets on a non-empty 4-element $Omega$ has cardinality $2^k$ for some $1 <= k <= 4$, i.e. size in ${2,4,8,16}$. Here $|cal(A)| = 6$, which is not a power of $2$, confirming $cal(A)$ cannot even be an algebra — let alone a $sigma$-algebra.]

#question[Prove the complement rule $PP(A^c) = 1 - PP(A)$ from the axioms.]
#answer[$A$ and $A^c$ are disjoint and $A union A^c = Omega$. By finite additivity (a case of K3) and normalization, $1 = PP(Omega) = PP(A union A^c) = PP(A) + PP(A^c)$. Rearranging gives $PP(A^c) = 1 - PP(A)$.]

#question[Write down the inclusion--exclusion formula for three events $A, B, C$.]
#answer[$PP(A union B union C) = PP(A) + PP(B) + PP(C) - PP(A inter B) - PP(A inter C) - PP(B inter C) + PP(A inter B inter C)$.]

#question[A fair die is rolled four times. What is the probability of getting at least one six?]
#answer[Take $Omega = {1,dots,6}^4$ uniform. The complement "no six" has probability $(5\/6)^4$, so $PP("at least one six") = 1 - (5\/6)^4 = 671\/1296 approx 0.518$.]

#question[True or false? If $cal(A)_1$ and $cal(A)_2$ are $sigma$-algebras on $Omega$, then $cal(A)_1 union cal(A)_2$ is a $sigma$-algebra on $Omega$.]
#answer[False in general. On $Omega = {1,2,3}$ take $cal(A)_1 = {emptyset, {1}, {2,3}, Omega}$ and $cal(A)_2 = {emptyset, {2}, {1,3}, Omega}$. Both are $sigma$-algebras, but $cal(A)_1 union cal(A)_2$ contains ${1}$ and ${2}$ yet not ${1} union {2} = {1,2}$, so it is not closed under unions. (The #emph[intersection] of $sigma$-algebras, by contrast, is always a $sigma$-algebra.)]

#question[What is the $sigma$-algebra generated by a system $cal(E) subset.eq cal(P)(Omega)$, and what is the Borel $sigma$-algebra $cal(B)$ on $RR$?]
#answer[$sigma(cal(E))$ is the smallest $sigma$-algebra containing $cal(E)$, obtained as the intersection of all $sigma$-algebras on $Omega$ that contain $cal(E)$. The Borel $sigma$-algebra $cal(B) = cal(B)^1$ on $RR$ is $sigma$ of the open intervals (equivalently, of the open sets); it contains all intervals, open, closed and countable sets, but is strictly smaller than $cal(P)(RR)$.]
]

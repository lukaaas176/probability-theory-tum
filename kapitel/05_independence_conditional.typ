#import "../vorlage.typ": *

= Product spaces, independence, and conditional probability

Chapters 2 through 4 studied a #emph[single] probability space $(Omega, cal(A), PP)$ and single random variables living on it. Almost every interesting model, however, involves #emph[several] sources of randomness at once — many coin tosses, a whole dataset, a disease status together with a test result — and asks how they relate. This chapter supplies the three tools that make such joint reasoning precise. First, #emph[product spaces] let us glue individual spaces into one carrier for several experiments. Second, #emph[conditional probability] formalizes how observing one event revises the probabilities of others, culminating in the law of total probability and Bayes' theorem. Third, #emph[independence] pins down exactly when two pieces of randomness carry no information about each other, and the special case of #emph[independent and identically distributed] (i.i.d.) variables underlies essentially all of statistics and machine learning. Throughout we fix a probability space $(Omega, cal(A), PP)$ and, where needed, a family $((Omega_i, cal(A)_i))_(i in I)$ of measurable spaces indexed by a non-empty set $I$, with an $(Omega_i, cal(A)_i)$-valued random variable $X_i$ for each $i in I$.

== Product spaces and product measures

To speak of several outcomes jointly we first need a single set that holds one slot per experiment.

#definition(title: "Product space (Cartesian product)")[
Let $(Omega_i)_(i in I)$ be a family of sets over a non-empty index set $I$. The *product space* (or *Cartesian product*)
$
Omega_I := product_(i in I) Omega_i := { (omega_i)_(i in I) : omega_i in Omega_i "for all" i in I }
$
is the set of all tuples with one coordinate $omega_i in Omega_i$ per index. If all factors coincide, $Omega_i = Omega$ for all $i in I$, we write $Omega^I := Omega_I$; and if $n := |I| < oo$ we write $Omega^n$.
]

Intuitively an element of $Omega_I$ is a tuple with one slot for each $i in I$, each slot filled by an arbitrary element of the corresponding $Omega_i$; the definition works verbatim for infinite index sets $I$, which is what will let us model infinite sequences of experiments.

#remark[
A product space is only a set — to do probability on it we also need a $sigma$-algebra and a measure. Both come with canonical constructions. There is a unique smallest $sigma$-algebra on $Omega_I$ making all coordinate projections measurable, the *product $sigma$-algebra* $cal(A)_I := ⊗_(i in I) cal(A)_i$. If moreover each $(Omega_i, cal(A)_i)$ carries a probability measure $PP_i$, there is a unique *product measure* $⊗_(i in I) PP_i$ on $cal(A)_I$ under which the coordinates behave like separate, non-interacting experiments. Together they form the *product probability space*
$
(product_(i in I) Omega_i, thin ⊗_(i in I) cal(A)_i, thin ⊗_(i in I) PP_i) = (Omega_I, cal(A)_I, PP_I) .
$
A useful fact for the continuous case is $⊗_(i=1)^n cal(B) = cal(B)^n$: the $n$-fold product of the Borel $sigma$-algebra on $RR$ is exactly the Borel $sigma$-algebra on $RR^n$ from Chapter 2.
]

Once several random variables share a space, two dual questions arise: how are they distributed #emph[together], and how is each one distributed #emph[on its own]?

#definition(title: "Joint and marginal distribution")[
Let $X := (X_i)_(i in I)$, regarded as an $(Omega_I, cal(A)_I)$-valued random variable. Its induced measure $P_X := PP compose X^(-1)$ on $(Omega_I, cal(A)_I)$ is the *joint distribution* of the family $(X_i)_(i in I)$. For each $i in I$ the induced measure $P_(X_i) := PP compose X_i^(-1)$ is the *marginal distribution* of $X_i$ (with respect to $P_X$).
]

For the two most important cases — finitely many discrete variables, or finitely many real-valued ones — the joint distribution is described by a single function of the whole tuple (a joint pmf, cdf, or pdf, not necessarily a product of one-dimensional pieces), and the marginals are recovered by summing or integrating out the other coordinates.

#example(title: "product pmf and product pdf")[
Let $p_1, dots, p_n$ be pmfs on $Omega$. Their *product pmf* on $Omega^n$ is
$
p(omega) := product_(i in [n]) p_i (omega_i) quad "for" omega = (omega_i)_(i in [n]) in Omega^n .
$
Likewise, for pdfs $p_1, dots, p_n$ on $RR$ the *product pdf* on $RR^n$ is $p(x) := product_(i in [n]) p_i (x_i)$ for $x = (x_i)_(i in [n]) in RR^n$. Thus the product measure, which models independent coordinates, is represented by the product of the respective pmfs or pdfs.
]

#proposition(name: "computing marginals")[
Let $I = [n]$ and $X = (X_1, dots, X_n)$.
+ If all $X_i$ are real-valued with joint cdf $F_X (x) = PP(X_1 <= x_1, dots, X_n <= x_n)$, then each marginal cdf is obtained by sending the other arguments to $+oo$:
  $
  F_(X_i)(x_i) = lim_(x_j -> oo, thin j != i) F_X (x_1, dots, x_n) .
  $
+ If $X$ is discrete with joint pmf $p_X$, then each $X_i$ has marginal pmf
  $
  p_(X_i)(omega_i) = sum_(omega_1 in Omega_1) dots.c sum_(omega_(i-1) in Omega_(i-1)) thin sum_(omega_(i+1) in Omega_(i+1)) dots.c sum_(omega_n in Omega_n) p_X (omega_1, dots, omega_n) .
  $
+ If $X$ is continuous with joint pdf $p_X$, then each $X_i$ has marginal pdf
  $
  p_(X_i)(x_i) = integral_RR dots.c integral_RR p_X (x_1, dots, x_n) thin d x_1 dots.c d x_(i-1) thin d x_(i+1) dots.c d x_n .
  $
]

In the two-variable shorthand these read $p_X (x) = sum_y p_(X,Y)(x, y)$ and $p_X (x) = integral_RR p_(X,Y)(x, y) thin d y$: to marginalize is simply to sum or integrate out every variable except the one of interest.

== Conditional probability

Suppose we learn that an event $B$ has occurred. This shrinks the world of possible outcomes to $B$ and forces us to renormalize so that $B$ now carries all the probability.

#definition(title: "Conditional probability")[
Let $A, B in cal(A)$ be events with $PP(B) > 0$. The *conditional probability of $A$ given $B$* is
$
PP(A | B) := frac(PP(A inter B), PP(B)) .
$
]

The requirement $PP(B) > 0$ is essential: conditioning on a null event is undefined at this level of the theory. Geometrically, $PP(A | B)$ measures the fraction of $B$'s probability mass that also lies in $A$; dividing by $PP(B)$ guarantees $PP(Omega | B) = 1$, so the conditioned assignment is again a bona fide probability.

#proposition(name: "conditioning yields a probability measure")[
Let $B in cal(A)$ with $PP(B) > 0$. Then the map
$
tilde(PP) : cal(A) -> [0, 1], quad A |-> tilde(PP)(A) := PP(A | B)
$
is a probability measure on $(Omega, cal(A))$. The probability space $(B, cal(A)|_B, tilde(PP)|_B)$ obtained using the induced $sigma$-algebra $cal(A)|_B$ from Chapter 2 is called the *trace* of $(Omega, cal(A), PP)$ on $B$.
]

#proof[
Non-negativity is clear since $PP(A inter B) >= 0$ and $PP(B) > 0$. Normalization holds because $tilde(PP)(Omega) = PP(Omega inter B) \/ PP(B) = PP(B) \/ PP(B) = 1$. For $sigma$-additivity, let $(A_k)_(k in NN)$ be pairwise disjoint; then the sets $(A_k inter B)_(k in NN)$ are pairwise disjoint too, and by $sigma$-additivity of $PP$,
$
tilde(PP)(union.big_(k) A_k) = frac(PP((union.big_k A_k) inter B), PP(B)) = frac(sum_k PP(A_k inter B), PP(B)) = sum_k tilde(PP)(A_k) .
$
]

Rearranging the definition gives the rule used to build up the probability of a conjunction step by step.

#keyfact[
*Multiplication rule.* For $A, B in cal(A)$ with $PP(A), PP(B) > 0$,
$
PP(A inter B) = PP(A) thin PP(B | A) = PP(B) thin PP(A | B) .
$
More generally, whenever $PP(inter.big_(i in [n]) A_i) > 0$, the *chain rule* factorizes a joint event into a cascade of conditionals.
]

#lemma(name: "chain rule / trivial factorization")[
For events $A_1, dots, A_(n+1) in cal(A)$ with $PP(inter.big_(i in [n]) A_i) > 0$,
$
PP(inter.big_(i in [n+1]) A_i) = PP(A_1) thin PP(A_2 | A_1) thin PP(A_3 | A_1 inter A_2) dots.c PP(A_(n+1) | inter.big_(i in [n]) A_i) .
$
]

#proof[
Induction on $n$. For $n = 1$ the claim is the multiplication rule $PP(A_1 inter A_2) = PP(A_1) PP(A_2 | A_1)$. For the step, note $PP(inter.big_(i in [n]) A_i) > 0$ implies $PP(inter.big_(i in [k]) A_i) > 0$ for every $k <= n$ by monotonicity, so all conditionals are defined. Applying the multiplication rule to the two events $inter.big_(i in [n]) A_i$ and $A_(n+1)$ gives $PP(inter.big_(i in [n+1]) A_i) = PP(inter.big_(i in [n]) A_i) thin PP(A_(n+1) | inter.big_(i in [n]) A_i)$, and expanding the first factor by the induction hypothesis yields the claim.
]

#example(title: "drawing without replacement")[
Draw two cards from a shuffled $52$-card deck without replacement, and let $A_i =$ "the $i$-th card is an ace". The chain rule gives
$
PP(A_1 inter A_2) = PP(A_1) thin PP(A_2 | A_1) = frac(4, 52) dot frac(3, 51) = frac(12, 2652) = frac(1, 221) approx 0.0045 .
$
Conditioning captures exactly the physical fact that removing one ace changes the deck for the second draw — the second factor is $3\/51$, not $4\/52$.
]

== The law of total probability and Bayes' theorem

Conditioning becomes a computational engine once we combine it with a #emph[partition] of the sample space: to find the probability of $A$, split the world into disjoint scenarios $B_i$, compute $A$'s probability inside each, and average with the scenario weights.

#theorem(name: "law of total probability and Bayes' rule")[
Let $B in cal(A)$ with $PP(B) > 0$ and let $I$ be a countable index set.
+ *Law of total probability.* If ${B_i : i in I} subset.eq cal(A)$ is a measurable partition of $B$ with $PP(B_i) > 0$ for all $i in I$, i.e. $union.big_(i in I) B_i = B$ and $B_i inter B_j = emptyset$ for $i != j$, then for every $A in cal(A)$
  $
  PP(A inter B) = sum_(i in I) PP(A | B_i) thin PP(B_i) .
  $
  In particular, taking $B = Omega$ and a partition ${B_i : i in I}$ of $Omega$ with $PP(B_i) > 0$, we get $PP(A) = sum_(i in I) PP(A | B_i) thin PP(B_i)$.
+ *Bayes' rule.* For $A in cal(A)$ with $PP(A) > 0$ and every measurable partition ${B_i : i in I}$ of $Omega$ with $PP(B_i) > 0$ for all $i in I$,
  $
  PP(B_i | A) = frac(PP(A | B_i) thin PP(B_i), sum_(j in I) PP(A | B_j) thin PP(B_j)) quad "for all" i in I .
  $
]

#proof[
For (i), the sets $(A inter B_i)_(i in I)$ are pairwise disjoint with union $A inter B$, so $sigma$-additivity gives $PP(A inter B) = sum_i PP(A inter B_i)$; applying the multiplication rule $PP(A inter B_i) = PP(A | B_i) PP(B_i)$ to each summand proves the claim. For (ii), by the definition of conditional probability and the multiplication rule, $PP(B_i | A) = PP(A inter B_i) \/ PP(A) = PP(A | B_i) PP(B_i) \/ PP(A)$; expanding the denominator $PP(A)$ with the law of total probability applied to the partition ${B_j}$ of $Omega$ yields the stated formula.
]

Bayes' rule is deceptively simple algebra, yet it is the backbone of statistical inference. The reason is an interpretation in terms of updating beliefs.

#keyfact[
*Bayes' theorem, belief-updating form.* With event of interest $A$ and evidence $B$,
$
underbrace(PP(A | B), "posterior") = frac(overbrace(PP(B | A), "likelihood") dot overbrace(PP(A), "prior"), underbrace(PP(B | A) thin PP(A) + PP(B | A^c) thin PP(A^c), "marginal likelihood / total evidence")) .
$
The *prior* $PP(A)$ is our belief before seeing evidence; the *likelihood* $PP(B | A)$ says how well $A$ explains the observation; the *posterior* $PP(A | B)$ is the updated belief. The denominator is just the normalizing constant, so $PP(A | B) prop PP(B | A) thin PP(A)$: posterior is proportional to likelihood times prior.
]

#remark[
The same schema, written for a parameter $theta$ and data $cal(D)$, gives the workhorse of Bayesian inference:
$
p(theta | cal(D)) = frac(p(cal(D) | theta) thin p(theta), p(cal(D))) prop p(cal(D) | theta) thin p(theta) ,
$
where $p(theta)$ is a prior over models, $p(cal(D) | theta)$ the likelihood (the data density viewed as a function of $theta$), and $p(cal(D))$ the model evidence. Likelihood is defined formally in Chapter 10 and Bayesian evidence in Chapter 14; here the formula is only a preview of Bayes' rule applied to parameters. Computing $p(cal(D)) = integral p(cal(D) | theta) p(theta) thin d theta$ is often the hard part, which is exactly why the proportionality form is so useful.
]

The following worked example is the classic illustration that a highly accurate test can still leave you very uncertain when the condition is rare — the #emph[base-rate fallacy].

#example(title: "medical test and the base-rate fallacy")[
A disease affects a fraction $PP(D) = 0.001$ of the population. A test is $99%$ sensitive and $99%$ specific: it is positive for a diseased person with probability $PP(+ | D) = 0.99$, and negative for a healthy person with probability $PP(- | D^c) = 0.99$, hence gives a false positive with probability $PP(+ | D^c) = 0.01$. You test positive. What is $PP(D | +)$?

The two scenarios $D$ and $D^c$ partition $Omega$, so the law of total probability gives the total evidence
$
PP(+) = PP(+ | D) thin PP(D) + PP(+ | D^c) thin PP(D^c) = 0.99 dot 0.001 + 0.01 dot 0.999 = 0.01098 .
$
Bayes' rule then yields
$
PP(D | +) = frac(PP(+ | D) thin PP(D), PP(+)) = frac(0.99 dot 0.001, 0.01098) = frac(0.00099, 0.01098) approx 0.090 .
$
Despite a $99%$-accurate test, a positive result means only about a $9%$ chance of actually being ill: the tiny prior $PP(D) = 0.001$ dominates, because among a large population the many healthy people generate far more false positives ($approx 0.999%$) than there are true positives ($approx 0.099%$). This is why rare-disease screening is followed by a second, independent confirmatory test.
]

== Independence of events

Independence is the precise counterpart of "learning $B$ tells us nothing about $A$": the conditional probability equals the unconditional one, $PP(A | B) = PP(A)$, which — cleared of the division — is the symmetric product form below.

#definition(title: "Independence of events")[
+ Two events $A, B in cal(A)$ are *independent (under $PP$)*, written $A perp perp B$, if
  $
  PP(A inter B) = PP(A) thin PP(B) .
  $
+ A family $(A_i)_(i in I)$ in $cal(A)$ is *(mutually) independent (under $PP$)*, written $perp perp_(i in I) A_i$, if for every finite subset $J subset.eq I$
  $
  PP(inter.big_(j in J) A_j) = product_(j in J) PP(A_j) .
  $
]

Two subtleties deserve emphasis. First, the product form makes independence symmetric and, unlike the ratio $PP(A | B) = PP(A)$, it stays meaningful even when $PP(B) = 0$. Second, mutual independence of a family is #emph[much] stronger than requiring every pair to be independent: it demands the product rule for #emph[all] finite sub-collections at once.

#example(title: "pairwise independence does not imply mutual independence")[
Let $Omega = {circle.small, triangle, square, star}$ with the uniform measure, and set
$
A = {circle.small, triangle}, quad B = {circle.small, square}, quad C = {circle.small, star} .
$
Each has probability $1\/2$, and the three pairwise intersections all equal ${circle.small}$, so
$
PP(A inter B) = PP(A inter C) = PP(B inter C) = 1/4 = PP(A) PP(B) = PP(A) PP(C) = PP(B) PP(C) ,
$
i.e. $A, B, C$ are pairwise independent. Yet $A inter B inter C = {circle.small}$ as well, so
$
PP(A inter B inter C) = 1/4 != 1/8 = PP(A) PP(B) PP(C) ,
$
and the triple is #emph[not] mutually independent. Pairwise independence is strictly weaker; the converse implication does hold.
]

#example(title: [independence despite an apparent "dependence"])[
Roll two distinct fair dice, $Omega = [6]^2$ uniform, and let $A = {(i, j) : i + j = 7}$ ("the sum is $7$") and $B = {(i, j) : i = 6}$ ("the first die shows $6$"). Then $|A| = |B| = 6$ and $A inter B = {(6, 1)}$, so
$
PP(A inter B) = 1/36 = 1/6 dot 1/6 = PP(A) PP(B) ,
$
and $A perp perp B$ — even though the sum "obviously depends" on the first die. Independence is a statement about probabilities, not about causal or logical connection: it is #emph[not] the same as "having nothing to do with one another".
]

#keyfact[
*Independence, at a glance.* Events $A, B$ are independent iff $PP(A inter B) = PP(A) PP(B)$, equivalently $PP(A | B) = PP(A)$ when $PP(B) > 0$. Watch the traps: (i) independence is #emph[not] disjointness — two disjoint events with positive probability are always #emph[dependent], since $PP(A inter B) = 0 < PP(A) PP(B)$; (ii) #emph[pairwise] independence does not give #emph[mutual] independence.
]

== Independence of random variables

For random variables, independence means the joint distribution factorizes into the marginals: knowing some coordinates tells us nothing about the others.

#definition(title: "Independence of random variables")[
Let $X_1, dots, X_n$ be random variables on $(Omega, cal(A), PP)$.
+ Real-valued $X_1, dots, X_n$ are *independent* iff their joint cdf factorizes: for all $x = (x_1, dots, x_n) in RR^n$,
  $
  F_(X_1, dots, X_n)(x_1, dots, x_n) = product_(i in [n]) F_(X_i)(x_i) .
  $
+ Discrete $X_1, dots, X_n$ are *independent* iff the *pmf factorizes*: $p_(X_1, dots, X_n)(s) = product_(i in [n]) p_(X_i)(s_i)$ for all $s in product_(i in [n]) Omega_i$.
+ Continuous $X_1, dots, X_n$ are *independent* iff the *pdf factorizes*: $p_X (x) = product_(i in [n]) p_(X_i)(x_i)$ for (Lebesgue-almost) all $x in RR^n$.
]

Comparing with the product-measure construction, independence of $(X_i)_(i in I)$ is exactly the statement that their joint distribution is the product of the marginals, $P_X = ⊗_(i in I) P_(X_i)$. Conditional distributions give a complementary bookkeeping device when variables are #emph[not] independent.

#definition(title: "Conditional cdf, pmf, and pdf")[
Let $X, Y$ be real-valued random variables with joint distribution $P$.
+ In the discrete case, if $PP(X = x) > 0$ the *conditional pmf of $Y$ given $X = x$* is
  $
  p_(Y | X = x)(y) = frac(PP(X = x, thin Y = y), PP(X = x)) = frac(p_(X,Y)(x, y), p_X (x)) .
  $
  Its conditional cdf is
  $
  F_(Y | X=x)(y) := PP(Y <= y | X=x) = sum_(t <= y) p_(Y | X=x)(t).
  $
+ In the continuous case, if $p_X (x) > 0$ the *conditional pdf of $Y$ given $X = x$* is
  $
  p_(Y | X = x)(y) = frac(p_(X,Y)(x, y), p_X (x)) .
  $
  Its conditional cdf is $F_(Y | X=x)(y) := integral_(-oo)^y p_(Y | X=x)(t) dif t$.
]

Independence of $X$ and $Y$ is then the statement that the conditional coincides with the marginal, $p_(Y | X = x) = p_Y$, mirroring $PP(A | B) = PP(A)$ for events. Finally, a frequently invoked relative of independence conditions on a third variable.

#definition(title: "Conditional independence")[
Let $X, Y, Z$ be random variables on the same probability space. Then $X$ and $Y$ are *conditionally independent given $Z$*, written $X perp perp Y | Z$, if the conditional joint distribution factorizes: whenever the densities exist,
$
p(x, y | z) = p(x | z) thin p(y | z) quad "for almost all" (x, y) "and for" P_Z"-almost all" z ,
$
so that, once $Z$ is known, $X$ carries no further information about $Y$.
]

== Product spaces revisited: i.i.d. random variables

The most important special case of independence adds one ingredient: the variables not only fail to influence each other, they are also copies of the #emph[same] distribution.

#definition(title: "Independent and identically distributed (i.i.d.)")[
A collection $X_1, dots, X_n$ (or an infinite sequence $X_1, X_2, dots$) of random variables is *independent and identically distributed (i.i.d.)* if the variables are independent and each has the same distribution $P_X$. We write $X_i tilde^"i.i.d." P_X$. Equivalently, in the discrete or continuous case the joint pmf/pdf is the product of one common factor,
$
p(x_1, dots, x_n) = product_(i in [n]) p_X (x_i) .
$
]

An i.i.d. sequence is precisely what the product-space machinery of the first section produces from a single distribution: taking identical factors $(Omega, cal(A), P_X)$ and forming the product probability space $(Omega^n, cal(A)^(⊗ n), P_X^(⊗ n))$ realizes $n$ independent draws from $P_X$ as the coordinate variables. An infinite sequence of coin tosses or card draws with replacement, modelled on $Omega^NN$, is this construction with an infinite index set.

#keyfact[
For an i.i.d. sample $X_1, dots, X_n tilde^"i.i.d." P_X$, the joint density factorizes into a single repeated factor. Consequently, once likelihood is defined in Chapter 10, observed i.i.d. data will have $L(theta | x_1, dots, x_n) = product_(i=1)^n p(x_i | theta)$ — a product, not a sum. This factorization is also what makes the laws of large numbers and the central limit theorem tractable; i.i.d. sampling is the default modelling assumption in classical statistics and much of machine learning.
]

#remark[
The i.i.d. assumption is a powerful idealization, not a law of nature, and it is worth checking. It simplifies analysis (the likelihood becomes a product), and it is the classical hypothesis under which the limit theorems of Chapter 9 are stated. But it is often only approximately true: time-series data carry temporal dependence, clustered data are correlated within clusters, and even "draw a person uniformly at random" breaks i.i.d. once we sample #emph[without] replacement from a finite population (after fixing $X_1$, the second draw $X_2$ is no longer #emph[independent] of it — conditionally it excludes the already-drawn person, even though each $X_i$ remains marginally uniform over the population). Treating dependent data as i.i.d. can produce badly overconfident inferences, so the assumption should be justified, not assumed.
]

#quizblock(title: "Quiz — Independence and conditional probability")[
#question[Define the conditional probability $PP(A | B)$ and state the multiplication rule for two events. Under what condition is $PP(A | B)$ defined?]
#answer[For $PP(B) > 0$, $PP(A | B) := PP(A inter B) \/ PP(B)$; it is undefined when $PP(B) = 0$. Rearranging gives the multiplication rule $PP(A inter B) = PP(B) PP(A | B) = PP(A) PP(B | A)$, which iterates to the chain rule $PP(inter.big_(i in [n]) A_i) = PP(A_1) PP(A_2 | A_1) dots.c PP(A_n | inter.big_(i in [n-1]) A_i)$.]

#question[State the law of total probability and Bayes' rule for a countable measurable partition ${B_i}$ of $Omega$ with $PP(B_i) > 0$. Then a factory has two lines: line 1 makes $60%$ of items with a $2%$ defect rate, line 2 makes $40%$ with a $5%$ defect rate. An item is defective — what is the probability it came from line 1?]
#answer[Law of total probability: $PP(A) = sum_i PP(A | B_i) PP(B_i)$. Bayes' rule: $PP(B_i | A) = PP(A | B_i) PP(B_i) \/ sum_j PP(A | B_j) PP(B_j)$. Here $PP("def") = 0.6 dot 0.02 + 0.4 dot 0.05 = 0.012 + 0.02 = 0.032$, so $PP("line 1" | "def") = 0.012 \/ 0.032 = 0.375$.]

#question[A disease has prevalence $1%$. A test has sensitivity $PP(+ | D) = 0.95$ and false-positive rate $PP(+ | D^c) = 0.05$. Compute $PP(D | +)$.]
#answer[Total evidence $PP(+) = 0.95 dot 0.01 + 0.05 dot 0.99 = 0.0095 + 0.0495 = 0.059$. Bayes: $PP(D | +) = 0.0095 \/ 0.059 approx 0.161$, about $16%$ — again far below the test's accuracy, because the disease is rare (the base-rate fallacy).]

#question[Monty Hall: three doors, one hides a car. You pick door 1; the host, who knows the layout, opens a different door revealing a goat and offers a switch. Should you switch? Justify with probabilities.]
#answer[Yes, switch. Let $C_i$ be "car behind door $i$", each with prior $1\/3$. If the car is behind your door 1 (prob $1\/3$), switching loses; if it is behind door 2 or 3 (combined prob $2\/3$), the host's forced reveal leaves the car on the other unopened door, so switching wins. Hence $PP("win by switching") = 2\/3$ versus $PP("win by staying") = 1\/3$. Conditioning on the host's action, which is informative because he never opens the car door, is what breaks the naive $1\/2$ intuition.]

#question[Two cards lie in a box: one is red on both sides, the other red on one side and blue on the other. You draw one, place it down, and a red face shows. What is the probability the hidden face is also red?]
#answer[Condition on "a red face is showing". Of the three red faces in the box (two on the red/red card, one on the red/blue card), two belong to the red/red card, whose other side is also red. So $PP("other side red" | "red showing") = 2\/3$, not $1\/2$. Equivalently, by Bayes with prior $1\/2$ on each card and likelihoods $PP("red up" | "red/red") = 1$, $PP("red up" | "red/blue") = 1\/2$: $PP("red/red" | "red up") = (1 dot 1\/2) \/ (1 dot 1\/2 + 1\/2 dot 1\/2) = (1\/2)\/(3\/4) = 2\/3$.]

#question[Events $A, B$ satisfy $PP(A) = 0.5$, $PP(B) = 0.4$ and are independent. Compute $PP(A inter B)$ and $PP(A union B)$. If instead $A$ and $B$ were disjoint with these probabilities, could they be independent?]
#answer[Independence: $PP(A inter B) = 0.5 dot 0.4 = 0.2$, so by inclusion--exclusion $PP(A union B) = 0.5 + 0.4 - 0.2 = 0.7$. If disjoint, $PP(A inter B) = 0 != 0.2 = PP(A) PP(B)$, so they would be #emph[dependent]. Two events of positive probability can never be both disjoint and independent.]

#question[True or false, with justification: if $A, B, C$ are pairwise independent then they are mutually independent.]
#answer[False. On $Omega = {circle.small, triangle, square, star}$ uniform, take $A = {circle.small, triangle}$, $B = {circle.small, square}$, $C = {circle.small, star}$. All pairwise intersections equal ${circle.small}$ with probability $1\/4 = (1\/2)(1\/2)$, so the events are pairwise independent; but $PP(A inter B inter C) = PP({circle.small}) = 1\/4 != 1\/8 = PP(A) PP(B) PP(C)$, so they are not mutually independent.]

#question[What does it mean for real-valued random variables $X_1, dots, X_n$ to be i.i.d.? Write the joint pdf, and contrast independence with conditional independence given a variable $Z$.]
#answer[i.i.d. means the $X_i$ are independent and share one distribution $P_X$; then the joint pdf factorizes into a single repeated factor, $p(x_1, dots, x_n) = product_(i=1)^n p_X (x_i)$. (Plain) independence of $X, Y$ means $p(x, y) = p_X (x) p_Y (y)$; #emph[conditional] independence given $Z$, written $X perp perp Y | Z$, means $p(x, y | z) = p(x | z) p(y | z)$ — the two need not hold together (variables can be dependent yet conditionally independent, and vice versa).]
]

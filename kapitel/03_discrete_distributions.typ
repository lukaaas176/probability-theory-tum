#import "../vorlage.typ": *

= Discrete probability spaces and distributions

Chapter 2 built the general apparatus — a sample space $Omega$, a $sigma$-algebra $cal(A)$ of events, and a probability measure $P$ — and warned that on uncountable spaces we cannot use the full power set as $cal(A)$ (the measure problem, the Vitali set). This chapter looks at the friendliest case, where that problem disappears completely: $Omega$ is *countable*. Here we may always take $cal(A) = cal(P)(Omega)$, and a single, elementary object — the probability mass function — encodes the entire measure. We then meet the handful of named discrete distributions (Bernoulli, binomial, geometric, negative binomial, Poisson, hypergeometric, and the discrete uniform) that model almost every counting experiment you will see in this course. Expectation $EE[X]$ and variance $"Var"(X)$, quoted in the summary table below, are defined in Chapter 6; the continuous counterpart (densities) follows in Chapter 4.

== Discrete probability spaces and the pmf

#definition(title: "Discrete probability space, probability mass function (pmf)")[
Let $Omega$ be an *at most countable* set. A probability measure $P$ on $(Omega, cal(A) := cal(P)(Omega))$ is called a *discrete probability measure*, and the triple $(Omega, cal(A), P)$ a *discrete probability space*. The map
$
p : Omega -> [0, 1], quad omega |-> p(omega) := P({omega})
$
is called the *probability mass function (pmf)* of $P$. It assigns to each single outcome $omega$ the probability of the elementary event ${omega}$.
]

Because $Omega$ is countable, every event $A subset.eq Omega$ is a countable disjoint union of singletons, $A = union.big_(omega in A) {omega}$. Countable additivity of $P$ (Chapter 2) therefore turns the pmf into the only object we ever need to specify.

#lemma(name: "correspondence between pmf and P")[
Let $Omega$ be at most countable.
+ If $(Omega, cal(A), P)$ is a discrete probability space with pmf $p$, then $P$ is *uniquely determined* by $p$, via
$
P(A) = sum_(omega in A) p(omega) quad "for every" A subset.eq Omega.
$
+ Conversely, given any function $p : Omega -> [0, 1]$ with $sum_(omega in Omega) p(omega) = 1$, the map $P(A) := sum_(omega in A) p(omega)$ is a discrete probability measure on $(Omega, cal(P)(Omega))$ whose pmf is exactly $p$.
]

#proof[
For (i), write $A = union.big_(omega in A) {omega}$ as a countable disjoint union. By $sigma$-additivity, $P(A) = sum_(omega in A) P({omega}) = sum_(omega in A) p(omega)$, so the values $p(omega)$ pin down $P$ on all of $cal(P)(Omega)$. For (ii) one checks Kolmogorov's axioms: $P(A) >= 0$ since $p >= 0$; $P(Omega) = sum_(omega in Omega) p(omega) = 1$; and for pairwise disjoint $A_1, A_2, dots$ rearranging the (absolutely convergent, non-negative) double sum gives $P(union.big_i A_i) = sum_i P(A_i)$. Finally $P({omega}) = p(omega)$, so $p$ is the pmf of $P$.
]

#keyfact[
On a countable space, *a pmf and a probability measure are the same information*. To specify a discrete model you never manipulate $P$ directly: you just give a function $p : Omega -> [0, 1]$ with $sum_(omega in Omega) p(omega) = 1$. Everything else — the probability of any event — is the sum $P(A) = sum_(omega in A) p(omega)$.
]

#remark[
The pmf also lets us place a discrete distribution on the real line. If $Omega subset.eq RR$ is countable and $p$ a pmf on it, then
$
P(A) = sum_(omega in Omega inter A) p(omega), quad F(x) = sum_(omega in Omega inter (-infinity, x]) p(omega)
$
define a discrete probability measure and its cumulative distribution function on $(RR, cal(B))$ (cf. Chapter 2). The cdf $F$ is then a step function: it jumps by $p(omega)$ at each atom $omega$ and is flat in between.
]

== The Laplace model and counting

The most basic pmf treats every outcome as equally likely.

#definition(title: "Laplace / uniform distribution")[
For a *finite* sample space $Omega$, the *Laplace* (or *uniform*) distribution $"Lap"_Omega$ has the constant pmf
$
p_(("Lap"_Omega)) : Omega -> [0, 1], quad omega |-> 1 / (|Omega|).
$
Every event then has probability
$
P(A) = (|A|) / (|Omega|) = "number of favorable outcomes" / "number of possible outcomes".
$
]

Under a Laplace model, computing a probability reduces to *counting the sizes of two finite sets*, which is combinatorics. The four standard counting schemes are captured by drawing $k$ times from an urn of $n$ distinguishable objects.

#lemma(name: "classical urn models")[
Draw $k in NN_(>0)$ times from an urn with $n in NN_(>0)$ distinct objects, writing $[n] := {1, dots, n}$. The number of possible outcomes is:
]

#table(
  columns: 3,
  align: (left, center, center),
  [*Draw scheme*], [*Sample space* $Omega$], [$|Omega|$],
  [ordered, with replacement], [$[n]^k$], [$n^k$],
  [ordered, without replacement], [${omega in [n]^k : omega_i eq.not omega_j "for" i eq.not j}$], [$n! / (n-k)!$],
  [unordered, without replacement], [${S subset.eq [n] : |S| = k}$], [$binom(n, k)$],
  [unordered, with replacement], [${a in NN_0^n : sum_(i=1)^n a_i = k}$], [$binom(n+k-1, k)$],
)

In the last row $a_i$ counts how often object $i$ was drawn. These four schemes cover a large range of sampling situations: generating a random password (ordered, with replacement), handing distinct prizes to distinct winners (ordered, without replacement), drawing lottery numbers (unordered, without replacement), and distributing identical resources among agents (unordered, with replacement).

#example(title: "at least one six in six dice")[
Throw six fair dice at once and ask for $p = P("at least one six")$. Model the throw as an ordered draw with replacement: $Omega = [6]^6$, so $|Omega| = 6^6$, under $"Lap"_Omega$. It is easier to count the *complement* $A^c = {"no die shows a six"} = [5]^6$, with $|A^c| = 5^6$. Hence
$
p = 1 - P(A^c) = 1 - (5^6) / (6^6) = 1 - (5/6)^6 approx 0.665.
$
Equivalently, the number of sixes is $"Bin"(6, 1/6)$-distributed and $p = 1 - P("Bin"(6, 1/6) = 0)$ — the bridge from raw counting to the named distributions below.
]

== The key discrete distributions

We now list the distributions you must recognize on sight. Throughout, $p in [0, 1]$ is a success probability and we (following the notes) reuse the letter $p$ for both the parameter and the pmf; the meaning is clear from context. We write $NN = {0, 1, 2, dots}$.

=== Bernoulli and the Bernoulli process

#definition(title: "Bernoulli distribution and Bernoulli process")[
For $p in [0, 1]$, the *Bernoulli distribution* $"Ber"(p)$ on $Omega = {0, 1}$ has pmf
$
p_(("Ber"(p)))(omega) = cases(p & "if" omega = 1\, (1 - p) & "if" omega = 0).
$
More generally, for $n in NN_(>0)$ the *Bernoulli process* $"Ber"(n, p)$ on $Omega = {0, 1}^n$ records the full sequence of $n$ independent trials:
$
p_(("Ber"(n, p)))(omega) = p^(sum_(i=1)^n omega_i) (1 - p)^(n - sum_(i=1)^n omega_i), quad omega = (omega_1, dots, omega_n).
$
]

$"Ber"(p)$ models a single binary trial (a biased coin flip, or whether a part passes inspection); $"Ber"(n, p)$ models $n$ such trials while remembering the exact outcome pattern.

=== Binomial distribution

#definition(title: "Binomial distribution")[
For $p in [0, 1]$ and $n in NN_(>0)$, the *binomial distribution* $"Bin"(n, p)$ on $Omega = {0, dots, n}$ has pmf
$
p_(("Bin"(n, p)))(k) = binom(n, k) p^k (1 - p)^(n - k).
$
]

$"Bin"(n, p)$ counts the *number of successes* in $n$ independent trials with success probability $p$ (e.g. the number of heads in $n$ coin flips). It arises from $"Ber"(n, p)$ by forgetting the order and keeping only the count $sum_i omega_i$: the factor $binom(n, k)$ counts the $binom(n, k)$ sequences with exactly $k$ ones.

=== Geometric and negative binomial distributions

#definition(title: "Geometric distribution")[
For $p in [0, 1]$, the *geometric distribution* $"Geo"(p)$ on $Omega = NN_(>0)$ has pmf
$
p_(("Geo"(p)))(k) = (1 - p)^(k - 1) p.
$
It models the number of trials *up to and including the first success* (e.g. how many customers arrive until the first sale).
]

#definition(title: "Negative binomial distribution")[
For $p in [0, 1]$ and $r in NN_(>0)$, the *negative binomial distribution* $"NegBin"(r, p)$ on $Omega = NN_(>=r)$ has pmf
$
p_(("NegBin"(r, p)))(k) = binom(k - 1, r - 1) p^r (1 - p)^(k - r).
$
Here $k$ is the *total number of trials needed to reach the $r$-th success* (e.g. free-throw attempts until a player makes $r$ baskets). In particular $"NegBin"(1, p) = "Geo"(p)$.
]

=== Poisson distribution

#definition(title: "Poisson distribution")[
For $lambda in RR_(>0)$, the *Poisson distribution* $"Poi"(lambda)$ on $Omega = NN$ has pmf
$
p_(("Poi"(lambda)))(k) = (e^(-lambda) lambda^k) / (k!).
$
It approximates the count of *rare events at a fixed rate* $lambda$ in a fixed interval (e.g. calls per hour at a switchboard). It is the limit of $"Bin"(n, lambda\/n)$ as $n -> infinity$: many trials, each individually unlikely.
]

=== Hypergeometric distribution

#definition(title: "Hypergeometric distribution")[
For $N in NN$, $K in {0, dots, N}$ and $n in {0, dots, N}$, the *hypergeometric distribution* $"Hyp"(N, K, n)$ on $Omega = {max(0, n + K - N), dots, min(n, K)}$ has pmf
$
p_(("Hyp"(N, K, n)))(k) = (binom(K, k) binom(N - K, n - k)) / (binom(N, n)).
$
It counts the number of "special" items when drawing $n$ items *without replacement* from a batch of $N$ containing $K$ special ones (e.g. defectives in a quality-control sample).
]

=== Discrete uniform distribution

The *discrete uniform distribution* is just $"Lap"_Omega$ on a finite $Omega$. On $Omega = {1, dots, n}$ it has pmf $p(k) = 1\/n$; it is the model for a fair die ($n = 6$), a fair spinner, or any equally-likely finite choice.

#keyfact[
The five wait-and-count distributions differ only in *what they count* and *how sampling is done* — this is the decision you must make in every exam problem:
- $"Ber"(p)$: outcome of *one* success/failure trial.
- $"Bin"(n, p)$: number of successes in a *fixed number* $n$ of independent trials (sampling *with* replacement / constant $p$).
- $"Geo"(p)$: number of trials *until the first* success.
- $"NegBin"(r, p)$: number of trials *until the $r$-th* success.
- $"Poi"(lambda)$: number of *rare events* in an interval at rate $lambda$.
- $"Hyp"(N, K, n)$: number of special items when sampling *without* replacement.
Rule of thumb: *fixed count of trials* $=>$ binomial/hypergeometric (with vs. without replacement); *wait for a success* $=>$ geometric/negative binomial.
]

== Summary table

The means and variances below are standard reference values; they are derived once expectation and variance are available (Chapter 6), and collected again in the distribution reference of Chapter 15.

#table(
  columns: 4,
  align: (left, center, center, center),
  [*Distribution*], [*pmf* $p(k)$], [$EE[X]$], [$"Var"(X)$],
  [Uniform on ${1, dots, n}$], [$1 / n$], [$(n + 1) / 2$], [$(n^2 - 1) / 12$],
  [$"Ber"(p)$], [$p^k (1 - p)^(1 - k)$], [$p$], [$p (1 - p)$],
  [$"Bin"(n, p)$], [$binom(n, k) p^k (1 - p)^(n - k)$], [$n p$], [$n p (1 - p)$],
  [$"Geo"(p)$], [$(1 - p)^(k - 1) p$], [$1 / p$], [$(1 - p) / p^2$],
  [$"NegBin"(r, p)$], [$binom(k - 1, r - 1) p^r (1 - p)^(k - r)$], [$r / p$], [$r (1 - p) / p^2$],
  [$"Poi"(lambda)$], [$(e^(-lambda) lambda^k) / (k!)$], [$lambda$], [$lambda$],
  [$"Hyp"(N, K, n)$], [$(binom(K, k) binom(N - K, n - k)) / binom(N, n)$], [$(n K) / N$], [$n (K / N) (1 - K / N) (N - n) / (N - 1)$],
)

#remark[
A few relationships worth remembering. The binomial is the count obtained from $"Ber"(n, p)$; $"Geo"(p) = "NegBin"(1, p)$; $"Poi"(lambda)$ is the $n -> infinity$ limit of $"Bin"(n, lambda\/n)$ (the *law of rare events*); and $"Hyp"(N, K, n)$ approaches $"Bin"(n, K\/N)$ when $N$ is large compared to $n$, because sampling with and without replacement then barely differ. Independence — the notion that makes "independent trials" precise — is developed in Chapter 5.
]

== Worked example

#example(title: "quality control: binomial, geometric, Poisson")[
A machine produces items that are defective independently with probability $p = 0.1$.

*(a) Binomial.* In a batch of $n = 10$ items, the number $X$ of defectives is $"Bin"(10, 0.1)$. The probability of exactly two defectives is
$
P(X = 2) = binom(10, 2) (0.1)^2 (0.9)^8 = 45 dot 0.01 dot 0.9^8 approx 0.194.
$

*(b) Geometric.* Testing items one by one, let $Y$ be the position of the first defective. Then $Y ~ "Geo"(0.1)$ and the first defective being the $4$-th item tested has probability
$
P(Y = 4) = (0.9)^3 (0.1) = 0.0729.
$

*(c) Poisson approximation.* Across a large lot of $n = 200$ items with the same small per-item rate, the expected number of defectives is $lambda = n p = 20$; the count is well approximated by $"Poi"(20)$, and e.g. $P("no defective") approx e^(-20)$. This is the law of rare events in action.
]

#quizblock(title: "Quiz — Discrete probability spaces & distributions")[
#question[What is a probability mass function, and in what precise sense does it determine the whole probability measure on a countable $Omega$?]
#answer[The pmf is $p : Omega -> [0, 1]$, $p(omega) = P({omega})$. Any function $p$ on a countable $Omega$ with $p >= 0$ and $sum_(omega in Omega) p(omega) = 1$ is a valid pmf, and it determines $P$ completely via $P(A) = sum_(omega in A) p(omega)$ for every $A subset.eq Omega$ (writing $A$ as a countable disjoint union of singletons and using $sigma$-additivity). So on a discrete space, "giving a pmf" and "giving a probability measure" are the same thing.]

#question[Why can we take $cal(A) = cal(P)(Omega)$ for a countable $Omega$, unlike in the uncountable case of Chapter 2?]
#answer[The measure problem (Vitali set) only obstructs putting a "useful" measure on the full power set of an *uncountable* space. For a countable $Omega$, every subset is a countable union of singletons, so $sum_(omega in A) p(omega)$ is always a well-defined $sigma$-additive assignment on all of $cal(P)(Omega)$. No smaller $sigma$-algebra is needed.]

#question[You draw $6$ numbers without replacement from ${1, dots, 49}$, order irrelevant (lotto). How many possible outcomes are there, and what is the probability of one fixed ticket under the Laplace model?]
#answer[This is the "unordered, without replacement" urn scheme, so $|Omega| = binom(49, 6) = 13 thin 983 thin 816$. Under $"Lap"_Omega$ each ticket has probability $P = 1\/binom(49, 6) approx 7.15 times 10^(-8)$. (Equivalently, the number of matches with the winning ticket is $"Hyp"(49, 6, 6)$-distributed.)]

#question[A fair coin is flipped $20$ times. Which distribution describes the number of heads, and what is the probability of getting exactly $10$ heads?]
#answer[The number of heads is $"Bin"(20, 1/2)$. Hence $P(X = 10) = binom(20, 10) (1/2)^20 = 184 thin 756 \/ 2^20 approx 0.176$.]

#question[A biased coin has $P("head") = 0.3$. What is the probability that the first head appears on the $4$-th toss, and which distribution is this?]
#answer[This is $"Geo"(0.3)$: $P(X = 4) = (1 - 0.3)^(4-1) dot 0.3 = 0.7^3 dot 0.3 = 0.1029$.]

#question[Explain the difference between $"Bin"(n, p)$ and $"Hyp"(N, K, n)$. When does the hypergeometric become approximately binomial?]
#answer[Both count "special" items in a sample of size $n$. $"Bin"(n, p)$ assumes sampling *with* replacement (equivalently, an infinite/very large population), so the success probability $p$ stays constant across draws. $"Hyp"(N, K, n)$ assumes sampling *without* replacement from a finite batch of $N$ with $K$ special items, so the probability shifts after each draw. When $N$ is large relative to $n$, the depletion is negligible and $"Hyp"(N, K, n) approx "Bin"(n, K\/N)$.]

#question[Give the pmf of $"Poi"(lambda)$, state one situation it models, and compute $P(X = 0)$.]
#answer[$p(k) = e^(-lambda) lambda^k \/ k!$ for $k in NN$, with $lambda > 0$. It models the count of rare events occurring at a constant rate $lambda$ over a fixed interval (e.g. phone calls per hour). Then $P(X = 0) = e^(-lambda) lambda^0 \/ 0! = e^(-lambda)$.]

#question[Quality control tests chips one by one until it finds the $r$-th defective; each chip is defective independently with probability $p$. Which distribution models the total number $X$ of chips tested, what is its support, and what is its expected value?]
#answer[$X ~ "NegBin"(r, p)$ with pmf $p(k) = binom(k-1, r-1) p^r (1-p)^(k-r)$ and support $Omega = NN_(>=r)$ (you need at least $r$ trials to see $r$ successes). Its mean is $EE[X] = r\/p$. The probability of a "batch of at most $m$ chips" is the cdf value $P(X <= m) = sum_(k=r)^m binom(k-1, r-1) p^r (1-p)^(k-r)$.]
]

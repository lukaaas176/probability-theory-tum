#import "../vorlage.typ": *

= Distribution reference and formula sheet

This chapter is a consolidated quick-reference. It gathers, in one place, every named distribution the course uses — the discrete families from Chapter 3 and the continuous families from Chapter 4 — together with cdf and quantile notation, conditional-moment identities, expectation and variance rules, inequalities, and limit theorems from earlier chapters. Nothing here is new: the parametrizations match the lecture notes exactly and each result is explained in its home chapter. Use this sheet for rapid recall before the exam; the two-line rules of thumb for #emph[choosing] a distribution are in the key-fact boxes of Chapters 3 and 4.

== Discrete distributions

Throughout, $p in [0, 1]$ is a success probability, $n, r in NN_(>0)$, and $lambda in RR_(>0)$; the geometric and negative-binomial rows require $p > 0$. For the hypergeometric $N in NN_(>0)$, $K in {0, dots, N}$ and $n in {0, dots, N}$. As in Chapter 3 we reuse the letter $p$ for both the parameter and the pmf, $k$ denotes the argument of the pmf, and $NN = {0, 1, 2, dots}$. Each row is a discrete probability measure on the stated support (its complement carries mass $0$).

#table(
  columns: 5,
  align: (left, left, left, center, center),
  [*Distribution*], [*Support*], [*pmf* $p(k)$], [$EE[X]$], [$"Var"(X)$],
  [Uniform on ${1, dots, n}$], [${1, dots, n}$], [$frac(1, n)$], [$frac(n + 1, 2)$], [$frac(n^2 - 1, 12)$],
  [$"Ber"(p)$], [${0, 1}$], [$p^k (1 - p)^(1 - k)$], [$p$], [$p (1 - p)$],
  [$"Bin"(n, p)$], [${0, dots, n}$], [$binom(n, k) p^k (1 - p)^(n - k)$], [$n p$], [$n p (1 - p)$],
  [$"Geo"(p)$], [$NN_(>0)$], [$(1 - p)^(k - 1) p$], [$frac(1, p)$], [$frac(1 - p, p^2)$],
  [$"NegBin"(r, p)$], [$NN_(>= r)$], [$binom(k - 1, r - 1) p^r (1 - p)^(k - r)$], [$frac(r, p)$], [$frac(r (1 - p), p^2)$],
  [$"Poi"(lambda)$], [$NN$], [$frac(e^(-lambda) lambda^k, k!)$], [$lambda$], [$lambda$],
  [$"Hyp"(N, K, n)$], [${max(0, n + K - N), dots, min(n, K)}$], [$frac(binom(K, k) binom(N - K, n - k), binom(N, n))$], [$frac(n K, N)$], [$n frac(K, N) (1 - frac(K, N)) frac(N - n, N - 1)$ $(N > 1)$],
)

#remark[
The discrete families are linked: $"Geo"(p) = "NegBin"(1, p)$; the binomial is the count $sum_i omega_i$ obtained by summing $n$ independent $"Ber"(p)$ trials; $"Poi"(lambda)$ is the $n -> infinity$ limit of $"Bin"(n, lambda\/n)$ (Chapter 3, law of rare events); and $"Hyp"(N, K, n) approx "Bin"(n, K\/N)$ when $N$ is large relative to $n$ (sampling with vs. without replacement barely differ).

For $N=1$, the hypergeometric distribution is deterministic and its variance is $0$; the formula in the table applies for $N>1$.
]

== Continuous distributions

Parameters range over $a < b$, $mu in RR$, $sigma > 0$, $alpha, beta > 0$, $lambda > 0$, $k in NN_(>0)$ and $nu > 0$. Each density is understood to be $0$ outside the stated support (the lecture notes write this explicitly with an indicator $bb(1)_Omega$). Two special functions appear in the densities below.

#definition(title: "Gamma and Beta functions")[
For $alpha, beta > 0$,
$
Gamma(alpha) = integral_0^infinity x^(alpha - 1) e^(-x) dif x, quad B(alpha, beta) = integral_0^1 x^(alpha - 1) (1 - x)^(beta - 1) dif x = frac(Gamma(alpha) Gamma(beta), Gamma(alpha + beta)).
$
The Gamma function extends the factorial, $Gamma(n) = (n - 1)!$ for $n in NN_(>0)$.
]

#table(
  columns: 5,
  align: (left, left, left, center, center),
  [*Distribution*], [*Support*], [*pdf* $p(x)$], [$EE[X]$], [$"Var"(X)$],
  [$"Unif"(a, b)$], [$[a, b]$], [$frac(1, b - a)$], [$frac(a + b, 2)$], [$frac((b - a)^2, 12)$],
  [$cal(N)(mu, sigma^2)$], [$RR$], [$frac(1, sqrt(2 pi) sigma) e^(-(x - mu)^2 \/ (2 sigma^2))$], [$mu$], [$sigma^2$],
  [$Gamma(alpha, beta)$], [$(0, infinity)$], [$frac(beta^alpha, Gamma(alpha)) x^(alpha - 1) e^(-beta x)$], [$frac(alpha, beta)$], [$frac(alpha, beta^2)$],
  [$"Exp"(lambda)$], [$(0, infinity)$], [$lambda e^(-lambda x)$], [$frac(1, lambda)$], [$frac(1, lambda^2)$],
  [$chi_k^2$], [$(0, infinity)$], [$frac(1, 2^(k\/2) Gamma(k\/2)) x^(k\/2 - 1) e^(-x\/2)$], [$k$], [$2 k$],
  [$t_nu$], [$RR$], [$frac(Gamma((nu + 1)\/2), sqrt(nu pi) Gamma(nu\/2)) (1 + x^2 \/ nu)^(-(nu + 1)\/2)$], [$0$ if $nu > 1$; undefined otherwise], [$frac(nu, nu - 2)$ if $nu > 2$; $oo$ if $1 < nu <= 2$; undefined otherwise],
  [$"Beta"(alpha, beta)$], [$[0, 1]$], [$frac(x^(alpha - 1) (1 - x)^(beta - 1), B(alpha, beta))$], [$frac(alpha, alpha + beta)$], [$frac(alpha beta, (alpha + beta)^2 (alpha + beta + 1))$],
)

#remark[
The continuous families are also nested: $"Exp"(lambda) = Gamma(1, lambda)$; $chi_k^2 = Gamma(k\/2, 1\/2)$; $"Unif"(0, 1) = "Beta"(1, 1)$; and $t_nu$ is the law of $Z \/ sqrt(W \/ nu)$ for independent $Z ~ cal(N)(0, 1)$ and $W ~ chi_nu^2$. The Gamma family uses the #emph[rate] parameter $beta$ (so its mean is $alpha\/beta$, not $alpha beta$); for the mean of $t_nu$ to exist we need $nu > 1$, and for its variance $nu > 2$.
]

== Distribution functions, quantiles, and conditioning

For a real-valued random variable $X$ and $q in (0,1)$, its cdf and generalized inverse are
$
F_X(x)=PP(X <= x), quad F_X^(-1)(q)=inf {x in RR : F_X(x) >= q}.
$
Every cdf is increasing and right-continuous, tends to $0$ and $1$ at the two infinities, and has jump
$
F_X(x)-F_X(x^-)=PP(X=x).
$
The value $F_X^(-1)(q)$ is the standard choice of $q$-quantile; $F_X^(-1)(1\/2)$ is a median. For $Z ~ cal(N)(0,1)$, the standard notation
$
Phi(z):=PP(Z <= z)
$
denotes the standard normal cdf.

#keyfact[
The two total laws from Chapter 6 are
$
EE[Y]=EE[EE[Y|X]],
$
$
"Var"(Y)=EE["Var"(Y|X)]+"Var"(EE[Y|X]).
$
The first averages conditional means; the second splits total variation into average within-group variation and variation between conditional means.
]

== Key formulas at a glance

The identities you reach for when computing with the distributions above. All are stated or derived in the referenced chapters; here they are collected as one-liners. Expectation and variance are linear/quadratic operations, the two tail inequalities bound probabilities using only $EE$ and $"Var"$, and the two limit theorems describe the average $macron(X)_n = frac(1, n) sum_(i=1)^n X_i$ of i.i.d. samples.

#table(
  columns: 3,
  align: (left, left, center),
  [*Result*], [*Statement*], [*Chapter*],
  [Linearity of $EE$], [$EE[a X + b Y] = a EE[X] + b EE[Y]$], [6],
  [Variance identity], [$"Var"(X) = EE[X^2] - (EE[X])^2$], [6],
  [Variance scaling], [$"Var"(a X + b) = a^2 "Var"(X)$], [6],
  [Variance of a sum], [$"Var"(X + Y) = "Var"(X) + "Var"(Y)$ if $X, Y$ independent], [5, 6],
  [LOTUS (discrete)], [$EE[g(X)] = sum_k g(k) p(k)$], [6],
  [LOTUS (continuous)], [$EE[g(X)] = integral_RR g(x) p(x) dif x$], [6],
  [Bayes' theorem], [$P(A | B) = frac(P(B | A) P(A), P(B))$], [5],
  [Total probability], [$P(B) = sum_i P(B | A_i) P(A_i)$ for a partition ${A_i}$], [5],
  [Markov's inequality], [$P(X >= a) <= frac(EE[X], a)$ for $X >= 0$, $a > 0$], [7],
  [Chebyshev's inequality], [$P(|X - EE[X]| >= a) <= frac("Var"(X), a^2)$, $a > 0$], [7],
  [(Weak) law of large numbers], [$macron(X)_n -> EE[X]$ in probability for i.i.d. integrable $X_i$], [9],
  [Central limit theorem], [$frac(macron(X)_n - mu, sigma \/ sqrt(n)) -> cal(N)(0, 1)$ in distribution for i.i.d. $X_i$ with $0 < sigma^2 < oo$], [9],
)

#keyfact[
Two moves cover most exam computations. To get any expectation of a #emph[function] of $X$, do not re-derive the distribution of $g(X)$ — apply LOTUS directly. To bound the probability of a deviation when you know only the mean (and variance), reach for Markov (one-sided, needs $X >= 0$) or Chebyshev (two-sided, uses the variance); both are the workhorses behind the law of large numbers in Chapter 9.
]

#remark[
Interactive companions — the Monty Hall simulator, a central-limit-theorem sampler, a change-of-variables visualizer, and live PMF/CDF and PDF/CDF explorers for every distribution in the tables above — live in the course's #emph[Additional material]. They are deliberately #emph[not] embedded here, so that this chapter stays a single, self-contained formula sheet.
]

#quizblock(title: "Quiz — Distribution reference")[
#question[State the pmf, mean and variance of $"Bin"(n, p)$, and say in one line what it counts.]
#answer[$p(k) = binom(n, k) p^k (1 - p)^(n - k)$ on ${0, dots, n}$, with $EE[X] = n p$ and $"Var"(X) = n p (1 - p)$. It counts the number of successes in $n$ independent trials, each with success probability $p$ (sampling with replacement / constant $p$).]

#question[Give the pmf and support of $"Poi"(lambda)$, its mean and variance, and one distribution it arises from as a limit.]
#answer[$p(k) = e^(-lambda) lambda^k \/ k!$ on $NN = {0, 1, 2, dots}$, with $EE[X] = "Var"(X) = lambda$ (mean and variance coincide). It is the $n -> infinity$ limit of $"Bin"(n, lambda\/n)$ — the law of rare events.]

#question[For $"Geo"(p)$, state the pmf, its support, and its mean and variance.]
#answer[$p(k) = (1 - p)^(k - 1) p$ on $NN_(>0) = {1, 2, 3, dots}$ (the trial of the first success), with $EE[X] = 1\/p$ and $"Var"(X) = (1 - p)\/p^2$. It is the special case $"NegBin"(1, p)$.]

#question[Write down the pdf of $cal(N)(mu, sigma^2)$ and its mean and variance. What is its support?]
#answer[$p(x) = frac(1, sqrt(2 pi) sigma) e^(-(x - mu)^2 \/ (2 sigma^2))$ on $RR$, with $EE[X] = mu$ and $"Var"(X) = sigma^2$. The parameter is the variance $sigma^2$, not the standard deviation.]

#question[State the pdf, mean and variance of $"Exp"(lambda)$, and relate it to the Gamma family.]
#answer[$p(x) = lambda e^(-lambda x)$ on $(0, infinity)$, with $EE[X] = 1\/lambda$ and $"Var"(X) = 1\/lambda^2$. It is the special case $"Exp"(lambda) = Gamma(1, lambda)$ and models the waiting time to the first event of a rate-$lambda$ Poisson process.]

#question[Give the pdf and support of $"Beta"(alpha, beta)$, its mean, and the special case that recovers a uniform law.]
#answer[$p(x) = frac(x^(alpha - 1) (1 - x)^(beta - 1), B(alpha, beta))$ on $[0, 1]$, with $EE[X] = frac(alpha, alpha + beta)$ and $"Var"(X) = frac(alpha beta, (alpha + beta)^2 (alpha + beta + 1))$. The uniform distribution $"Unif"(0, 1)$ is the special case $"Beta"(1, 1)$.]

#question[How does the chi-squared distribution $chi_k^2$ relate to the Gamma distribution and to normal variables, and what are its mean and variance?]
#answer[$chi_k^2 = Gamma(k\/2, 1\/2)$ with density $frac(1, 2^(k\/2) Gamma(k\/2)) x^(k\/2 - 1) e^(-x\/2)$ on $(0, infinity)$; it is the law of a sum of $k$ squared independent standard normals. Its mean is $k$ and its variance is $2 k$.]

#question[State Markov's and Chebyshev's inequalities, and give the LOTUS formula for $EE[g(X)]$ in the continuous case.]
#answer[Markov: for $X >= 0$ and $a > 0$, $P(X >= a) <= EE[X] \/ a$. Chebyshev: for $a > 0$, $P(|X - EE[X]| >= a) <= "Var"(X) \/ a^2$. LOTUS (continuous): $EE[g(X)] = integral_RR g(x) p(x) dif x$, so you never need the distribution of $g(X)$ itself.]
]

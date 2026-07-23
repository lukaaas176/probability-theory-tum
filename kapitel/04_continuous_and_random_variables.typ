#import "../vorlage.typ": *

= Densities, continuous distributions, and random variables

Chapter 3 built distributions on at-most-countable sample spaces, where a probability measure is completely described by a probability mass function. Many quantities of interest — a waiting time, a measurement error, a height — are naturally modelled on $RR$ (or $RR^n$), where no single outcome carries positive probability. The right tool there is a #emph[density]. This chapter introduces densities and continuous distributions, and then the central abstraction of the whole course: the #emph[random variable].

== Probability density functions

#definition(title: "probability density function")[
Let $(Omega, cal(A), mu)$ be a measure space. A #emph[(probability) density function] (pdf) on $(Omega, cal(A), mu)$ is a $mu$-integrable function $p: Omega -> RR_(>=0)$ with
$
integral p dif mu = 1.
$
Throughout this course the underlying measure space is $(RR^n, cal(B)^n, lambda^n)$ with the $n$-dimensional Lebesgue measure $lambda^n$, so a pdf is simply a function $p: RR^n -> RR_(>=0)$ with
$
integral_(RR^n) p(x) dif x = integral_(-oo)^oo dots.c integral_(-oo)^oo p(x_1, dots, x_n) dif x_1 dots dif x_n = 1.
$
]

#remark[
All densities in this course are taken with respect to the Lebesgue measure $lambda^n$ on $RR^n$. The Lebesgue integral is more general than the familiar Riemann integral (it handles functions with many discontinuities), but whenever both exist they agree, so for computations you may integrate as usual. We deliberately skip the measure-theoretic technicalities of integration.
]

A density does not itself assign probabilities to events — it #emph[induces] a probability measure by integration.

#proposition(name: "density-induced probability measure")[
Let $p: RR^n -> RR_(>=0)$ be a probability density function. Then
$
cal(B)^n -> [0, 1], quad A |-> integral_(RR^n) p(x) dot chi_A (x) dif x
$
uniquely defines a probability measure on $(RR^n, cal(B)^n)$, the #emph[probability measure induced by $p$]. Here $chi_A$ is the indicator function, $chi_A (x) = 1$ if $x in A$ and $chi_A (x) = 0$ otherwise.
]

Which probability measures arise this way? Exactly the ones that do not put mass where length/area/volume is zero.

#theorem(name: "Radon–Nikodym for " + $RR^n$)[
Let $P$ be a probability measure on $(RR^n, cal(B)^n)$. The following are equivalent:
+ $P lt.double lambda^n$ ($P$ is #emph[absolutely continuous] with respect to $lambda^n$): for every $A in cal(B)^n$ with $lambda^n (A) = 0$ we also have $P(A) = 0$.
+ There exists a probability density function $p: RR^n -> RR_(>=0)$ inducing $P$.

When these hold, $(RR^n, cal(B)^n, P)$ is called a #emph[continuous probability space], and $p$ is the (Lebesgue) density of $P$.
]

For $n = 1$ the density and the cumulative distribution function determine each other by integration and differentiation.

#lemma(name: "pdf and cdf")[
Let $P$ be a probability measure on $(RR, cal(B))$ with cdf $F$.
+ If $p$ is a pdf of $P$, then $F(x) = integral_(-oo)^x p(y) dif y$.
+ If $F$ is (weakly) differentiable, then $p := F'$ is a corresponding pdf of $P$.
]

#keyfact[
In one dimension: #emph[the cdf is the integral of the pdf, and the pdf is the derivative of the cdf.] Probabilities of intervals are areas under the density,
$
P(a <= X <= b) = integral_a^b p(x) dif x,
$
so for a continuous distribution every single point has probability $0$: $P(X = c) = 0$.
]

== Random variables

So far we assigned probabilities to subsets of one fixed $Omega$. Usually we care about some numerical quantity #emph[derived] from the outcome — this is a random variable.

#definition(title: "measurable map, random variable")[
Let $(Omega, cal(A))$ and $(Omega', cal(A)')$ be measurable spaces. A map $X: Omega -> Omega'$ is #emph[measurable] (with respect to $cal(A)$ and $cal(A)'$) if
$
X^(-1)(A') in cal(A) quad "for all " A' in cal(A)'.
$
If $(Omega, cal(A), P)$ is a probability space, such a measurable map $X$ is a #emph[random variable] on it. For $(Omega', cal(A)') = (RR, cal(B))$ we call $X$ a #emph[real-valued random variable] (RV); for $(RR^n, cal(B)^n)$ a #emph[random vector].
]

The measurability condition is exactly what we need so that "$X$ lands in $A'$" is an event we can assign a probability to. We write, increasing sloppiness as we go,
$
{X in A'} := {omega in Omega : X(omega) in A'} = X^(-1)(A'), quad {X <= c} := {omega in Omega : X(omega) <= c},
$
and eventually just $P(X <= c)$ instead of $P({X <= c})$ — but under the hood this is always the probability of an event $A subset.eq Omega$.

#definition(title: "distribution of a random variable")[
Let $X: Omega -> Omega'$ be a random variable on $(Omega, cal(A), P)$. Then
$
P_X : cal(A)' -> [0, 1], quad A' |-> P(X^(-1)(A')) = P({X in A'})
$
is a probability measure on $(Omega', cal(A)')$, the #emph[(probability) distribution] (or #emph[law]) of $X$. We say $X$ #emph[follows] $P_X$ and write $X tilde P_X$ (e.g. $X tilde cal(N)(0, sigma^2)$).
]

The distribution $P_X$ is the pushforward $P compose X^(-1)$ of $P$ along $X$. Two more notions we will use constantly:

#definition(title: "identically distributed, cdf and pdf of an RV")[
Random variables $(X_i)_(i in I)$ are #emph[identically distributed] if $P_(X_i) = P$ for the same law $P$ and all $i$ (their base spaces may differ). For a real-valued RV $X$, its #emph[cumulative distribution function] is $F_X := F_(P_X)$, and if $F_X$ is (weakly) differentiable — so $P_X$ is continuous — its #emph[probability density function] is $p_X := F_X'$.
]

#corollary[
Real-valued random variables are identically distributed if and only if they have the same cdf (equivalently, when they exist, the same pdf).
]

#remark[
Once we speak of a random variable we usually stop caring about the underlying $(Omega, cal(A), P)$ and where it came from — all that matters is the distribution $P_X$. Machine-learning setups routinely begin "let $X$ be a random variable following $P dots$" with no mention of $Omega$ at all. Because every RV induces a probability measure, all results for probability measures transfer directly to random variables. This is why we usually think of a real-valued RV directly through the pdf (or cdf) of its distribution; the density is also called the #emph[Radon–Nikodym derivative] of $P_X$ with respect to $lambda^n$ (and, for discrete $X$, with respect to the counting measure, giving the pmf of Chapter 3).
]

== Common continuous distributions

Two special functions recur in the definitions below.

#definition(title: "Gamma and Beta functions")[
$
Gamma(alpha) = integral_0^oo x^(alpha - 1) e^(-x) dif x quad (alpha > 0), quad quad
B(alpha, beta) = integral_0^1 x^(alpha - 1) (1 - x)^(beta - 1) dif x = (Gamma(alpha) Gamma(beta)) / Gamma(alpha + beta) quad (alpha, beta > 0).
$
$Gamma$ extends the factorial: $Gamma(n) = (n - 1)!$ for $n in NN_(>0)$.
]

#example(title: "the standard continuous distributions")[
Each is given by its pdf on $Omega subset.eq RR$ (extended by $0$ outside $Omega$ via the indicator $chi_Omega$).
- #emph[Uniform] $"Unif"(a, b)$, $a < b$, on $[a, b]$: $ p(x) = chi_([a,b])(x) dot 1 / (b - a). $ Every point in $[a, b]$ is equally likely (a random time between two deadlines).
- #emph[Normal / Gaussian] $cal(N)(mu, sigma^2)$, $sigma > 0$, on $RR$: $ p(x) = 1 / (sqrt(2 pi) sigma) exp(- (x - mu)^2 / (2 sigma^2)). $ Models natural variability and measurement noise; the most important continuous distribution.
- #emph[Exponential] $"Exp"(lambda) = Gamma(1, lambda)$, $lambda > 0$, on $RR_(>0)$: $ p(x) = chi_(RR_(>0))(x) dot lambda e^(- lambda x). $ Time until the first event of a rate-$lambda$ Poisson process (next bus, length of a call).
- #emph[Gamma] $Gamma(alpha, beta)$, $alpha, beta > 0$, on $RR_(>0)$: $ p(x) = chi_(RR_(>0))(x) dot beta^alpha / Gamma(alpha) x^(alpha - 1) e^(- beta x). $ Waiting time for $alpha$ events at rate $beta$.
- #emph[Chi-squared] $chi_k^2 = Gamma(k/2, 1/2)$, $k > 0$ degrees of freedom, on $RR_(>0)$: sum of squares of $k$ independent standard normals; central in variance-based testing (Chapter 12).
- #emph[Student's $t$] $t_nu$, $nu > 0$, on $RR$: $ p(x) = (Gamma((nu + 1)/2)) / (sqrt(nu pi) Gamma(nu/2)) (1 + x^2 / nu)^(- (nu + 1) / 2). $ Heavier-tailed than the Gaussian; small-sample inference on a mean with unknown variance (Chapter 13).
- #emph[Beta] $"Beta"(alpha, beta)$, $alpha, beta > 0$, on $[0, 1]$: $ p(x) = chi_([0,1])(x) dot (x^(alpha - 1) (1 - x)^(beta - 1)) / B(alpha, beta). $ Models random proportions; $"Unif"(0,1) = "Beta"(1, 1)$. It is the natural conjugate prior for a probability (Chapter 14).
]

#keyfact[
The three you must know cold are the #emph[Uniform], the #emph[Exponential] (memoryless; the continuous analogue of the geometric distribution), and the #emph[Normal]. Their pdfs, means and variances are collected in the reference sheet in Chapter 15.
]

#remark[
All these densities are deliberately defined on all of $RR$, with the indicator $chi_Omega$ restricting the support. Many further distributions (log-normal, Cauchy, Weibull, …) arise via transformations, mixtures or limits of the ones above — the machinery for that is Chapter 8. As George Box put it, #emph["all models are wrong, but some are useful"]: modelling a person's height as $cal(N)(mu, sigma^2)$ literally allows negative heights with positive probability, yet can still nail the inference you actually care about.
]

#example(title: "computing a probability")[
For $X tilde cal(N)(mu, sigma^2)$ the probability of landing in $[a, b]$ is $P(a <= X <= b) = integral_a^b p_X (x) dif x$; there is no elementary closed form, so one standardizes to $Z = (X - mu) / sigma tilde cal(N)(0, 1)$ and reads $Phi$, the standard normal cdf, from a table: $P(a <= X <= b) = Phi((b - mu)/sigma) - Phi((a - mu)/sigma)$.
]

#quizblock(title: "Quiz — Continuous distributions and random variables")[
#question[What two conditions must a function $p: RR^n -> RR$ satisfy to be a probability density function?]
#answer[$p(x) >= 0$ for all $x$ (non-negativity) and $integral_(RR^n) p(x) dif x = 1$ (it integrates to one). It then induces a probability measure via $A |-> integral p dot chi_A dif x$.]

#question[For a continuous real-valued random variable $X$, what is $P(X = c)$ for a fixed $c in RR$, and why?]
#answer[$P(X = c) = 0$, because $P(X = c) = integral_c^c p_X (x) dif x = 0$. Probability comes only from intervals of positive length; individual points carry no mass. (This is why $P(a <= X <= b) = P(a < X < b)$ for continuous $X$.)]

#question[State the relationship between the pdf $p_X$ and the cdf $F_X$ of a real-valued random variable.]
#answer[$F_X (x) = integral_(-oo)^x p_X (y) dif y$ and, where $F_X$ is differentiable, $p_X = F_X'$. In words: the cdf is the integral of the pdf, and the pdf is the derivative of the cdf.]

#question[Precisely, what does it mean for a map $X: Omega -> Omega'$ to be a random variable, and what is its distribution $P_X$?]
#answer[$X$ must be #emph[measurable]: $X^(-1)(A') in cal(A)$ for every $A' in cal(A)'$, so that ${X in A'}$ is always an event. Its distribution is the pushforward $P_X (A') = P(X^(-1)(A')) = P({X in A'})$, a probability measure on $(Omega', cal(A)')$.]

#question[The Radon–Nikodym theorem characterizes which probability measures $P$ on $(RR^n, cal(B)^n)$ have a density. What is the condition?]
#answer[$P$ has a Lebesgue density if and only if $P lt.double lambda^n$, i.e. $P$ is absolutely continuous with respect to Lebesgue measure: whenever $lambda^n (A) = 0$ we also have $P(A) = 0$. The density is the Radon–Nikodym derivative $dif P slash dif lambda^n$.]

#question[Write down the pdf of the exponential distribution $"Exp"(lambda)$ and say what it models.]
#answer[$p(x) = lambda e^(-lambda x)$ for $x > 0$ (and $0$ otherwise), with rate $lambda > 0$. It models the waiting time until the first event of a Poisson process of rate $lambda$ (e.g. time until the next bus). It is memoryless.]

#question[Let $X tilde cal(N)(mu, sigma^2)$. How do you compute $P(a <= X <= b)$ using the standard normal cdf $Phi$?]
#answer[Standardize: $Z = (X - mu)/sigma tilde cal(N)(0,1)$, so $P(a <= X <= b) = Phi((b - mu)/sigma) - Phi((a - mu)/sigma)$. There is no elementary antiderivative of the Gaussian density, hence the use of the tabulated $Phi$.]

#question[Two real-valued random variables have the same cumulative distribution function. Must they be identically distributed? Must they be equal?]
#answer[They must be identically distributed — same cdf $arrow.l.r.double$ same law $P_X$ (Corollary). They need #emph[not] be equal as functions: identically distributed random variables can live on different probability spaces and take different values outcome by outcome; only their distributions coincide.]
]

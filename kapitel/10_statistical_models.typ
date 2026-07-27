#import "../vorlage.typ": *

= Statistical models and basic concepts

The previous chapters played a fixed game: we #emph[assumed] a probability distribution — say $X tilde cal(N)(mu, sigma^2)$ with #emph[known] $mu$ and $sigma^2$ — and computed probabilities of events or properties of random variables from it. This direction, from a fully specified model to statements about outcomes, is #emph[deductive inference] and is exactly what "probability" has meant so far. Statistics runs the arrow backwards. We are handed #emph[data] — the observed values $x_1, dots, x_n$ of some random experiment — and we want to say something about the (usually unknown) distribution or the parameters that generated them. This is #emph[inductive inference]: we #emph[learn from data]. This chapter fixes the vocabulary — statistical model, sample, statistic, estimator, parameter of interest, identifiability and likelihood — on which Chapters 11–14 (point estimation, hypothesis testing, interval estimation, and the Bayesian vs. frequentist divide) are built.

== From probability to statistics

Picture two clouds. On the left sit #emph[general principles]: the assumed ground truth, the population, the full distribution. On the right sit #emph[specific instances]: the concrete manifestations, the samples, the data. Probability theory is the arrow from left to right: given the model, what do the data look like? Statistical inference is the arrow from right to left: given the data, what was the model? The two are inverse activities on the same pair of objects.

#keyfact[
*Deductive inference (probability)* goes from a known distribution to the behaviour of data. *Inductive inference (statistics)* goes from observed data back to the unknown distribution — or to the parameters — that generated them. In statistics the data $x_1, dots, x_n$ are treated as #emph[realizations] of random variables $X_1, dots, X_n$, and inference is the attempt to reason from these realizations to the model behind them.
]

#remark[
The word *inference* is used differently in statistics and machine learning. Statistical inference learns unknown population or model properties from observed data, including uncertainty about those properties. In machine learning, “inference time” usually means applying an already trained model to new inputs — what statistics would ordinarily call *prediction*. Fitting model parameters is statistical inference but is usually called *training* in machine learning.
]

#example(title: "what we want from statistical inference")[
Suppose we observe a sequence of $n$ coin flips $x_1, dots, x_n in {0, 1}$ (with $1$ = heads). Three natural questions already preview the next three chapters:
- #emph[Point estimation] (Chapter 11): what is the probability $theta$ of heads for this coin — a single best guess?
- #emph[Hypothesis testing] (Chapter 12): can we decide, with some confidence, whether the coin is fair ($theta = 1\/2$) against the alternative that it is biased?
- #emph[Interval estimation] (Chapter 13): what is a plausible #emph[range] of values for $theta$, and how confident are we in it?

The same template covers quality control: an NVMe-drive maker promises that at most $1$ in $10000$ drives fails in the first year; after selling many drives and observing a handful of failures, may the buyer sue? We rarely get to answer such questions with a flat "yes" or "no"; inductive inference forces us to speak in #emph[levels of confidence] rather than certainties.
]

The first move is always a #emph[modelling choice]. Before any computation we must decide what #emph[not] to model and which possibilities we deem plausible — that is, we must fix a "collection of possibilities" that we believe contains (or at least approximates) the truth. This collection is the statistical model.

== The statistical model

#definition(title: "Statistical model")[
Let $(Omega, cal(A))$ be a measurable sample space and let $Theta$ be a non-empty index set, called the *parameter space*. For a family of probability distributions
$
P_Theta := (P_theta)_(theta in Theta) = { P_theta : theta in Theta } quad "on" (Omega, cal(A)),
$
the triple $(Omega, cal(A), P_Theta)$ is called a *statistical model*. When the underlying sample space and $sigma$-algebra are clear from context, we often simply call $P_Theta$ the statistical model.
]

The difference from a probability space is exactly the plural: instead of one fixed measure $PP$ we carry a whole #emph[family] $(P_theta)_(theta in Theta)$ of candidate distributions, one for each parameter value $theta in Theta$, and inference is the task of deciding which member of the family the data favour.

#definition(title: "Well-specified and mis-specified models")[
A statistical model is *well-specified* if there exists a $theta in Theta$ such that $P_theta$ is the true distribution of the random experiment; this $theta$ is then called the *true parameter*. In other words, the ground truth lies inside the specified space of possibilities. Otherwise the model is called *mis-specified*.
]

Whenever a random variable $X$ satisfies $X tilde P_theta$ for some $theta in Theta$, we say that $X$ #emph[follows] or is #emph[distributed according to] the model, and write (in a mild abuse of notation) $X tilde P_Theta$.

#keyfact[
The central object of all statistics is the family $ { P_theta : theta in Theta } $. Probability theory works #emph[inside] one member $P_theta$; statistics reasons #emph[across] the family to identify the member — or the parameter $theta$ — responsible for the observed data.
]

=== Parametric and non-parametric models

#definition(title: "Parametric and non-parametric models")[
If $Theta subset.eq RR^k$ for some finite $k in NN_(>0)$, the model is called *parametric*. Otherwise it is called *non-parametric*. A common characterization is that a model is non-parametric whenever $Theta$ is "infinite-dimensional" — for instance the set of #emph[all] continuous distributions. Non-parametric models impose very few restrictions on the admitted distributions; this course focuses almost exclusively on parametric models.
]

#example(title: "parametric models")[
Each situation is modelled by choosing a family from the distribution zoo of Chapters 3 and 4:
- #emph[Coin flips.] $(Omega = {0, 1}, cal(A) = cal(P)({0, 1}), ("Ber"(theta))_(theta in [0, 1]))$, so $Theta = [0, 1]$ and $theta$ is the probability of heads.
- #emph[Defective screws in a bag of $50$.] $(Omega = {0, dots, 50}, cal(P)(Omega), ("Bin"(50, theta))_(theta in [0, 1]))$.
- #emph[Phone calls per $15$-minute interval.] $(NN, cal(P)(NN), ("Poi"(lambda))_(lambda in RR_(>0)))$.
- #emph[Subway waiting time.] $(RR, cal(B), ("Unif"(0, theta))_(theta in RR_(>0)))$.
- #emph[Light-bulb lifetime.] $(RR, cal(B), ("Exp"(lambda))_(lambda in RR_(>0)))$.
- #emph[Filling amount of a bottling machine.] $(RR, cal(B), (cal(N)(mu, sigma^2))_((mu, sigma^2) in RR times RR_(>0)))$, a two-parameter model with $theta = (mu, sigma^2)$.
]

#remark[
Models are routinely "wrong" yet useful. The Gaussian bottling model above assigns positive probability to negative fill volumes, which are physically impossible, so strictly speaking no $theta$ makes it exactly true and the model is mis-specified. We nevertheless use it because it captures the relevant behaviour well enough. The art of modelling is choosing a family rich enough to contain a good approximation of the truth, yet simple enough to reason about.
]

== Samples and statistics

We almost always observe not one but $n$ data points. Modelling them jointly requires a sample space for the whole collection.

#definition(title: "Random sample")[
A *random sample* of size $n$ is a random vector $(X_1, dots, X_n)$ taking values in the product space $(Omega^n, cal(A)^(⊗ n))$, where $cal(A)^(⊗ n)$ denotes the $n$-fold product $sigma$-algebra. In the vast majority of cases we assume the components are *independent and identically distributed* (*i.i.d.*): each $X_i tilde P_theta$ with the #emph[same] true parameter $theta$, and the $X_i$ are mutually independent. The observed values $x = (x_1, dots, x_n)$ are the *realizations* of this sample.
]

Everything we compute from the data is a #emph[function] of the sample. Such functions get their own name.

#definition(title: "Statistic")[
Let $(Omega, cal(A), P_Theta)$ be a statistical model and $(X_1, dots, X_n)$ a random sample. A *statistic* is a measurable function
$
T : Omega^n -> RR^k quad "for some" k in NN_(>0)
$
that *does not depend on the unknown parameter* $theta$. Its value $t = T(x_1, dots, x_n)$ is computed from the realized data $x = (x_1, dots, x_n)$.
]

The defining restriction — no dependence on $theta$ — is what makes a statistic #emph[usable]: since we never know the true $theta$, only quantities we can actually evaluate from the data alone qualify. A statistic is an #emph[observable] quantity once the data are collected.

#example(title: "statistics")[
For a real-valued sample $X_1, dots, X_n$:
- the *sample mean* $accent(X, macron)_n := frac(1, n) sum_(i=1)^n X_i$;
- for $n >= 2$, the *sample variance* $S_n^2 := frac(1, n - 1) sum_(i=1)^n (X_i - accent(X, macron)_n)^2$ (the division by $n - 1$, rather than $n$, is #emph[Bessel's correction]);
- the *maximum* $X_((n)) := max(X_1, dots, X_n)$;
- even a constant such as $T(X_1, dots, X_n) = pi$, or (when $n >= 6$) a single coordinate $T(X_1, dots, X_n) = X_6$, is technically a statistic.

The sample mean and sample variance are the data-side analogues of the expectation and variance of Chapter 6, and by the laws of large numbers (Chapter 9) they approach their theoretical counterparts as $n$ grows.
]

#remark[
The sample size $n$ is #emph[implicit] in the definition: a statistic is really defined for a fixed $n$. When we want to vary $n$ we write $T_n$ to make the dependence explicit — as in $accent(X, macron)_n$ — but note that not every statistic has a natural "version for any $n$" (the constant $pi$ trivially does, the coordinate $X_6$ does not).
]

A statistic becomes an #emph[estimator] the moment we use it as a guess for an unknown quantity.

#definition(title: "Estimator and estimate")[
An *estimator* for an unknown quantity of interest — formally, a #emph[parameter of interest] $gamma$, defined below — is a statistic $hat(gamma) = T(X_1, dots, X_n)$; being a statistic, it may not depend on the unknown parameter. The concrete value $hat(gamma)_"obs" := hat(gamma)(x) = T(x_1, dots, x_n)$ obtained on a particular realization $x$ is called an *estimate*.
]

Any statistic is a #emph[valid] estimator; whether it is a #emph[good] one — unbiased, low-variance, consistent — is the subject of Chapter 11, which also introduces the maximum-likelihood recipe for constructing estimators.

== Parameters of interest and identifiability

Often we do not care about the entire parameter $theta$, only about some feature of it.

#definition(title: "Parameter of interest")[
A *parameter of interest* is a function $gamma : Theta -> RR^k$. The goal of statistical inference is then to make statements about the value $gamma(theta)$. Taking $gamma = "id"$ (the identity) recovers the full parameter $theta$ as a special case.
]

#example(title: "parameters of interest in a Gaussian model")[
In the model $(RR, cal(B), (cal(N)(mu, sigma^2))_((mu, sigma^2) in RR times RR_(>0)))$ with $theta = (theta_1, theta_2) = (mu, sigma^2)$, we might be interested only in
- the mean, $gamma(theta) = theta_1 = mu$; or
- the variance, $gamma(theta) = theta_2 = sigma^2$; or
- when $mu > 0$, the *coefficient of variation* $gamma(theta) = sqrt(theta_2) \/ theta_1 = sigma \/ mu$.

Most of the time we simply take $gamma = "id"$, so that the parameter of interest is all of $theta$.
]

Some parameters can never be pinned down, no matter how much data we collect. The concept that rules this out is identifiability.

#definition(title: "Identifiability")[
A parameter of interest $gamma$ (possibly the full parameter $theta$) is *identifiable* in the model $(Omega, cal(A), P_Theta)$ if
$
gamma(theta) != gamma(theta') quad ==> quad P_theta != P_(theta') quad "for all" theta, theta' in Theta,
$
or, equivalently by contraposition, if $P_theta = P_(theta')$ implies $gamma(theta) = gamma(theta')$. If a parameter of interest is not identifiable, it is impossible to determine its value uniquely #emph[even with an infinite amount of data], and we call it *unidentifiable*.
]

#example(title: "identifiability in a Gaussian model")[
Let $X = A + B$ with independent $A tilde cal(N)(mu_A, 1)$ and $B tilde cal(N)(mu_B, 1)$, so that $X tilde cal(N)(mu_A + mu_B, 2)$ and $theta = (mu_A, mu_B) in RR^2$. The full parameter $theta$ is #emph[not] identifiable: for instance $theta = (1, 2)$ and $theta = (2, 1)$ yield the very same distribution $cal(N)(3, 2)$ for $X$, so no amount of data on $X$ can distinguish them. The parameter of interest $gamma(theta) = mu_A + mu_B$, however, #emph[is] identifiable, since equal distributions force equal means.
]

== The likelihood function

Identifiability tells us #emph[whether] the data can, in principle, reveal a parameter. The likelihood tells us #emph[how strongly] a given data set points to each candidate value. It is the bridge from "given the distribution, how probable are the data?" to "given the data, which distribution?".

#definition(title: "Likelihood and log-likelihood")[
Let $(X_1, dots, X_n)$ be a random sample from a statistical model $(Omega, cal(A), P_Theta)$ in which every $P_theta$ has a probability mass function or density $p_theta (dot) =: p(dot | theta)$. Given observed data $x = (x_1, dots, x_n)$, the *likelihood function* is
$
L(dot | x) : Theta -> RR_(>= 0), quad theta |-> L(theta | x) := p_theta (x) = p(x_1, dots, x_n | theta).
$
If $X_1, dots, X_n$ are i.i.d., the joint mass/density factorizes and
$
L(theta | x) = product_(i=1)^n p(x_i | theta).
$
The *log-likelihood function* is $ell(theta | x) := ln(L(theta | x))$, which for an i.i.d. sample turns the product into a sum, $ell(theta | x) = sum_(i=1)^n ln p(x_i | theta)$.
]

#keyfact[
The likelihood $L(theta | x)$ is a function of the *parameter* $theta$, with the data $x$ held fixed — #emph[not] a function of $x$, and #emph[not] a probability density over $theta$ (it need not integrate to $1$ in $theta$). It exists only #emph[relative to observed data]. The notation $p(x | theta)$ and $L(theta | x)$ merely emphasizes "what is fixed and what varies". Taking the logarithm is convenient because it turns products into sums and, being strictly increasing, leaves the maximizing $theta$ unchanged.
]

Maximizing $L(theta | x)$ — equivalently $ell(theta | x)$ — over $theta$ amounts to finding the model that is "most likely to have generated the data". That optimization defines the #emph[maximum-likelihood estimator], studied systematically in Chapter 11; here we only set up the function it maximizes.

#example(title: [likelihood for coin flips — Bernoulli($theta$)])[
Model $n$ coin flips as an i.i.d. sample $X_1, dots, X_n tilde "Ber"(theta)$ with $Theta = [0, 1]$, so the single-flip mass function is $p(x_i | theta) = theta^(x_i) (1 - theta)^(1 - x_i)$ for $x_i in {0, 1}$. Writing $k = sum_(i=1)^n x_i$ for the number of heads observed, the likelihood is
$
L(theta | x) = product_(i=1)^n theta^(x_i) (1 - theta)^(1 - x_i) = theta^(sum_(i=1)^n x_i) (1 - theta)^(n - sum_(i=1)^n x_i) = theta^k (1 - theta)^(n - k),
$
and the log-likelihood is
$
ell(theta | x) = k ln(theta) + (n - k) ln(1 - theta).
$
As a function of $theta$ this is maximized at $theta = k \/ n = accent(x, macron)_n$, the observed fraction of heads — the intuitive "best guess" for the coin's bias, and (as Chapter 11 will confirm) exactly its maximum-likelihood estimate.
]

#example(title: "likelihood for a normal distribution")[
For an i.i.d. sample $X_1, dots, X_n tilde cal(N)(mu, sigma^2)$ the single-observation density is $p(x_i | mu, sigma^2) = (2 pi sigma^2)^(-1\/2) exp(- frac((x_i - mu)^2, 2 sigma^2))$, so
$
L(mu, sigma^2 | x) = product_(i=1)^n (2 pi sigma^2)^(-1\/2) exp(- frac((x_i - mu)^2, 2 sigma^2)) = (2 pi sigma^2)^(-n\/2) exp(- frac(1, 2 sigma^2) sum_(i=1)^n (x_i - mu)^2),
$
and the log-likelihood collapses to a manageable sum,
$
ell(mu, sigma^2 | x) = - n/2 ln(2 pi) - n/2 ln(sigma^2) - frac(1, 2 sigma^2) sum_(i=1)^n (x_i - mu)^2.
$
The log form makes the dependence on $mu$ and $sigma^2$ transparent and is the starting point for maximum-likelihood estimation in Chapter 11.
]

#remark[
A statistical model, as defined here, carries no $n$: it describes a single random experiment. Statistics, however, is all about inference from $n$ observations $x = (x_1, dots, x_n)$. The bridge is exactly the i.i.d. viewpoint: we regard each $X_i$ as an independent draw from the #emph[same] model $X_i tilde P_theta$. This is why we cheerfully write $X tilde P_Theta$ even when $X = (X_1, dots, X_n)$ already bundles $n$ components. With this vocabulary in place — model, sample, statistic, estimator, parameter of interest, identifiability and likelihood — Chapters 11–14 turn the abstract goal "learn $theta$ from data" into concrete procedures.
]

#quizblock(title: "Quiz — Statistical models")[
#question[Explain the difference between deductive inference (probability) and inductive inference (statistics), and say which one "learns from data".]
#answer[Deductive inference starts from a fully specified distribution and computes the behaviour of outcomes/data — the direction of probability theory. Inductive inference starts from observed data $x_1, dots, x_n$, treated as realizations of random variables, and reasons back to the unknown distribution or parameters that generated them — this is statistics, and it is the one that "learns from data".]

#question[State the formal definition of a statistical model, naming every ingredient.]
#answer[A statistical model is a triple $(Omega, cal(A), P_Theta)$ where $(Omega, cal(A))$ is a measurable sample space, $Theta$ is a non-empty parameter space (index set), and $P_Theta = (P_theta)_(theta in Theta) = {P_theta : theta in Theta}$ is a family of probability distributions on $(Omega, cal(A))$, one for each $theta in Theta$.]

#question[When is a statistical model called parametric, and when non-parametric? Give one example of each.]
#answer[It is parametric if $Theta subset.eq RR^k$ for some finite $k in NN_(>0)$ (e.g. the coin model with $Theta = [0, 1]$, or the two-parameter Gaussian model with $theta = (mu, sigma^2)$). It is non-parametric otherwise, typically when $Theta$ is infinite-dimensional (e.g. the family of all continuous distributions).]

#question[Write down a statistical model for $n$ coin flips using a Bernoulli family, and identify the parameter space.]
#answer[Model each flip as $X_i tilde "Ber"(theta)$ i.i.d., $i = 1, dots, n$. The resulting model for the $n$-fold experiment is $(Omega = {0, 1}^n, cal(A) = cal(P)({0, 1}^n), ("Ber"(theta)^(⊗ n))_(theta in [0, 1]))$, with joint mass function $ PP_theta (x_1, dots, x_n) = theta^(sum_(i=1)^n x_i) (1 - theta)^(n - sum_(i=1)^n x_i) $ for $(x_1, dots, x_n) in {0, 1}^n$. The parameter space is $Theta = [0, 1]$, with $theta$ the probability of heads on a single flip.]

#question[Define a statistic. Why must it not depend on the unknown parameter $theta$, and is the sample mean $accent(X, macron)_n$ a statistic?]
#answer[A statistic is a measurable function $T : Omega^n -> RR^k$ of the sample that does not depend on $theta$. The restriction is essential because $theta$ is unknown: only quantities computable from the data alone are observable and therefore usable. The sample mean $accent(X, macron)_n = frac(1, n) sum_(i=1)^n X_i$ depends only on the data, so it is a statistic (indeed a common estimator of the mean).]

#question[Define identifiability of a parameter of interest $gamma$, give the equivalent contrapositive form, and explain why it matters.]
#answer[$gamma$ is identifiable if $gamma(theta_1) != gamma(theta_2)$ implies $P_(theta_1) != P_(theta_2)$ for all $theta_1, theta_2 in Theta$; equivalently, if $P_(theta_1) = P_(theta_2)$ implies $gamma(theta_1) = gamma(theta_2)$. It matters because an unidentifiable parameter cannot be determined uniquely even with infinitely much data — different parameter values produce identical distributions, so the data can never separate them.]

#question[For an i.i.d. sample $X_1, dots, X_n tilde "Ber"(theta)$ with $k = sum_(i=1)^n x_i$ heads, write the likelihood $L(theta | x)$ and the log-likelihood $ell(theta | x)$.]
#answer[The likelihood is $L(theta | x) = product_(i=1)^n theta^(x_i) (1 - theta)^(1 - x_i) = theta^k (1 - theta)^(n - k)$, and the log-likelihood is $ell(theta | x) = k ln(theta) + (n - k) ln(1 - theta)$. It is maximized at $theta = k \/ n = accent(x, macron)_n$.]

#question[True or false: the likelihood function $L(theta | x)$ is a probability density over $theta$. Justify.]
#answer[False. $L(theta | x)$ is a function of the parameter $theta$ with the data $x$ held fixed; it need not integrate to $1$ over $theta$ and carries no interpretation as a density in $theta$. (It is built from the density/mass function $p(x | theta)$ of the data, not of the parameter.) It also exists only relative to observed data, so it is not a property of the model alone.]
]

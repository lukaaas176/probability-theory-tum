#import "../vorlage.typ": *

= Interval estimation

Chapter 11 produced #emph[point estimates]: a single number $hat(theta)$ offered as our best guess for an unknown parameter. A point estimate on its own is silent about its own reliability — reporting $hat(mu) = 5.2$ gives no hint of whether the truth is plausibly $5.1$ or plausibly anywhere in $[0, 10]$. #emph[Interval estimation] repairs this by reporting a whole range of plausible values together with a quantified level of confidence. The central object is the *confidence interval*, and — exactly as with hypothesis testing in Chapter 12 — its correct interpretation is frequentist and notoriously easy to get wrong. Chapter 14 will revisit the same questions from the Bayesian side and contrast the confidence interval with its Bayesian counterpart, the #emph[credible interval].

== The confidence interval

While a point estimate is a single "best guess", an *interval estimate* provides a range of plausible values for an unknown parameter, accompanied by a level of confidence. We treat the parameter as a fixed but unknown constant and let the #emph[interval] be random.

#definition(title: "Confidence interval, confidence level")[
Let $(Omega, cal(A), (PP_theta)_(theta in Theta))$ be a statistical model and let $gamma(theta) in RR$ be a parameter of interest. A *$100(1 - alpha)$% confidence interval* ("CI") for $gamma(theta)$ is an interval with #emph[random] endpoints $(L(X), U(X))$, computed from the sample $X = (X_1, dots, X_n)$, such that
$
PP_theta (L(X) <= gamma(theta) <= U(X)) >= 1 - alpha quad "for all" theta in Theta .
$
The number $1 - alpha in (0, 1)$ is the *confidence level* (and $alpha$ the *error level*); the guaranteed probability on the left is called the *coverage*.
]

The decisive point is #emph[what is random and what is fixed]. The endpoints $L(X)$ and $U(X)$ are random variables — functions of the sample — so the interval $[L(X), U(X)]$ shifts and stretches from one dataset to the next. The parameter $gamma(theta)$, by contrast, is an unknown but fixed constant. The coverage inequality must hold #emph[uniformly] in $theta$: whatever the true parameter is, the random interval must trap it with probability at least $1 - alpha$.

== Interpreting the confidence level

Because the probability attaches to the random interval and not to the fixed parameter, the confidence level must be read as a statement about the #emph[procedure], not about any one computed interval.

#keyfact[
Correct: if we repeat the whole sampling-and-construction procedure many times, then in the long run at least a fraction $1 - alpha$ of the intervals produced will contain the true parameter. #emph[Incorrect]: "the true parameter lies in #emph[this] interval $[4.4, 5.6]$ with probability $1 - alpha$." Once the data are observed the interval is a fixed set of numbers and the fixed parameter either lies in it or does not — nothing is left to be random. The probability describes the method, not a single outcome.
]

#remark[
Spelling out the frequentist reading of a $95%$ CI: were we to draw a fresh sample and rebuild the interval a large number of times, about $95%$ of those randomly generated intervals would contain the true, fixed parameter value. It is #emph[incorrect] to say that for one specific, already-calculated interval there is a $95%$ probability that the parameter lies inside. This is precisely the interpretation Chapter 14 revises: a Bayesian *credible interval*, resting on a different notion of probability, #emph[does] license the statement "the parameter lies inside with probability $1 - alpha$".
]

== The pivotal-quantity method

How does one actually construct endpoints that satisfy the coverage guarantee? The standard tool is a *pivotal quantity* (or *pivot*).

#definition(title: "Pivotal quantity")[
A *pivotal quantity* for $gamma(theta)$ is a function $Q(X, gamma(theta))$ of the sample and the parameter whose distribution under $PP_theta$ is the #emph[same for every] $theta in Theta$ — that is, its distribution does not depend on the unknown parameter.
]

Since the distribution of a pivot is known and parameter-free, we can bracket it between fixed quantiles and then #emph[invert] the bracket to obtain random bounds on the parameter itself.

#keyfact[
*Pivotal-quantity recipe.* (1) Find a pivot $Q(X, gamma(theta))$ with a known, parameter-free distribution. (2) Choose constants $a, b$ (usually symmetric quantiles) with $PP(a <= Q <= b) = 1 - alpha$. (3) Algebraically rearrange $a <= Q(X, gamma(theta)) <= b$ into the form $L(X) <= gamma(theta) <= U(X)$. The resulting $(L(X), U(X))$ is a $100(1 - alpha)$% confidence interval.
]

== Confidence intervals for a normal mean

Throughout this section $X_1, dots, X_n$ are i.i.d. $cal(N)(mu, sigma^2)$ and we want a CI for the mean $mu$; write $macron(X)_n = 1/n sum_(i=1)^n X_i$ for the sample mean. Following the same convention as the tests of Chapter 12, $z_alpha$ denotes the *upper $alpha$-quantile* of the standard normal — the value with $PP(Z >= z_alpha) = alpha$ for $Z ~ cal(N)(0, 1)$, equivalently the $(1 - alpha)$-quantile. By symmetry, $PP(-z_(alpha/2) <= Z <= z_(alpha/2)) = 1 - alpha$.

=== Known variance: the z-interval

#example(title: "CI for a normal mean, known variance")[
Suppose $sigma^2$ is known. The standardized sample mean
$
Z = (macron(X)_n - mu)/(sigma\/sqrt(n)) ~ cal(N)(0, 1)
$
is a pivot: its distribution is standard normal for #emph[every] $mu$. Hence $PP(-z_(alpha/2) <= Z <= z_(alpha/2)) = 1 - alpha$, and rearranging this double inequality to isolate $mu$ gives
$
PP(macron(X)_n - z_(alpha/2) sigma/sqrt(n) <= mu <= macron(X)_n + z_(alpha/2) sigma/sqrt(n)) = 1 - alpha .
$
The $100(1 - alpha)$% CI for $mu$ is therefore
$
macron(X)_n plus.minus z_(alpha/2) sigma/sqrt(n) .
$
]

The half-width $z_(alpha/2) sigma\/sqrt(n)$ is the *margin of error*. Two levers control it. Raising the confidence level widens the interval: for $alpha = 0.05$ we use $z_(0.025) approx 1.96$, for $alpha = 0.10$ we use $z_(0.05) approx 1.645$, and for $alpha = 0.01$ we use $z_(0.005) approx 2.576$. Collecting more data narrows it, but only like $1\/sqrt(n)$: quartering the width requires roughly sixteen times as many observations.

=== Unknown variance: the t-interval

In practice $sigma^2$ is usually unknown too and must be estimated from the data by the sample variance $S_n^2 = 1/(n - 1) sum_(i=1)^n (X_i - macron(X)_n)^2$.

#example(title: "CI for a normal mean, unknown variance")[
When $sigma^2$ is unknown, replace it by $S_n^2$ and use the pivot
$
T = (macron(X)_n - mu)/(S_n\/sqrt(n)) ~ t_(n-1) ,
$
a Student's $t$-distribution with $n - 1$ degrees of freedom — free of #emph[both] $mu$ and $sigma^2$ (a non-trivial fact: even though $S_n$ estimates $sigma$, the ratio's distribution does not depend on it), which is exactly what makes $T$ a valid pivot now that $sigma^2$ is unknown too. The $100(1 - alpha)$% CI for $mu$ is
$
macron(X)_n plus.minus t_(n-1, alpha/2) S_n/sqrt(n) ,
$
where $t_(n-1, alpha/2)$ is the upper $alpha\/2$-quantile of the $t_(n-1)$ distribution.
]

The $t$-distribution has *heavier tails* than the normal, so $t_(n-1, alpha/2) > z_(alpha/2)$ and the $t$-interval is wider — the price we pay for the extra uncertainty of having estimated $sigma$. As $n -> oo$ the estimate $S_n$ stabilizes, $t_(n-1)$ converges to $cal(N)(0, 1)$, and the two intervals coincide.

=== A worked computation

#example(title: "a 95% CI for a filling machine")[
A machine fills bottles to a nominal $500$ ml; assume the fill volume is $cal(N)(mu, sigma^2)$ with #emph[known] standard deviation $sigma = 8$ ml. We measure $n = 16$ bottles and observe a sample mean $macron(x)_n = 502$ ml. For a $95%$ CI we take $alpha = 0.05$, so $z_(alpha/2) = z_(0.025) approx 1.96$. The standard error is
$
sigma/sqrt(n) = 8/sqrt(16) = 8/4 = 2 ,
$
so the margin of error is $z_(alpha/2) sigma\/sqrt(n) = 1.96 dot 2 = 3.92$, and the interval is
$
502 plus.minus 3.92 = [498.08, 505.92] "ml" .
$
Read it correctly: the #emph[rule] that produced $[498.08, 505.92]$ traps the true mean $mu$ in $95%$ of repeated experiments — not "$mu in [498.08, 505.92]$ with probability $0.95$". Had $sigma$ been unknown, we would use $S_n$ and the critical value $t_(15, 0.025) approx 2.131$ in place of $1.96$, yielding a slightly wider interval.
]

== Confidence intervals for a proportion

Beyond the Gaussian, the pivotal recipe combined with the central limit theorem (Chapter 9) yields an approximate CI for an unknown probability.

#example(title: "CI for a proportion (Wald interval)")[
Let $X_1, dots, X_n$ be i.i.d. $"Ber"(p)$ and estimate $p$ by $hat(p) = macron(X)_n$. For large $n$ the central limit theorem gives the approximate pivot
$
(hat(p) - p)/sqrt(p(1 - p)\/n) approx cal(N)(0, 1) .
$
Replacing the unknown $p$ in the denominator by its estimate $hat(p)$ and inverting yields the *Wald interval*, an approximate $100(1 - alpha)$% CI for $p$:
$
hat(p) plus.minus z_(alpha/2) sqrt((hat(p)(1 - hat(p)))/n) .
$
]

#remark[
The Wald interval is only #emph[approximately] valid, and the approximation degrades for small $n$ or when $p$ is near $0$ or $1$, where its true coverage can drop well below the nominal $1 - alpha$. Alternatives such as the *Wilson score interval* or the *Clopper–Pearson interval* provide better coverage in those regimes.
]

== Duality with hypothesis testing

Confidence intervals and two-sided tests are two views of a single inferential problem.

#remark[
A $100(1 - alpha)$% CI for $theta$ consists of exactly those values $theta_0$ for which the two-sided test of $H_0 : theta = theta_0$ would #emph[not] be rejected at significance level $alpha$. Conversely, if a level-$alpha$ test rejects $H_0 : theta = theta_0$, then $theta_0$ falls outside the $100(1 - alpha)$% CI. "Inverting" a whole family of tests is a general recipe for building confidence sets, and it lets us port every test of Chapter 12 into a corresponding interval.
]

This closes the frequentist inference toolkit assembled across Chapters 10–13: statistical models, point estimation, hypothesis testing, and now interval estimation. All of them treat $theta$ as a fixed unknown and let probability describe the random data-generating procedure. Chapter 14 restarts from a different premise — $theta$ itself is modelled as random — and the analogous object there, the *credible interval*, genuinely does carry the "probability that $theta$ lies inside" reading that the confidence interval must refuse.

#quizblock(title: "Quiz — Interval estimation")[
#question[Define a $100(1 - alpha)$% confidence interval for a parameter $gamma(theta)$, and identify precisely what is random and what is fixed.]
#answer[It is an interval with random endpoints $(L(X), U(X))$, computed from the sample $X$, such that $PP_theta (L(X) <= gamma(theta) <= U(X)) >= 1 - alpha$ for all $theta in Theta$. The endpoints are random (functions of the data); the parameter $gamma(theta)$ is a fixed unknown constant. The confidence level is $1 - alpha$.]

#question[A colleague computes a $95%$ CI $[4.4, 5.6]$ for $mu$ and states: "there is a $95%$ probability that $mu in [4.4, 5.6]$." Why is this wrong, and what is the correct interpretation?]
#answer[Once the data are observed, the interval $[4.4, 5.6]$ is a fixed set and $mu$ is a fixed number, so $mu$ is either in it or not — there is no probability left to assign. The $95%$ refers to the #emph[procedure]: if the sampling-and-construction were repeated many times, about $95%$ of the resulting intervals would contain the true $mu$. The probability statement is about the method, not about this one interval.]

#question[What is a pivotal quantity, why is it the key to the construction, and what pivot is used for a normal mean with known variance?]
#answer[A pivotal quantity $Q(X, gamma(theta))$ is a function of the sample and the parameter whose distribution does not depend on the unknown parameter. Because its distribution is known, we can bracket it between fixed quantiles $a <= Q <= b$ with probability $1 - alpha$ and then invert to get random bounds $L(X) <= gamma(theta) <= U(X)$. For a normal mean with known $sigma^2$ the pivot is $Z = (macron(X)_n - mu)\/(sigma\/sqrt(n)) ~ cal(N)(0, 1)$.]

#question[Compute a $95%$ confidence interval for $mu$ from an i.i.d. $cal(N)(mu, sigma^2)$ sample with known $sigma = 8$, sample size $n = 16$, and observed sample mean $macron(x)_n = 502$. Use $z_(0.025) approx 1.96$.]
#answer[The standard error is $sigma\/sqrt(n) = 8\/4 = 2$, so the margin of error is $1.96 dot 2 = 3.92$. The CI is $macron(x)_n plus.minus z_(alpha/2) sigma\/sqrt(n) = 502 plus.minus 3.92 = [498.08, 505.92]$.]

#question[When the variance $sigma^2$ is unknown, how does the CI for a normal mean change, and why is the resulting interval wider?]
#answer[Estimate $sigma^2$ by the sample variance $S_n^2$ and switch from the normal quantile to the $t$-quantile: the CI becomes $macron(X)_n plus.minus t_(n-1, alpha/2) S_n\/sqrt(n)$, using the pivot $T = (macron(X)_n - mu)\/(S_n\/sqrt(n)) ~ t_(n-1)$. The $t_(n-1)$ distribution has heavier tails than $cal(N)(0, 1)$, so $t_(n-1, alpha/2) > z_(alpha/2)$; this accounts for the extra uncertainty of estimating $sigma$. As $n -> oo$ the two intervals coincide.]

#question[Give an approximate $95%$ CI for a proportion $p$ from $n = 400$ i.i.d. $"Ber"(p)$ observations with $hat(p) = 0.6$, state the justification, and note one caveat.]
#answer[By the central limit theorem, $(hat(p) - p)\/sqrt(p(1 - p)\/n) approx cal(N)(0, 1)$; plugging in $hat(p)$ gives the Wald interval $hat(p) plus.minus z_(alpha/2) sqrt(hat(p)(1 - hat(p))\/n)$. Here $sqrt(0.6 dot 0.4 \/ 400) = sqrt(0.0006) approx 0.0245$, so the margin is $1.96 dot 0.0245 approx 0.048$ and the CI is about $[0.552, 0.648]$. Caveat: the Wald approximation is poor for small $n$ or $p$ near $0$ or $1$; use the Wilson or Clopper–Pearson interval there.]

#question[Explain the duality between two-sided hypothesis tests and confidence intervals.]
#answer[A $100(1 - alpha)$% CI for $theta$ is exactly the set of values $theta_0$ that a two-sided level-$alpha$ test of $H_0 : theta = theta_0$ would fail to reject. Conversely, if such a test rejects $H_0 : theta = theta_0$, then $theta_0$ lies outside the CI. So a CI and the corresponding family of tests encode the same information — inverting the tests builds the interval.]
]

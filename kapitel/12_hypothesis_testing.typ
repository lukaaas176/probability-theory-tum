#import "../vorlage.typ": *

= Hypothesis testing

Point estimation (Chapter 11) turns a sample into a #emph[number], a best guess for an unknown parameter. Hypothesis testing turns a sample into a #emph[decision]: given a claim about the population parameter, do the data give us enough evidence to reject that claim? This is the formal framework behind "is the new drug better than the standard?", "is this coin fair?", and countless questions in the empirical sciences. Throughout we work inside a statistical model $(Omega, cal(A), P_Theta)$ with parameter space $Theta$, exactly as in the previous chapters; the new ingredient is that we split $Theta$ into two competing parts and let the data adjudicate between them.

== From estimation to a binary decision

A #emph[statistical hypothesis] is a claim about the parameter of a statistical model. In testing we always consider two competing, mutually exclusive hypotheses and split the parameter space accordingly.

#definition(title: "Null and alternative hypothesis")[
Let $(Omega, cal(A), P_Theta)$ be a statistical model and let
$
Theta = Theta_0 union.plus Theta_1, quad Theta_0 inter Theta_1 = emptyset,
$
be a partition of the parameter space into two disjoint pieces.
- The *null hypothesis* $H_0 : Theta_0$ is the statement that the true parameter lies in $Theta_0$. It typically encodes a default, a status quo or "no effect".
- The *alternative hypothesis* $H_1 : Theta_1$ (also written $H_A$) is the statement that the true parameter lies in $Theta_1$. It encodes the claim we are actually looking for evidence for.
]

For a sample $X = (X_1, dots, X_n) ~ P_Theta$, testing asks whether the null model is #emph[misspecified] — whether the data are incompatible with the true parameter lying in $Theta_0$. If so, we #emph[reject] $H_0$; otherwise we #emph[fail to reject] it. Note the deliberate asymmetry already in the language: rejecting a hypothesis is a strong, evidence-based act, whereas failing to reject is merely the absence of such evidence. By convention we say the null hypothesis $H_0$ #emph[is valid] if the restricted model $(Omega, cal(A), P_(Theta_0))$ is well-specified, i.e. the true parameter really lies in $Theta_0$.

#definition(title: "Simple and composite hypotheses")[
A hypothesis is *simple* if it pins the parameter down to a single value, i.e. $|Theta_0| = 1$ (or $|Theta_1| = 1$); we then write the single element as $theta_0$ (or $theta_1$). Otherwise ($|Theta_0| > 1$) the hypothesis is *composite*. A composite one-sided hypothesis such as $Theta_0 = { theta in Theta : theta <= theta_0 }$ has a distinguished *boundary* value $theta_0$ that will govern its worst-case error.
]

#example(title: "setting up hypotheses")[
+ #emph[A fair coin.] For a coin with unknown heads-probability $p$, testing fairness means $H_0 : p = 0.5$ (simple) against $H_1 : p != 0.5$ (composite).
+ #emph[A new drug.] Let $mu$ be the average recovery time and $mu_0 = 10$ days the current standard. To test whether the drug shortens recovery we set $H_0 : mu >= 10$ (no improvement or worse) against $H_1 : mu < 10$ (improvement); both are composite. A simpler but common variant fixes the boundary, $H_0 : mu = 10$ versus $H_1 : mu < 10$.
]

Which claim becomes the null is a modelling choice, not a symmetry: we put on $H_0$ the statement we are prepared to reject #emph[only] on strong evidence, because — as the next sections make precise — the whole machinery is designed to control the error of wrongly rejecting it.

== Tests, rejection regions, and the two error types

A test is a rule that maps every possible dataset to one of the two decisions "reject $H_0$" or "do not reject $H_0$".

#definition(title: "Statistical test, rejection region")[
A *statistical test* is a (measurable) map
$
phi : Omega^n -> [0, 1] .
$
It is called *non-randomized* if $phi(Omega^n) subset.eq {0, 1}$, and *randomized* otherwise. We focus on non-randomized tests. By convention $phi(x) = 1$ means *reject $H_0$* and $phi(x) = 0$ means *fail to reject $H_0$*. The set
$
phi^(-1)({1}) = { x in Omega^n : phi(x) = 1 }
$
is called the *rejection region* (or *critical region*): the datasets that lead to rejection.
]

Because the decision is binary while the truth ($H_0$ valid or $H_1$ valid) is also binary, exactly two kinds of mistake are possible.

#definition(title: "Type I and type II error")[
- A *type I error* is rejecting $H_0$ when it is in fact valid: $phi(x) = 1$ although $P_(Theta_0)$ is well-specified.
- A *type II error* is failing to reject $H_0$ when it is in fact false: $phi(x) = 0$ although $P_(Theta_1)$ is well-specified.
The four combinations of truth and decision are:
]

#table(
  columns: 3,
  align: (left, center, center),
  inset: 7pt,
  table.header([*true state*], [*fail to reject $H_0$*], [*reject $H_0$*]),
  [$H_0$ valid], [correct decision], [type I error],
  [$H_1$ valid], [type II error], [correct decision (power)],
)

The two errors are not on an equal footing. In science we typically design a test to #emph[detect] a departure from the default, so we treat wrongly claiming such a departure (a type I error) as the more serious mistake and control its probability first.

== Significance level and power

To quantify the two errors we look at the probability of rejection as a function of the true parameter.

#definition(title: "Size, significance level, and power function")[
Let $phi$ be a test in the model $(Omega, cal(A), P_Theta)$.
- The *power function* of $phi$ is
$
G_phi : Theta -> [0, 1], quad G_phi (theta) = EE_theta [phi(X)] ,
$
the probability of rejecting $H_0$ when the true parameter is $theta$. (For a non-randomized test this is just $P_theta (phi(X) = 1) = P_theta ("reject" H_0)$.)
- The *size* of $phi$ is its worst-case type I error probability,
$
"size"(phi) := sup_(theta in Theta_0) G_phi (theta) = sup_(theta in Theta_0) EE_theta [phi] .
$
For a prescribed bound $alpha_0 in [0,1]$, we say $phi$ is a *test at significance level $alpha_0$* if $"size"(phi) <= alpha_0$. A conservative test may have size strictly below its nominal level.
- For $theta in Theta_1$, the value $G_phi (theta)$ is the *power against the alternative $theta$* — the probability of correctly rejecting $H_0$. The *type II error probability* at $theta in Theta_1$ is
$
beta(theta) := 1 - G_phi (theta) .
$
]

So on $Theta_0$ we want the power function to be #emph[small] (few type I errors), and on $Theta_1$ we want it #emph[large] (much power, few type II errors). These two goals pull in opposite directions.

#keyfact[
The design of a test is deliberately asymmetric. For a fixed sample size $n$ we (a) first #emph[cap] the type I error by demanding a level $alpha$, i.e. $G_phi (theta) <= alpha$ for all $theta in Theta_0$; and (b) then, subject to that cap, try to make the power $G_phi (theta)$ as large as possible for $theta in Theta_1$, i.e. minimize type II errors. Shrinking $alpha$ shrinks the rejection region, which raises $beta$ and lowers power: for fixed $n$ there is an unavoidable trade-off between the two errors.
]

#remark[
Failing to reject $H_0$ is #emph[not] the same as accepting $H_0$ or having found evidence for it. The absence of evidence against the null is not evidence in favour of it: a test may simply have too little power (too small $n$, or an alternative too close to the boundary) to detect a real effect. The correct phrasing of a negative result is "we fail to reject $H_0$", never "we have shown $H_0$".
]

Two special classes of tests refine goal (b). Both fix the level $alpha$ first.

#definition(title: "Uniformly most powerful and unbiased tests")[
Fix $alpha in [0, 1]$.
- A test $phi$ at level $alpha$ is *uniformly most powerful (UMP)* if for every other level-$alpha$ test $psi$ of $H_0$ against $H_1$ we have $G_phi (theta) >= G_psi (theta)$ for all $theta in Theta_1$. A UMP test is simultaneously best against every alternative.
- A test $phi$ is *unbiased at level $alpha$* if $G_phi (theta_0) <= alpha <= G_phi (theta_1)$ for all $theta_0 in Theta_0$, $theta_1 in Theta_1$: it is never less likely to reject under a true alternative than under the null.
]

== The p-value

The lecture's informal description of a test is: reduce the data to a statistic $T(x)$, work out how surprising the observed value is #emph[if the null were true], and reject when it is surprising beyond a pre-set threshold. The number that measures "how surprising" is the p-value.

#definition(title: "p-value")[
Let $T$ be a test statistic whose distribution under a simple null $H_0 : theta = theta_0$ is known, with observed value $t_"obs" = T(x)$. The *p-value* is the probability, computed under $P_(theta_0)$, of observing a value of $T$ at least as extreme as $t_"obs"$ in the direction of the alternative. For a one-sided alternative favoring large values of $T$,
$
"p-value" = P_(theta_0)(T >= t_"obs") ,
$
and, when the null distribution of $T$ is symmetric about $0$, the usual two-sided p-value is $P_(theta_0)(|T| >= |t_"obs"|)$. For a composite null, a valid p-value must account for the worst-case null distribution (often attained at a boundary); one common construction takes the supremum of the relevant tail probability over $theta in Theta_0$. One rejects $H_0$ at level $alpha$ when $"p-value" <= alpha$.
]

The p-value packages the test into a single comparison: it is the smallest significance level at which the observed data would already lead to rejection. Small p-value $=>$ the data are hard to reconcile with $H_0$.

#remark[
The p-value is routinely misread. It is #emph[not] the probability that $H_0$ is true (that is not even a meaningful frequentist quantity — $H_0$ is either valid or not), nor the probability that the result arose "by chance", nor one minus the probability that $H_1$ is true. It is a statement about the data assuming $H_0$: the probability, over hypothetical repetitions of the experiment under $H_0$, of a test statistic as extreme as the one seen. Likewise $alpha$ is an upper bound on the long-run type I error probability under the null, not a measure of confidence in one particular decision. The actual rejection probability $G_phi(theta)$ can be smaller than $alpha$ and depend on the null parameter $theta in Theta_0$. If the null is in fact false, $alpha$ describes no real probability at all.
]

== The Neyman–Pearson lemma

For a simple-versus-simple test there is a clean answer to "what is the most powerful level-$alpha$ test?". It is based on the likelihood ratio.

#theorem(name: "Neyman–Pearson lemma, 1932")[
Consider a binary statistical model $(Omega, cal(A), (P_(theta_0), P_(theta_1)))$ testing the simple null $H_0 : {theta_0}$ against the simple alternative $H_1 : {theta_1}$, with likelihood function $L(theta | x)$. For a given significance level $alpha in (0, 1)$, the most powerful test is the *likelihood-ratio test (LRT)*, which rejects $H_0$ if and only if
$
frac(L(theta_1 | x), L(theta_0 | x)) > k ,
$
where the constant $k$ is chosen so that the test has size exactly $alpha$ (assuming such a test exists).
]

The lemma is the theoretical bedrock of testing: it says that among all ways of using the data, thresholding the likelihood ratio wastes nothing. In many parametric families this ratio turns out to be monotone in a simple statistic (the sample mean, say), which is why the "obvious" tests below are in fact optimal.

#example(title: "Neyman–Pearson for the exponential")[
Observe a single $X ~ "Exp"(lambda)$ and test $H_0 : {lambda_0}$ against $H_1 : {lambda_1}$ with $lambda_1 > lambda_0 > 0$. The density is $p(x | lambda) = lambda e^(-lambda x)$ for $x >= 0$, so the likelihood ratio is
$
Lambda(x) = frac(L(lambda_1 | x), L(lambda_0 | x)) = frac(lambda_1 e^(-lambda_1 x), lambda_0 e^(-lambda_0 x)) = frac(lambda_1, lambda_0) e^(-(lambda_1 - lambda_0) x) .
$
The LRT rejects when $Lambda(x) > k'$. Since $lambda_1 > lambda_0$, the factor $e^(-(lambda_1 - lambda_0) x)$ is #emph[decreasing] in $x$, so $Lambda(x) > k'$ is equivalent to $x < c$ for a threshold $c$: small observations are the evidence for the larger rate $lambda_1$. Choosing $c$ for size $alpha$,
$
alpha = P_(lambda_0)(X < c) = integral_0^c lambda_0 e^(-lambda_0 x) dif x = 1 - e^(-lambda_0 c) quad => quad c = - frac(ln(1 - alpha), lambda_0) ,
$
which is positive because $ln(1 - alpha) < 0$. The power against $lambda_1$ is
$
G_phi (lambda_1) = P_(lambda_1)(X < c) = 1 - e^(-lambda_1 c) = 1 - (1 - alpha)^(lambda_1 \/ lambda_0) ,
$
which exceeds $alpha$ (since $lambda_1 \/ lambda_0 > 1$), confirming the test is unbiased.
]

== Constructing a test in practice

Writing down the decision rule $phi$ directly is awkward. In practice one extracts the following recipe from the Neyman–Pearson picture; it applies far beyond the simple-versus-simple case.

#definition(title: "Recipe for constructing a test")[
+ Choose a real-valued *test statistic* $T : Omega^n -> RR$ that summarizes the sample (e.g. the sample mean when testing a mean, the sample variance when testing a variance).
+ Determine, at least approximately, the *distribution of $T(X)$ under $H_0$* (its *null distribution*) — exactly, via the central limit theorem for large $n$, or with a justified simulation method. A permutation test simulates the null by relabelling observations when the null law is unchanged by those relabellings (exchangeability); a parametric bootstrap simulates new data from a fitted null model.
+ Fix a level $alpha$ and define the *rejection region* $R$ through quantiles of the null distribution. The threshold is the *critical value* and $R$ the *critical region*. For a composite null the size is $sup_(theta in Theta_0) G_phi (theta)$ and must not exceed $alpha$; when $G_phi$ is monotone on $Theta_0$ (as in the one-sided examples below), the supremum is attained at the null boundary.
+ Set $phi(x) = bb(1)_R (T(x))$, i.e. $phi(x) = 1$ if $T(x) in R$ (reject) and $0$ otherwise.
]

#definition(title: "One-sided and two-sided tests")[
Let $Theta subset.eq RR$.
- A *one-sided* (one-tailed) test is used for a directional alternative, $H_1 : theta > theta_0$ or $H_1 : theta < theta_0$; the rejection region sits entirely in one tail of the null distribution.
- A *two-sided* (two-tailed) test is used for a non-directional alternative, $H_1 : theta != theta_0$; its rejection region uses both tails. In the standard symmetric-null procedures below, level $alpha$ is split equally using the $alpha \/ 2$ and $1 - alpha \/ 2$ quantiles; asymmetric null laws can require an unequal split.
For the stochastically monotone families considered below, a one-sided level-$alpha$ test gains power in its chosen direction while its rejection probability in the opposite direction is at most $alpha$. This is a property of those models and rejection regions, not of the phrase "one-sided" alone.
]

=== The z-test for a normal mean

We derive the workhorse test from the Neyman–Pearson lemma. Let $X_1, dots, X_n ~ cal(N)(mu, sigma^2)$ be i.i.d. with #emph[known] variance $sigma^2$, and test $H_0 : {mu_0}$ against $H_1 : {mu_1}$ with $mu_1 > mu_0$. The likelihood ratio is
$
Lambda(x) = frac(exp(- frac(1, 2 sigma^2) sum_i (x_i - mu_1)^2), exp(- frac(1, 2 sigma^2) sum_i (x_i - mu_0)^2)) = exp( frac(1, 2 sigma^2) ( 2(mu_1 - mu_0) sum_i x_i + n(mu_0^2 - mu_1^2) ) ) .
$
Rejecting when $Lambda(x) > k$ is, after taking logarithms and using $mu_1 > mu_0$, equivalent to $macron(X)_n > c$ for a constant $c$: the LRT depends on the data #emph[only through the sample mean]. To achieve size $alpha$ we need $P_(mu_0)(macron(X)_n > c) = alpha$. Under $H_0$ the standardized mean
$
Z = frac(macron(X)_n - mu_0, sigma \/ sqrt(n)) ~ cal(N)(0, 1)
$
is standard normal, so $c = mu_0 + z_alpha dot sigma \/ sqrt(n)$, where $z_alpha$ denotes the $1 - alpha$ quantile of $cal(N)(0,1)$, i.e. $P(Z >= z_alpha) = alpha$. Crucially, $c$ depends only on $mu_0$, $sigma$, $n$ and $alpha$ — not on the particular value $mu_1$ — so this same rejection region is simultaneously most powerful against #emph[every] $mu_1 > mu_0$, i.e. it is most powerful for the whole composite alternative $H_1 : mu > mu_0$. The resulting UMP test — the *one-sided z-test* — rejects $H_0$ when
$
macron(x)_n > mu_0 + z_alpha frac(sigma, sqrt(n)) quad "equivalently" quad z_"obs" > z_alpha .
$

#keyfact[
The *z-test for a normal mean* (known $sigma^2$) uses the standardized sample mean $Z = (macron(X)_n - mu_0) \/ (sigma \/ sqrt(n))$, which is $cal(N)(0,1)$ under $H_0$. Reject $H_0$ if:
- one-sided $H_1 : mu > mu_0$: $z_"obs" > z_alpha$;
- one-sided $H_1 : mu < mu_0$: $z_"obs" < -z_alpha$;
- two-sided $H_1 : mu != mu_0$: $|z_"obs"| > z_(alpha \/ 2)$.
For $alpha = 0.05$ the two-sided cutoff is $z_(alpha \/ 2) approx 1.96$; for $alpha = 0.01$ (one-sided) it is $z_alpha approx 2.33$; for $alpha = 0.001$ (two-sided) it is $z_(alpha \/ 2) approx 3.29$.
]

=== A zoo of Gaussian tests

The same recipe, with a different statistic and null distribution, gives the standard tests. Here $z_alpha$, $t_(n-1, alpha)$ and $chi^2_(n-1, alpha)$ denote upper $alpha$-quantiles (the $1 - alpha$ quantiles) of the respective distributions, and $S_n^2$ is the sample variance. One- and two-sided versions share a statistic and null distribution and only differ in how the rejection region is placed.

#table(
  columns: 4,
  align: (left, center, center, left),
  inset: 7pt,
  table.header([*setting*], [*$H_0$*], [*statistic*], [*null distribution*]),
  [mean, $sigma^2$ known (z-test)], [$mu = mu_0$], [$Z = frac(macron(X)_n - mu_0, sigma \/ sqrt(n))$], [$cal(N)(0, 1)$],
  [mean, $sigma^2$ unknown (t-test)], [$mu = mu_0$], [$T = frac(macron(X)_n - mu_0, S_n \/ sqrt(n))$], [$t_(n-1)$],
  [variance, $mu$ unknown ($chi^2$-test)], [$sigma^2 = sigma_0^2$], [$C = frac((n-1) S_n^2, sigma_0^2)$], [$chi^2_(n-1)$],
  [two means, equal variance (two-sample t)], [$mu_X = mu_Y$], [$T = frac(macron(X) - macron(Y), S_p sqrt(1 \/ n_X + 1 \/ n_Y))$], [$t_(n_X + n_Y - 2)$],
)

For the two-sample t-test, $S_p^2 = frac((n_X - 1) S_X^2 + (n_Y - 1) S_Y^2, n_X + n_Y - 2)$ is the pooled sample variance. For large samples, the central limit theorem supports approximate z-tests and suitably studentized mean tests under finite-variance conditions. It does #emph[not] make the displayed chi-squared variance test distribution-free: its chi-squared null law, and the exact finite-sample t laws in the table, rely on Gaussian sampling. Nonnormal variance inference requires a different asymptotic variance, bootstrap, or robust method.

== A worked test with a decision

We run the recipe end to end and reach an actual decision.

#example(title: "have the light bulbs changed?")[
A factory's bulbs historically last on average $mu_0 = 1200$ hours with known standard deviation $sigma = 150$ hours. A new process yields a sample of $n = 36$ bulbs with sample mean $macron(x)_n = 1250$ hours; lifetimes are assumed normal. Has the mean lifetime #emph[changed]?

*Step 1 — hypotheses.* "Changed" is non-directional, so this is two-sided: $H_0 : mu = 1200$ against $H_1 : mu != 1200$.

*Step 2 — statistic and null distribution.* Variance is known and the data are normal, so we use the z-statistic $Z = (macron(X)_n - mu_0) \/ (sigma \/ sqrt(n))$, which is $cal(N)(0,1)$ under $H_0$.

*Step 3 — observed value.*
$
z_"obs" = frac(1250 - 1200, 150 \/ sqrt(36)) = frac(50, 150 \/ 6) = frac(50, 25) = 2 .
$

*Step 4 — decision.* At $alpha = 0.05$ the two-sided critical value is $z_(alpha \/ 2) approx 1.96$. Since $|z_"obs"| = 2 > 1.96$, we #emph[reject $H_0$]: at the 5% level there is significant evidence that the mean lifetime has changed. At the much stricter $alpha = 0.001$ the cutoff is $z_(alpha \/ 2) approx 3.29$, and now $|z_"obs"| = 2 < 3.29$, so we #emph[fail to reject $H_0$].

The two answers are not a contradiction. $alpha$ is an upper bound on the long-run probability of falsely rejecting a true null; the actual rejection probability can be smaller and depend on the null parameter. It is not a probability that this particular rejection is correct; rejecting at 5% but not at 0.1% simply means the evidence is moderate — enough to clear a lenient bar, not a stringent one.
]

== Practical cautions and extensions

The single-test framework above is the foundation, but real studies must also plan for power and for the number of analyses performed.

#definition(title: "Power analysis")[
A *power analysis* chooses the sample size before data collection so that, at a fixed significance level $alpha$, a proposed test reaches a desired power $1-beta$ against a scientifically relevant alternative or effect size. Power depends on the test, effect size, noise level and sample size. A non-significant result from an underpowered study is therefore especially uninformative.
]

#keyfact[
*Multiple testing inflates false positives.* If $m$ null hypotheses are tested separately at level $alpha$, let $I_0 subset.eq {1, dots, m}$ be the index set of true nulls and let $q_i <= alpha$ be the actual rejection probability for test $i in I_0$. The union bound gives
$
PP("at least one type I error") <= sum_(i in I_0) q_i <= |I_0| alpha <= m alpha.
$
If the true-null rejection events are independent, then the exact probability is
$
PP("at least one type I error") = 1-product_(i in I_0)(1-q_i) <= 1-(1-alpha)^|I_0| <= 1-(1-alpha)^m,
$
For $0 < alpha < 1$, equality through the final bound holds only when the stated independence holds, all $m$ nulls are true, and $q_i = alpha$ for every $i in I_0$. The *Bonferroni correction* tests each hypothesis at level $alpha\/m$, guaranteeing family-wise error at most $alpha$ without requiring independence. Procedures controlling the *false discovery rate (FDR)* instead control the expected proportion of false rejections among all rejections and can be less conservative.
]

#remark[
Trying many outcomes, subgroups, preprocessing choices or tests and reporting only a significant result is *p-hacking*. The unreported multiplicity makes the nominal p-value misleading and contributes to failures of replication. Preregistering hypotheses and analysis plans, reporting all analyses, and using appropriate multiple-testing corrections reduce this problem.
]

#remark[
Bayesian hypothesis testing, previewing Chapter 14, can compare hypotheses through a *Bayes factor*. For hypotheses $H_0,H_1$,
$
"BF"_(1 0) := frac(p(x|H_1),p(x|H_0)),
$
where each term is the marginal likelihood of the data under that hypothesis, integrating over any parameters with their prior distributions. Unlike a p-value, a Bayes factor can quantify evidence in either direction; its value depends on the priors used within the hypotheses.
]

#quizblock(title: "Quiz — Hypothesis testing")[
#question[Define the size of a test $phi$, state what it means for $phi$ to have prescribed significance level $alpha$, and define the power function $G_phi$. Which rejection probabilities do we want small, and on which part of $Theta$?]
#answer[The power function is $G_phi(theta)=EE_theta[phi(X)]$, the rejection probability at parameter $theta$. The actual size is $"size"(phi)=sup_(theta in Theta_0)G_phi(theta)$. A test has prescribed level $alpha$ when $"size"(phi)<=alpha$; equality need not hold. We want rejection probabilities small on $Theta_0$ and large on $Theta_1$, where $beta(theta)=1-G_phi(theta)$ is the type II error probability.]

#question[Distinguish a type I from a type II error, and explain why "we fail to reject $H_0$" must not be reported as "we have shown $H_0$".]
#answer[A type I error is rejecting $H_0$ when it is valid; a type II error is failing to reject $H_0$ when it is false. Failing to reject only means the data did not provide strong enough evidence against $H_0$ — absence of evidence is not evidence of absence. A low-power test (small $n$, or an alternative near the boundary) can easily fail to reject a false null, so a non-rejection never establishes the null.]

#question[Is $H_0 : mu >= 10$ simple or composite? What about $H_0 : p = 0.5$? For the composite case, what is the "boundary" and why does it matter?]
#answer[$H_0 : mu >= 10$ is composite ($Theta_0 = [10, oo)$ has more than one element); $H_0 : p = 0.5$ is simple ($|Theta_0| = 1$). For the composite one-sided null the boundary is $mu_0 = 10$. For the monotone test family, $"size"(phi) = sup_(theta in Theta_0) G_phi (theta) <= alpha$, and the supremum is attained at the boundary; this boundary supremum calibrates the critical value.]

#question[Light bulbs: $mu_0 = 1200$, known $sigma = 150$, $n = 36$, $macron(x)_n = 1250$, two-sided. Compute $z_"obs"$ and decide at $alpha = 0.05$ ($z_(alpha\/2) approx 1.96$) and at $alpha = 0.001$ ($z_(alpha\/2) approx 3.29$).]
#answer[$z_"obs" = (1250 - 1200) \/ (150 \/ 6) = 50 \/ 25 = 2$. At $alpha = 0.05$: $|2| > 1.96$, so reject $H_0$. At $alpha = 0.001$: $|2| < 3.29$, so fail to reject. Moderate evidence: enough at 5%, not at 0.1%.]

#question[A brewery claims bottles hold $330$ ml. With $n = 10$, $macron(x)_(10) = 328.5$, sample variance $s_(10)^2 = 4$, test $H_0 : mu = 330$ against $H_1 : mu != 330$ at $alpha = 0.05$ (use $t_(9, 0.025) approx 2.262$). Which test, and what do you conclude?]
#answer[Variance unknown and data normal, so a two-sided one-sample t-test with $T = (macron(X)_n - mu_0) \/ (S_n \/ sqrt(n)) ~ t_9$. Here $s_(10) = sqrt(4) = 2$, so $t_"obs" = (328.5 - 330) \/ (2 \/ sqrt(10)) = -1.5 \/ 0.632 approx -2.373$. Since $|t_"obs"| = 2.373 > 2.262$, reject $H_0$: significant evidence at the 5% level that the mean is not 330 ml.]

#question[One-sided z-test, $H_0 : mu <= 10$ vs $H_1 : mu > 10$, known $sigma^2 = 9$, $n = 25$, $alpha = 0.01$ with $z_(0.01) approx 2.33$. Give the rejection region in terms of $macron(X)_(25)$, then find the type II error $beta$ and the power at the true mean $mu_a = 11.5$ (use $Phi(-0.17) approx 0.4325$).]
#answer[The null-boundary statistic is $Z = (macron(X)_(25) - 10) \/ (3 \/ 5) = (macron(X)_(25) - 10) \/ 0.6$; reject if $z_"obs" > 2.33$, i.e. $macron(X)_(25) > 10 + 2.33 dot 0.6 = 11.398$. Under $mu_a = 11.5$, $macron(X)_(25) ~ cal(N)(11.5, 9\/25) = cal(N)(11.5, 0.36)$ (sd $0.6$), so $beta = P_(mu_a)(macron(X)_(25) <= 11.398) = Phi((11.398 - 11.5)\/0.6) = Phi(-0.17) approx 0.4325$. Power $= 1 - beta approx 0.5675$.]

#question[State the Neyman–Pearson lemma. For a single $X ~ "Exp"(lambda)$ testing $H_0 : {lambda_0}$ vs $H_1 : {lambda_1}$ with $lambda_1 > lambda_0$, show the most powerful test rejects for small $x$ and give the critical value $c$ at level $alpha$.]
#answer[For a simple-vs-simple test the most powerful level-$alpha$ test is the likelihood-ratio test rejecting when $L(theta_1 | x) \/ L(theta_0 | x) > k$, with $k$ set so the size is $alpha$. Here $Lambda(x) = (lambda_1 \/ lambda_0) e^(-(lambda_1 - lambda_0) x)$ is decreasing in $x$ (as $lambda_1 > lambda_0$), so $Lambda(x) > k'$ becomes $x < c$. Setting $alpha = P_(lambda_0)(X < c) = 1 - e^(-lambda_0 c)$ gives $c = -ln(1 - alpha) \/ lambda_0 > 0$.]

#question[Explain what a p-value is and give two common misinterpretations of it.]
#answer[The p-value is the probability, computed under $H_0$, of observing a test statistic at least as extreme as the one observed (in the alternative's direction); one rejects at level $alpha$ iff p-value $<= alpha$. It is a statement about the data #emph[assuming the null holds] — a long-run frequency over hypothetical repetitions under $H_0$ — not a statement about $theta$ or about $H_0$ itself. (Formally, if the null is simple and the test statistic's null law is continuous, the p-value is $"Unif"(0,1)$ under $H_0$, so "reject iff p-value $<= alpha$" is exact in this special case. In general, level $alpha$ only guarantees a type I rejection probability at most $alpha$, which may be smaller and depend on the null parameter.)

Two common misinterpretations:

+ #emph["The p-value is the probability that $H_0$ is true"] (equivalently: "the probability the result occurred by chance," or "$1$ minus the probability that $H_1$/the effect is real"). This confuses $PP("data" | H_0)$ with the reversed conditional $PP(H_0 | "data")$ — an inverse-probability (base-rate) fallacy. Turning one into the other requires Bayes' rule and a prior on $H_0$, which the p-value calculation never uses, and the two quantities can diverge arbitrarily: in the Jeffreys–Lindley paradox, holding a small p-value (e.g. $0.05$) fixed while the sample size $n -> infinity$ drives the Bayes factor in favor of $H_0$ to infinity, i.e. $PP(H_0 | "data") -> 1$ even though the p-value stays "significant."

+ #emph[A small p-value means the effect is large or important, and a large p-value ($p > alpha$) proves $H_0$, i.e. shows there is no effect]. The p-value is driven by the data only through effect size #emph[and] sample size together (roughly, through a noncentrality $delta sqrt(n)/sigma$), so it conflates the two: for #emph[any] fixed nonzero true effect $delta$, however practically negligible, the p-value $-> 0$ as $n -> infinity$ — a tiny effect becomes "significant" with enough data. Conversely, a large p-value only shows the data are #emph[compatible] with $H_0$; since the power of the test depends on $n$ and $delta$, failing to reject can simply mean the study was underpowered, not that $H_0$ is true ("absence of evidence is not evidence of absence"). Statistical significance is therefore not the same as practical/scientific significance, and non-significance is not proof of the null.]
]

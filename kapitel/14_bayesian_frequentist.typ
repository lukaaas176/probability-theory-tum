#import "../vorlage.typ": *

= Bayesian vs. frequentist inference

Chapters 11 to 13 developed the frequentist toolkit — maximum-likelihood estimation, hypothesis tests with $p$-values, and confidence intervals — all resting on one picture: the unknown parameter $theta$ is a fixed constant, and probability describes the long-run frequency of outcomes across hypothetical repetitions of the experiment. This chapter introduces a genuinely different picture. Bayesian inference treats $theta$ #emph[itself] as random: we encode our belief about it as a probability distribution and update that distribution as data arrive. The two schools agree on the likelihood, disagree on what a probability #emph[is], and — as we will see — often agree numerically while disagreeing on what the numbers #emph[mean].

== The two schools of thought

Every estimator and test in the preceding chapters belongs to the #emph[frequentist] school of statistics. This school treats parameters as fixed, unknown constants and defines probability as the long-run frequency of outcomes in (hypothetical) repeated experiments. Bayesian inference offers an alternative perspective: parameters are random variables about which we hold beliefs, and those beliefs are revised in light of data. Chapter 1's guiding view — that a probability never stands on its own but always encodes a state of knowledge — is essentially the Bayesian stance made precise.

#keyfact[
The paradigms differ in two coupled ways at once.
- #emph[Nature of the parameter.] For a frequentist, $theta$ is a fixed unknown constant. For a Bayesian, $theta$ is a random variable equipped with a distribution.
- #emph[Meaning of probability.] For a frequentist, a probability is a long-run frequency over repetitions. For a Bayesian, it is a #emph[degree of belief].
Everything else — priors, posteriors, credible intervals — follows from taking $theta$ to be random.
]

== The Bayesian model: prior, likelihood, posterior

A Bayesian model keeps the frequentist likelihood but adds one new ingredient, a distribution over the parameter itself.

#definition(title: "Bayesian statistical model")[
A (parametric) *Bayesian statistical model* consists of two ingredients.
+ A *likelihood* $p(x | theta)$, exactly as in the frequentist model, describing the data-generating process for a given value of the parameter $theta in Theta$.
+ A *prior distribution* $pi(theta)$, a probability distribution over the parameter space $Theta$ that represents our belief about $theta$ #emph[before] observing any data.
]

Once data $x$ are observed, Bayes' rule combines the two ingredients into a single updated distribution.

#definition(title: "Posterior distribution")[
Given observed data $x$, Bayes' rule updates the prior into the *posterior distribution*
$
pi(theta | x) = frac(p(x | theta) pi(theta), p(x)) = frac("likelihood" times "prior", "evidence") .
$
The denominator
$
p(x) = integral_Theta p(x | theta) pi(theta) dif theta
$
is the *marginal likelihood* (or *evidence*) of the data. It does not depend on $theta$ and serves purely as a normalizing constant. Because it is often hard to evaluate, one usually works with the *unnormalized posterior*
$
pi(theta | x) prop p(x | theta) pi(theta) .
$
]

#keyfact[
The engine of Bayesian inference is one update rule,
$
pi(theta | x) quad prop quad p(x | theta) dot pi(theta) , quad quad "i.e." quad quad "posterior" prop "likelihood" times "prior" .
$
The posterior $pi(theta | x)$ is #emph[the] object of Bayesian inference: a full probability distribution that summarizes everything we know about $theta$ after seeing the data. Every Bayesian answer — a point estimate, an interval, a prediction — is obtained by squeezing this one distribution into the desired shape.
]

== Point estimates from the posterior

The posterior is a whole distribution; a point estimate collapses it into a single representative number. The choice of representative corresponds to the loss one is willing to minimize.

#definition(title: "Bayesian point estimators")[
Common point estimates derived from the posterior $pi(theta | x)$ are:
- the *posterior mean* $hat(theta)_"mean" = EE[theta | x] = integral theta pi(theta | x) dif theta$, which minimizes the posterior expected squared error;
- the *posterior median* $hat(theta)_"med"$, the value with $PP(theta <= hat(theta)_"med" | x) = 1 \/ 2$, which minimizes the posterior expected absolute error;
- the *maximum a posteriori (MAP)* estimate $hat(theta)_"map" = "arg max"_theta pi(theta | x) = "arg max"_theta p(x | theta) pi(theta)$, the mode of the posterior.
]

#remark[
The MAP estimate maximizes $p(x | theta) pi(theta)$. Dropping the prior — or using a flat prior $pi(theta) prop 1$ — makes this identical to maximizing the likelihood, so the MAP reduces to the maximum-likelihood estimate of Chapter 11. In this sense the MLE is the special case of the MAP estimate that arises under a non-informative prior; more generally, whenever the prior is informative, it is exactly the extra ingredient that regularizes the estimate toward the prior belief. This closeness to the familiar MLE is why the MAP is perhaps the most common Bayesian point estimate.
]

== Conjugate priors and the Beta--Binomial model

Computing the posterior in principle requires the evidence integral $p(x)$, which is rarely available in closed form. A #emph[conjugate prior] sidesteps this difficulty entirely: it is chosen so that the posterior belongs to the #emph[same] parametric family as the prior, turning the update into simple bookkeeping of parameters.

#definition(title: "Conjugate prior")[
A family of priors is *conjugate* to a likelihood $p(x | theta)$ if, for every prior $pi(theta)$ in the family, the resulting posterior $pi(theta | x)$ lies in the same family. Only the parameters change under the update; the functional form does not.
]

The canonical example pairs a Beta prior with a Bernoulli/Binomial likelihood — the natural model for an unknown success probability such as a coin's bias.

#example(title: "Beta–Binomial posterior update")[
Suppose we observe $x$ successes in $n$ independent $"Bernoulli"(theta)$ trials, so the likelihood is
$
p(x | theta) = binom(n, x) theta^x (1 - theta)^(n - x) prop theta^x (1 - theta)^(n - x) .
$
Encode the prior belief about the success probability $theta in [0, 1]$ by a *Beta* distribution with hyperparameters $a, b > 0$,
$
pi(theta) = frac(1, B(a, b)) theta^(a - 1) (1 - theta)^(b - 1) prop theta^(a - 1) (1 - theta)^(b - 1) ,
$
where $B(a, b)$ is the normalizing Beta function. Multiplying likelihood and prior,
$
pi(theta | x) prop theta^x (1 - theta)^(n - x) dot theta^(a - 1) (1 - theta)^(b - 1) = theta^(a + x - 1) (1 - theta)^(b + n - x - 1) .
$
This is exactly the kernel of another Beta distribution, so
$
pi(theta | x) = "Beta"(a + x, b + n - x) .
$
The Beta family is therefore conjugate to the Bernoulli/Binomial likelihood: the update just adds the observed successes $x$ to $a$ and the observed failures $n - x$ to $b$. The prior parameters $a$ and $b$ behave like #emph[pseudo-counts] of prior successes and failures.
]

#example(title: "a coin with a uniform prior")[
Flip a coin $n = 10$ times and observe $x = 8$ heads. Take the flat prior $pi(theta) = "Beta"(1, 1)$, which is the uniform distribution on $[0, 1]$ (no prior preference). The posterior is
$
pi(theta | x) = "Beta"(1 + 8, 1 + 10 - 8) = "Beta"(9, 3) .
$
Reading point estimates off this posterior — recall that for $alpha, beta > 1$ a $"Beta"(alpha, beta)$ distribution has mean $alpha \/ (alpha + beta)$ and mode $(alpha - 1) \/ (alpha + beta - 2)$ —
$
hat(theta)_"mean" = frac(a + x, a + b + n) = frac(9, 12) = 0.75 , quad quad hat(theta)_"map" = frac(a + x - 1, a + b + n - 2) = frac(8, 10) = 0.8 .
$
The MAP equals the frequentist MLE $hat(theta) = x \/ n = 0.8$, as it must under a flat prior, while the posterior mean $0.75$ is pulled slightly toward the prior mean $1 \/ 2$ — the regularizing effect of the prior. The $95%$ equal-tailed credible interval, defined next, runs between the $2.5%$ and $97.5%$ posterior quantiles and is approximately $[0.48, 0.94]$.
]

== Credible intervals versus confidence intervals

The posterior also yields interval estimates directly, by carving out a region of high posterior probability.

#definition(title: "Credible interval")[
A $100(1 - alpha)$% *credible interval* for $theta$ is an interval $(l, u)$ with
$
PP(l <= theta <= u | x) = integral_l^u pi(theta | x) dif theta = 1 - alpha .
$
The endpoints $l, u$ are #emph[fixed] numbers. A common choice is the *equal-tailed* interval, whose bounds are the $alpha \/ 2$ and $1 - alpha \/ 2$ quantiles of the posterior.
]

This looks superficially like the confidence interval of Chapter 13, but the interpretation is fundamentally different — and the difference is a favourite exam trap.

#remark[
The interpretation of a credible interval is direct and intuitive: #emph[given the observed data, the probability that $theta$ lies in this specific interval is $1 - alpha$]. Contrast this with the frequentist confidence interval of Chapter 13, whose endpoints $(L(X), U(X))$ are #emph[random] and whose $1 - alpha$ guarantee concerns the #emph[procedure]: if we repeated the sampling many times, about a fraction $1 - alpha$ of the constructed intervals would cover the fixed true $theta$. For one already-computed confidence interval the parameter is either inside or outside — no probability remains. In short, the credible interval is a statement about the parameter, whereas the confidence interval is a statement about the procedure. Interpreting a confidence interval as if it were a credible interval is one of the most common mistakes in applied statistics.
]

#example(title: "the two intervals need not agree")[
For the coin above ($n = 10$, $x = 8$) the Bayesian $95%$ credible interval is $approx [0.48, 0.94]$. The frequentist Wald confidence interval of Chapter 13, $hat(theta) plus.minus z_(alpha \/ 2) sqrt(hat(theta)(1 - hat(theta)) \/ n)$, gives
$
0.8 plus.minus 1.96 dot 0.127 approx [0.55, 1.05] ,
$
an interval that spills above $1$ and so exposes the poor small-sample behaviour of the Wald interval. With little data and a boundary-ish parameter the two disagree; with a flat prior and large $n$ they converge, as discussed next.
]

== The philosophical divide and practical convergence

The core disagreement is about two things at once: what a probability #emph[is], and what kind of object a parameter #emph[is]. Frequentists read probability as long-run frequency and treat $theta$ as a fixed constant; Bayesians read probability as a degree of belief and treat $theta$ as a random variable carrying a distribution. Broadly, frequentist inference aims to build methods with frequency guarantees over repeated sampling, while Bayesian inference aims to analyze degrees of belief.

#table(
  columns: 3,
  align: left,
  table.header([*Aspect*], [*Frequentist*], [*Bayesian*]),
  [Parameter $theta$], [Fixed unknown constant], [Random variable with a distribution],
  [Meaning of probability], [Long-run frequency over repetitions], [Degree of belief / state of knowledge],
  [Prior belief], [None], [Encoded by the prior $pi(theta)$],
  [Main inferential object], [Estimator or test built from the data], [Posterior $pi(theta | x)$],
  [Point estimate], [MLE $hat(theta)$], [Posterior mean, median, or MAP],
  [Interval], [Confidence interval (random endpoints)], [Credible interval (fixed endpoints)],
  [Interval guarantee], [Coverage of the procedure over repetitions], [Probability $theta$ is inside, given the data],
)

Despite the sharp philosophical contrast, the two paradigms frequently agree in practice. For large samples the likelihood dominates any fixed prior, so the posterior concentrates around the MLE and Bayesian and frequentist point estimates become numerically close. Under non-informative priors this extends to intervals: the credible interval for a normal mean with a flat prior is #emph[identical] to the corresponding frequentist confidence interval — yet the interpretations stay distinct. The choice between the paradigms is usually driven by whether informative prior knowledge is available and by which interpretation the problem calls for, not by a decisive mathematical superiority of either.

#quizblock(title: "Quiz — Bayesian vs. frequentist inference")[
#question[State the single most fundamental difference between the frequentist and Bayesian views, and how it changes the meaning of the word "probability".]
#answer[A frequentist treats the parameter $theta$ as a fixed unknown constant and interprets probability as a long-run frequency over (hypothetical) repeated experiments. A Bayesian treats $theta$ as a random variable equipped with a distribution and interprets probability as a degree of belief (a state of knowledge). Making $theta$ random is what allows one to speak of the "probability that $theta$ takes a certain value", which is meaningless in the frequentist picture.]

#question[Write down Bayes' rule for the posterior, name each factor, and explain the role of the denominator $p(x)$.]
#answer[$pi(theta | x) = frac(p(x | theta) pi(theta), p(x))$, i.e. posterior $=$ (likelihood $times$ prior) $\/$ evidence. Here $p(x | theta)$ is the likelihood, $pi(theta)$ the prior, and $pi(theta | x)$ the posterior. The denominator $p(x) = integral_Theta p(x | theta) pi(theta) dif theta$ is the marginal likelihood (evidence); it does not depend on $theta$ and only normalizes the posterior to integrate to $1$, which is why one often works with the unnormalized form $pi(theta | x) prop p(x | theta) pi(theta)$.]

#question[Define the posterior mean, posterior median, and MAP estimate. Under what prior does the MAP coincide with the maximum-likelihood estimate?]
#answer[Posterior mean $hat(theta)_"mean" = EE[theta | x]$ (minimizes posterior expected squared error); posterior median $hat(theta)_"med"$ with $PP(theta <= hat(theta)_"med" | x) = 1 \/ 2$ (minimizes posterior expected absolute error); MAP $hat(theta)_"map" = "arg max"_theta pi(theta | x)$, the mode of the posterior. Under a flat (non-informative) prior $pi(theta) prop 1$, maximizing $p(x | theta) pi(theta)$ is the same as maximizing $p(x | theta)$, so the MAP equals the MLE.]

#question[What is a conjugate prior, and why is it convenient? Give the standard example.]
#answer[A prior family is conjugate to a likelihood if the posterior always stays in the same family, so only the parameters update. This is convenient because it gives the posterior in closed form and avoids computing the evidence integral $p(x)$. The standard example: a $"Beta"(a, b)$ prior is conjugate to a Bernoulli/Binomial likelihood, giving posterior $"Beta"(a + x, b + n - x)$ after $x$ successes in $n$ trials.]

#question[You observe $7$ successes in $10$ independent Bernoulli trials and place a $"Beta"(2, 2)$ prior on the success probability $theta$. Give the posterior, its mean, and the MAP estimate.]
#answer[Posterior $= "Beta"(2 + 7, 2 + 3) = "Beta"(9, 5)$. Posterior mean $= frac(a + x, a + b + n) = frac(9, 14) approx 0.64$. MAP $= frac(a + x - 1, a + b + n - 2) = frac(8, 12) approx 0.67$. Both are pulled below the MLE $7 \/ 10 = 0.7$ toward the prior mean $1 \/ 2$.]

#question[Contrast the interpretation of a $95%$ credible interval with that of a $95%$ confidence interval.]
#answer[A $95%$ credible interval has fixed endpoints and the statement "given the data, $PP(theta in [l, u] | x) = 0.95$" is literally true — it is a probability statement about the parameter. A $95%$ confidence interval has random endpoints; its guarantee is about the procedure: across many repetitions about $95%$ of the constructed intervals cover the fixed true $theta$. For one realized confidence interval $theta$ is simply in it or not; no probability remains.]

#question[True or false: for a realized $95%$ confidence interval $[1.2, 3.4]$, there is a $95%$ probability that $theta$ lies in $[1.2, 3.4]$. Justify.]
#answer[False. In the frequentist framework $theta$ is a fixed constant and the realized interval is fixed too, so $theta$ is either inside or outside — the probability is $0$ or $1$, we just do not know which. The $95%$ refers to the long-run coverage of the interval-constructing procedure, not to a specific interval. The $95%$-probability reading is valid only for a Bayesian credible interval.]

#question[Under what circumstances do Bayesian and frequentist analyses tend to give numerically similar answers, even though their interpretations differ?]
#answer[When the sample size is large and/or the prior is non-informative (flat). Then the likelihood dominates the prior, the posterior concentrates around the MLE, and point estimates and intervals from the two approaches nearly coincide — e.g. the credible interval for a normal mean under a flat prior equals the frequentist confidence interval. The interpretations (statement about the parameter vs. about the procedure) remain distinct regardless.]
]

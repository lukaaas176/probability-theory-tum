#import "../vorlage.typ": *

= Convergence of random variables and limit theorems

The earlier chapters worked with a fixed collection of random variables. Statistics and machine learning, however, live in the regime where the number of observations grows: we collect a #emph[sequence] $X_1, X_2, dots$ of measurements — typically thought of as independent observations from one underlying process — and ask what happens to their average as the sample size $n$ increases. Chapter 7 already gave one quantitative handle on this through concentration inequalities, which bound how far a sum or mean can stray from its expectation. This chapter completes the picture in two steps. First we make precise what it means for a sequence of random variables to #emph[converge]: unlike for sequences of numbers, there are several genuinely different notions. Then we state the two foundational limit theorems built on them — the #emph[laws of large numbers], which say that the sample mean settles on the true mean, and the #emph[central limit theorem], which says #emph[how] the sample mean fluctuates around that mean and at what rate.

== Modes of convergence

For a sequence of real numbers there is only one notion of convergence. Random variables are functions on a sample space, so "$X_n$ gets close to $X$" can mean several inequivalent things depending on whether we track outcomes pointwise, control the probability of a gap, or only compare distributions.

#definition(title: "Modes of convergence")[
Let $(X_n)_(n in NN)$ be real-valued random variables and let $X$ be another random variable (which may be a constant). For convergence in probability and almost sure convergence, assume they are defined on the same probability space $(Omega, cal(A), PP)$. Convergence in distribution compares only their laws, so no common probability space is required.
- $(X_n)$ *converges in probability* to $X$, written $X_n ->^P X$, if for every $epsilon > 0$
  $
  lim_(n -> oo) PP(|X_n - X| >= epsilon) = 0 .
  $
  Intuitively, for large $n$ it is very unlikely that $X_n$ is far from $X$.
- $(X_n)$ *converges almost surely* to $X$, written $X_n ->^"a.s." X$ (or $X_n -> X$ a.s.), if
  $
  PP({omega in Omega : lim_(n -> oo) X_n (omega) = X(omega)}) = 1 .
  $
  Intuitively, for almost every outcome $omega$ the sequence of numbers $X_n (omega)$ converges to $X(omega)$.
- $(X_n)$ *converges in distribution* (or *weakly*) to $X$, written $X_n ->^d X$ (or $X_n => X$), if
  $
  lim_(n -> oo) F_(X_n)(x) = F_X (x)
  $
  at every point $x$ where the limit cdf $F_X$ is continuous. Equivalently, the characteristic functions converge pointwise, $lim_(n -> oo) phi_(X_n)(t) = phi_X (t)$ for all $t in RR$.
]

#remark[
The three modes express increasingly weak notions of "closeness".
- Convergence in probability and almost sure convergence are #emph[strong]: they relate $X_n$ and $X$ as functions on the #emph[same] sample space, coupling their values outcome-by-outcome rather than only comparing distributions. Almost sure convergence is the direct, pointwise statement that $X_n (omega) -> X(omega)$ for almost every $omega$, so individual values genuinely become close; convergence in probability is slightly weaker — it only makes a large gap between $X_n (omega)$ and $X(omega)$ #emph[improbable] for large $n$, not impossible for any particular $omega$ — but still couples the two variables on the same experiment.
- Convergence in distribution is much weaker: it compares only the #emph[cdfs]. The variables $X_n$ and $X$ need not even live on the same probability space, and their individual values may be entirely unrelated — one $X_n$ could be a laboratory measurement, another a count of microbes in a river, the limit $X$ a property of galaxies. All that matches in the limit is their overall #emph[probabilistic shape].
]

This distinction matters most for the central limit theorem below, which asserts only convergence in distribution: the standardized sum does not become #emph[equal] to a standard normal, its #emph[distribution] merely comes to resemble one.

== Relations between the modes

The three modes are ordered by strength, and the ordering is strict.

#keyfact[
For any sequence of random variables,
$
X_n ->^"a.s." X quad ==> quad X_n ->^P X quad ==> quad X_n ->^d X .
$
In words: almost sure convergence $=>$ convergence in probability $=>$ convergence in distribution. Neither implication reverses in general. Two partial converses do hold: if $X_n ->^P X$ then some #emph[subsequence] of $(X_n)$ converges almost surely to $X$; and if the $X_n$ are realized on a common probability space with the #emph[constant] limit $c in RR$ there, then $X_n ->^d c$ already implies $X_n ->^P c$.
]

Two examples show that the arrows cannot be reversed.

#example(title: "convergence in probability but not almost surely")[
Work on $([0, 1], cal(B)|_([0,1]), lambda|_([0,1]))$ with $lambda$ the uniform (Lebesgue) measure. Write each $n >= 1$ uniquely as $n = 2^k + j$ with $0 <= j < 2^k$, and define the #emph[travelling bump]
$
X_n = bb(1)_(I_n), quad quad I_n = [j\/2^k, (j+1)\/2^k) .
$
The bump has width $1\/2^k$ and slides across $[0, 1]$, restarting narrower each time $k$ increases. For any $epsilon in (0, 1)$,
$
PP(|X_n - 0| >= epsilon) = PP(X_n = 1) = 1\/2^k -> 0 quad (n -> oo) ,
$
so $X_n ->^P 0$. Yet for every fixed $omega in [0,1)$ there is, for each $k$, exactly one $j$ with $omega in I_n$, so $X_n (omega) = 1$ for infinitely many $n$ and the sequence $X_n (omega)$ never settles. The exceptional endpoint ${1}$ has probability zero, hence $PP(lim_(n -> oo) X_n = 0) = 0$: there is no almost sure convergence to $0$.
]

#example(title: "convergence in distribution but not in probability")[
Let $U tilde.op "Ber"(1\/2)$, set $X_n := U$ for all $n$, and put $Y := 1 - U$. Since $U$ and $1 - U$ have the same $"Ber"(1\/2)$ law, $F_(X_n) = F_Y$ for every $n$, so trivially $X_n ->^d Y$. But $U in {0, 1}$ forces
$
|X_n - Y| = |U - (1 - U)| = |2 U - 1| = 1 quad "for all" n ,
$
so $PP(|X_n - Y| >= 1) = 1$ never goes to $0$ and there is no convergence in probability. Convergence in distribution matches marginal laws only, never the joint behaviour.
]

== The laws of large numbers

With convergence defined, we can state the theorems that justify estimating an unknown mean by an observed average. Both concern the *sample mean* $accent(X, macron)_n := frac(1, n) sum_(i=1)^n X_i$.

#theorem(name: "weak law of large numbers")[
Let $X_1, X_2, dots$ be identically distributed, pairwise uncorrelated random variables with finite mean $EE[X_i] = mu$ and finite variance $"Var"(X_i) = sigma^2 < oo$. Then the sample mean converges in probability to the mean,
$
accent(X, macron)_n ->^P mu .
$
]

#proof[
By linearity of expectation $EE[accent(X, macron)_n] = frac(1, n) sum_(i=1)^n EE[X_i] = mu$, and since the $X_i$ are uncorrelated the variance of the sum is the sum of the variances, so
$
"Var"(accent(X, macron)_n) = frac(1, n^2) sum_(i=1)^n "Var"(X_i) = frac(n sigma^2, n^2) = frac(sigma^2, n) .
$
Applying Chebyshev's inequality (Chapter 7) to $accent(X, macron)_n$ gives, for every $epsilon > 0$,
$
PP(|accent(X, macron)_n - mu| >= epsilon) <= frac("Var"(accent(X, macron)_n), epsilon^2) = frac(sigma^2, n epsilon^2) -> 0 quad (n -> oo) .
$
Hence $accent(X, macron)_n ->^P mu$. The theorem in fact holds in the #emph[i.i.d.] case assuming only a finite mean (the variance may be infinite), via a more involved proof through characteristic functions (Chapter 8) rather than Chebyshev; the weaker pairwise-uncorrelated hypothesis used above does not by itself extend this far. Note that i.i.d. variables are in particular pairwise uncorrelated, so the finite-variance argument above already applies to the i.i.d. case as well.
]

#theorem(name: "strong law of large numbers")[
Let $X_1, X_2, dots$ be i.i.d. random variables with $EE[abs(X_1)] < oo$, and write $mu := EE[X_1]$. Then the sample mean converges almost surely to the mean,
$
accent(X, macron)_n ->^"a.s." mu .
$
]

#remark[
Comparing the two laws:
- The strong law implies the weak law and is genuinely stronger: it says the sample mean converges to $mu$ along #emph[almost every] individual sequence of outcomes, not merely that large deviations become improbable.
- Its proof is harder; the standard route uses the Borel–Cantelli lemmas to show that deviations from $mu$ occur only finitely often. The weak law, by contrast, also follows elegantly from characteristic functions and Lévy's continuity theorem (Chapter 8).
- Both laws are the theoretical licence for statistics: they are the reason the average of finitely many observations tells us anything about the true mean of the population that generated them. Without them (or the concentration inequalities of Chapter 7) there would be no a-priori reason to trust a sample average at all.
- What the laws do #emph[not] say is #emph[how] $accent(X, macron)_n$ is distributed around $mu$ for large but finite $n$, nor how fast it converges. That is exactly the gap the central limit theorem fills.
]

== The central limit theorem

The laws of large numbers collapse the sample mean onto a single point. Rescaling the deviation $accent(X, macron)_n - mu$ by the right factor reveals a universal shape underneath.

#theorem(name: "central limit theorem")[
Let $X_1, X_2, dots$ be i.i.d. random variables with finite mean $EE[X_i] = mu$ and finite, non-zero variance $"Var"(X_i) = sigma^2 in RR_(>0)$. Let $S_n := sum_(i=1)^n X_i$ be the sum and $accent(X, macron)_n = S_n \/ n$ the sample mean, and form the *standardized sum*
$
Z_n = frac(S_n - EE[S_n], sqrt("Var"(S_n))) = frac(S_n - n mu, sigma sqrt(n)) = frac(accent(X, macron)_n - mu, sigma \/ sqrt(n)) .
$
Then
$
Z_n ->^d cal(N)(0, 1) .
$
The scale $sigma \/ sqrt(n)$ that governs the spread of $accent(X, macron)_n$ is called the *standard error*.
]

#proof[
(Sketch, via characteristic functions.) Standardize each term by $Y_i := (X_i - mu) \/ sigma$, so $EE[Y_i] = 0$, $"Var"(Y_i) = 1$ and $Z_n = frac(1, sqrt(n)) sum_(i=1)^n Y_i$. Because the $Y_i$ are i.i.d., the characteristic function of $Z_n$ factorizes,
$
phi_(Z_n)(t) = EE[e^(i t Z_n)] = (phi_(Y_1)(t \/ sqrt(n)))^n .
$
Taylor-expanding $phi_(Y_1)$ around $0$ and using $phi_(Y_1)(0) = 1$, $phi'_(Y_1)(0) = i EE[Y_1] = 0$ and $phi''_(Y_1)(0) = -EE[Y_1^2] = -1$ gives $phi_(Y_1)(s) = 1 - s^2 \/ 2 + o(s^2)$. Substituting $s = t \/ sqrt(n)$,
$
phi_(Z_n)(t) = (1 - frac(t^2, 2 n) + o(t^2 \/ n))^n -> e^(-t^2 \/ 2) quad (n -> oo) ,
$
using the limit $(1 + x \/ n)^n -> e^x$. The right-hand side $e^(-t^2 \/ 2)$ is exactly the characteristic function of $cal(N)(0, 1)$, so by Lévy's continuity theorem (Chapter 8) $Z_n ->^d cal(N)(0, 1)$.
]

#keyfact[
For large $n$ the central limit theorem licenses the Gaussian approximations
$
S_n approx cal(N)(n mu, n sigma^2), quad quad accent(X, macron)_n approx cal(N)(mu, sigma^2 \/ n) ,
$
read as "approximately distributed like", equivalently $sqrt(n)(accent(X, macron)_n - mu) ->^d cal(N)(0, sigma^2)$. The striking point is that this holds #emph[whatever] the distribution of the $X_i$, as long as $mu$ and $sigma^2$ are finite — which is why Gaussians appear everywhere — and the fluctuations shrink at the $sqrt(n)$ rate encoded in the standard error $sigma \/ sqrt(n)$.
]

#remark[
Two cautions and a pointer.
- The compact form $accent(X, macron)_n ->^d cal(N)(mu, sigma^2 \/ n)$ is often written but is #emph[not] literally correct: convergence in distribution requires a #emph[fixed] limit, whereas the right-hand side still depends on $n$ (and degenerates to a point mass at $mu$ as $n -> oo$, consistent with the laws of large numbers). The precise statement is the standardized one, $Z_n ->^d cal(N)(0, 1)$.
- The i.i.d. assumption can be relaxed. The Lindeberg–Feller CLT covers independent but not identically distributed summands provided no single term dominates the total variance, and further versions handle certain dependent sequences. This robustness is why the normal distribution is so pervasive.
- These approximations underpin hypothesis tests and confidence intervals for means (Chapters 12 and 13); the ubiquitous "standard-error bars" in plots are an implicit appeal to the CLT.
]

#example(title: "a worked CLT approximation")[
Flip a fair coin $n = 100$ times and let $S_(100)$ be the number of heads. Writing $X_i tilde.op "Ber"(1\/2)$ for the individual flips, each has mean $mu = 1\/2$ and variance $sigma^2 = p(1 - p) = 1\/4$, so $S_(100) = sum_(i=1)^(100) X_i tilde.op "Bin"(100, 1\/2)$ has
$
EE[S_(100)] = n mu = 50, quad "Var"(S_(100)) = n sigma^2 = 25, quad sqrt("Var"(S_(100))) = 5 .
$
To approximate $PP(S_(100) >= 60)$ we standardize and invoke the CLT:
$
PP(S_(100) >= 60) = PP(frac(S_(100) - 50, 5) >= frac(60 - 50, 5)) = PP(Z_(100) >= 2) approx 1 - Phi(2) ,
$
where $Phi$ is the standard normal cdf introduced in Chapter 4. Since $Phi(2) approx 0.9772$, this gives $PP(S_(100) >= 60) approx 0.0228$, about $2.3%$. The same computation in the sample-mean form uses the standard error $sigma \/ sqrt(n) = 0.5 \/ 10 = 0.05$: the event $S_(100) >= 60$ is $accent(X, macron)_(100) >= 0.6$, and $(0.6 - 0.5) \/ 0.05 = 2$ reproduces the identical $z$-score — sum and mean are two views of the one standardized quantity. The exact binomial value is $0.0284$; a continuity correction (replacing $60$ by $59.5$, i.e. $z = 1.9$) sharpens the approximation to $1 - Phi(1.9) approx 0.0287$.
]

#quizblock(title: "Quiz — Convergence and limit theorems")[
#question[State the three modes of convergence of a sequence $(X_n)$ to $X$, with their defining conditions.]
#answer[(i) #emph[In probability], $X_n ->^P X$: for every $epsilon > 0$, $lim_(n -> oo) PP(|X_n - X| >= epsilon) = 0$. (ii) #emph[Almost surely], $X_n ->^"a.s." X$: $PP({omega : lim_(n -> oo) X_n (omega) = X(omega)}) = 1$. (iii) #emph[In distribution], $X_n ->^d X$: $lim_(n -> oo) F_(X_n)(x) = F_X (x)$ at every continuity point $x$ of $F_X$ (equivalently, $phi_(X_n)(t) -> phi_X (t)$ for all $t$).]

#question[Write the chain of implications between the three modes. Do any of the reverse implications hold?]
#answer[$X_n ->^"a.s." X ==> X_n ->^P X ==> X_n ->^d X$. The reverse implications fail in general. Two partial converses hold: convergence in probability yields a subsequence converging almost surely; and if the $X_n$ are realized on a common probability space with the #emph[constant] limit $c$ there, convergence in distribution to $c$ implies convergence in probability to $c$.]

#question[Give an example showing that convergence in distribution does not imply convergence in probability.]
#answer[Let $U tilde.op "Ber"(1\/2)$, $X_n := U$ and $Y := 1 - U$. Then $F_(X_n) = F_Y$ so $X_n ->^d Y$, but $|X_n - Y| = |2U - 1| = 1$ always, so $PP(|X_n - Y| >= 1) = 1 arrow.not 0$ and $X_n$ does not converge to $Y$ in probability.]

#question[Prove the weak law of large numbers assuming finite variance $sigma^2$, and identify where the assumptions are used.]
#answer[With $accent(X, macron)_n = frac(1, n) sum_(i=1)^n X_i$, linearity of expectation gives
$ EE[accent(X, macron)_n] = frac(1,n) sum_(i=1)^n EE[X_i] = mu $
(uses finiteness of $mu$ so each $EE[X_i]$ exists, and identical distribution so every $EE[X_i]$ equals the *same* $mu$).

By bilinearity of covariance, $"Var"(accent(X, macron)_n) = frac(1, n^2) "Var"(sum_(i=1)^n X_i)$. Pairwise uncorrelatedness (implied by independence) makes all cross terms $"Cov"(X_i, X_j) = 0$ for $i eq.not j$ vanish, so the variance of the sum is additive:
$ "Var"(sum_(i=1)^n X_i) = sum_(i=1)^n "Var"(X_i) = sum_(i=1)^n sigma^2 = n sigma^2 $
(uses identical distribution, so every $"Var"(X_i)$ equals the *same* $sigma^2$, and finiteness of $sigma^2$ so this is a well-defined finite number rather than $infinity$). Hence
$ "Var"(accent(X, macron)_n) = frac(n sigma^2, n^2) = sigma^2 \/ n , $
finite for every $n$ precisely because $sigma^2 < infinity$.

Chebyshev's inequality (itself only meaningful because $EE[accent(X, macron)_n^2] < infinity$, i.e. because the variance is finite) gives, for every $epsilon > 0$,
$ PP(|accent(X, macron)_n - mu| >= epsilon) <= "Var"(accent(X, macron)_n) \/ epsilon^2 = sigma^2 \/ (n epsilon^2) -> 0 quad "as" n -> infinity , $
i.e. $accent(X, macron)_n ->^P mu$. The convergence of the bound to $0$ relies on $sigma^2$ being a *fixed, finite* constant that does not grow with $n$ — this is exactly the finite-variance hypothesis at work.

*Where the assumptions are used:*
- *Finite mean $mu$*: needed for $EE[accent(X, macron)_n] = mu$ to exist at all.
- *Identical distribution*: makes every $EE[X_i] = mu$ (so $EE[accent(X, macron)_n]=mu$ exactly, not a mixture of different means) and every $"Var"(X_i) = sigma^2$ (so $sum_i "Var"(X_i) = n sigma^2$).
- *Independence* (only pairwise uncorrelatedness is actually needed): kills the cross-covariance terms $"Cov"(X_i,X_j)=0$, $i eq.not j$, making the variance of the sum additive. Without it, $"Var"(accent(X, macron)_n)$ need not shrink (e.g. if all $X_i$ are equal, $"Var"(accent(X, macron)_n) = sigma^2$ for every $n$).
- *Finite variance $sigma^2 < infinity$*: makes $"Var"(accent(X, macron)_n) = sigma^2\/n$ a well-defined finite quantity, makes Chebyshev's inequality a non-vacuous bound, and — being a fixed constant independent of $n$ — is exactly why $sigma^2 \/ (n epsilon^2) -> 0$ as $n -> infinity$.]

#question[How do the strong and weak laws differ, in statement and in assumptions?]
#answer[The weak law states $accent(X, macron)_n ->^P mu$ (large deviations become improbable). Its standard proof (via Chebyshev, as above) needs identically distributed, pairwise uncorrelated variables with finite #emph[variance] — finite mean alone is not enough there, since the argument needs $"Var"(accent(X, macron)_n) = sigma^2 \/ n -> 0$. A sharper version (Khinchin) needs only finite mean, but it strengthens "pairwise uncorrelated" to fully independent (i.i.d.), and is proved via characteristic functions rather than Chebyshev. The strong law states $accent(X, macron)_n ->^"a.s." mu$ (the average converges along almost every outcome sequence) and is usually stated for i.i.d. variables with finite mean alone, with no variance assumption needed. The strong law implies the weak law, but not conversely.]

#question[State the central limit theorem precisely, and give the resulting approximations for $S_n$ and $accent(X, macron)_n$.]
#answer[For i.i.d. $X_i$ with mean $mu$ and finite non-zero variance $sigma^2$, the standardized sum $Z_n = (S_n - n mu) \/ (sigma sqrt(n)) = (accent(X, macron)_n - mu) \/ (sigma \/ sqrt(n))$ satisfies $Z_n ->^d cal(N)(0, 1)$. For large $n$ this gives $S_n approx cal(N)(n mu, n sigma^2)$ and $accent(X, macron)_n approx cal(N)(mu, sigma^2 \/ n)$, equivalently $sqrt(n)(accent(X, macron)_n - mu) ->^d cal(N)(0, sigma^2)$.]

#question[Why is the frequently seen statement "$accent(X, macron)_n ->^d cal(N)(mu, sigma^2 \/ n)$" not literally correct?]
#answer[Convergence in distribution is defined only against a #emph[fixed] limit distribution, but $cal(N)(mu, sigma^2 \/ n)$ depends on $n$. Moreover, as $n -> oo$ it degenerates to a point mass at $mu$ (as the laws of large numbers require). The correct statement rescales the deviation: $Z_n = (accent(X, macron)_n - mu) \/ (sigma \/ sqrt(n)) ->^d cal(N)(0, 1)$.]

#question[The i.i.d. random variables $X_i$ have mean $mu = 20$ and standard deviation $sigma = 5$. For a sample of size $n = 100$, approximate $PP(|accent(X, macron)_(100) - 20| <= 1)$, and find the smallest $n$ making the standard error at most $0.25$. (Use $Phi(2) approx 0.9772$.)]
#answer[The standard error is $sigma \/ sqrt(n) = 5 \/ 10 = 0.5$. Standardizing, $PP(|accent(X, macron)_(100) - 20| <= 1) = PP(|Z| <= 1 \/ 0.5) = PP(|Z| <= 2) approx 2 Phi(2) - 1 approx 0.954$. For the standard error, $sigma \/ sqrt(n) <= 0.25$ means $sqrt(n) >= 5 \/ 0.25 = 20$, i.e. $n >= 400$.]
]

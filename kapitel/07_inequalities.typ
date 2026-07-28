#import "../vorlage.typ": *

= Basic probability inequalities

Chapter 6 computed the expectation and variance of specific distributions. Very often, though, the exact distribution of a quantity is unknown or too unwieldy to integrate, yet we still need to control how much probability mass can sit far out in the tails, or far from the mean. This chapter collects three inequalities that deliver such control from #emph[minimal] information — a mean, a variance, or mere convexity — with no need for the full distribution. They are the workhorses behind concentration results, previewed in the chapter's final section, and behind the weak law of large numbers in Chapter 9, previewed already in the section on Chebyshev's inequality below.

The common theme is a trade-off: the less we assume about $X$, the weaker (looser) the resulting bound. Markov's inequality assumes almost nothing and is correspondingly crude; Chebyshev's adds a variance and controls two-sided deviations; Jensen's exploits convexity to move an expectation through a nonlinear map.

== Markov's inequality

Markov's inequality bounds the probability that a non-negative random variable exceeds a threshold, using #emph[only] its mean. Intuitively: if the average is small, the variable cannot spend too much probability far above it.

#theorem(name: "Markov's inequality")[
Let $(Omega, cal(A), PP)$ be a probability space, $X : Omega -> RR$ a random variable, and $f$ a monotonically increasing, non-negative function defined on an interval $I subset.eq RR$ that contains the image $"im"(X) = X(Omega)$. Then for every $epsilon in I$ with $f(epsilon) > 0$,
$
PP(X >= epsilon) <= frac(1, f(epsilon)) EE[f(X)] .
$
In particular, taking $f(x) = x$ on the non-negative reals, for a *non-negative* random variable $X$ (that is, $PP(X >= 0) = 1$) and any constant $epsilon > 0$,
$
PP(X >= epsilon) <= frac(EE[X], epsilon) .
$
]

#proof[
We prove the non-negative special case without assuming that $X$ has a density. Pointwise,
$
X >= epsilon chi_{X >= epsilon},
$
so monotonicity and linearity of expectation give $EE[X] >= epsilon EE[chi_{X >= epsilon}] = epsilon PP(X >= epsilon)$. Dividing by $epsilon > 0$ proves the special case. The general form follows by applying it to the non-negative variable $f(X)$: monotonicity of $f$ gives ${X >= epsilon} subset.eq {f(X) >= f(epsilon)}$, and hence $PP(X >= epsilon) <= PP(f(X) >= f(epsilon)) <= EE[f(X)] / f(epsilon)$.
]

Markov's bound is deliberately blunt: it needs hardly any assumption on $X$ and consumes only the mean, so it is rarely tight — but it is the right first move when the mean is all you have.

#example(title: "bounding a tail from the mean alone")[
Suppose the average daily number of hits on a website is $EE[X] = 50$. Because the count $X$ is non-negative, Markov's inequality with $epsilon = 150$ bounds the chance of an unusually busy day:
$
PP(X >= 150) <= frac(EE[X], 150) = frac(50, 150) = frac(1, 3) .
$
So a day with at least one hundred fifty hits occurs with probability at most $1 \/ 3$ — a guarantee obtained without knowing anything about the shape of the traffic distribution.
]

== Chebyshev's inequality

Feeding the variance into Markov turns a one-sided tail bound into a two-sided #emph[deviation] bound: how likely is $X$ to land far from its mean in #emph[either] direction? This is Chebyshev's inequality, a direct corollary of Markov.

#corollary(name: "Chebyshev's inequality")[
Let $X$ be a random variable with finite variance. Then for every $epsilon > 0$,
$
PP(abs(X - EE[X]) >= epsilon) <= frac("Var"(X), epsilon^2) .
$
]

#proof[
Apply Markov's inequality with the monotone map $f(x) = x^2$ to the non-negative variable $abs(X - EE[X])$, at threshold $epsilon$. Since $abs(X - EE[X]) >= epsilon$ and $(X - EE[X])^2 >= epsilon^2$ describe the same event,
$
PP(abs(X - EE[X]) >= epsilon) = PP((X - EE[X])^2 >= epsilon^2) <= frac(EE[(X - EE[X])^2], epsilon^2) = frac("Var"(X), epsilon^2) ,
$
the last step being the definition of the variance.
]

If $sigma = sqrt("Var"(X)) > 0$, writing the threshold as $epsilon = k sigma$ for $k>0$ gives the memorable form
$
PP(abs(X - EE[X]) >= k sigma) <= frac(1, k^2) ,
$
which holds for #emph[every] distribution with finite positive variance: no matter its shape, at most $1 \/ k^2$ of the mass lies beyond $k$ standard deviations from the mean. A zero-variance variable is constant and must be handled directly because the standardized threshold would be $0$.

#example(title: "deviations in standard-deviation units")[
Let $X$ have mean $mu_X = 10$ and variance $sigma_X^2 = 4$, so $sigma_X = 2$. The probability that $X$ strays more than three standard deviations from its mean is bounded by
$
PP(abs(X - 10) >= 3 dot 2) = PP(abs(X - 10) >= 6) <= frac(1, 3^2) = frac(1, 9) .
$
Equivalently, $X$ lands outside the interval $(4, 16)$ with probability at most $1 \/ 9$ — again a universal guarantee, valid whatever the distribution of $X$ may be, as long as its mean and variance are finite.
]

Chebyshev demands more than Markov (a variance, not just a mean) and rewards you with a potentially tighter, two-sided bound. Its single most important consequence is the following.

#keyfact[
Chebyshev is the engine of the *weak law of large numbers*. For independent, identically distributed $X_1, dots, X_n$ with mean $mu$ and variance $sigma^2$, the sample mean $M_n = frac(1, n) sum_(i=1)^n X_i$ has $EE[M_n] = mu$ and $"Var"(M_n) = frac(sigma^2, n)$, so
$
PP(abs(M_n - mu) >= epsilon) <= frac(sigma^2, n epsilon^2) -> 0 quad (n -> oo) .
$
The sample mean concentrates on the true mean — this is convergence in probability, made precise in Chapter 9.
]

== Jensen's inequality

The third inequality is of a different flavour: it relates the expectation of a #emph[transformed] variable, $EE[g(X)]$, to the transformation of the expectation, $g(EE[X])$, whenever $g$ is convex.

#definition(title: "Convex function")[
A function $g : I -> RR$, defined on an interval $I subset.eq RR$ (in particular $I = RR$), is *convex* if for all $x_1, x_2 in I$ and $t in [0, 1]$,
$
g(t x_1 + (1 - t) x_2) <= t thin g(x_1) + (1 - t) thin g(x_2) ,
$
that is, every chord of the graph lies on or above the graph. It is *concave* if $-g$ is convex, and *strictly convex* if the inequality is strict whenever $x_1 != x_2$ and $t in (0, 1)$.
]

#theorem(name: "Jensen's inequality")[
Let $X$ be an integrable random variable taking values in an interval $I subset.eq RR$, and let $g : I -> RR$ be convex with $g(X)$ integrable. Then
$
g(EE[X]) <= EE[g(X)] .
$
If $g$ is concave the inequality reverses, $EE[g(X)] <= g(EE[X])$. If $g$ is strictly convex, equality holds if and only if $X$ is almost surely constant, i.e. $X = EE[X]$ with probability $1$.
]

#proof[
We sketch the differentiable case. A convex differentiable $g$ lies above each of its tangent lines; the tangent at $x_0 = EE[X]$ is $L(x) = g(EE[X]) + g'(EE[X]) (x - EE[X])$, so $g(X) >= L(X)$ pointwise. Taking expectations and using linearity, with the constants $g(EE[X])$ and $g'(EE[X])$ pulled out,
$
EE[g(X)] >= g(EE[X]) + g'(EE[X]) thin (EE[X] - EE[X]) = g(EE[X]) .
$
For non-differentiable convex $g$ the same argument works with a #emph[supporting line], which a convex function possesses at every point.
]

#example(title: "two faces of Jensen")[
- *Logarithm and the AM--GM inequality.* The map $g(x) = -ln(x)$ is convex on $(0, oo)$. For a positive random variable $X$, Jensen gives $EE[-ln(X)] >= -ln(EE[X])$, i.e.
$
EE[ln(X)] <= ln(EE[X]) :
$
the expected logarithm never exceeds the logarithm of the expectation. Specialized to a uniform average of positive numbers this is exactly the statement that the geometric mean is at most the arithmetic mean.
- *Mean versus median.* Let $X$ have finite variance, with mean $mu$, median $m$ and standard deviation $sigma$. Then
$
abs(mu - m) = abs(EE[X - m]) <= EE[abs(X - m)] <= EE[abs(X - mu)] <= sqrt(EE[(X - mu)^2]) = sigma .
$
The first inequality is Jensen for the convex map $abs(dot)$; the second uses the median's absolute-error-minimizing property from Chapter 6; the third is Jensen for the concave map $sqrt(dot)$ applied to $(X - mu)^2$. So the mean and median can differ by at most one standard deviation.
]

#keyfact[
The three tools at a glance. *Markov* needs only a finite mean and non-negativity, and gives a one-sided bound $PP(X >= epsilon) <= EE[X] \/ epsilon$. *Chebyshev* adds a variance and controls two-sided deviations, $PP(abs(X - EE[X]) >= epsilon) <= "Var"(X) \/ epsilon^2$. *Jensen* needs only convexity of $g$ and yields $g(EE[X]) <= EE[g(X)]$. The less each assumes, the looser it is: reach for the weakest one that still uses the information you actually have.
]

== Outlook: concentration inequalities

Markov and Chebyshev both bound how far $X$ strays from a reference value, so they quantify how #emph[concentrated] the probability mass is. When the quantity of interest is a function — typically a sum or average — of #emph[many independent] random variables, none of which alone changes it much, one can do far better than these polynomial bounds.

#remark[
A large body of theory shows that such functions can concentrate #emph[exponentially] tightly around their expectation under suitable boundedness, tail, independence or martingale assumptions. These #emph[concentration inequalities] carry names like *Chernoff*, *Hoeffding*, *Azuma*, *McDiarmid*, *Bennett* and *Bernstein*, and they are a cornerstone of modern statistics and machine learning. Where Markov and Chebyshev give bounds that decay only polynomially in the deviation $epsilon$, these can give exponentially small tail probabilities — the reason empirical averages over large samples are often so reliable.
]

#quizblock(title: "Quiz — Basic probability inequalities")[
#question[State Markov's inequality for a non-negative random variable $X$, and name the only feature of $X$ it uses. When is it the right tool to reach for?]
#answer[For $X >= 0$ almost surely and any $epsilon > 0$, $PP(X >= epsilon) <= EE[X] \/ epsilon$. It uses only the mean $EE[X]$ (plus non-negativity). Reach for it when you know essentially nothing beyond the mean and want a quick one-sided tail bound; expect a loose result.]

#question[Prove the non-negative form of Markov's inequality by splitting the expectation at $epsilon$.]
#answer[Split with indicators: $X=X chi_{X<epsilon}+X chi_{X>=epsilon}$. Since both terms are non-negative and $X chi_{X>=epsilon} >= epsilon chi_{X>=epsilon}$ pointwise, $EE[X] >= EE[X chi_{X>=epsilon}] >= epsilon EE[chi_{X>=epsilon}] = epsilon PP(X>=epsilon)$. Dividing by $epsilon>0$ gives Markov's inequality. This proof covers discrete, continuous and mixed laws.]

#question[A server handles on average $EE[X] = 20$ requests per second. Bound the probability that it handles at least $100$ in a given second.]
#answer[$X$ is non-negative, so Markov with $epsilon = 100$ gives $PP(X >= 100) <= 20 \/ 100 = 1 \/ 5$. At most a $20%$ chance.]

#question[How is Chebyshev's inequality obtained from Markov's? Carry out the derivation.]
#answer[Apply ordinary Markov to the non-negative random variable $Y=(X-EE[X])^2$ at the positive threshold $epsilon^2$. Since ${abs(X-EE[X])>=epsilon}={Y>=epsilon^2}$, $PP(abs(X-EE[X])>=epsilon)=PP(Y>=epsilon^2)<=EE[Y]\/epsilon^2="Var"(X)\/epsilon^2$.]

#question[A random variable $X$ has mean $10$ and variance $4$. Bound $PP(abs(X - 10) >= 6)$, and state the general $k$-standard-deviation bound.]
#answer[Here $sigma = 2$ and $6 = 3 sigma$, so Chebyshev gives $PP(abs(X - 10) >= 6) <= "Var"(X) \/ 6^2 = 4 \/ 36 = 1 \/ 9$. In general, for $sigma>0$ and $k>0$, $PP(abs(X - mu) >= k sigma) <= 1 \/ k^2$.]

#question[Use Jensen's inequality to show $EE[X^2] >= (EE[X])^2$, and say what this reveals about the variance.]
#answer[The map $g(x) = x^2$ is convex, so $EE[g(X)] >= g(EE[X])$, i.e. $EE[X^2] >= (EE[X])^2$. Rearranged, $"Var"(X) = EE[X^2] - (EE[X])^2 >= 0$ — the variance is never negative.]

#question[For a positive random variable $X$ with $EE[X]<oo$ and $EE[1\/X]<oo$, is $EE[1 \/ X]$ at least, or at most, $1 \/ EE[X]$? Justify with Jensen.]
#answer[The map $g(x) = 1 \/ x$ is strictly convex on $(0, oo)$, so Jensen gives $EE[1 \/ X] >= 1 \/ EE[X]$. Thus it is at least $1\/EE[X]$, with equality if and only if $X$ is almost surely constant.]

#question[Let $X_1, dots, X_n$ be independent and identically distributed with mean $mu$ and variance $sigma^2$, and let $M_n = frac(1, n) sum_(i=1)^n X_i$ be their sample mean. Bound $PP(abs(M_n - mu) >= epsilon)$ and give its limit as $n -> oo$. Which theorem does this establish?]
#answer[Since $EE[M_n] = mu$ and $"Var"(M_n) = sigma^2 \/ n$, Chebyshev gives $PP(abs(M_n - mu) >= epsilon) <= sigma^2 \/ (n epsilon^2) -> 0$ as $n -> oo$. This is the weak law of large numbers (convergence of $M_n$ to $mu$ in probability), developed in Chapter 9.]
]

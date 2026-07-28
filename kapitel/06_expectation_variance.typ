#import "../vorlage.typ": *

= Expectation, variance, and moments

Chapters 3 and 4 gave us the objects that describe a random variable completely: the probability mass function of a discrete $X$ and the probability density function of a continuous $X$. A full distribution is a lot of information, and in practice we rarely need all of it. This chapter develops its main numerical summaries: #emph[expectation], #emph[variance] and #emph[standard deviation]; #emph[covariance], #emph[correlation] and #emph[partial correlation] for relationships between variables; #emph[quantiles] and the #emph[median]; and conditional expectation and variance. The recurring theme is that these summaries turn full distributions into interpretable numbers while retaining enough algebra for efficient computation.

== Expectation

The expectation is the probability-weighted average of the values a random variable takes. It is defined by a sum in the discrete case and an integral in the continuous case, with a matching integrability condition that guarantees the answer is a well-defined finite number.

#definition(title: "Expectation, expected value, mean")[
Let $X$ be a real-valued random variable with distribution $P_X$. The *expectation* (or *expected value*, or *mean*) of $X$, denoted $EE[X]$ (sometimes $mu_X$), is defined as follows.
- If $X$ is *discrete* with pmf $p_X$ on a countable set $Omega subset.eq RR$, then
  $
  EE[X] = sum_(x in Omega) x thin p_X (x), quad "provided" quad sum_(x in Omega) abs(x) thin p_X (x) < oo .
  $
- If $X$ is *continuous* with pdf $p_X$, then
  $
  EE[X] = integral_(-oo)^oo x thin p_X (x) dif x, quad "provided" quad integral_(-oo)^oo abs(x) thin p_X (x) dif x < oo .
  $
Both are special cases of the unified definition $EE[X] = integral_RR x dif P_X (x)$, valid for every distribution regardless of whether a pmf or pdf exists, provided $integral_RR abs(x) dif P_X (x) < oo$. If this absolute-summability / absolute-integrability condition fails, the expectation is said to *not exist* or to be *undefined*.
]

We write the argument of the expectation in square brackets, $EE[dot.c]$, to stress that expectation is a *functional*: it takes a random variable (a measurable function) as input and returns a number. The absolute-value condition is not a technicality to be waved away — it is exactly what rules out ambiguous "$oo - oo$" situations, and some famous distributions (the Cauchy distribution among them) have no expectation at all. Throughout the course we adopt the convention that random variables are #emph[integrable], i.e. $EE[abs(X)] < oo$, unless stated otherwise, so that the mean exists.

#remark[
Why does expectation require $X$ to be *real-valued*? Consider $Omega = {circle.small, square, triangle}$ with $PP({circle.small}) = 0.5$, $PP({square}) = 0.3$, $PP({triangle}) = 0.2$, and the random variable $X(omega) = omega$. The sum $sum_(x in Omega) x thin p_X (x)$ would ask us to form $circle.small dot.op 0.5 + square dot.op 0.3 + triangle dot.op 0.2$, but multiplication by a scalar and addition are not defined for abstract symbols. Expectation relies on the values living in a set like $RR$ where these operations behave as usual. To average such outcomes we must first #emph[encode] them numerically, e.g. via a real-valued $Y$ with $Y(circle.small) = 3$, $Y(square) = 1$, $Y(triangle) = 0$, giving $EE[Y] = 3 dot.op 0.5 + 1 dot.op 0.3 + 0 dot.op 0.2 = 1.8$.
]

#example(title: "two expectations")[
#emph[Discrete.] Let $X$ be a biased three-sided die on $Omega = {1, 2, 3}$ with pmf $p_X (1) = 0.5$, $p_X (2) = 0.3$, $p_X (3) = 0.2$. Then
$
EE[X] = 1 dot.op 0.5 + 2 dot.op 0.3 + 3 dot.op 0.2 = 0.5 + 0.6 + 0.6 = 1.7,
$
and the condition $sum abs(x) p_X (x) = 1.7 < oo$ is met.

#emph[Continuous.] Let $X ~ "Unif"(a, b)$ for $a < b$, with pdf $p_X (x) = 1 \/ (b - a)$ on $[a, b]$ and $0$ elsewhere. Then
$
EE[X] = integral_a^b x dot.op frac(1, b - a) dif x = frac(1, b - a) [frac(x^2, 2)]_a^b = frac(1, b - a) dot.op frac(b^2 - a^2, 2) = frac(a + b, 2),
$
the midpoint of the interval, exactly as intuition demands.
]

== The law of the unconscious statistician

Often we do not care about $X$ itself but about some transformed quantity $Y = g(X)$ — a squared value, a cost, a payoff. Computing $EE[Y]$ by first finding the whole distribution of $Y$ is usually far more work than necessary. The following result lets us integrate $g$ directly against the distribution of $X$.

#lemma(name: "law of the unconscious statistician, LOTUS")[
Let $X$ be a real-valued random variable with distribution $P_X$, and let $g : RR -> RR$ be a measurable function. Then $Y = g(X)$ is again a real-valued random variable with expectation
$
EE[g(X)] = integral_RR g(x) dif P_X (x),
$
provided $integral_RR abs(g(x)) dif P_X (x) < oo$. Concretely,
$
EE[g(X)] = sum_(x in Omega) g(x) thin p_X (x) quad "(discrete)", quad quad EE[g(X)] = integral_(-oo)^oo g(x) thin p_X (x) dif x quad "(continuous)".
$
]

The name pokes gentle fun at how naturally one "unconsciously" plugs $g(x)$ into the mean formula in place of $x$, without stopping to derive the distribution of $g(X)$ first. LOTUS is the workhorse behind essentially every computation in the rest of this chapter: the variance, for instance, is nothing but $EE[g(X)]$ for the choice $g(x) = (x - EE[X])^2$.

== Linearity and further properties of expectation

Expectation inherits its most important properties from the linearity of sums and integrals. These are used so constantly that they deserve to be memorized as a block.

#proposition(name: "properties of expectation")[
Let $X, Y$ be real-valued random variables on the same probability space and $a, b, c in RR$ constants. Assume all relevant expectations exist. Then
+ *linearity:* $EE[a X + b Y] = a thin EE[X] + b thin EE[Y]$; as a special case $EE[a X + b] = a thin EE[X] + b$;
+ *constants:* $EE[c] = c$;
+ *non-negativity:* if $X >= 0$ (i.e. $X(omega) >= 0$ for all $omega$), then $EE[X] >= 0$;
+ *monotonicity:* if $X >= Y$, then $EE[X] >= EE[Y]$;
+ *product of independent variables:* if $X$ and $Y$ are independent, then $EE[X Y] = EE[X] thin EE[Y]$.
]

The single most important thing to notice is what property (i) does #emph[not] require. Linearity holds for #emph[any] two random variables on the same space, no matter how strongly dependent they are: $EE[X + Y] = EE[X] + EE[Y]$ always. Independence is needed only for the very different statement about the expectation of a #emph[product], property (v). Confusing the two is one of the most common mistakes in the exam.

#keyfact[
*Linearity of expectation is unconditional:* $EE[a X + b Y] = a thin EE[X] + b thin EE[Y]$ holds even when $X$ and $Y$ are dependent. In sharp contrast, independence of $X$ and $Y$ guarantees $EE[X Y] = EE[X] thin EE[Y]$ (Chapter 5). Independence is sufficient but not necessary: the product identity alone does not imply independence.
]

#example(title: "linearity without independence")[
Roll two fair dice and let $S = X_1 + X_2$ be their sum. Each $X_i$ has $EE[X_i] = (1 + 2 + dots.c + 6) \/ 6 = 3.5$, so by linearity $EE[S] = 3.5 + 3.5 = 7$ — and this stays true even if we had glued the dice together so that $X_2$ always equalled $X_1$, since linearity never asked about their dependence. Contrast this with $EE[X_1 X_2]$: because the two rolls #emph[are] independent, $EE[X_1 X_2] = EE[X_1] thin EE[X_2] = 3.5 dot.op 3.5 = 12.25$, whereas for the glued dice $EE[X_1 X_2] = EE[X_1^2] = (1 + 4 + 9 + 16 + 25 + 36) \/ 6 = 91 \/ 6 approx 15.17 eq.not 12.25$.
]

== Variance and standard deviation

The mean tells us where a distribution sits; the variance tells us how widely it is spread around that center. It is the expected squared deviation from the mean.

#definition(title: "Variance, standard deviation")[
Let $X$ be a real-valued random variable whose mean $EE[X]$ exists. The *variance* of $X$, denoted $"Var"(X)$ (sometimes $sigma_X^2$), is
$
"Var"(X) = EE[(X - EE[X])^2],
$
provided this expectation exists (for which $EE[X^2] < oo$ suffices). The *standard deviation* $sigma(X) = sigma_X$ is its non-negative square root,
$
sigma(X) = sqrt("Var"(X)) .
$
]

Variance measures the squared magnitude of the fluctuations of $X$ about its mean; because it is measured in the #emph[square] of the units of $X$, the standard deviation is often the more interpretable quantity, expressing the spread in the original units. Squaring is what makes deviations above and below the mean both count as spread rather than cancel. Expanding the square via linearity gives a formula that is almost always the easier one to compute with.

#proposition(name: "computational formula for variance")[
For any square-integrable $X$,
$
"Var"(X) = EE[X^2] - (EE[X])^2 .
$
]

#proof[
Write $mu = EE[X]$, a constant. Using LOTUS on $g(x) = (x - mu)^2$ and then linearity of expectation,
$
"Var"(X) = EE[(X - mu)^2] = EE[X^2 - 2 mu X + mu^2] = EE[X^2] - 2 mu thin EE[X] + mu^2 = EE[X^2] - 2 mu^2 + mu^2 = EE[X^2] - mu^2 . qed
$
]

#example(title: "variances of the two examples")[
#emph[Biased die (continued).] With $EE[X] = 1.7$ from before, LOTUS gives
$
EE[X^2] = 1^2 dot.op 0.5 + 2^2 dot.op 0.3 + 3^2 dot.op 0.2 = 0.5 + 1.2 + 1.8 = 3.5,
$
so $"Var"(X) = 3.5 - 1.7^2 = 3.5 - 2.89 = 0.61$ and $sigma(X) = sqrt(0.61) approx 0.781$.

#emph[Uniform (continued).] For $X ~ "Unif"(a, b)$, LOTUS gives $EE[X^2] = integral_a^b x^2 \/ (b - a) dif x = (a^2 + a b + b^2) \/ 3$. Hence
$
"Var"(X) = frac(a^2 + a b + b^2, 3) - (frac(a + b, 2))^2 = frac(4(a^2 + a b + b^2) - 3(a + b)^2, 12) = frac(a^2 - 2 a b + b^2, 12) = frac((b - a)^2, 12),
$
with standard deviation $sigma(X) = (b - a) \/ sqrt(12)$.
]

The variance interacts cleanly with affine rescaling, a fact we use whenever we standardize a variable.

#proposition(name: "properties of variance")[
Let $X, Y$ be real-valued random variables and $a, b in RR$. Assume all relevant variances exist. Then
+ *non-negativity:* $"Var"(X) >= 0$, with $"Var"(X) = 0$ if and only if $PP(X = EE[X]) = 1$ (i.e. $X$ is almost surely constant);
+ *constants:* $"Var"(b) = 0$;
+ *scaling and shifting:* $"Var"(a X + b) = a^2 "Var"(X)$; in particular adding a constant does not change the variance;
+ *sum of independent variables:* if $X$ and $Y$ are independent, then $"Var"(X + Y) = "Var"(X) + "Var"(Y)$.
]

Property (iii) is worth pausing on: shifting a distribution rigidly by $b$ leaves its spread untouched, while stretching it by a factor $a$ multiplies the variance by $a^2$ — equivalently, the standard deviation scales by $abs(a)$, since $sigma(a X + b) = abs(a) thin sigma(X)$. Property (iv) is the reason variance is so pleasant for sums of independent quantities; the general (possibly dependent) case is treated in the section on sums below, once covariance is available. Variance is the ingredient that powers the concentration inequalities of Chapter 7 (Chebyshev) and the limit theorems of Chapter 9 (the law of large numbers and the central limit theorem).

== Higher moments

Mean and variance are the first two members of a whole family of summaries built from powers of $X$.

#remark[
For $k in NN_(>0)$, the *$k$-th moment* of $X$ is $EE[X^k]$ (when it exists), and the *$k$-th central moment* is $EE[(X - EE[X])^k]$. In this language the mean is the first moment and the variance is the second central moment. Higher central moments carry finer shape information — the third describes #emph[asymmetry] (skewness) and the fourth the #emph[tail weight] (kurtosis) — but this course works almost exclusively with the first two. Chapter 8 introduces the moment-generating function $EE[e^(t X)]$, which packages all finite moments into derivatives at $0$ when it exists near $0$.
]

== Covariance and correlation

To summarize the joint behaviour of #emph[two] random variables we ask whether they tend to deviate from their means in the same direction. This is measured by the covariance, the natural two-variable generalization of variance.

#definition(title: "Covariance")[
Let $X$ and $Y$ be real-valued random variables on the same probability space whose means exist. The *covariance* of $X$ and $Y$, denoted $"Cov"(X, Y)$ (sometimes $sigma_(X Y)$), is
$
"Cov"(X, Y) = EE[(X - EE[X])(Y - EE[Y])],
$
provided this expectation exists.
]

A positive covariance means $X$ and $Y$ tend to lie on the same side of their means at the same time — both above, or both below (they move together); a negative covariance means they tend to lie on opposite sides. Setting $Y = X$ recovers the variance, $"Cov"(X, X) = "Var"(X)$. For random #emph[vectors] $X = (X_1, dots, X_m)^top$ and $Y = (Y_1, dots, Y_n)^top$ one collects all pairwise covariances into a *cross-covariance matrix* with entries $("Cov"(X_i, Y_j))_(i, j)$ (when $Y = X$ this reduces to the ordinary, symmetric *covariance matrix* of $X$), but the scalar case is all we need here. As with the variance, expanding the product gives a shortcut formula.

#proposition(name: "computational formula for covariance")[
For any square-integrable $X$ and $Y$,
$
"Cov"(X, Y) = EE[X Y] - EE[X] thin EE[Y] .
$
]

#proof[
Write $mu_X = EE[X]$ and $mu_Y = EE[Y]$. Expanding the product and using linearity of expectation (with $mu_X, mu_Y$ constants),
$
"Cov"(X, Y) &= EE[(X - mu_X)(Y - mu_Y)] = EE[X Y - X mu_Y - Y mu_X + mu_X mu_Y] \
&= EE[X Y] - mu_Y thin EE[X] - mu_X thin EE[Y] + mu_X mu_Y = EE[X Y] - mu_X mu_Y . qed
$
]

#keyfact[
The two shortcut identities you reach for constantly: $"Var"(X) = EE[X^2] - (EE[X])^2$ and $"Cov"(X, Y) = EE[X Y] - EE[X] thin EE[Y]$. Both turn a definition full of nested subtractions into a single subtraction of two easily computed expectations.
]

#example(title: "covariance and correlation of two variables")[
Let $(X, Y)$ be a discrete random vector with joint pmf $p(0,0) = 0.4$, $p(0,1) = 0.1$, $p(1,0) = 0.1$, $p(1,1) = 0.4$. The marginals are
$
p_X (0) = p_X (1) = 0.5, quad p_Y (0) = p_Y (1) = 0.5,
$
so $mu_X = mu_Y = 0 dot.op 0.5 + 1 dot.op 0.5 = 0.5$. The product $X Y$ equals $1$ only when $X = Y = 1$, hence
$
EE[X Y] = 1 dot.op p(1,1) = 0.4, quad "so" quad "Cov"(X, Y) = 0.4 - 0.5 dot.op 0.5 = 0.15 > 0 .
$
Because each of $X, Y$ is a $"Ber"(0.5)$ variable, $"Var"(X) = "Var"(Y) = 0.5 dot.op 0.5 = 0.25$ and $sigma_X = sigma_Y = 0.5$, so the correlation coefficient (defined next) is $"Corr"(X, Y) = 0.15 \/ (0.5 dot.op 0.5) = 0.6$: a moderately strong positive linear association.
]

Covariance is #emph[bilinear] — linear in each argument separately — which makes it behave like a symmetric "inner product" on random variables. This is the single most useful computational fact about it.

#proposition(name: "properties of covariance")[
Let $W, X, Y, Z$ be real-valued random variables and $a, b, c, d in RR$. Assume all relevant covariances exist. Then
+ *symmetry:* $"Cov"(X, Y) = "Cov"(Y, X)$;
+ *relation to variance:* $"Cov"(X, X) = "Var"(X)$;
+ *bilinearity:* $"Cov"(a X + b Y, Z) = a thin "Cov"(X, Z) + b thin "Cov"(Y, Z)$, and likewise in the second argument;
+ *constants:* $"Cov"(X, c) = 0$;
+ *independence implies zero covariance:* if $X$ and $Y$ are independent, then $"Cov"(X, Y) = 0$ (the converse is false in general).
]

Property (v) follows immediately from the product rule for independent expectations: $X$ and $Y$ independent give $EE[X Y] = EE[X] thin EE[Y]$, so $"Cov"(X, Y) = EE[X Y] - EE[X] thin EE[Y] = 0$. The warning attached to it is important: zero covariance means only the #emph[absence of a linear relationship]. For example, if $X ~ cal(N)(0,1)$ and $Y=X^2$, then $EE[X]=EE[X^3]=0$, both variances are positive, and $"Cov"(X,Y)=0$, yet $Y$ is determined by $X$.

Covariance carries the units of $X$ times the units of $Y$, which makes its raw magnitude hard to interpret. Dividing out the two standard deviations produces a dimensionless number always lying in $[-1, 1]$.

#definition(title: "Correlation coefficient")[
For real-valued $X, Y$ with $sigma_X > 0$ and $sigma_Y > 0$, the *correlation coefficient* (or *Pearson correlation coefficient*) is
$
"Corr"(X, Y) = rho_(X Y) = frac("Cov"(X, Y), sigma_X thin sigma_Y) = frac("Cov"(X, Y), sqrt("Var"(X) thin "Var"(Y))) in [-1, 1] .
$
If $"Corr"(X, Y) = 0$ we call $X$ and $Y$ *uncorrelated*.
]

#proposition(name: "properties of correlation")[
Let $X, Y$ be real-valued with $sigma_X > 0$, $sigma_Y > 0$. Then
+ *range:* $-1 <= rho_(X Y) <= 1$;
+ *perfect linear relationship:* $rho_(X Y) = 1$ if and only if $Y = a X + b$ almost surely for some $a > 0$, and $rho_(X Y) = -1$ if and only if the same holds with $a < 0$;
+ *invariance to affine transformations:* for $a eq.not 0$, $c eq.not 0$, $ rho_(a X + b, thin c Y + d) = "sign"(a c) dot.op rho_(X Y) $ so correlation is unchanged by scaling and shifting, up to sign;
+ *independence implies uncorrelated:* if $X$ and $Y$ are independent, then $rho_(X Y) = 0$ (again, the converse is false).
]

#keyfact[
Correlation is a dimensionless, standardized measure of the *linear* relationship between $X$ and $Y$, with $abs("Corr"(X, Y)) <= 1$ and the extremes $plus.minus 1$ attained exactly for a perfect affine relationship $Y = a X + b$. #emph[Independent] $=>$ #emph[uncorrelated], but #emph[not] conversely: $"Corr"(X, Y) = 0$ rules out a linear trend, not dependence in general. Scatter-plots of data with a clearly curved but symmetric shape can have correlation exactly $0$ while being highly dependent.
]

=== Partial correlation

Ordinary correlation can be induced by a third variable that is linearly related to both variables of interest. Partial correlation removes that linear contribution before measuring what remains.

#definition(title: "Partial correlation coefficient")[
Let $X,Y$ be square-integrable, non-degenerate real-valued random variables and let $Z=(Z_1,dots,Z_k)$ be a square-integrable random vector. Let $hat(X)$ and $hat(Y)$ be their best affine least-squares predictors from $Z$, and define the residuals $X_"res" := X-hat(X)$ and $Y_"res" := Y-hat(Y)$. If both residuals have positive variance, the *partial correlation of $X$ and $Y$ given $Z$* is
$
rho_(X Y | Z) := "Corr"(X_"res",Y_"res").
$
When $Z$ is a single real-valued variable and $abs(rho_(X Z)), abs(rho_(Y Z)) < 1$,
$
rho_(X Y | Z) = frac(rho_(X Y) - rho_(X Z) rho_(Y Z), sqrt((1-rho_(X Z)^2)(1-rho_(Y Z)^2))).
$
If this value is $0$, $X$ and $Y$ are *partially uncorrelated given $Z$*.
]

#remark[
Partial uncorrelatedness removes only #emph[linear] effects of $Z$ and is not the same as conditional independence $X perp perp Y | Z$ from Chapter 5. Neither property implies the other without additional assumptions; for jointly Gaussian variables the connection is much tighter.
]

== Quantiles and medians

Means and variances summarize a distribution through moments. Quantiles instead locate specified fractions of its probability mass and remain meaningful even when moments do not exist.

#definition(title: "Quantile, quantile function, median")[
Let $X$ be a real-valued random variable with cdf $F_X$, and let $q in (0,1)$. A value $x_q in RR$ is a *$q$-quantile* if
$
PP(X <= x_q) >= q quad "and" quad PP(X >= x_q) >= 1-q.
$
Equivalently, $F_X(x_q) >= q$ and $F_X(x_q^-) <= q$. Quantiles need not be unique, especially when the cdf has flat regions; jumps also prevent use of an ordinary inverse. The standard single-valued convention is the generalized inverse, or *quantile function*,
$
F_X^(-1)(q) := inf {x in RR : F_X(x) >= q}.
$
The *median* is any $1\/2$-quantile. Quartiles correspond to $q=1\/4,1\/2,3\/4$, and percentiles express $q$ as a percentage.
]

#example(title: "quantiles of an exponential distribution")[
For $X ~ "Exp"(lambda)$, $F_X(x)=1-e^(-lambda x)$ for $x >= 0$. Solving $F_X(x_q)=q$ gives
$
x_q = -frac(ln(1-q),lambda).
$
In particular the median is $ln(2)\/lambda$, whereas $EE[X]=1\/lambda$. Their difference reflects the exponential distribution's long right tail.
]

#remark[
The mean and median describe different notions of center.
- The mean uses every value and is sensitive to extreme tails; a median depends only on how probability is split and is robust to outliers.
- A quantile, hence a median, exists for every real-valued distribution, even when the mean is undefined.
- If $EE[X^2] < oo$, the mean is the unique minimizer of $c |-> EE[(X-c)^2]$.
- Any median minimizes $c |-> EE[abs(X-c)]$.
These optimization properties explain why squared-error regression targets a conditional mean while absolute-error regression targets a conditional median.
]

#theorem(name: "quantile transformation")[
Let $F$ be a cdf and define its generalized inverse
$
Q_F(u) := inf {x in RR : F(x) >= u}, quad u in (0,1).
$
If $U ~ "Unif"(0,1)$, then $Q_F(U)$ has cdf $F$. Thus every probability distribution on $RR$ can be generated by transforming one uniform random variable.
]

#proof[
By the definition of the generalized inverse and monotonicity of $F$,
$
Q_F(u) <= x quad <=> quad u <= F(x).
$
Therefore $PP(Q_F(U) <= x)=PP(U <= F(x))=F(x)$ for every $x$, which identifies the law by the cdf--measure correspondence from Chapter 2.
]

#example(title: "inverse-transform sampling")[
The theorem gives an exact sampling recipe: generate $U ~ "Unif"(0,1)$ and return $F^(-1)(U)$. For the exponential cdf above,
$
F^(-1)(U) = -frac(ln(1-U),lambda) ~ "Exp"(lambda).
$
Since $1-U ~ "Unif"(0,1)$ too, implementations commonly use $-ln(U)\/lambda$. This procedure is called *inverse-transform sampling*.
]

== Variance of a sum

Combining bilinearity of covariance with $"Cov"(X, X) = "Var"(X)$ yields the general formula for the variance of a linear combination — the identity that governs how uncertainties accumulate when random quantities are added.

#keyfact[
For real-valued $X_1, dots, X_n$ and constants $a_1, dots, a_n$,
$
"Var"(sum_(i=1)^n a_i X_i) = sum_(i=1)^n a_i^2 "Var"(X_i) + 2 sum_(1 <= i < j <= n) a_i a_j "Cov"(X_i, X_j) .
$
In particular $"Var"(X + Y) = "Var"(X) + "Var"(Y) + 2 "Cov"(X, Y)$. If the $X_i$ are #emph[pairwise independent] (or merely pairwise uncorrelated) all covariance terms vanish and the formula collapses to $"Var"(sum_i a_i X_i) = sum_i a_i^2 "Var"(X_i)$.
]

The pairwise-independent case is the reason variances of independent contributions simply add. It is exactly what makes the mean and variance of the named distributions in Chapter 15 so easy to derive, as the following flagship computation shows.

#example(title: "mean and variance of a binomial via a sum of Bernoullis")[
Let $X ~ "Bin"(n, p)$, which by Chapter 3 can be written as $X = sum_(i=1)^n X_i$ with $X_1, dots, X_n$ independent $"Ber"(p)$ indicators. Each indicator has $EE[X_i] = p$ and, since $X_i^2 = X_i$, variance $"Var"(X_i) = EE[X_i^2] - (EE[X_i])^2 = p - p^2 = p(1 - p)$. Linearity of expectation gives
$
EE[X] = sum_(i=1)^n EE[X_i] = n p,
$
and, because the indicators are independent, the covariance terms drop out and the variances add:
$
"Var"(X) = sum_(i=1)^n "Var"(X_i) = n p (1 - p) .
$
Decomposing a complicated variable into a sum of simple independent pieces, then applying linearity and the independent-sum rule, is the standard route to a mean and a variance.
]

== Conditional expectation and variance

The conditional distributions from Chapter 5 let us recompute numerical summaries after learning the value of another variable.

#definition(title: "Conditional expectation")[
Let $X,Y$ be real-valued random variables and assume the relevant expectations exist. The *conditional expectation of $Y$ given $X=x$* is the expectation under the conditional law of $Y$ given $X=x$:
$
EE[Y | X=x] = cases(
  sum_y y thin p_(Y|X=x)(y) & "in the discrete case",
  integral_(-oo)^oo y thin p_(Y|X=x)(y) dif y & "in the continuous case".
)
$
As a function $h(x):=EE[Y|X=x]$ of the conditioning value, it defines the random variable
$
EE[Y|X] := h(X),
$
called the *conditional expectation of $Y$ given $X$*.
]

#remark[
When $Y$ is square-integrable, $EE[Y|X]$ is the mean-squared-error-optimal predictor of $Y$ based on $X$: among suitable functions $g$, it minimizes $EE[(Y-g(X))^2]$. The residual is orthogonal to every square-integrable function of $X$,
$
EE[(Y-EE[Y|X]) g(X)] = 0.
$
Thus a regression method trained with squared loss is, at population level, trying to learn a conditional mean.
]

#theorem(name: "law of total expectation / tower property")[
For integrable $Y$,
$
EE[Y] = EE[EE[Y|X]].
$
Conditioning may therefore simplify a difficult expectation: compute it inside each value or group of $X$, then average those conditional means over $X$.
]

#proof[
In the continuous-density case, $p_(Y|X=x)(y) p_X(x)=p_(X,Y)(x,y)$ for almost every $x$ with $p_X(x)>0$; the conditional can be defined arbitrarily on the remaining null set. Hence marginalization gives
$
EE[EE[Y|X]]
&= integral_RR integral_RR y p_(Y|X=x)(y) p_X(x) dif y dif x \
&= integral_RR y (integral_RR p_(X,Y)(x,y) dif x) dif y
= integral_RR y p_Y(y) dif y = EE[Y].
$
The discrete proof is the same calculation with sums. The measure-theoretic theorem also covers laws without pmfs or pdfs.
]

#definition(title: "Conditional variance")[
The *conditional variance of $Y$ given $X=x$* is
$
"Var"(Y|X=x) := EE[(Y-EE[Y|X=x])^2 | X=x]
= EE[Y^2|X=x] - EE[Y|X=x]^2.
$
As $x$ varies this defines the random variable $"Var"(Y|X)$.
]

#theorem(name: "law of total variance")[
For square-integrable $Y$,
$
"Var"(Y) = EE["Var"(Y|X)] + "Var"(EE[Y|X]).
$
The first term is the average variation #emph[within] the groups determined by $X$; the second is the variation #emph[between] their conditional means.
]

#proof[
Write $m(X)=EE[Y|X]$ and insert it between $Y$ and $EE[Y]$:
$
Y-EE[Y] = (Y-m(X)) + (m(X)-EE[Y]).
$
After squaring and taking expectations, the cross term vanishes by the orthogonality property above. The tower property turns $EE[(Y-m(X))^2]$ into $EE["Var"(Y|X)]$, while the second square is $"Var"(m(X))$.
]

#example(title: "Poisson thinning via the total laws")[
Let $N ~ "Poi"(lambda)$ be the number of customers and suppose each independently buys with probability $q in [0,1]$. If $K$ is the number of purchases, then $K|N=n ~ "Bin"(n,q)$, so
$
EE[K|N]=q N, quad "Var"(K|N)=q(1-q)N.
$
The total expectation and total variance give
$
EE[K]=q EE[N]=q lambda,
$
$
"Var"(K)=q(1-q)EE[N]+q^2 "Var"(N)=q(1-q)lambda+q^2 lambda=q lambda.
$
In fact $K ~ "Poi"(q lambda)$, consistently with the mean and variance found here.
]

#remark[
In the Bayesian models introduced in Chapter 14, conditioning on a random parameter $theta$ yields the decomposition
$
"Var"(Y)=EE["Var"(Y|theta)]+"Var"(EE[Y|theta]).
$
The within-parameter term is often called *aleatoric uncertainty* (irreducible outcome variation), while the between-parameter term is called *epistemic uncertainty* (variation due to uncertainty about the parameter).
]

#quizblock(title: "Quiz — Expectation, variance, and moments")[
#question[State the definition of $EE[X]$ for a discrete random variable $X$ with pmf $p_X$ on a countable $Omega subset.eq RR$, including the condition under which it exists.]
#answer[$EE[X] = sum_(x in Omega) x thin p_X (x)$, provided the absolute-summability condition $sum_(x in Omega) abs(x) thin p_X (x) < oo$ holds. If that fails, the expectation is undefined. (For continuous $X$ the sum is replaced by $integral_(-oo)^oo x thin p_X (x) dif x$ with condition $integral abs(x) p_X (x) dif x < oo$.)]

#question[A biased three-sided die has pmf $p_X (1) = 0.5$, $p_X (2) = 0.3$, $p_X (3) = 0.2$. Compute $EE[X]$, $EE[X^2]$, $"Var"(X)$ and $sigma(X)$.]
#answer[$EE[X] = 1 dot.op 0.5 + 2 dot.op 0.3 + 3 dot.op 0.2 = 1.7$. By LOTUS $EE[X^2] = 1 dot.op 0.5 + 4 dot.op 0.3 + 9 dot.op 0.2 = 3.5$. Then $"Var"(X) = EE[X^2] - (EE[X])^2 = 3.5 - 1.7^2 = 3.5 - 2.89 = 0.61$, and $sigma(X) = sqrt(0.61) approx 0.781$.]

#question[True or false: $EE[X + Y] = EE[X] + EE[Y]$ requires $X$ and $Y$ to be independent. And what property does independence buy you?]
#answer[False. Linearity of expectation is unconditional — $EE[a X + b Y] = a thin EE[X] + b thin EE[Y]$ holds for any $X, Y$ on the same space, dependent or not. Independence is sufficient for the #emph[product] rule $EE[X Y] = EE[X] thin EE[Y]$ and hence for $"Cov"(X, Y) = 0$, but it is not necessary: uncorrelated variables satisfy the product rule without necessarily being independent.]

#question[Prove the computational formula $"Var"(X) = EE[X^2] - (EE[X])^2$ from the definition.]
#answer[Let $mu = EE[X]$. Then $"Var"(X) = EE[(X - mu)^2] = EE[X^2 - 2 mu X + mu^2] = EE[X^2] - 2 mu thin EE[X] + mu^2 = EE[X^2] - 2 mu^2 + mu^2 = EE[X^2] - mu^2$, using linearity of expectation and that $mu$ is a constant.]

#question[Given $"Var"(X) = 4$ and constants $a = 3$, $b = 10$, what is $"Var"(3 X + 10)$ and $sigma(3 X + 10)$?]
#answer[By scaling and shifting, $"Var"(a X + b) = a^2 "Var"(X) = 9 dot.op 4 = 36$ (the shift $+10$ has no effect). The standard deviation is $sigma(3 X + 10) = abs(a) thin sigma(X) = 3 dot.op 2 = 6$.]

#question[For the joint pmf $p(0,0) = 0.4$, $p(0,1) = 0.1$, $p(1,0) = 0.1$, $p(1,1) = 0.4$, compute $"Cov"(X, Y)$ and $"Corr"(X, Y)$.]
#answer[Marginals give $EE[X] = EE[Y] = 0.5$ and $"Var"(X) = "Var"(Y) = 0.25$. Only $(1,1)$ makes $X Y = 1$, so $EE[X Y] = 0.4$ and $"Cov"(X, Y) = 0.4 - 0.5 dot.op 0.5 = 0.15$. Then $"Corr"(X, Y) = 0.15 \/ (0.5 dot.op 0.5) = 0.6$.]

#question[Give the general formula for $"Var"(X + Y)$, and explain when it reduces to $"Var"(X) + "Var"(Y)$.]
#answer[$"Var"(X + Y) = "Var"(X) + "Var"(Y) + 2 "Cov"(X, Y)$. It reduces to $"Var"(X) + "Var"(Y)$ exactly when $"Cov"(X, Y) = 0$, i.e. when $X$ and $Y$ are uncorrelated — in particular whenever they are independent (which implies zero covariance).]

#question[Does $"Corr"(X, Y) = 0$ imply that $X$ and $Y$ are independent? Justify.]
#answer[No. Zero correlation means only the absence of a #emph[linear] relationship. Let $X ~ cal(N)(0,1)$ and $Y=X^2$. Then $EE[X]=EE[X^3]=0$, $"Var"(X)=1$ and $"Var"(Y)=2$, so $"Cov"(X,Y)=EE[X^3]-EE[X]EE[X^2]=0$ and $rho_(X Y)=0$. Nevertheless $Y$ is a deterministic function of $X$, so they are dependent. Independence implies uncorrelated, but not the reverse.]
]

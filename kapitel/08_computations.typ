#import "../vorlage.typ": *

= Computations with distributions

Once a random variable $X$ has a distribution, we rarely leave it untouched. We feed it through a function to obtain $Y = g(X)$, we add several independent copies together, or we standardize it before comparing to a table. This chapter assembles the toolbox for such manipulations. Two operations are central. The first is #emph[transformation]: given the distribution of $X$ and a map $g$, what is the distribution of $Y = g(X)$? The answer for smooth, monotone $g$ is the #emph[change-of-variables formula], with its characteristic $abs("derivative")$ (in one dimension) or $abs("Jacobian determinant")$ (in several) correction factor. The second is #emph[addition of independent random variables], whose distribution is given by a #emph[convolution]. Both operations become dramatically easier through #emph[integral transforms] — the characteristic function and the moment-generating function — which turn the awkward convolution into an ordinary product and encode every moment (Chapter 6) in their derivatives. We close with the Gaussian family, where all of these computations collapse into linear algebra.

Throughout we write $f_X$ for a density (pdf), $p_X$ for a probability mass function (pmf), and $F_X$ for the cumulative distribution function (cdf) introduced in Chapters 3 and 4. Densities live on continuous supports, pmfs on discrete ones; the two transformation stories run in parallel.

== Transformations: the distribution of $Y = g(X)$

The safest general recipe never guesses the density directly. Instead it goes through the cdf, because the event ${g(X) <= y}$ can always be rewritten as an event about $X$:
$
F_Y (y) = PP(Y <= y) = PP(g(X) <= y) .
$
Whenever we can turn the right-hand side into a statement of the form $PP(X in A_y)$, we obtain $F_Y$, and differentiating (in the continuous case) or differencing (in the discrete case) yields the law of $Y$. Everything below is a worked-out consequence of this single idea.

=== The discrete case

For a discrete $X$ no calculus is needed: the pmf of $Y = g(X)$ collects all the mass that $g$ sends to a common value.

#definition(title: "Pushforward pmf")[
Let $X$ be a discrete random variable with pmf $p_X$ and let $g$ be any function. The pmf of $Y = g(X)$ is
$
p_Y (y) = PP(g(X) = y) = sum_(x : g(x) = y) p_X (x) ,
$
the sum running over all $x$ in the support of $X$ with $g(x) = y$.
]

If $g$ is injective on the support of $X$, each $y$ has a unique preimage and the formula simplifies to $p_Y (g(x)) = p_X (x)$; a non-injective $g$ (such as $g(x) = x^2$) genuinely merges probabilities.

=== The continuous case: change of variables

For continuous $X$ the discrete sum is replaced by a derivative, and a monotone smooth $g$ produces the celebrated Jacobian correction. The next result is the workhorse of the chapter.

#proposition(name: "transformation of densities / change of variables")[
Let $X$ be a continuous random variable with density $f_X$, let $S_X := {x in RR : f_X (x) > 0}$ be its support, and let $g : RR -> RR$ be continuously differentiable and strictly monotonic on $S_X$. Set $Y := g(X)$. Then the density of $Y$ is
$
f_Y (y) = f_X (g^(-1)(y)) abs((dif)/(dif y) g^(-1)(y)) quad "for" y in g(S_X) ,
$
and $f_Y (y) = 0$ for $y in.not g(S_X)$.

More generally, let $X$ be a random vector in $RR^n$ with density $f_X$ and let $g : RR^n -> RR^n$ be continuously differentiable and bijective on $S_X$ with a Jacobian determinant that never vanishes. Then, with $J_(g^(-1)) (y) = [(partial g_i^(-1))/(partial y_j)]_(i,j=1)^n$ the Jacobian of the inverse map,
$
f_Y (y) = f_X (g^(-1)(y)) abs(det J_(g^(-1)) (y))
= f_X (g^(-1)(y)) 1/abs(det J_g (g^(-1)(y))) quad "for" y in g(S_X) .
$
]

#keyfact[
In one dimension the change-of-variables formula is
$
f_Y (y) = f_X (g^(-1)(y)) dot abs((dif)/(dif y) g^(-1)(y)) .
$
The absolute value of the derivative is not cosmetic: it rescales the density so that it still integrates to $1$. A map that locally stretches lengths by a factor $abs(g')$ must thin the density by the reciprocal factor to conserve probability mass — exactly the "$1 / abs(g')$" you can read off the formula via $(dif)/(dif y) g^(-1)(y) = 1 \/ g'(g^(-1)(y))$.
]

#proof[
We prove the scalar case; the vector case is the multivariate substitution rule for integrals. Suppose first that $g$ is strictly increasing, so $g^(-1)$ exists and is increasing. Then
$
F_Y (y) = PP(g(X) <= y) = PP(X <= g^(-1)(y)) = F_X (g^(-1)(y)) .
$
Differentiating with respect to $y$ by the chain rule gives $f_Y (y) = f_X (g^(-1)(y)) dot (dif)/(dif y) g^(-1)(y)$. Because $g^(-1)$ is increasing its derivative is positive, so it equals its own absolute value and the claimed formula follows. If instead $g$ is strictly decreasing, then $g^(-1)$ is decreasing and ${g(X) <= y} = {X >= g^(-1)(y)}$, whence
$
F_Y (y) = PP(X >= g^(-1)(y)) = 1 - F_X (g^(-1)(y)) .
$
Differentiating yields $f_Y (y) = - f_X (g^(-1)(y)) dot (dif)/(dif y) g^(-1)(y)$, and since the derivative is now negative, $-(dif)/(dif y) g^(-1)(y) = abs((dif)/(dif y) g^(-1)(y))$. In both cases we obtain the stated formula. If $g$ is not monotone on all of $S_X$, split $S_X$ into pieces on which $g$ is strictly monotone, apply the formula on each piece, and add the resulting contributions.
]

The most common special case is an affine map, which merely shifts and rescales.

#corollary(name: "affine transformation")[
Let $X$ have density $f_X$ and set $Y = a X + b$ with $a in RR without {0}$ and $b in RR$. Then
$
f_Y (y) = 1/abs(a) f_X ((y - b)/a) .
$
For a random vector $X$ with density $f_X$ and $Y = A X + b$ with $A in RR^(n times n)$ invertible, $f_Y (y) = f_X (A^(-1)(y - b)) \/ abs(det A)$.
]

#proof[
Here $g(x) = a x + b$ is strictly monotone with inverse $g^(-1)(y) = (y - b)\/a$ and $(dif)/(dif y) g^(-1)(y) = 1\/a$. The general formula gives $f_Y (y) = f_X ((y - b)\/a) dot abs(1\/a)$. The vector statement is the analogous Jacobian computation with $J_(g^(-1)) = A^(-1)$ and $abs(det A^(-1)) = 1\/abs(det A)$.
]

#example(title: "a worked change of variables: the log-normal")[
Let $X ~ cal(N)(0, 1)$ with density $f_X (x) = 1/sqrt(2 pi) e^(-x^2 \/ 2)$, and let $Y = e^X$. The map $g(x) = e^x$ is continuously differentiable and strictly increasing on $S_X = RR$, with image $g(S_X) = (0, oo)$, inverse $g^(-1)(y) = ln y$, and $(dif)/(dif y) ln y = 1\/y > 0$. The change-of-variables formula gives, for $y > 0$,
$
f_Y (y) = f_X (ln y) dot abs(1/y) = 1/(y sqrt(2 pi)) e^(-(ln y)^2 \/ 2) ,
$
and $f_Y (y) = 0$ for $y <= 0$. This is the #emph[log-normal] density: taking the logarithm of a log-normal variable returns a normal one. The factor $1\/y$ is precisely the Jacobian correction — without it the expression would not integrate to $1$.
]

When $g$ is not monotone we must partition the support, and preimages combine — the continuous echo of the pushforward sum.

#example(title: "a non-monotone map: the chi-squared density")[
Let $X ~ cal(N)(0, 1)$ and $Y = X^2$. Here $g(x) = x^2$ is not monotone on $RR$, so we return to the cdf. For $y > 0$,
$
F_Y (y) = PP(X^2 <= y) = PP(-sqrt(y) <= X <= sqrt(y)) = F_X (sqrt(y)) - F_X (-sqrt(y)) .
$
Differentiating with the chain rule and using that $f_X$ is even,
$
f_Y (y) = f_X (sqrt(y)) 1/(2 sqrt(y)) + f_X (-sqrt(y)) 1/(2 sqrt(y)) = (f_X (sqrt(y)))/sqrt(y) = 1/sqrt(2 pi y) e^(-y \/ 2) ,
$
for $y > 0$. This is the chi-squared density with one degree of freedom, $chi^2_1 = "Gamma"(1\/2, 1\/2)$. Note how the two monotone branches $x = plus.minus sqrt(y)$ each contribute a term, exactly as the proof's final remark predicts.
]

== Sums of independent random variables: convolution

Adding independent random variables is the operation behind sample sums and averages (Chapters 6 and 9). Its distribution is obtained by summing (or integrating) over all the ways two values can add up to a given total. This operation is the #emph[convolution].

#proposition(name: "convolution formula")[
Let $X$ and $Y$ be independent and set $Z = X + Y$.

If $X, Y$ are discrete with pmfs $p_X, p_Y$, then $Z$ has pmf
$
p_Z (z) = sum_(x) p_X (x) p_Y (z - x) ,
$
the sum running over the support of $X$.

If $X, Y$ are continuous with densities $f_X, f_Y$, then $Z$ has density
$
f_Z (z) = integral_(-oo)^oo f_X (x) f_Y (z - x) dif x .
$
]

#proof[
In the discrete case, decompose the event ${Z = z}$ over the disjoint values of $X$ and use independence:
$
p_Z (z) = PP(X + Y = z) = sum_(x) PP(X = x, Y = z - x) = sum_(x) p_X (x) p_Y (z - x) .
$
In the continuous case we compute the cdf and differentiate. By independence the joint density factors, $f_(X,Y) (x, y) = f_X (x) f_Y (y)$, so
$
F_Z (z) = PP(X + Y <= z) = integral_(-oo)^oo integral_(-oo)^(z - x) f_X (x) f_Y (y) dif y dif x .
$
Differentiating under the integral in $z$ replaces the inner integral by its integrand at $y = z - x$, giving $f_Z (z) = integral_(-oo)^oo f_X (x) f_Y (z - x) dif x$.
]

#example(title: "discrete convolution: the sum of two Poissons")[
Let $X ~ "Poi"(lambda)$ and $Y ~ "Poi"(mu)$ be independent. For $z in NN$ the supports force $0 <= x <= z$, so
$
p_Z (z) &= sum_(k=0)^z p_X (k) p_Y (z - k) = sum_(k=0)^z e^(-lambda) lambda^k/k! dot e^(-mu) mu^(z-k)/(z-k)! \
        &= e^(-(lambda + mu)) 1/z! sum_(k=0)^z binom(z, k) lambda^k mu^(z-k) = e^(-(lambda + mu)) (lambda + mu)^z/z! ,
$
where the last step is the binomial theorem. Hence $Z ~ "Poi"(lambda + mu)$: the sum of independent Poissons is Poisson with the added rates.
]

#example(title: "continuous convolution: the sum of two exponentials")[
Let $X, Y ~ "Exp"(lambda)$ be #emph[i.i.d.], with density $f(t) = lambda e^(-lambda t)$ for $t >= 0$ and $0$ otherwise, and set $Z = X + Y$. The integrand $f_X (x) f_Y (z - x)$ is non-zero only when both $x >= 0$ and $z - x >= 0$, i.e. $0 <= x <= z$. Thus for $z >= 0$,
$
f_Z (z) = integral_0^z lambda e^(-lambda x) dot lambda e^(-lambda (z - x)) dif x = lambda^2 e^(-lambda z) integral_0^z dif x = lambda^2 z e^(-lambda z) .
$
This is the $"Gamma"(2, lambda)$ (Erlang) density. Since $"Exp"(lambda) = "Gamma"(1, lambda)$, we have found $"Gamma"(1, lambda) + "Gamma"(1, lambda) = "Gamma"(2, lambda)$; iterating, the sum of $n$ i.i.d. $"Exp"(lambda)$ variables is $"Gamma"(n, lambda)$.
]

== Characteristic and moment-generating functions

Convolutions are cumbersome to iterate. The remedy is to move to a transform domain in which "adding independent variables" becomes "multiplying functions". The most important such transform always exists.

#definition(title: "characteristic function")[
The *characteristic function* (cf) of a random variable $X$ is
$
phi_X (t) = EE[e^(i t X)] = EE[cos(t X) + i sin(t X)] , quad t in RR ,
$
where $i = sqrt(-1)$. Explicitly,
$
phi_X (t) = sum_(x) e^(i t x) p_X (x) quad ("discrete"), quad quad phi_X (t) = integral_(-oo)^oo e^(i t x) f_X (x) dif x quad ("continuous") .
$
It exists for #emph[every] random variable and every $t$, because $abs(e^(i t X)) = 1$ makes the expectation of a bounded quantity.
]

#proposition(name: "properties of characteristic functions")[
Let $X, Y$ be random variables. Then
+ $phi_X (0) = 1$ and $abs(phi_X (t)) <= 1$ for all $t$;
+ $phi_(a X + b) (t) = e^(i t b) phi_X (a t)$ for constants $a, b$;
+ moments arise from derivatives: $EE[X^n] = i^(-n) phi_X^((n)) (0)$, whenever the $n$-th moment exists;
+ *product rule*: if $X$ and $Y$ are independent, then $phi_(X + Y) (t) = phi_X (t) phi_Y (t)$;
+ *uniqueness*: the cf determines the distribution — equal cfs mean equal laws, with explicit inversion formulas recovering $F_X$ or $f_X$;
+ *continuity (Lévy)*: $phi_(X_n) (t) -> phi_X (t)$ pointwise, with $phi_X$ continuous at $t = 0$, is equivalent to convergence in distribution $X_n -> X$.
]

#keyfact[
The *product rule* is the payoff. For independent $X, Y$,
$
phi_(X + Y) (t) = phi_X (t) dot phi_Y (t) ,
$
so the convolution in the "value domain" becomes an ordinary product in the "transform domain". Combined with *uniqueness*, this is the standard machine for identifying the distribution of a sum: multiply the characteristic functions, recognise the result. The *continuity* property (item 6) is in turn the engine behind the central limit theorem in Chapter 9.
]

#example(title: "cf of the normal")[
For $X ~ cal(N)(mu, sigma^2)$ the characteristic function is
$
phi_X (t) = EE[e^(i t X)] = exp(i mu t - 1/2 sigma^2 t^2) .
$
In particular the standard normal $cal(N)(0, 1)$ has $phi(t) = e^(-t^2 \/ 2)$, and property 2 recovers the general case: $phi_(sigma Z + mu) (t) = e^(i t mu) phi_Z (sigma t) = e^(i mu t) e^(-sigma^2 t^2 \/ 2)$.
]

A closely related transform trades the imaginary exponent for a real one.

#remark[
The *moment-generating function* (MGF) of $X$ is $M_X (t) = EE[e^(t X)]$, defined for those real $t$ where the expectation is finite (typically an interval around $0$). Like the cf it satisfies a product rule $M_(X + Y) (t) = M_X (t) M_Y (t)$ for independent $X, Y$, it generates moments via $EE[X^n] = M_X^((n)) (0)$, and — where it exists in a neighbourhood of $0$ — it determines the distribution uniquely. Its drawback is exactly that existence caveat: some distributions (for instance the Cauchy) have no MGF near $0$, whereas the characteristic function $phi_X (t) = EE[e^(i t X)]$ always exists. The two are formally related by $phi_X (t) = M_X (i t)$.
]

#remark[
Beyond the lecture notes, the discrete counterpart worth knowing is the *probability-generating function* (pgf) of an $NN$-valued $X$, $G_X (s) = EE[s^X] = sum_(k=0)^oo s^k p_X (k)$ for $s in [0, 1]$. It also multiplies under independence, $G_(X + Y) = G_X dot G_Y$, its derivatives at $s = 0$ recover the pmf ($p_X (k) = G_X^((k)) (0) \/ k!$) and at $s = 1$ the factorial moments — making it the transform of choice for sums of independent counting variables.
]

== Using transforms for sums

The product rule turns the recognition of sums into algebra: form the product of characteristic functions and read off which distribution it belongs to. The following reproduces, transform-side, results that would be painful by direct convolution.

#example(title: "sums of independent random variables via cf")[
#emph[Poissons.] With $X ~ "Poi"(lambda)$ one computes $phi_X (t) = exp(lambda (e^(i t) - 1))$. For independent $X ~ "Poi"(lambda)$ and $Y ~ "Poi"(mu)$,
$
phi_(X + Y) (t) = exp(lambda (e^(i t) - 1)) dot exp(mu (e^(i t) - 1)) = exp((lambda + mu)(e^(i t) - 1)) ,
$
the cf of $"Poi"(lambda + mu)$; by uniqueness $X + Y ~ "Poi"(lambda + mu)$, recovering the convolution result above with no summation.

#emph[Gammas with a common rate.] The characteristic function of $X ~ "Gamma"(alpha, beta)$ is $phi_X (t) = (1 - i t \/ beta)^(-alpha)$. For independent $X_1 ~ "Gamma"(alpha_1, beta)$ and $X_2 ~ "Gamma"(alpha_2, beta)$,
$
phi_(X_1 + X_2) (t) = (1 - i t \/ beta)^(-alpha_1) (1 - i t \/ beta)^(-alpha_2) = (1 - i t \/ beta)^(-(alpha_1 + alpha_2)) ,
$
so $X_1 + X_2 ~ "Gamma"(alpha_1 + alpha_2, beta)$. Because $"Exp"(lambda) = "Gamma"(1, lambda)$ and $chi^2_k = "Gamma"(k \/ 2, 1 \/ 2)$, this single line establishes additivity for the exponential (recovering the Erlang result) and the chi-squared families as special cases.
]

== Gaussians: computation becomes linear algebra

The Gaussian family is closed under every operation of this chapter, which is why so much of applied probability "just becomes linear algebra".

#lemma(name: "affine maps and sums of Gaussians")[
Let $X ~ cal(N)(mu, sigma^2)$. Then for $a in RR without {0}$ and $b in RR$,
$
a X + b ~ cal(N)(a mu + b, a^2 sigma^2) .
$
In particular the standardization $(X - mu) \/ sigma ~ cal(N)(0, 1)$. If moreover $X ~ cal(N)(mu_1, sigma_1^2)$ and $Y ~ cal(N)(mu_2, sigma_2^2)$ are independent, then
$
X + Y ~ cal(N)(mu_1 + mu_2, sigma_1^2 + sigma_2^2) .
$
]

#proof[
The affine statement is the change-of-variables corollary applied to the normal density (or property 2 of the cf: $phi_(a X + b) (t) = e^(i t b) phi_X (a t) = exp(i (a mu + b) t - 1/2 a^2 sigma^2 t^2)$, the cf of $cal(N)(a mu + b, a^2 sigma^2)$). For the sum, multiply characteristic functions:
$
phi_(X + Y) (t) = exp(i mu_1 t - 1/2 sigma_1^2 t^2) exp(i mu_2 t - 1/2 sigma_2^2 t^2) = exp(i (mu_1 + mu_2) t - 1/2 (sigma_1^2 + sigma_2^2) t^2) ,
$
which is the cf of $cal(N)(mu_1 + mu_2, sigma_1^2 + sigma_2^2)$; uniqueness finishes the proof.
]

The same closure holds in $RR^d$. A multivariate Gaussian $X ~ cal(N)(mu, Sigma)$ with mean $mu in RR^d$ and covariance $Sigma in RR^(d times d)$ (symmetric positive definite) has density
$
f_X (x) = 1/((2 pi)^(d \/ 2) abs(Sigma)^(1 \/ 2)) exp(-1/2 (x - mu)^top Sigma^(-1) (x - mu)) ,
$
and for any matrix $A$ and vector $b$ the affine image is again Gaussian, $A X + b ~ cal(N)(A mu + b, A Sigma A^top)$.

#remark[
For Gaussians, uncorrelated is equivalent to independent, and the family is closed under affine maps, marginalization, conditioning and linear combinations — so every such computation reduces to matrix arithmetic on the mean vector and covariance matrix. The full multivariate rules (marginals, conditionals and general linear combinations) are collected in the distribution reference of Chapter 15; here we only needed the scalar affine and additivity facts, which are direct applications of change of variables and the characteristic-function product rule.
]

#quizblock(title: "Quiz — Computations with distributions")[
#question[Let $X ~ "Unif"(0, 1)$ and $Y = - ln X$. Find the density of $Y$.]
#answer[The map $g(x) = - ln x$ is strictly decreasing on $(0, 1)$ with inverse $g^(-1)(y) = e^(-y)$ and $(dif)/(dif y) e^(-y) = - e^(-y)$. Since $f_X (x) = 1$ on $(0, 1)$ and $g((0,1)) = (0, oo)$, the change-of-variables formula gives $f_Y (y) = f_X (e^(-y)) abs(- e^(-y)) = e^(-y)$ for $y > 0$, and $0$ otherwise. Hence $Y ~ "Exp"(1)$.]

#question[A random variable $X$ has density $f_X$. Write down the density of $Y = 3 X - 2$.]
#answer[This is affine with $a = 3$, $b = -2$, so $f_Y (y) = 1/abs(3) f_X ((y + 2)/3) = 1/3 f_X ((y + 2)/3)$.]

#question[Let $X ~ cal(N)(0, 1)$. Derive the density of $Y = X^2$ and name the distribution.]
#answer[For $y > 0$, $F_Y (y) = PP(-sqrt(y) <= X <= sqrt(y)) = F_X (sqrt(y)) - F_X (-sqrt(y))$. Differentiating and using that $f_X$ is even, $f_Y (y) = f_X (sqrt(y)) \/ sqrt(y) = 1 \/ sqrt(2 pi y) dot e^(-y \/ 2)$ for $y > 0$. This is the chi-squared distribution with one degree of freedom, $chi^2_1 = "Gamma"(1\/2, 1\/2)$.]

#question[Let $X ~ "Poi"(2)$ and $Y ~ "Poi"(3)$ be independent. What is the distribution of $X + Y$, and what is $PP(X + Y = 1)$?]
#answer[By additivity of independent Poissons (convolution, or the cf product), $X + Y ~ "Poi"(5)$. Hence $PP(X + Y = 1) = e^(-5) 5^1 / 1! = 5 e^(-5) approx 0.0337$.]

#question[Let $X, Y ~ "Exp"(lambda)$ be i.i.d. Use the convolution formula to compute the density of $Z = X + Y$.]
#answer[For $z >= 0$, $f_Z (z) = integral_0^z lambda e^(-lambda x) lambda e^(-lambda (z - x)) dif x = lambda^2 e^(-lambda z) integral_0^z dif x = lambda^2 z e^(-lambda z)$. This is the $"Gamma"(2, lambda)$ (Erlang) density; $f_Z (z) = 0$ for $z < 0$.]

#question[Given that the cf of $Z ~ cal(N)(0, 1)$ is $phi_Z (t) = e^(-t^2 \/ 2)$, use a cf property to obtain the cf of $X ~ cal(N)(mu, sigma^2)$.]
#answer[Write $X = sigma Z + mu$. By $phi_(a Z + b) (t) = e^(i t b) phi_Z (a t)$ with $a = sigma$, $b = mu$, we get $phi_X (t) = e^(i t mu) phi_Z (sigma t) = e^(i mu t) e^(-sigma^2 t^2 \/ 2) = exp(i mu t - 1/2 sigma^2 t^2)$.]

#question[Let $X ~ cal(N)(1, 2)$ and $Y ~ cal(N)(-1, 3)$ be independent. What is the distribution of $2 X - Y$?]
#answer[Affine images and sums of independent Gaussians are Gaussian. The mean is $2 dot 1 - (-1) = 3$ and, by independence, the variance is $2^2 dot 2 + (-1)^2 dot 3 = 8 + 3 = 11$. Hence $2 X - Y ~ cal(N)(3, 11)$.]

#question[Explain why the characteristic function makes "sum of independent variables" easy, and use it to identify the distribution of the sum of $n$ i.i.d. $"Exp"(lambda)$ variables.]
#answer[For independent variables the cf of the sum is the product of the cfs, $phi_(sum_i X_i) = product_i phi_(X_i)$, and the cf determines the distribution uniquely. Each $X_i ~ "Exp"(lambda) = "Gamma"(1, lambda)$ has cf $(1 - i t \/ lambda)^(-1)$, so the sum has cf $(1 - i t \/ lambda)^(-n)$, which is the cf of $"Gamma"(n, lambda)$. Thus $sum_(i=1)^n X_i ~ "Gamma"(n, lambda)$ (an Erlang distribution).]
]

#import "../vorlage.typ": *

= Exam training

This final chapter puts the whole course to work. The problems below are taken and adapted from the official DWT mock exam and the summer 2025 final and retake exams, and each one is paired with a complete worked solution faithful to the official solution suggestions. Together they sweep across the curriculum: $sigma$-algebras and probability spaces (Chapter 2), discrete and continuous distributions (Chapters 3 and 4), independence (Chapter 5), expectation and variance (Chapter 6), the inequalities of Chebyshev and the limit theorems (law of large numbers, central limit theorem), and the estimation and hypothesis-testing material at the end of the course.

Each exam is presented as its own quiz block, and question numbering restarts inside every block. Use them the way you would use the real thing: cover the solution, work each problem fully on paper with a visible line of reasoning (in the exam only justified answers earn credit), then reveal and compare every intermediate step, not just the final number.

#keyfact[
A short checklist that resolves most exam problems before any computation:
- *Name the model first.* Decide whether you are counting with a Laplace space, or which named distribution fits ("fixed number of trials" $=>$ binomial; "wait for the $r$-th success" $=>$ geometric / negative binomial; "rare events at a rate" $=>$ Poisson; a density on $RR$ $=>$ continuous).
- *"At least one" $=>$ complement.* Compute $1 - PP("none")$ instead of a hard union.
- *Non-approximate bound $=>$ Chebyshev; approximate bound / large $n$ $=>$ CLT.* Chebyshev always holds but is loose; the CLT is only approximate but far sharper.
- *Estimator questions.* MLE: write the likelihood, take $ln$, differentiate, check the second derivative. Then check unbiasedness by taking an expectation, and use the CLT for the approximate sampling distribution.
]

#quizblock(title: "Mock exam — selected problems")[
#question[
#emph[(True or false, with justification.)]
(i) Is $RR without NN in cal(B)$ (the Borel $sigma$-algebra on $RR$)?
(ii) Let $X$ be a real random variable whose expectation exists. Then for #emph[every] continuous $f : RR -> RR$ we have $EE[f(X - EE[X])] = 0$.
(iii) If $X, Y$ are random variables (with existing expectations and variances) and $X <= Y$, then $"Var"(X) <= "Var"(Y)$.
(iv) Let $X_1, X_2, dots$ be iid with $EE[X_i] = 0$ and $"Var"(X_i) = 1$, and let $accent(X, macron)_n = 1/n sum_(i=1)^n X_i$. Then $F_(accent(X, macron)_n)(x) = Phi(x)$ for all $n$, where $Phi$ is the standard normal cdf.
]
#answer[
*(i) True.* Every singleton ${k}$ is Borel (it is closed), so the countable union $NN = union.big_(k in NN) {k} in cal(B)$, and $cal(B)$ is closed under complements, hence $RR without NN = NN^c in cal(B)$. This is the closure argument from Chapter 2.

*(ii) False.* Take $f(x) = x^2$. Then $EE[f(X - EE[X])] = EE[(X - EE[X])^2] = "Var"(X)$, which is not zero for any non-degenerate $X$. (The claim is only true for $f$ linear, via linearity of expectation.)

*(iii) False.* An ordering of the random variables says nothing about the spread. Let $Y = 10$ be deterministic and $X ~ "Unif"(0,1)$. Then $X <= Y$ pointwise, yet $"Var"(X) = 1/12 > 0 = "Var"(Y)$.

*(iv) False.* The equality $F_(accent(X, macron)_n) = Phi$ is what the central limit theorem gives only in the limit $n -> oo$, and even then not for $accent(X, macron)_n$ itself: the correctly scaled quantity is $sqrt(n) accent(X, macron)_n$ (here $Z_n = (sum_i X_i)/sqrt(n)$). For finite $n$ the cdf of $accent(X, macron)_n$ is generally not standard normal.
]

#question[
State (i) the strong law of large numbers with all required assumptions, and (ii) the full definition of the mode of convergence appearing in it.
]
#answer[
*(i) Strong law of large numbers.* Let $X_1, X_2, dots$ be a sequence of iid random variables with finite mean $EE[X_i] = mu < oo$, and let $accent(X, macron)_n = 1/n sum_(i=1)^n X_i$ be the sample mean. Then
$
accent(X, macron)_n ->^("a.s.") mu .
$
The essential hypotheses are: #emph[identically distributed], #emph[independent], and a #emph[finite (existing) mean]; the convergence is #emph[almost sure].

*(ii) Almost sure convergence.* A sequence $(X_n)_(n in NN)$ of random variables converges #emph[almost surely] to a random variable $X$, all defined on the same probability space $(Omega, cal(A), PP)$, if
$
PP({omega in Omega : lim_(n -> oo) X_n (omega) = X(omega)}) = 1 .
$
Note this is convergence to a random variable (or here the constant $mu$) on a common probability space, not merely convergence of numbers.
]

#question[
In a microchip factory each chip is defective with probability $p = 0.2$, independently. Quality control tests chips one by one until it has found exactly $r = 16$ defectives; those chips form one batch. Let $X ~ "NegBin"(16, 0.2)$ be the number of chips tested per batch. In one week $n = 50$ independent batches are shipped. (Recall $EE[X] = r/p$ and $"Var"(X) = r(1-p)/p^2$.)
(i) Probability that the first batch contains at most $70$ chips (leave the sum unevaluated).
(ii) A #emph[non-approximate] upper bound on the probability that the weekly total deviates from its mean by more than $300$ chips.
(iii) Using the CLT, approximate the probability that the weekly total exceeds $5000$ chips, in terms of $Phi$.
]
#answer[
*(i)* We need $16 <= X <= 70$ (at least $16$ trials are required for $16$ defectives). With the pmf $p(k) = binom(k-1, r-1) p^r (1-p)^(k-r)$ and $r = 16$, $p = 0.2$,
$
PP(16 <= X <= 70) = sum_(k=16)^70 binom(k-1, 15) (0.2)^16 (0.8)^(k-16) .
$

*(ii)* For a bound that is #emph[always] valid we use Chebyshev, which needs the mean and variance of the weekly total. For one batch,
$
EE[X] = r/p = 16/0.2 = 80, quad "Var"(X) = (r(1-p))/p^2 = (16 dot 0.8)/0.04 = 320 .
$
Let $S_50 = sum_(i=1)^50 X_i$ with the $X_i$ iid. Then $EE[S_50] = 50 dot 80 = 4000$ and $"Var"(S_50) = 50 dot 320 = 16000$. Chebyshev's inequality with $epsilon = 300$ gives
$
PP(|S_50 - 4000| >= 300) <= ("Var"(S_50))/epsilon^2 = 16000/300^2 = 16000/90000 = 8/45 .
$
*Result:* the probability is at most $8/45 approx 0.178$.

*(iii)* The standard deviation of the total is $sigma_(S_50) = sqrt(16000) = 40 sqrt(10)$. By the CLT $S_50 approx cal(N)(4000, 16000)$, so standardizing,
$
PP(S_50 > 5000) approx PP(Z > (5000 - 4000)/(40 sqrt(10))) = PP(Z > (5 sqrt(10))/2), quad Z ~ cal(N)(0,1),
$
since $1000/(40 sqrt(10)) = 25/sqrt(10) = (5 sqrt(10))/2$. Hence
$
PP(S_50 > 5000) approx 1 - Phi((5 sqrt(10))/2) = Phi(- (5 sqrt(10))/2) .
$
]

#question[
A factory makes LEDs on two lines. Line A makes $70%$ of all LEDs with defect probability $p_A = 0.05$; line B makes $30%$ with defect probability $p_B = 0.15$. An inspector draws $n = 10$ LEDs from the mixed warehouse (independent trials). (Leave powers $p^k$ unsimplified.)
(i) Probability that the sample contains exactly one defective LED.
(ii) Given exactly one defective, the probability it came from line A.
(iii) Expected number of defectives in the sample.
(iv) Testing a line-B batch one by one, the probability that the first defective is the $4$th LED tested.
]
#answer[
Let $A$, $B$ be the events "from line A / line B", so $PP(A) = 0.7$, $PP(B) = 0.3$, and let $K$ be the number of defectives among the $10$.

*(i)* By the law of total probability the defect probability of a randomly chosen LED is
$
PP("defect") = PP(A) p_A + PP(B) p_B = 0.7 dot 0.05 + 0.3 dot 0.15 = 0.08 .
$
Then $K ~ "Bin"(10, 0.08)$, so
$
PP(K = 1) = binom(10, 1) (0.08)(1 - 0.08)^9 = 0.8 (0.92)^9 .
$

*(ii)* Let $E$ be the event "exactly one defective and it is from line A". Then $PP(A | K = 1) = PP(E, K=1)/PP(K=1) = PP(E)/PP(K=1)$. For the numerator, the single defective can sit in any of the $10$ positions; that position holds a defective line-A LED (probability $PP(A) p_A = 0.7 dot 0.05 = 0.035$) and the other $9$ are non-defective (probability $(0.92)^9$). Thus
$
PP(A | K = 1) = (10 dot 0.035 (0.92)^9)/(0.8 (0.92)^9) = 0.35/0.8 = 7/16 .
$

*(iii)* Writing $K = sum_(i=1)^10 X_i$ with $X_i$ the indicator that LED $i$ is defective, the law of total expectation applied to each $X_i$ (conditioning on which line LED $i$ came from) and summed over the $10$ iid LEDs gives
$
EE[K] = sum_(i=1)^10 (p_A PP(A) + p_B PP(B)) = 10 dot 0.05 dot 0.7 + 10 dot 0.15 dot 0.3 = 0.35 + 0.45 = 0.8 .
$
(Equivalently $EE[K] = 10 dot 0.08 = 0.8$.)

*(iv)* Waiting for the first success is geometric. For line B the success (defect) probability is $p_B = 0.15$, so with $T ~ "Geo"(0.15)$,
$
PP(T = 4) = (1 - 0.15)^(4-1) (0.15) = (0.85)^3 (0.15) .
$
]

#question[
In Fluptia parents have children until they either have a daughter or reach $N in NN_(>0)$ sons (no multiple births; each child is a son or daughter with probability $1/2$).
(i) Give an explicit probability space $(Omega, cal(A), PP)$ (write $Omega$, choose $cal(A)$, give the pmf).
(ii) Define random variables $X$, $Y$ for the number of daughters and sons of a completed family.
(iii) Probability that a completed family has at least as many daughters as sons.
(iv) Given that families average $1 - 1/2^N$ sons, how many more sons than daughters does a family have on average? (You may use $sum_(k=1)^N 1/2^k = 1 - 1/2^N$.)
]
#answer[
*(i)* Writing $D$ for a daughter and $S$ for a son, the possible completed families are
$
Omega = {D, S D, S S D, dots, underbrace(S dots S, N-1) D, underbrace(S dots S, N)} =: {omega_0, omega_1, dots, omega_N},
$
where $omega_k$ means "$k$ sons were born" (followed by a daughter if $k < N$). We take $cal(A) = cal(P)(Omega)$. Since births are independent with $PP(S) = PP(D) = 1/2$, the pmf is
$
p(omega_k) = cases((1/2)^(k+1) = 1/2^(k+1) & "if" k in {0, dots, N-1}, 1/2^N & "if" k = N) .
$
(The case $k = N$ has no final daughter, hence the larger value $1/2^N$.)

*(ii)* The number of daughters and sons are
$
X(omega_k) = cases(1 & "if" k in {0, dots, N-1}, 0 & "if" k = N), quad quad Y(omega_k) = k .
$

*(iii)* The event "at least as many daughters as sons" is ${X >= Y}$. Since $Y(omega_k) = k$ and $X(omega_k) <= 1$, this event is ${omega_0}$ when $N = 1$ and ${omega_0, omega_1}$ when $N >= 2$. Hence
$
PP(X >= Y) = cases(p(omega_0) = 1/2 & "if" N = 1, p(omega_0) + p(omega_1) = 1/2 + 1/4 = 3/4 & "if" N >= 2) .
$

*(iv)* We want $EE[Y - X] = EE[Y] - EE[X]$ by linearity. Since $X in {0, 1}$,
$
PP(X = 1) = sum_(k=0)^(N-1) 1/2^(k+1) = 1 - 1/2^N, quad "so" quad EE[X] = 1 dot PP(X=1) = 1 - 1/2^N .
$
As $EE[Y] = 1 - 1/2^N$ is given, $EE[Y - X] = 0$: *on average a family has exactly as many sons as daughters.*
]
]

#quizblock(title: "Final exam (Summer 2025) — selected problems")[
#question[
#emph[(True or false, with justification.)]
(a) For a probability space $(Omega, cal(A), PP)$ and $A, B in cal(A)$ with $PP(A) > 0$, $PP(B) > 0$, always $PP(A | B) = PP(B | A)$.
(b) In a statistical model, if $hat(theta)_1, hat(theta)_2$ are unbiased estimators of $theta$, then so is $1/3 hat(theta)_1 + 2/3 hat(theta)_2$.
(c) A level-$alpha = 0.05$ test rejects $H_0$ "the batch conforms to the claimed defect proportion". One may conclude that the probability the whole batch conforms is at most $5%$.
(d) If $X, Y$ are iid $"Exp"(lambda)$, then the cdf of the ratio $X/Y$ is $F(t) = t/(1+t)$ for $t > 0$ and $0$ otherwise.
]
#answer[
*(a) False.* Take $Omega = {0, 1}$ with the Laplace measure, $A = {0, 1}$, $B = {0}$. Then
$
PP(A | B) = (PP(A inter B))/PP(B) = (1/2)/(1/2) = 1, quad PP(B | A) = (PP(A inter B))/PP(A) = (1/2)/1 = 1/2 .
$
The two agree only in special cases (e.g. $PP(A) = PP(B)$); this is exactly what Bayes' theorem corrects for.

*(b) True.* By linearity of expectation and unbiasedness $EE[hat(theta)_i] = theta$,
$
EE[1/3 hat(theta)_1 + 2/3 hat(theta)_2] = 1/3 EE[hat(theta)_1] + 2/3 EE[hat(theta)_2] = 1/3 theta + 2/3 theta = theta .
$
(Any convex combination of unbiased estimators is unbiased.)

*(c) False.* The significance level $alpha$ is a property of the #emph[procedure] (the probability of a type-I error, i.e. of rejecting a true $H_0$). It is not the probability that the null hypothesis, or the true parameter, holds for a particular batch; rejecting at level $0.05$ makes no such statement about the batch itself.

*(d) True.* Using the hint $F(t) = PP(X < t Y)$ and independence, for $t > 0$,
$
F(t) &= integral_0^oo (integral_0^(t y) lambda e^(-lambda x) d x) lambda e^(-lambda y) d y = integral_0^oo (1 - e^(-lambda t y)) lambda e^(-lambda y) d y \
     &= 1 - lambda integral_0^oo e^(-lambda (t + 1) y) d y = 1 - 1/(t + 1) = t/(t + 1) .
$
Since $PP(X/Y > 0) = 1$, we have $F(t) = 0$ for $t <= 0$.
]

#question[
State (a) the central limit theorem with all required assumptions, and (b) the full general definition of the mode of convergence appearing in it.
]
#answer[
*(a) Central limit theorem.* Let $X_1, X_2, dots$ be iid with finite mean $EE[X_i] = mu$ and finite, non-zero variance $"Var"(X_i) = sigma^2 in RR_(>0)$. Writing $S_n = sum_(i=1)^n X_i$,
$
Z_n = (S_n - EE[S_n])/sqrt("Var"(S_n)) = (S_n - n mu)/(sigma sqrt(n)) = (accent(X, macron)_n - mu)/(sigma \/ sqrt(n)) ->^("d") cal(N)(0, 1) .
$
Equivalent standard forms are $S_n approx cal(N)(n mu, n sigma^2)$ and $accent(X, macron)_n approx cal(N)(mu, sigma^2 \/ n)$ (informal large-$n$ approximations only, since the right-hand side depends on $n$ and is therefore not a fixed limit law); the precise convergence-in-distribution statement is the standardized one, $sqrt(n)(accent(X, macron)_n - mu) ->^("d") cal(N)(0, sigma^2)$.

*(b) Convergence in distribution.* A sequence $(X_n)_(n in NN)$ converges in distribution to $X$ (all on the same probability space) if
$
lim_(n -> oo) F_(X_n)(x) = F_X (x)
$
for every $x in RR$ at which $F_X$ is continuous. (Equivalently, pointwise convergence of the characteristic functions.)
]

#question[
Let $X$ be continuous with density $p_X (x) = x/c$ for $x in [0, 2]$ and $0$ otherwise.
(a) Find $c$ so that $p_X$ is a valid density.
(b) Determine the cdf $F_X$.
(c) Compute the mean and median of $X$.
(d) With $Y = ln(X)$, determine the density of $Y$. (You may use $p_Y (y) = p_X (g^(-1)(y)) |d/(d y) g^(-1)(y)|$.)
]
#answer[
*(a)* A density integrates to $1$:
$
integral_0^2 x/c d x = 1/c [x^2/2]_0^2 = 1/c (4/2 - 0) = 2/c = 1 quad ==> quad c = 2 .
$
(Since $x >= 0$ on the support, $p_X >= 0$ too.)

*(b)* Integrating the density: $F_X (x) = 0$ for $x < 0$ and $F_X (x) = 1$ for $x > 2$; for $x in [0, 2]$,
$
F_X (x) = integral_0^x t/2 d t = [t^2/4]_0^x = x^2/4 .
$
So $F_X (x) = 0$ for $x < 0$, $= x^2/4$ for $x in [0, 2]$, and $= 1$ for $x > 2$.

*(c)* Mean:
$
EE[X] = integral_0^2 x (x/2) d x = integral_0^2 x^2/2 d x = [x^3/6]_0^2 = 8/6 = 4/3 .
$
Median $m$ solves $F_X (m) = 1/2$: $m^2/4 = 1/2 => m^2 = 2 => m = sqrt(2)$.

*(d)* Here $g(x) = ln(x)$, so $g^(-1)(y) = e^y$ with $d/(d y) g^(-1)(y) = e^y$. As $X$ ranges over $[0, 2]$, $Y$ ranges over $(-oo, ln(2)]$. For $y$ in that range,
$
p_Y (y) = p_X (e^y) |e^y| = (e^y)/2 dot e^y = (e^(2 y))/2 ,
$
and $p_Y (y) = 0$ otherwise.
]

#question[
Let $X_1, dots, X_n$ be iid $"Poi"(lambda)$ with unknown $lambda > 0$ (pmf $p(x) = e^(-lambda) lambda^x \/ x!$).
(a) Derive the maximum-likelihood estimator $hat(lambda)_"mle"$.
(b) Is it unbiased for $lambda$?
(c) Use the CLT to give the approximate distribution of $hat(lambda)_"mle"$ for large $n$.
(d) Historically a light-bulb line averages $lambda_0 = 4$ defectives per batch. Testing $n = 100$ new batches gives $accent(x, macron)_100 = 5$. Construct an approximate level-$alpha = 0.05$ test of whether the mean #emph[increased], and decide. (Use $z_(0.05) approx 1.64$.)
]
#answer[
*(a)* For a sample $x = (x_1, dots, x_n)$ the likelihood is
$
L(lambda | x) = product_(i=1)^n (e^(-lambda) lambda^(x_i))/(x_i !) = (e^(-n lambda) lambda^(sum_i x_i))/(product_i x_i !) ,
$
with log-likelihood $ell(lambda) = -n lambda + (sum_i x_i) ln(lambda) - ln(product_i x_i !)$. Setting the derivative to zero,
$
(d ell)/(d lambda) = -n + 1/lambda sum_i x_i = 0 quad ==> quad lambda = 1/n sum_(i=1)^n x_i = accent(x, macron)_n .
$
The second derivative $-(sum_i x_i)\/lambda^2 < 0$ confirms a maximum, so $hat(lambda)_"mle" = accent(X, macron)_n$.

*(b) Yes.* MLEs are not unbiased in general, but here the estimator is the sample mean, which is unbiased for $EE[X_i] = lambda$: $EE[accent(X, macron)_n] = lambda$.

*(c)* Since $EE[X_i] = "Var"(X_i) = lambda$, the CLT gives, for large $n$,
$
accent(X, macron)_n approx cal(N)(EE[X_i], ("Var"(X_i))/n) = cal(N)(lambda, lambda\/n) .
$

*(d)* Test $H_0 : lambda = 4$ against the one-sided $H_1 : lambda > 4$. Under $H_0$, $hat(lambda)_"mle" = accent(X, macron)_n approx cal(N)(4, 4\/n)$, so the standardized statistic is
$
Z = (accent(X, macron)_n - 4)/sqrt(4\/100) approx cal(N)(0, 1) quad "under" H_0 .
$
This is a one-sided $z$-test with rejection region $z_"obs" > z_(0.05) approx 1.64$. Here
$
z_"obs" = (5 - 4)/sqrt(4\/100) = 1/0.2 = 5 .
$
Since $5 > 1.64$, we *reject $H_0$* at level $alpha = 0.05$: the data give strong evidence that the mean number of defectives has increased.
]

#question[
Let $m, n in NN_(>0)$. A group of $n$ hunters with perfect aim simultaneously shoot at $m$ ducks; each hunter picks a target uniformly at random and independently (so several may pick the same duck, and each shoots once). Let $X$ be the number of surviving ducks.
(a) Compute $EE[X]$.
(b) Compute $"Var"(X)$.
(c) For $n = 2$ hunters, find $k$ (as a function of $m$) with $PP(X in [EE[X] - k, EE[X] + k]) >= 0.9$.
]
#answer[
Index ducks by $i in {1, dots, m}$ and let $A_i$ = "duck $i$ survives". Duck $i$ survives iff no hunter targets it; each hunter misses it with probability $(m-1)/m$ independently, so $PP(A_i) = ((m-1)/m)^n$. Write $X_i = chi_(A_i)$, so $X = sum_(i=1)^m X_i$.

*(a)* By linearity of expectation,
$
EE[X] = sum_(i=1)^m EE[X_i] = sum_(i=1)^m PP(A_i) = m ((m-1)/m)^n .
$

*(b)* Use $"Var"(X) = EE[X^2] - EE[X]^2$ with $EE[X^2] = sum_(i, k) EE[X_i X_k]$ and $EE[X_i X_k] = PP(A_i inter A_k)$. For $i = k$, $EE[X_i^2] = PP(A_i) = ((m-1)/m)^n$. For $i eq.not k$, both survive iff every hunter avoids #emph[both], which has probability $(m-2)/m$ per hunter, so $PP(A_i inter A_k) = ((m-2)/m)^n$. There are $m$ diagonal and $m(m-1)$ off-diagonal terms:
$
EE[X^2] = m ((m-1)/m)^n + m(m-1) ((m-2)/m)^n .
$
Therefore
$
"Var"(X) = m ((m-1)/m)^n + m(m-1) ((m-2)/m)^n - m^2 ((m-1)/m)^(2 n) .
$

*(c)* The requirement $PP(X in [EE[X] - k, EE[X] + k]) >= 0.9$ is $PP(|X - EE[X]| > k) < 0.1$, so it suffices to force the Chebyshev bound $PP(|X - EE[X]| >= k) <= "Var"(X)\/k^2$ down to $0.1$, i.e. $"Var"(X)\/k^2 = 0.1$, giving $k^2 = 10 "Var"(X)$. For $n = 2$ the variance above simplifies to $"Var"(X) = (m-1)\/m^2$, hence $k^2 = 10 (m-1)/m^2$ and
$
k = ceil(sqrt(10(m-1))/m) ,
$
rounding up so the guarantee still holds.
]
]

#quizblock(title: "Retake exam (Summer 2025) — selected problems")[
#question[
#emph[(True or false, with justification.)]
(a) On $Omega = {a, b, c}$, the collection ${emptyset, {a}, {c}, {a, c}, Omega}$ is a $sigma$-algebra.
(b) For random variables $X, Y$ on a shared probability space (all needed moments existing), $"Var"(Y) >= EE["Var"(Y | X)]$.
(c) Let $S = inter { cal(A) : cal(A) "is a" sigma"-algebra with" cal(L) subset.eq cal(A) }$ be the $sigma$-algebra generated by $cal(L) subset.eq cal(P)(Omega)$. If two probability measures $P_1, P_2$ satisfy $P_1(L) = P_2(L)$ for all $L in cal(L)$, then $P_1 = P_2$.
(d) For $X_1, X_2, dots ~ "Poi"(2)$ the sample mean satisfies $accent(X, macron)_n ->^("P") 2$.
]
#answer[
*(a) False.* It is not closed under complements: $Omega without {a} = {b, c}$ is not in the collection (equivalently ${a} union {c} = {a, c}$ is present, but ${a}^c = {b,c}$ is missing).

*(b) True.* The law of total variance states
$
"Var"(Y) = EE["Var"(Y | X)] + "Var"(EE[Y | X]) ,
$
and the second summand is a variance, hence $>= 0$. Therefore $"Var"(Y) >= EE["Var"(Y | X)]$.

*(c) False.* Agreement on a generator does not force agreement on $S$ unless the generator is intersection-stable. Take $Omega = {1, 2, 3, 4}$ and $cal(L) = {{1, 2}, {2, 3}}$, so $S = cal(P)(Omega)$. The measures
$
P_1 = 1/3 delta_1 + 1/3 delta_2 + 1/3 delta_3, quad P_2 = 1/6 delta_1 + 1/2 delta_2 + 1/6 delta_3 + 1/6 delta_4
$
satisfy $P_1({1,2}) = P_2({1,2}) = P_1({2,3}) = P_2({2,3}) = 2/3$, yet $P_1 eq.not P_2$ (they differ on ${4}$).

*(d) False.* The statement is missing #emph[independence]. Without it the weak law can fail: if $X_i = X_1$ for all $i$, then $accent(X, macron)_n = X_1$ for every $n$, which does not converge to the constant $2$ (indeed $PP(|X_1 - 2| >= epsilon) > 0$ for suitable $epsilon$, since $PP(X_1 = k) > 0$ for all $k in NN$).
]

#question[
Let $U ~ "Unif"(0, 1)$ and set $X = -1/lambda ln(U)$ for a fixed $lambda > 0$.
(a) Derive the density $p_X$ (state the support).
(b) Model $X$ as a response time; the probability of waiting at least $5$ hours is $p in (0, 1)$. Having already waited $5$ hours, what is the probability of waiting at least $5$ more?
(c) Given only that $X = -1/lambda ln(U)$, $U ~ "Unif"(0, 1)$, and $EE[X] = 1/lambda$, compute $integral_0^1 ln(u) d u$ without integrating.
]
#answer[
*(a)* Here $p_U (u) = 1$ on $(0, 1)$. From $x = -1/lambda ln(u)$ we get $u = e^(-lambda x) = g^(-1)(x)$, with $d/(d x) g^(-1)(x) = -lambda e^(-lambda x)$, absolute value $lambda e^(-lambda x)$. As $u in (0, 1)$ gives $x in RR_(>=0)$, the change-of-variables formula yields
$
p_X (x) = p_U (g^(-1)(x)) |d/(d x) g^(-1)(x)| = 1 dot lambda e^(-lambda x) = lambda e^(-lambda x) quad "for" x >= 0 ,
$
and $0$ otherwise. So $X ~ "Exp"(lambda)$.

*(b)* This asks for $PP(X >= 10 | X >= 5)$. The exponential distribution is #emph[memoryless]: with $PP(X >= x) = 1 - F_X (x) = e^(-lambda x)$,
$
PP(X >= 10 | X >= 5) = (PP(X >= 10))/(PP(X >= 5)) = (e^(-10 lambda))/(e^(-5 lambda)) = e^(-5 lambda) = PP(X >= 5) = p .
$
The remaining wait has the same distribution regardless of how long you have already waited.

*(c)* By the law of the unconscious statistician (LOTUS),
$
1/lambda = EE[X] = EE[-1/lambda ln(U)] = integral_0^1 (-1/lambda ln(u)) dot 1 d u = -1/lambda integral_0^1 ln(u) d u .
$
Multiplying by $-lambda$ gives $integral_0^1 ln(u) d u = -1$.
]

#question[
A rainfall amount is modelled by the density $p_theta (x) = 1/theta^2 x e^(-x\/theta)$ for $x >= 0$, with unknown $theta > 0$, based on iid measurements $X_1, dots, X_n$.
(a) Show that the MLE is $hat(theta)_"mle" = 1/(2 n) sum_(i=1)^n X_i$.
(b) Give a Chebyshev bound on $PP(|hat(theta)_"mle" - theta| >= epsilon)$. (Use $EE[X_i] = 2 theta$, $"Var"(X_i) = 2 theta^2$.)
(c) Use the CLT to approximate $PP(|hat(theta)_"mle" - theta| >= epsilon)$ in terms of $Phi$.
(d) Contrast the results of (b) and (c).
]
#answer[
*(a)* The likelihood and log-likelihood are
$
L(theta | x) = product_(i=1)^n 1/theta^2 x_i e^(-x_i\/theta) = theta^(-2 n) (product_(i=1)^n x_i) exp(-1/theta sum_(i=1)^n x_i), quad ell(theta) = -2 n ln(theta) - 1/theta sum_(i=1)^n x_i + "const" .
$
Differentiating and setting to zero,
$
(d ell)/(d theta) = -(2 n)/theta + 1/theta^2 sum_i x_i = (-2 n theta + sum_i x_i)/theta^2 = 0 quad ==> quad hat(theta) = 1/(2 n) sum_(i=1)^n x_i .
$
The second derivative $ell''(theta) = (2 n)/theta^2 - 2/theta^3 sum_i x_i = 2/theta^3 (n theta - sum_i x_i)$ is negative at $hat(theta)$ (there $n hat(theta) - sum_i x_i = 1/2 sum_i x_i - sum_i x_i = -1/2 sum_i x_i < 0$), so $hat(theta)$ is the maximizer.

*(b)* With the given moments,
$
EE[hat(theta)_"mle"] = 1/(2 n) dot n dot 2 theta = theta, quad "Var"(hat(theta)_"mle") = 1/(2 n)^2 dot n dot 2 theta^2 = theta^2/(2 n) .
$
So the estimator is unbiased and Chebyshev gives, for any $epsilon > 0$,
$
PP(|hat(theta)_"mle" - theta| >= epsilon) <= ("Var"(hat(theta)_"mle"))/epsilon^2 = theta^2/(2 n epsilon^2) .
$

*(c)* By the CLT, $(hat(theta)_"mle" - theta)\/sqrt("Var"(hat(theta)_"mle")) = (hat(theta)_"mle" - theta)\/(theta\/sqrt(2 n)) ->^("d") cal(N)(0, 1)$, so
$
PP(|hat(theta)_"mle" - theta| >= epsilon) approx 2 Phi(- (sqrt(2 n) epsilon)/theta) .
$

*(d)* The Chebyshev bound in (b) uses only the variance and is #emph[always valid], but it is loose and decays only like $1\/n$. The CLT expression in (c) is only an #emph[approximation], but its Gaussian tail decays far faster, so it is typically much sharper. Chebyshev is a guarantee that may be pessimistic; the CLT is an accurate estimate that is not a strict bound.
]

#question[
Let $X_1, dots, X_n$ be iid with cdf $F_(X_i)$, and let the #emph[empirical cdf] be $hat(F)_n (t) = 1/n sum_(i=1)^n chi_((-oo, t])(X_i)$.
(a) Show $n hat(F)_n (t) ~ "Bin"(n, F_(X_i)(t))$.
(b) Is $hat(F)_n (t)$ unbiased for $F_(X_i)(t)$?
(c) Compute the mean squared error $"mse"(hat(F)_n (t))$.
(d) Give an approximate $100(1 - alpha)%$ confidence interval for $F_(X_i)(t)$.
]
#answer[
*(a)* Each indicator $chi_((-oo, t])(X_i)$ takes values in ${0, 1}$ with $PP(chi_((-oo, t])(X_i) = 1) = PP(X_i <= t) = F_(X_i)(t)$, so $chi_((-oo, t])(X_i) ~ "Ber"(F_(X_i)(t))$, and these are independent (as the $X_i$ are). A sum of $n$ iid Bernoulli variables is binomial:
$
n hat(F)_n (t) = sum_(i=1)^n chi_((-oo, t])(X_i) ~ "Bin"(n, F_(X_i)(t)) .
$

*(b) Yes.* Using $EE["Bin"(n, p)] = n p$,
$
EE[n hat(F)_n (t)] = n F_(X_i)(t) quad ==> quad EE[hat(F)_n (t)] = F_(X_i)(t) ,
$
so $hat(F)_n (t)$ is unbiased.

*(c)* For an unbiased estimator, $"mse" = "Var"$. With $"Var"("Bin"(n, p)) = n p (1 - p)$,
$
"Var"(n hat(F)_n (t)) = n F_(X_i)(t)(1 - F_(X_i)(t)) quad ==> quad "mse"(hat(F)_n (t)) = "Var"(hat(F)_n (t)) = (F_(X_i)(t)(1 - F_(X_i)(t)))/n .
$

*(d)* Writing $hat(p) = hat(F)_n (t)$ (an average of $"Ber"(p)$ variables with $p = F_(X_i)(t)$), the Wald interval gives the approximate $100(1 - alpha)%$ confidence interval
$
hat(F)_n (t) plus.minus z_(alpha\/2) sqrt((hat(F)_n (t)(1 - hat(F)_n (t)))/n) ,
$
where $z_(alpha\/2)$ is the $(1 - alpha\/2)$-quantile of $cal(N)(0, 1)$.
]

#question[
You play tennis against a strong opponent (win probability $p$) and a weak one (win probability $q$), with $0 < p < q < 1$; matches are independent.
(a) In a three-match tournament you win if you win two #emph[consecutive] matches. Compare schedule SWS (strong-weak-strong) with WSW (weak-strong-weak); which is better and why?
(b) The schedule is chosen by a fair coin. Told only that you won, what is $PP("SWS" | "win")$?
(c) In a four-match tournament with order SWWS you win if you win at least two #emph[non-consecutive] matches. Compute the winning probability.
]
#answer[
Let $W_i$ / $L_i$ be winning / losing match $i$. Winning two consecutive matches in three games is the disjoint event $(W_1 inter W_2) union (L_1 inter W_2 inter W_3)$, so $PP("win") = PP(W_1 inter W_2) + PP(L_1 inter W_2 inter W_3)$.

*(a)* For SWS (matches strong, weak, strong):
$
PP("win" | "SWS") = p q + (1 - p) q p = 2 p q - p^2 q = p q (2 - p) .
$
For WSW (weak, strong, weak):
$
PP("win" | "WSW") = q p + (1 - q) p q = 2 p q - p q^2 = p q (2 - q) .
$
Since $p < q$ we have $2 - p > 2 - q$, hence $p q (2 - p) > p q (2 - q)$: *schedule SWS is better.* Intuitively, only consecutive wins count, so the middle match is mandatory; placing the #emph[weak] opponent there maximizes the probability of that must-win game.

*(b)* By the law of total probability,
$
PP("win") = 1/2 PP("win" | "SWS") + 1/2 PP("win" | "WSW") = 1/2 p q (2 - p) + 1/2 p q (2 - q) = 1/2 p q (4 - p - q) .
$
Bayes' theorem then gives
$
PP("SWS" | "win") = (PP("win" | "SWS") dot 1/2)/(PP("win")) = (p q (2 - p) dot 1/2)/(1/2 p q (4 - p - q)) = (2 - p)/(4 - p - q) .
$

*(c)* Let $A_i$ = "win match $i$" (types S, W, W, S, so $PP(A_1) = PP(A_4) = p$, $PP(A_2) = PP(A_3) = q$). The non-consecutive winning pairs are $(1,3), (1,4), (2,4)$; set $E_13 = A_1 inter A_3$, $E_14 = A_1 inter A_4$, $E_24 = A_2 inter A_4$. By independence,
$
PP(E_13) = p q, quad PP(E_14) = p^2, quad PP(E_24) = q p = p q ,
$
$
PP(E_13 inter E_14) = p^2 q, quad PP(E_13 inter E_24) = p^2 q^2, quad PP(E_14 inter E_24) = p^2 q, quad PP(E_13 inter E_14 inter E_24) = p^2 q^2 .
$
By inclusion-exclusion,
$
PP("win") &= PP(E_13 union E_14 union E_24) \
          &= (p q + p^2 + p q) - (p^2 q + p^2 q^2 + p^2 q) + p^2 q^2 \
          &= 2 p q + p^2 - 2 p^2 q = p(2 q + p - 2 p q) .
$
]
]

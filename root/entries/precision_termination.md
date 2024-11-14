# Precision, Division and Termination

A simple but related problem to the [threshold limiter post](./threshold_limiter.html)...

First, some notation:

$$
f^i(k) = \begin{cases}
    f(f^{i-1}(k)) & i > 1\\
    f(k) & i = 1
\end{cases}
$$

`round(k,precision)` follows [Python's semantics](https://docs.python.org/3/library/functions.html#round); precision is the decimal place rounding is applied to.

The function of interest is $f(k)=\texttt{round}(k/2, 4), k>0$. Now, say this function is repeatedly applied and only terminates when, for some $i\gt 1$, $f^i(k) = f^{i-1}(k)$.
That is, we've arrived at a fixed point where continued applications result in the same value. For any $k>0$ does an $i$ exist?

If infinite precision was an option it doesn't seem so; for any given number a smaller number could always be produced by dividing by two.
However, in this case `round()` enforces a fixed precision of 4 decimal places (.0001).

Given $k>0$, $\frac{k}{2^i} = .0001$ is the number of divisions to reach the smallest unit of precision. Given that $i$ will
really be an integer number of divisions the result may ultimately be smaller than .0001. Given $0\lt r \leq .0001$ then
$\texttt{round}(r/2,4) \in \{ 0, .0001 \}$. If $r$ was .0001 then the termination rule applies as $\texttt{round}(.0001/2,4) = .0001$. Otherwise, the result is 0.
0/2 = 0 so the termination rule also applies in this case. Therefore, there is always an $i$ such that $f^i(k)$ always terminates.
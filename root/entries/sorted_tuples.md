# Little Lemma: Sorted Tuples

Take an $n$-tuple $T$ consisting of the integers $[0,n-1)$ such that $T = (n-1,t_1,...t_{n-1})$.

Next, constraint $A$: Given $i>0$, $\exists j$ where $0\leq j\lt i$ such that $|t_j-t_i|=1$.

Put another way, the tuple consists of the integers $[0,n-1)$ where the first integer is $n-1$. For any
integer in the tuple aside from the first $n-1$ there must exist an integer to its left that differs by 1.  

Can anything be said about the ordering of $T$? My claim: $T$ is sorted in descending order.

_Proof_

Take $t_1$. $A$ applies since $1\geq 0$. It must be the case that $0\leq j\lt 1$; so $j=0$.
Therefore, $|t_0-t_1| = 1 = |n-1-t_1| = 1$. Then $t_1=n$ or $t_1=n-2$. $n$ is out of bounds so
$t_1=n-2$.

Now $T=(n-1,n-2,t_2,...,t_{n-1})$.

So, $t_0=n-1$, $t_1=t_0-1$. Assume $t_k=t_{k-1}-1$. Then it can be shown that $t_k\implies t_{k+1}$:

\begin{align*}
t_k &= t_{k-1}-1\\
t_k-1 &= t_{k-1}-1-1\\
t_{k+1} &= t_k-1 
\end{align*}

<div style="float: right;">
$\blacksquare$
</div>
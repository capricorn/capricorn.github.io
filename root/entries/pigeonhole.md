# A Pigeonhole Proof

Take $n\geq 0$ to distribute over $k>0$ bins. $i\in [0,k)$ represents bin $i$ and $V(i)$ is
the value apportioned to each bin such that $\sum_{i\in [0,k)}V(i)=n$.

The claim: $(\exists i, V(i)\lt n/k)\implies (\exists j\neq i, V(j)\gt n/k)$.

Take the remaining $k-1$ bins aside from $i$. I restrict the remaining bins
to contain at most $n/k$. The largest sum of these remaining bins is then
$(k-1)(n/k)$. Therefore: 
$$
(k-1)(n/k) + V(i) \lt (k-1)(n/k) + (n/k)
$$ 

i.e.

$$
(k-1)(n/k) + V(i) \lt n
$$

As $V(i)$ is fixed, one of the remaining $k-1$ bins must be $\gt n/k$. $\blacksquare$

The typical pigeonhole claim is that there always exists a bin $\geq n/k$. Assume all bins equal $n/k$; true.
Otherwise, assume a bin $\gt n/k$; true. And finally, take the case described above that a bin is $\lt n/k$; true.
# A 2-Convolution Algebra of Sorts...

A 2-convolution is defined as:
$$
\text{Conv}_{2,\lambda}=\{(a,b) | a + b = \lambda, a,b\geq 0, \lambda\geq0\}
$$

For example, all solutions to $\text{Conv}_{2,2}$:
```
(0,2)
(2,0)
(1,1)
```

Next, two special symbols:
$$
\alpha=(0,\lambda)
$$
$$
\omega=(\lambda,0)
$$

Clearly these represent two valid solutions to $a+b=\lambda$.

Now for an operation:
$$
i\geq 0, \alpha^i = \alpha + i\langle 1,-1\rangle
$$

This is applied using typical vector operations; that is:
$$
\alpha^i = (i,\lambda-i)
$$

#### Lemma A -- reachability

$$
\alpha^i = \omega
$$
$$
(i,\lambda-i) = (\lambda,0)
$$
Then $i=\lambda$. That is, $\alpha^\lambda = \omega$.

Some thoughts:

- Clearly $\alpha$ can "reach" $\omega$ by repeatedly adding $\langle 1,-1\rangle$.
- Starting from $\alpha$, it takes $\lambda$ steps to reach $\omega$.
- Considered as a graph, there are (at most) $1+\lambda$ unique nodes visited.

#### Lemma B -- uniqueness

I consider a list of elements to be unique if every possible list pair is not equal.

More formally, prove: $\forall i,j \text{ s.t. } 0\leq i,j \leq\lambda, (i\neq j)\implies(\alpha^i\neq\alpha^j)$.

Examine the case
$$
\alpha^i = \alpha^j
$$

$$
(i,\lambda-i) = (j,\lambda-j)
$$

Clearly the above is only equal when $i=j$. Therefore, if $i\neq j$ then $\alpha^i \neq \alpha^j$. $\blacksquare$

The consequence is that every application $0\leq i\leq\lambda$, $\alpha^i$ is unique.
# Utilitarianism & Wealth Redistribution Noodlings

Say there are $T$ total dollars distributed across $n$ people; consider
these dollars to signify "wealth."
To redistribute this $T$ equally, each person would be apportioned
$T/n$ dollars, i.e. the mean.

Now, there is occasionally a utilitarian argument for redistribution
in that it will benefit the most people to do so. If the objective
is to redistribute equally as discussed earlier, "most people" must mean
\>50%. This can only be the case if, given the probability distribution of
wealth $W$ where $M$ is its median and $\mu$ the mean, that the mean is
greater than the median:

$$
X\sim W, \mathbb{P}(X\leq M) < \mathbb{P}(X\leq\mu)
$$

$\mathbb{P}(X\leq M) = 0.5$, so a mean greater than the median implies
that the majority of the population has less wealth than the mean.
This is simply a necessary condition of the argument; otherwise equalizing
will hurt more people than it helps.

What about considering the problem not as maximizing the number of beneficiaries but
rather maximizing the net benefit to the group? That is, compute each individual's
benefit and sum these. It is well known that $\mu$ zeroes the differences of a sample $X$, 
i.e. $\sum_{x\in X}(x-\mu)=0$. By this logic a redistribution effectively accomplishes
nothing; money is ultimately just shuffled around, and the large loser's loss cancels out
the small gains of many winners.
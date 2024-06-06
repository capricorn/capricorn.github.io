# When was that book last checked out? 

Often I visit my local university library. It has an immense
catalog spread over multiple floors with even more in storage.
As I've wandered down the aisles in search of a book I couldn't help
but wonder: how long have so many of these poor, lonely books sat
collecting dust? It isn't so often that I spot students reading
them...

How about a simple model for estimating? A few liberties of
my model:

_Multiple checkouts are allowed_. While the idea is to model
a physical library, this would be more akin to a digital checkout.
That is, if I check out a book someone else still can too. I've
ignored any holding times where the book is inaccessible due
to being checked out.

_All the books in the library were available initially_. Think
of it as the library having a "grand opening."

_The library is immutable._ No changes to the collection occur
whatsoever.

Let's model the following example. A library has 1,000,000 books
available. Every day, 1000 books are checked out at random.

Therefore $p=1000/1000000=1/1000$ is the probability that a
given book is checked out each day. The probability distribution 
of the number of days until a given book is checked out is geometric,
i.e. $X\sim Geo(1/1000)$. From this the expected number of days
until checkout is $\mathbb{E}(X)=1/p=1000$.

Now, go to this library and grab a book to checkout. Since the
expectation of days until checkout is 1000 days, and _you yourself
are performing a checkout_, then the expectation is that this book
has been sitting on the shelf for 1000 days. How glum...

Below is a simulation for the skeptics. Every day for 10,000 days,
1000 books are checked out at random. Each checkout the time
since the last checkout is recorded. All of these times are taken
together and averaged. In this case, the convergence is expected
to be 1000 as described earlier.

```python
from random import randint
from statistics import mean

# A book initially begins with no checkouts on file.
prev_checkout_day = 1_000_000 * [None]
elapsed = 1_000_000 * [None]

for day in range(10_000):
    # Each day 1000 books are checked out at random
    # (ie p=1,000/1,000,000=1/1,000 for a random book to be checked out that day)
    for _ in range(1000):
        selected_book = randint(0,999_999)

        # Whenever we encounter a book, record the time between now and the prior checkout.
        elapsed[selected_book] = (day-prev_checkout_day[selected_book]) if prev_checkout_day[selected_book] else day
        prev_checkout_day[selected_book] = day

avg_days = mean([ since for since in elapsed if since ])
print(avg_days) # sample output: 999.349834706113
```

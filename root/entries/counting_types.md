# Counting Type Composition

One approach to type composition is the use of 'sum' and 'product' types.
For example, take the set of nominal types `T = {A,B,C}`. A type that conforms
to A OR B (a sum type) is expressed as `A|B`. A type that conforms to B AND C
(a product type) is expressed as `AB`. With these primitives it's possible to construct
more complex types such as `AB|C`. 

This raises the question: given $T$, how many valid compositions are there?

Well, examining products, there's `AB, BC, B, ABC, ...` which intuitively is all possible
combinations of `T`, i.e. the power set $\mathcal{P}(T)$. But! This happens to include the
empty set. For the sake of elegance I will include this type in the count. This is not too unusual;
most languages have the concept of `Void` or something similar for optionals, etc.

Now, given all the products, how many ways can they be combined (unioned together) as sum types? 
Since the sum is commutative just like products, this points again to combinations. That is, all
possible combinations (sums) _of_ the combinations (products.) So, the power set of the power set,
$\mathcal{P}(\mathcal{P}(T))$!

It's well known that the cardinality of the power set is $2^N$. Therefore the power set of the power set
has cardinality $2^{2^N}$. With respect to the types `T` in question, there is another little edge case
involving the empty set: $\{\emptyset, \{\emptyset\}\}\ \subset \mathcal{P}(\mathcal{P}(T))$---which is to say,
the empty set is counted twice. So, taking that into account, the total number of compositions is:

$$
2^{2^{|T|}}-1
$$


## Generation example with Python

The following is a script to compute all the compositions and print them sorted: 

```python
fset = frozenset

def powerset(s):
    if s == fset():
        return fset(fset())
    if len(s) == 1:
        return fset([fset(), s])

    subsets = fset()
    for e in s:
        subsets = subsets | powerset(s-fset([e]))

    return fset([s, *subsets])

types = powerset(powerset(fset(['A','B','C'])))
# Oh my...
output = '\n'.join(sorted([ # Sort by length and break ties lexicographically
    '|'.join([
        ''.join(prod_type if prod_type != fset() else 'V')
        for prod_type in sum_type
    ])
    # Exclude {} to avoid double counting N
    for sum_type in types if sum_type != fset()
], key=λ key: (len(key),key)))

# Len: 2^(2^|s|)-1
print(output)
print(len(types - fset([fset()])))
```

[Github Gist](https://gist.github.com/capricorn/9f916322510a3e2cfec23bfbec685afa)

And the output for `T={A,B,C}`. The empty set is printed as `V` here:

```
A
B
C
V
BA
CA
CB
B|A
B|C
CBA
C|A
V|A
V|B
V|C
A|CB
BA|A
BA|C
B|BA
B|CA
B|CB
CA|A
CA|C
C|CB
V|BA
V|CA
V|CB
BA|CA
BA|CB
B|C|A
CA|CB
CBA|A
CBA|B
CBA|C
CBA|V
V|B|A
V|B|C
V|C|A
BA|C|A
B|A|CB
B|BA|A
B|CA|A
B|C|BA
B|C|CA
B|C|CB
CBA|BA
CBA|CA
CBA|CB
C|A|CB
C|CA|A
V|A|CB
V|BA|A
V|BA|C
V|B|BA
V|B|CA
V|B|CB
V|CA|A
V|C|CA
V|C|CB
BA|A|CB
BA|CA|A
BA|C|CA
BA|C|CB
B|BA|CB
B|CA|BA
B|CA|CB
CA|A|CB
CBA|A|V
CBA|B|A
CBA|B|C
CBA|B|V
CBA|C|A
CBA|C|V
C|CA|CB
V|BA|CA
V|BA|CB
V|B|C|A
V|CA|CB
BA|CA|CB
B|CA|C|A
B|C|A|CB
B|C|BA|A
CBA|A|CB
CBA|BA|A
CBA|BA|C
CBA|BA|V
CBA|B|BA
CBA|B|CA
CBA|B|CB
CBA|CA|A
CBA|CA|V
CBA|C|CA
CBA|C|CB
CBA|V|CB
V|BA|C|A
V|B|A|CB
V|B|BA|A
V|B|CA|A
V|B|CA|C
V|B|C|BA
V|B|C|CB
V|CA|C|A
V|C|A|CB
BA|CA|C|A
BA|C|A|CB
B|BA|A|CB
B|CA|A|CB
B|CA|BA|A
B|CA|C|BA
B|CA|C|CB
B|C|BA|CB
CA|C|A|CB
CBA|BA|CA
CBA|BA|CB
CBA|B|A|V
CBA|B|C|A
CBA|B|C|V
CBA|CA|CB
CBA|C|A|V
V|BA|A|CB
V|BA|CA|A
V|BA|CA|C
V|BA|C|CB
V|B|BA|CB
V|B|CA|BA
V|B|CA|CB
V|CA|A|CB
V|CA|C|CB
BA|CA|A|CB
BA|CA|C|CB
B|CA|BA|CB
B|C|BA|V|A
B|C|CA|V|A
B|C|CB|V|A
CBA|A|V|CB
CBA|BA|A|V
CBA|BA|C|A
CBA|BA|C|V
CBA|B|A|CB
CBA|B|BA|A
CBA|B|BA|V
CBA|B|CA|A
CBA|B|CA|C
CBA|B|CA|V
CBA|B|C|BA
CBA|B|C|CB
CBA|B|V|CB
CBA|CA|A|V
CBA|CA|C|A
CBA|CA|C|V
CBA|C|A|CB
CBA|C|V|CB
V|BA|CA|CB
B|BA|CA|V|A
B|BA|CB|V|A
B|CA|CB|V|A
B|C|BA|CA|A
B|C|BA|CA|V
B|C|BA|CB|A
B|C|BA|CB|V
B|C|CA|CB|A
B|C|CA|CB|V
B|C|CBA|V|A
CBA|BA|A|CB
CBA|BA|CA|A
CBA|BA|CA|C
CBA|BA|CA|V
CBA|BA|C|CB
CBA|BA|V|CB
CBA|B|BA|CB
CBA|B|CA|BA
CBA|B|CA|CB
CBA|CA|A|CB
CBA|CA|C|CB
CBA|CA|V|CB
C|BA|CA|V|A
C|BA|CB|V|A
C|CA|CB|V|A
BA|CA|CB|V|A
B|BA|CA|CB|A
B|BA|CA|CB|V
B|CBA|BA|V|A
B|CBA|CA|V|A
B|CBA|CB|V|A
B|C|BA|CA|CB
B|C|CBA|BA|A
B|C|CBA|BA|V
B|C|CBA|CA|A
B|C|CBA|CA|V
B|C|CBA|CB|A
B|C|CBA|CB|V
CBA|BA|CA|CB
C|BA|CA|CB|A
C|BA|CA|CB|V
C|CBA|BA|V|A
C|CBA|CA|V|A
C|CBA|CB|V|A
B|CBA|BA|CA|A
B|CBA|BA|CA|V
B|CBA|BA|CB|A
B|CBA|BA|CB|V
B|CBA|CA|CB|A
B|CBA|CA|CB|V
B|C|BA|CA|V|A
B|C|BA|CB|V|A
B|C|CA|CB|V|A
B|C|CBA|BA|CA
B|C|CBA|BA|CB
B|C|CBA|CA|CB
CBA|BA|CA|V|A
CBA|BA|CB|V|A
CBA|CA|CB|V|A
C|CBA|BA|CA|A
C|CBA|BA|CA|V
C|CBA|BA|CB|A
C|CBA|BA|CB|V
C|CBA|CA|CB|A
C|CBA|CA|CB|V
B|BA|CA|CB|V|A
B|CBA|BA|CA|CB
B|C|BA|CA|CB|A
B|C|BA|CA|CB|V
B|C|CBA|BA|V|A
B|C|CBA|CA|V|A
B|C|CBA|CB|V|A
CBA|BA|CA|CB|A
CBA|BA|CA|CB|V
C|BA|CA|CB|V|A
C|CBA|BA|CA|CB
B|CBA|BA|CA|V|A
B|CBA|BA|CB|V|A
B|CBA|CA|CB|V|A
B|C|CBA|BA|CA|A
B|C|CBA|BA|CA|V
B|C|CBA|BA|CB|A
B|C|CBA|BA|CB|V
B|C|CBA|CA|CB|A
B|C|CBA|CA|CB|V
C|CBA|BA|CA|V|A
C|CBA|BA|CB|V|A
C|CBA|CA|CB|V|A
B|CBA|BA|CA|CB|A
B|CBA|BA|CA|CB|V
B|C|BA|CA|CB|V|A
B|C|CBA|BA|CA|CB
CBA|BA|CA|CB|V|A
C|CBA|BA|CA|CB|A
C|CBA|BA|CA|CB|V
B|C|CBA|BA|CA|V|A
B|C|CBA|BA|CB|V|A
B|C|CBA|CA|CB|V|A
B|CBA|BA|CA|CB|V|A
B|C|CBA|BA|CA|CB|A
B|C|CBA|BA|CA|CB|V
C|CBA|BA|CA|CB|V|A
B|C|CBA|BA|CA|CB|V|A
255
```
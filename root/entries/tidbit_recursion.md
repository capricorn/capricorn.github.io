# Flattening Trees From Recursive Functions

Take the following recursive implementation of an (almost complete) power set generator:

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

    return fset([s, subsets])
```

Computing `powerset(fset(['A','B','C']))`{.python} and printing each set:

```python
frozenset({frozenset({'B', 'A'}), frozenset({'C', 'A'}), frozenset({frozenset(), frozenset({'A'}), frozenset({'C'})}), frozenset({frozenset(), frozenset({'B'}), frozenset({'C'})}), frozenset({frozenset(), frozenset({'A'}), frozenset({'B'})}), frozenset({'B', 'C'})})
frozenset({'B', 'C', 'A'})
```

... which is some sort of deeply nested tree. Sometimes this can be complicated to fix. The first step is to decide
what the return type _should_ be. In this case, a power set should be `Set[Set[str]]`{.python}. With that in mind, establish the base case types. The first base case `s == fset()`{.python} returns `{{}}` which is acceptable. The
second base case `len(s) == 1`{.python} returns `{{}, Set[str]}`{.python} which also satisfies the requirement.

With the base cases established a 'recursive invariant' can be established. Jump to the recursive return statement,
`fset([s, subsets])`{.python}. `s` is `Set[str]`{.python}, so if `subsets` is proven to be the same then the
return guarantees a type of `Set[Set[str]]`{.python}.

How to guarantee `subsets` is `Set[str]`{.python}? Consider it from the base cases. `subsets` will be
`Set[Set[str]]`{.python} as it is the union of these. With that in mind, unpacking `subsets` will ensure 
each element of the set is `Set[str]`{.python} and preserve the same return type as the base cases: 
`return fset([s, *subsets])`{.python}

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

    # Unpack here to obtain [Set[str], Set[str]...]
    return fset([s, *subsets])
```

```python
frozenset({'C', 'A'})
frozenset({'B', 'A'})
frozenset({'B', 'C'})
frozenset({'B', 'C', 'A'})
frozenset({'C'})
frozenset({'B'})
frozenset()
frozenset({'A'})
```
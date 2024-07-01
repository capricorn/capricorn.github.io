---
header-includes:
- |
    ```{=html}
    <style>
    .operator {
        color: red;
    }
    .number {
        color: blue;
    }
    </style>
    ```
---
# AST Syntax Highlighting with Prolog

Consider a simple prefix arithmetic notation; a few examples:

```
+ 1 2   i.e. 1+2 
+ * 4 4 * 6 6   i.e. (4*4) + (6*6)
/ 8 * 2 2   i.e. (8/(2*2))
```

The above grammar can be represented in Prolog as:

```prolog
operator(plus).
operator(minus).
operator(multiply).
operator(divide).

arithmetic(Op, num, num) :- operator(Op).

arithmetic(Op, A, num) :- 
    operator(Op), 
    A = arithmetic(_,_,_).

arithmetic(Op, num, A) :- 
    operator(Op), 
    A = arithmetic(_,_,_).

arithmetic(Op, A, B) :- 
    operator(Op), 
    A = arithmetic(_,_,_),
    B = arithmetic(_,_,_).
```

So 'parsing' the prior examples would produce ASTs of the form (actual digits excluded)

```prolog
arithmetic(plus, num, num). % + 1 2
arithmetic(plus, arithmetic(multiply, num, num), arithmetic(multiply, num, num)). % + * 4 4 * 6 6
arithmetic(divide, num, arithmetic(multiply, num, num)). % / 8 * 2 2 
```

Given this AST, the objective is to spit out a sequence of HTML `<span>` for coloring the various nodes.
Prolog is no stranger to tree rewriting; here's one approach:

```prolog
stringify_op(Op, Str) :-
    (Op = plus, Str = '+')
    ; (Op = minus, Str = '-')
    ; (Op = multiply, Str = '*')
    ; (Op = divide, Str = '/').

highlight_num(num, Str) :-
    format(atom(Str), '<span class="number">~a</span>', [num]).

highlight_op(Op, Str) :-
    stringify_op(Op, S1),
    format(atom(Str), '<span class="operator">~a</span>', [S1]).

highlight_arithmetic(Op, num, num, Highlight) :-
    highlight_op(Op, OpHL),
    highlight_num(num, N1HL),
    highlight_num(num, N2HL),
    format(atom(Highlight), '~a ~a ~a', [OpHL, N1HL, N2HL]).

highlight_arithmetic(Op, num, A, Highlight) :-
    highlight_op(Op, OpHL),
    highlight_num(num, N1HL),
    A = arithmetic(SubOp, SubA, SubB),
    highlight_arithmetic(SubOp, SubA, SubB, SubHL),
    format(atom(Highlight), '~a ~a ~a', [OpHL, N1HL, SubHL]).

highlight_arithmetic(Op, A, num, Highlight) :-
    highlight_op(Op, OpHL),
    A = arithmetic(SubOp, SubA, SubB),
    highlight_arithmetic(SubOp, SubA, SubB, SubHL),
    highlight_num(num, N1HL),
    format(atom(Highlight), '~a ~a ~a', [OpHL, SubHL, N1HL]).

highlight_arithmetic(Op, A, B, Highlight) :-
    highlight_op(Op, OpHL),
    A = arithmetic(AOp, AA, AB),
    B = arithmetic(BOp, BB, BA),
    highlight_arithmetic(AOp, AA, AB, AHL),
    highlight_arithmetic(BOp, BA, BB, BHL),
    format(atom(Highlight), '~a ~a ~a', [OpHL, AHL, BHL]).
```

For syntax highlighting, the following CSS styling is used:
```css
.operator {
    color: red;
}
.number {
    color: blue;
}
```

Now for generating the HTML. Each node is converted to its equivalent span and concatenated. Again, using the initial examples:

```prolog
?- highlight_arithmetic(plus,num,num,HL).
HL = '<span class="operator">+</span> <span class="number">num</span> <span class="number">num</span>' .
```

<span class="operator">+</span> <span class="number">num</span> <span class="number">num</span>

```prolog
?- highlight_arithmetic(plus, arithmetic(multiply, num, num), arithmetic(multiply, num, num), HL).
HL = '<span class="operator">+</span> <span class="operator">*</span> <span class="number">num</span> <span class="number">num</span> <span class="operator">*</span> <span class="number">num</span> <span class="number">num</span>' .
```

<span class="operator">+</span> <span class="operator">\*</span> <span class="number">num</span> <span class="number">num</span> <span class="operator">\*</span> <span class="number">num</span> <span class="number">num</span>

```prolog
?- highlight_arithmetic(divide, num, arithmetic(multiply, num, num), HL).
HL = '<span class="operator">/</span> <span class="number">num</span> <span class="operator">*</span> <span class="number">num</span> <span class="number">num</span>' .
```

<span class="operator">/</span> <span class="number">num</span> <span class="operator">\*</span> <span class="number">num</span> <span class="number">num</span>
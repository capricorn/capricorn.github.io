# Experiment: HTML Scraping with Prolog

Scraping tasks generally require solving the following problem: extract an element from the document with some set of identifying properties.
In that sense it isn't hard to consider the problem as finding elements that satisfy a set of constraints.

What are a few common constraints? Properties such as:

- Parent
- Sibling
- Tag (`div`, `p`)
- Class

## An Approach

[logicalsoup](https://github.com/capricorn/logicalsoup) is a script I wrote for this experiment. It takes an HTML file, parses it with beautifulsoup and
spits out a collection of Prolog facts that define some of the constraints detailed above. For example:

```bash
$ poetry run python -m logicalsoup.main tests/data/ask-hn.html > out/askhn.pl
```

will provide facts such as:

```prolog
attr("c97724ec-6c91-11ef-a357-6a3e8c423ff5", div, title, "upvote").
child("c976ee14-6c91-11ef-a357-6a3e8c423ff5", "c976edf6-6c91-11ef-a357-6a3e8c423ff5").
sibling("c9773086-6c91-11ef-a357-6a3e8c423ff5", "c97730f4-6c91-11ef-a357-6a3e8c423ff5").
```

The queries above have declarations like:

```prolog
attr(ElementId, Tag, AttributeKey, AttributeValue)
child(ChildId,ParentId)
sibling(SiblingId,BaseId)
```

Any attribute with multiple values e.g. `foo="abc xyz"` outputs a separate attribute for each value.
`ElementId` is a generated UUID assigned to each tag which is considered the identifier of that element.

A complex example of an extraction: extract all posts from [u/whoishiring](https://news.ycombinator.com/user?id=whoishiring) on [Ask HN](https://news.ycombinator.com/ask):

```prolog
?- attr(FirstId,class,"athing"),attr(FirstId,tr),sibling(SiblingId,FirstId),descendant(ChildId,SiblingId),attr(ChildId,a,class,"hnuser"),attr(ChildId,text("whoishiring")),descendant(TitleId,FirstId),attr(TitleId,class,"title"),attr(TitleId,text(Title)),descendant(LinkId,TitleId),attr(LinkId,a,href,PostLink).
FirstId = "c977221c-6c91-11ef-a357-6a3e8c423ff5",
SiblingId = "c977262c-6c91-11ef-a357-6a3e8c423ff5",
ChildId = "c97727c6-6c91-11ef-a357-6a3e8c423ff5",
TitleId = "c977253c-6c91-11ef-a357-6a3e8c423ff5",
Title = "Ask HN: Who is hiring?\n                                        (September 2024)",
LinkId = "c97725d2-6c91-11ef-a357-6a3e8c423ff5",
PostLink = "item?id=41425910" ;
FirstId = "c977221c-6c91-11ef-a357-6a3e8c423ff5",
SiblingId = "c977262c-6c91-11ef-a357-6a3e8c423ff5",
ChildId = "c97727c6-6c91-11ef-a357-6a3e8c423ff5",
TitleId = "c977253c-6c91-11ef-a357-6a3e8c423ff5",
Title = "Ask HN: Who is hiring?\n                                        (September 2024)",
LinkId = "c97725d2-6c91-11ef-a357-6a3e8c423ff5",
PostLink = "item?id=41425910" ;
FirstId = "c9772b4a-6c91-11ef-a357-6a3e8c423ff5",
SiblingId = "c9772f5a-6c91-11ef-a357-6a3e8c423ff5",
ChildId = "c97730f4-6c91-11ef-a357-6a3e8c423ff5",
TitleId = "c9772e60-6c91-11ef-a357-6a3e8c423ff5",
Title = "Ask HN: Who wants to be\n                                        hired? (September 2024)",
LinkId = "c9772eec-6c91-11ef-a357-6a3e8c423ff5",
PostLink = "item?id=41425908" ;
FirstId = "c9772b4a-6c91-11ef-a357-6a3e8c423ff5",
SiblingId = "c9772f5a-6c91-11ef-a357-6a3e8c423ff5",
ChildId = "c97730f4-6c91-11ef-a357-6a3e8c423ff5",
TitleId = "c9772e60-6c91-11ef-a357-6a3e8c423ff5",
Title = "Ask HN: Who wants to be\n                                        hired? (September 2024)",
LinkId = "c9772eec-6c91-11ef-a357-6a3e8c423ff5",
PostLink = "item?id=41425908" ;
false.
```

See [facts.jinja](https://github.com/capricorn/logicalsoup/blob/master/facts.jinja) for extra predicates. 


## Possible Improvements

- Dealing with 'symmetry' in solutions
- Interop with Python
- Better sibling extraction (e.g. nth sibling, etc)
- A simple approach to dropping unwanted resolved variables (e.g. only show solutions to `Title`, etc)
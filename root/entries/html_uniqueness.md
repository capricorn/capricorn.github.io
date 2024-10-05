# HTML Element Uniqueness

There are two possiblities for _uniquely_ identifying an HTML element:

- Its id attribute
- Its path in the DOM (xpath?)

The former is obvious. The latter works because the document is a proper tree. 

This implies a rank for filter criteria with these two constraints being the strongest: they are guaranteed to match
a single element. An example of a weaker constraint would be filtering by tag or class. These constraints guarantee
the element of interest is in the set of filtered elements but may match other elements as well; that is, constraints
weaker than the strongest constraints listed above are insufficient for uniquely identifying elements _generally_. However,
it may be sufficient in the context of a specific document (e.g. a class is only used once, hence it reduces to an id.)
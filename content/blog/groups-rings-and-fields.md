{
    "date": "2014-12-17",
    "description": "A short summary about some basic algebraic structures.",
    "slug": "groups-rings-and-fields",
    "tags": "groups, rings, fields, abelian, monoid, math, algebra, mathematics",
    "title": "Groups, Rings and Fields"
}

This semester I am taking a automata theory course at the university
which relies heavily on basic algebraic structures like
[monoids](http://en.wikipedia.org/wiki/Monoid),
[groups](http://en.wikipedia.org/wiki/Group_(mathematics)),
[rings](http://en.wikipedia.org/wiki/Ring_(mathematics)) and
[fields](http://en.wikipedia.org/wiki/Field_%28mathematics%29) the
latter is better known as *Körper* in german lectures.

Sometimes I'm a little bit confused which structure needs which
properties to be satisfied. That's why I decided to write a short
summary about this topic and the process of writing this post also helps
me to remember it, thus I can kill two birds with one stone.

Groups
======

A group $(G, \cdot)$ is a set of elements $G$ and a binary operation
$\cdot$.

Conditions
----------

1.  **Closure**

    $\forall a,b \in G : a \cdot b \in G$

2.  **Associativity**

    $\forall a,b,c \in G : a \cdot (b \cdot c) = (a \cdot b) \cdot c$

3.  **Identity**

    $\forall a \exists 1 : ( a, 1 \in G ) \land ( a \cdot 1 = 1 \cdot a = a )$

4.  **Inverse**

    $\forall a \exists a^{-1} : ( a, a^{-1} \in G ) \land ( a \cdot a^{-1} = a^{-1} \cdot a = 1 )$

5.  **Commutative**

    $\forall a,b \in G : a \cdot b = b \cdot a$

-   A **semigroup** only has to be *closed under the group operation*
    $\cdot$ (1) and *associative* (2)
-   A **monoid** is a semigroup plus the *identity element* (3)
-   A monoid with the *inverse* (4) is called a **group**
-   If the group is also *commutative* (5) then it's called an **abelian
    group**

Rings
=====

A ring $(R, +, \cdot)$ is a set with elements $R$ and two binary
operations $+$ and $\cdot$.

Conditions
----------

1.  $+$ is **associative**

    $\forall a,b,c \in R : a + (b + c) = (a + b) + c$

2.  $+$ is **commutative**

    $\forall a,b \in R : a + b = b + a$

3.  **Identity** for $+$

    $\forall a \exists 1 : ( a, 1 \in R ) \land ( a + 1 = 1 + a = a )$

4.  **Inverse** for $+$

    $\forall a \exists a^{-1} : ( a, a^{-1} \in R ) \land ( a + a^{-1} = a^{-1} + a = 1 )$

5.  Left and right **distributive**

$$\begin{split}
\forall a,b,c \in R &:\\
& a \cdot (b + c) = (a \cdot b) + (a \cdot c) \land \\
& (b + c) \cdot a = (b \cdot a) + (c \cdot a)
\end{split}$$

6.  $\cdot$ is **associative**

    $\forall a,b,c \in R : (a \cdot b) \cdot c = a \cdot (b \cdot c)$

-   If condition 4. is *not* satisfied (there is no additive inverse
    element), then the structure is called a **semiring**.
-   A **ring** has to satifsfy all six conditions
-   If the $\cdot$ operation is also commutative the structure is called
    **commutative ring**

Fields
======

A field $(F, +, \cdot)$ is a set with elements $F$ and two binary
operations $+$ and $\cdot$ that satisfies *all the conditions of a ring*
plus the following three:

1.  $\cdot$ is **commutative**

    $\forall a,b \in F : a \cdot b = b \cdot a$

2.  $\cdot$ is **identity**

    $\forall a \exists 1 : ( a, 1 \in F) \land ( a \cdot 1 = 1 \cdot a = a)$

3.  $\cdot$ is **inverse**

    $\forall a \exists a^{-1} : ( a, a^{-1} \in F ) \land ( a + a^{-1} = a^{-1} + a = 1 )$

-   If the $\cdot$ operation is *not commutative*, then the structure is
    called a **skew field**, **division algebra** or **Schiefkörper**

References
----------

-   [Group](http://mathworld.wolfram.com/Group.html)
-   [Ring](http://mathworld.wolfram.com/Ring.html)
-   [Field axioms](http://mathworld.wolfram.com/FieldAxioms.html)


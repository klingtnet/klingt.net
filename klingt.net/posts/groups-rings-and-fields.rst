.. title: Groups, Rings and Fields
.. slug: groups-rings-and-fields
.. date: 2014-12-17 20:35:42 UTC+01:00
.. tags: groups, rings, fields, abelian, monoid, math, algebra, mathematics
.. link:
.. description: A short summary about some basic algebraic structures.
.. type: text

This semester I am taking a automata theory course at the university which relies heavily on basic algebraic structures like `monoids <http://en.wikipedia.org/wiki/Monoid>`_, `groups <http://en.wikipedia.org/wiki/Group_(mathematics)>`_, `rings <http://en.wikipedia.org/wiki/Ring_(mathematics)>`_ and `fields <http://en.wikipedia.org/wiki/Field_%28mathematics%29>`_ the latter is better known as *Körper* in german lectures.

Sometimes I'm a little bit confused which structure needs which properties to be satisfied. That's why I decided to write a short summary about this topic and the process of writing this post also helps me to remember it, thus I can kill two birds with one stone.

Groups
------

A group :math:`(G, \cdot)` is a set of elements :math:`G` and a binary operation :math:`\cdot`.

Conditions
~~~~~~~~~~

1. **Closure**

   :math:`\forall a,b \in G : a \cdot b \in G`

2. **Associativity**

   :math:`\forall a,b,c \in G : a \cdot (b \cdot c) = (a \cdot b) \cdot c`

3. **Identity**

   :math:`\forall a \exists 1 : ( a, 1 \in G ) \land ( a \cdot 1 = 1 \cdot a = a )`

4. **Inverse**

   :math:`\forall a \exists a^{-1} : ( a, a^{-1} \in G ) \land ( a \cdot a^{-1} = a^{-1} \cdot a = 1 )`

5. **Commutative**

   :math:`\forall a,b \in G : a \cdot b = b \cdot a`

- A **semigroup** only has to be *closed under the group operation* :math:`\cdot` (1) and *associative* (2)
- A **monoid** is a semigroup plus the *identity element* (3)
- A monoid with the *inverse* (4) is called a **group**
- If the group is also *commutative* (5) then it's called an **abelian group**

Rings
~~~~~

A ring :math:`(R, +, \cdot)` is a set with elements :math:`R` and two binary operations :math:`+` and :math:`\cdot`.

Conditions
----------

1. :math:`+` is **associative**

   :math:`\forall a,b,c \in R : a + (b + c) = (a + b) + c`

2. :math:`+` is **commutative**

   :math:`\forall a,b \in R : a + b = b + a`

3. **Identity** for :math:`+`

   :math:`\forall a \exists 1 : ( a, 1 \in R ) \land ( a + 1 = 1 + a = a )`

4. **Inverse** for :math:`+`

   :math:`\forall a \exists a^{-1} : ( a, a^{-1} \in R ) \land ( a + a^{-1} = a^{-1} + a = 1 )`

5. Left and right **distributive**

.. math::

    \begin{split}
    \forall a,b,c \in R &:\\
    & a \cdot (b + c) = (a \cdot b) + (a \cdot c) \land \\
    & (b + c) \cdot a = (b \cdot a) + (c \cdot a)
    \end{split}

6. :math:`\cdot` is **associative**

   :math:`\forall a,b,c \in R : (a \cdot b) \cdot c = a \cdot (b \cdot c)`

- A **ring** has to satifsfy all six conditions
- If the :math:`\cdot` operation is also commutative the structure is called **commutative ring**

Fields
------

A field :math:`(F, +, \cdot)` is a set with elements :math:`F` and two binary operations :math:`+` and :math:`\cdot` that satisfies *all the conditions of a ring* plus the following three:

1. :math:`\cdot` is **commutative**

   :math:`\forall a,b \in F : a \cdot b = b \cdot a`

2. :math:`\cdot` is **identity**

   :math:`\forall a \exists 1 : ( a, 1 \in F) \land ( a \cdot 1 = 1 \cdot a = a)`

3. :math:`\cdot` is **inverse**

   :math:`\forall a \exists a^{-1} : ( a, a^{-1} \in F ) \land ( a + a^{-1} = a^{-1} + a = 1 )`

- If the :math:`\cdot` operation is *not commutative*, then the structure is called a **skew field**, **division algebra** or **Schiefkörper**

----

References
~~~~~~~~~~

- `Group <http://mathworld.wolfram.com/Group.html>`_
- `Ring <http://mathworld.wolfram.com/Ring.html>`_
- `Field axioms <http://mathworld.wolfram.com/FieldAxioms.html>`_

.. title: links for cw48
.. slug: links-for-cw48
.. date: 2014-11-23 17:30:36 UTC+01:00
.. tags: python, bytecode
.. link:
.. description: the weekly link list for calendar week 48
.. type: text

This weeks list has gotten a little longer than planned and I have left out the links to vagrant, docker and salt/ansible (I haven't decided yet which to choose). My plan is to setup a build environment for this blog using those tools, but more to that in a future post.

- How to understand `python bytecode <http://security.coverity.com/blog/2014/Nov/understanding-python-bytecode.html>`_ using python.
- Why facebook uses `react js to generate their CSS <https://speakerdeck.com/vjeux/react-css-in-js>`_ and which problem they had with stylesheets *at scale* (buzzword):
    1. global namespace
    2. dependencies
    3. dead code elimination
    4. minification
    5. sharing constants
    6. non-deterministic resolution
    7. isolation

    Points 1-5 could be solved using their approach to generate the CSS via JS. Especially the first 3 points are important, #5 can be solved easily using `SASS <http://sass-lang.com/>`_.

    One thing to note is that even facebook developers are using the crappiest of all web development resources, w3schools.com [1]_, like you can see on slide 5.
- A beautiful `collection of vim plugin <http://vimawesome.com/>`_
- `Functional progamming using JavaScript <http://scott.sauyet.com/Javascript/Talk/2014/01/FuncProgTalk/#slide-0>`_.
- `Hands-On Start to Mathematica <https://www.youtube.com/playlist?list=PLxn-kpJHbPx1TOYrbMrvqOztwg0Ncv07e>`_. [🎥]
- *Modellanalyse* is a 2 weekly podcast produced by mathematics faculty of the KIT (Karslruhe Institute for Technology) and is really worth listening to. In of their last episodes they've talked about `Analysis <http://www.math.kit.edu/ianm4/seite/ma-analysis/de>`_ and presented an overview over all the basic concepts of this large branch of mathematics. [🔊/German]
- if you want to refresh your knowledge or learn Haskell from the ground up, `Learn you a Haskell for Great Good <http://learnyouahaskell.com/chapters>`_ is the right starting point.
- `Extreme Programming <http://en.m.wikipedia.org/wiki/Extreme_programming>`_ is not a new concept but a worth one to know (`image-source <http://commons.wikimedia.org/wiki/File:Extreme_Programming.svg>`_)
    .. image:: /imgs/Extreme_Programming.png
        :class: kn-image
        :alt: extreme programming
- `If programming languages were weapons <http://bjorn.tipling.com/if-programming-languages-were-weapons>`_
- `C Pointers Explained <http://karwin.blogspot.de/2012/11/c-pointers-explained-really.html>`_ (in a tiny fontsize).
- `Cello <https://github.com/orangeduck/libCello>`_ provides higher level programming features for C, like Interfaces, Exceptions and `Duck-Typing <http://en.wikipedia.org/wiki/Duck_typing>`_.
- A little outdated `IntelliJ tutorial <http://wiki.jetbrains.net/intellij/Developing_and_running_a_Java_EE_Hello_World_application>`_ that tells you how to write a *Hello World* application in Java EE. This is so over-engineered and complicated that I have to wonder why anyone has ever used this. The worst thing, it did not get much better till today.
- Why are `12 notes in one octave <Why 12 notes to the Octave>`_, at least in our `equal-tempered <http://en.wikipedia.org/wiki/Equal_temperament>`_ western scale?
    An octave is a doubling in frequency, or a ratio of :math:`{2}:{1}`. The subdivision in twelve tones, each with a ration of :math:`{1}:{\sqrt[12]{2}}`, gives a very good approximation for `perfect fifths <http://en.wikipedia.org/wiki/Perfect_fifth>`_ :math:`{1}:{2^{\frac{7}{12}}}` and is optimal for an octave.

----

.. [#] I haven't set a link to them with intention, but it seems that they `have gotten better <http://www.w3fools.com/>`_
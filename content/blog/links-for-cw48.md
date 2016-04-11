{
    "date": "2014-11-30",
    "description": "The weekly link list for calendar week 48.",
    "slug": "links-for-cw48",
    "tags": "python, bytecode, css, sass, react, extreme programming, pointers, C, cello, java, equal tempered, scale, octave, vim",
    "title": "Links for cw48"
}

This weeks list has gotten a little longer than planned and I have left
out links to [vagrant](https://www.vagrantup.com/),
[docker](https://www.docker.com/) and [salt](http://www.saltstack.com/)
or [ansible](http://www.ansible.com/home) (I haven't decided yet which
to choose). My plan is to setup a build environment for this blog using
those tools, but more to that in a future post. Before someone asks, I
won't use [puppet](http://puppetlabs.com/) that's for sure.

-   How to understand [python
    bytecode](http://security.coverity.com/blog/2014/Nov/understanding-python-bytecode.html)
    using python.
-   

    Why facebook uses [react js to generate their CSS](https://speakerdeck.com/vjeux/react-css-in-js) and which problem they had with stylesheets *at scale* (buzzword):

    :   1.  global namespace
        2.  dependencies
        3.  dead code elimination
        4.  minification
        5.  sharing constants
        6.  non-deterministic resolution
        7.  isolation

        Points 1-5 could be solved using their approach to generate the
        CSS via JS. Especially the first 3 points are important, \#5 can
        be solved easily using [SASS](http://sass-lang.com/).

        One thing to note is that even facebook developers are using the
        crappiest of all web development resources, w3schools.com
        \[1\]\_, like you can see on slide 5.

-   A beautiful [collection of vim plugins](http://vimawesome.com/).
-   [Functional progamming using
    JavaScript](http://scott.sauyet.com/Javascript/Talk/2014/01/FuncProgTalk/#slide-0).
-   [Hands-On Start to
    Mathematica](https://www.youtube.com/playlist?list=PLxn-kpJHbPx1TOYrbMrvqOztwg0Ncv07e).
    \[🎥\]
-   *Modellanalyse* is a bi-weekly podcast produced by mathematics
    faculty of the KIT (Karslruhe Institute for Technology) and is
    really worth listening to. In of their last episodes they've talked
    about [Analysis](http://www.math.kit.edu/ianm4/seite/ma-analysis/de)
    and presented an overview over all the basic concepts of this large
    branch of mathematics. \[🔊/German\]
-   if you want to refresh your knowledge or learn Haskell from the
    ground up, [Learn you a Haskell for Great
    Good](http://learnyouahaskell.com/chapters) is the right
    starting point.
-   

    [Extreme Programming](http://en.m.wikipedia.org/wiki/Extreme_programming) is not a new concept but a worth one to know ([image-source](http://commons.wikimedia.org/wiki/File:Extreme_Programming.svg))

    :   ![extreme programming](/imgs/Extreme_Programming.png){.kn-image}

-   [If programming languages were
    weapons](http://bjorn.tipling.com/if-programming-languages-were-weapons).
-   [C Pointers
    Explained](http://karwin.blogspot.de/2012/11/c-pointers-explained-really.html)
    (in a tiny fontsize).
-   [Cello](https://github.com/orangeduck/libCello) provides higher
    level programming features for C, like Interfaces, Exceptions and
    [Duck-Typing](http://en.wikipedia.org/wiki/Duck_typing).
-   A little outdated [IntelliJ
    tutorial](http://wiki.jetbrains.net/intellij/Developing_and_running_a_Java_EE_Hello_World_application)
    that tells you how to write a *Hello World* application in Java EE.
    This is so over-engineered and complicated that I have to wonder why
    anyone has ever used this. The worst thing, it did not get much
    better till today.
-   

    Why are [12 notes in one octave](http://www.math.uwaterloo.ca/~mrubinst/tuning/12.html), at least in our [equal-tempered](http://en.wikipedia.org/wiki/Equal_temperament) western scale?

    :   An octave is a doubling in frequency, or a ratio of ${1}:{2}$.
        The subdivision in twelve tones, each with a ration of
        ${1}:{\sqrt[12]{2}}$, gives a very good approximation for
        [perfect fifths](http://en.wikipedia.org/wiki/Perfect_fifth)
        ${1}:{2^{\frac{7}{12}}}$ and is optimal for an octave.

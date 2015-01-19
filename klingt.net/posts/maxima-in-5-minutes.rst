.. title: Maxima in 5 minutes
.. slug: maxima-in-5-minutes
.. date: 2014-11-10 12:58:58 UTC+01:00
.. tags: maxima, math, CAS
.. link:
.. description: Learn how to use the basics of the maxima computer algebra system in 5 minutes.
.. type: text

The following article is heavily inspired by this one from `math-blog <http://math-blog.com/2007/06/04/a-10-minute-tutorial-for-solving-math-problems-with-maxima/>`_ and will only cover the basic functionality that you need to get started. `Maxima <http://maxima.sourceforge.net/>`_ is an open-source `computer algebra system <http://en.wikipedia.org/wiki/Computer_algebra_system>`_ which allows you to make calculations with arbitrary precision or to simply mathematical expressions. You can even use it as a perfectly ordinary calculator 😊.

the user interface
==================

There are at least two ways to use maxima. The first one is the *interactive* mode where maxima works as an interpreter and executes your expression right away. The second is the noninteractive mode, which is used when you load maxima with a script like this :code:`maxima -b file.mac`. I am not a hundred percent sure, but I think that ``.mac`` is the common file extension for maxima scripts. Note that maxima will close right after executing your script. To prevent this you can load your script as init script with :code:`maxima --init-mac file.mac`.

Before starting maxima, make sure that you have *readline wrapper* installed because otherwise you can't use your arrow keys to access your previous input. When you have that start maxima with `rlwrap maxima` from your terminal.

The resulting prompt should look something like this:

.. code:: sh

    Maxima 5.34.1 http://maxima.sourceforge.net
    using Lisp SBCL 1.2.2
    Distributed under the GNU Public License. See the file COPYING.
    Dedicated to the memory of William Schelter.
    The function bug_report() provides bug reporting information.
    (%i1)

Maxima will give each statement that you enter ``%i`` and that it outputs ``%o`` a unique number. You can refer to them in your calculations with ``%iX`` respectively ``%oX``, where ``X`` is the index number of a statement or output. There is also a shorthand for using the last output ``%``.

To search in the documentation for help to a specific function enter ``??functionname`` which will give you a list of possible matches to choose from or ``none`` if you've decided to resign the help.

Some important constants and their expression in maxima
-------------------------------------------------------

- ``%e`` Euler's number
- ``%pi`` the almighty π
- ``%phi`` golden mean
- ``%i`` the imaginary unit (for the fearless)

basic syntax
------------

The most important part, every statement you enter has to be delimited by an semicolon ``;``. If you forget it, the interpreter will sit around twiddling it's thumbs until you finalize your statement.

Variables can be assigned with a infix colon `:` like this: ``foo:3;``. Function definitions are made similar with `:=`, e.g.: ``f(x):=sin(%pi*x);`` (even that ``f(x)`` will be zero for all :math:`x \in \mathbb{N}`). Now you have to armamentarium (Handwerkszeug?) to get started.

If you need the TeX output for any expression, use ``tex(foobar);``.

algebra
=======

Maybe you've ever wondered what the prime factorization of *42* would be? No more, simply enter ``factor(42);`` and you will get the ``2 3 7`` because :math:`2*3*7=42`. You don't have to look in formulary to expand some nth-power terms because it's as easy as factorization: ``expand((x+1)^2);``. Still not impressed?

simplification
--------------

Now we will *simplify* some expressions, which should be very helpful in most cases. There are two methods for simplification, one for rational expression which is called ``ratsimp`` and one for trigonometric ones ``trigsimp``. Here is an example:

.. code::
    :number-lines:

    (%i1) ratsimp(sqrt(x^2)/4+1/4);
            abs(x) + 1
    (%o1)   ----------
                4

If you are a little bit confused why :math:`sqrt(x^2)` was simplified to the absolute value of :math:`abs(x)`, that's why maxima had assumed that we use real numbers and the square root of them is only defined for positive real numbers.

.. code::
    :number-lines:

    (%i1) trigsimp(1/(1-cos(x))+1/(1+cos(x)));
                 2
    (%o1)  - -----------
                 2
              cos (x) - 1

Okay, :math:`-\frac{2}{cos(x)^2}` could also be written as :math:`2csc(x)^2` but we won't be nitpickers here.

To solve an equation for a variable or a list of variables use ``solve(equation, [variables]);``.

.. code::
    :number-lines:

    (%i1) solve(x^2=-1,[x]);
    (%o1)   [x = - %i, x = %i]

There is our imaginary unit again.

analysis
========

Because this was planned as a five minute guide I won't go in detail. All the things you've done can in high-school math, like differentiation and integration can be done by maxima without breaking a sweat (or tears).

:math:`f(x) = e^{2x} \frac{d}{dx}` is:

.. code::
    :number-lines:

    (%i1) f(x):=%e^(2*x);
                      2 x
    (%o1)   f(x) := %e
    (%i2) diff(f(x), x);
                2 x
    (%o2)   2 %e

Note that you must use explicit multiplication in maxima, e.g. ``2x`` won't work.

Integration works analogously with the ``integrate();`` function.

To calculate the limit for a function you have to know the three different *types of infinity*, that exist in maxima:

- ``inf`` :math:`\infty`
- ``minf`` :math:`-\infty`
- ``infinite`` is the complex :math:`\infty`

.. code::
    :number-lines:

    (%i2) limit(1-1/x^2, x, inf);
    (%o2)   1

Especially as a computer scientist you have to use sums everywhere, the equivalent of the famous `Gaußsche Summenformel <http://de.wikipedia.org/wiki/Gau%C3%9Fsche_Summenformel>`_ :math:`\sum_{k=1}^{100} k` is ``sum(k, k, 1, 100);``. More general: ``sum(expression, summation index, lower bound, upper bound);``.

To get the `Taylor approximation <http://en.wikipedia.org/wiki/Taylor%27s_theorem>`_ for a differentiable function at a point until a specific degree use ``taylor(function, variable, point, degree);``, e.g. ``taylor(sin(x), x, 0, 10);``.

plotting
========

The last part of this guide—that slightly longer as five minutes—is about plotting. Maxima uses *gnuplot* for this purpose, so make sure it is available on your system.

To make a 2D-Plot enter a function or a list of functions as first argument and as second argument the `abscissa <http://en.wikipedia.org/wiki/Abscissa>`_ variable and a arange. Maybe you want to plot :math:`\sin(x)` and :math:`\cos(x)` side-by-side from -π to π:

.. code::

    plot2d([sin(x),cos(x)], [x,-%pi,%pi]);

Three dimensional plots work the same way, apart from that you have to enter a range for the second variable:

.. code::

    plot3d(sin(x+y), [x,-%pi,%pi], [y,2*-%pi, 2*%pi]);

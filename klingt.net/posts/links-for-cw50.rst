.. title: Links for cw50
.. slug: links-for-cw50
.. date: 2014-12-08 16:49:06 UTC+01:00
.. tags: monad, functional programming
.. link: 
.. description: Another weekly link list, this time for calendar week 50. The year is almost over.
.. type: text

- `The internet is shit <http://www.internetisshit.org/>`_. I don't know if this should be taken to serious, but the following quote is gold:

    Give an infinite number of monkeys typewriters and they'll produce the works of Shakespeare. Unfortunately, I feel like I'm reading all the books where they didn't.
- `Motivation for Monads <http://cs.coloradocollege.edu/~bylvisaker/MonadMotivation/>`_ explains the *Why* not the *How*.
- `Imperative vs Declarative <http://latentflip.com/imperative-vs-declarative/>`_ tries to give a motivation for using declarative programming style using SQL and `d3 <http://d3js.org/>`_ examples. If you've ever used a language that gives you ``map`` and ``fold`` methods on collections you will miss them when they're not available.
- `How or where to begin learning mathematics from the first principles? <https://news.ycombinator.com/item?id=8697772>`_. For my german readers I can recommend **Mathematik für Informatiker** `Band 1 <http://www.amazon.de/dp/3540708243>`_ which covers Logic, Linear Algebra and Discrete Mathematics as well as `Band 2 <http://www.amazon.de/dp/3642542735>`_ where Analysis and Basic Statistics are teached. Those books cover all topics in depth and have exercises at the end of each chapter. They should be solved because mathematics is like programming, you won't learn it without doing it. If you want to buy them, take a look on eBay, I got my pair nearly unused for a small amount of money.
- `Seagull <https://github.com/tobegit3hub/seagull>`_ a Web UI to to monitor your docker deamon. To try it run this line in your shell and open `localhost:10086 <http://localhost:10086>`_ afterwards:

.. code:: bash

    docker run -d -p 10086:10086 -v /var/run/docker.sock:/var/run/docker.sock tobegit3hub/seagull

{
    "date": "2014-12-14",
    "description": "Another weekly link list, this time for calendar week 50. The year is almost over.",
    "slug": "links-for-cw50",
    "tags": "monad, functional programming, imperative, declarative, mathematics, seagull, docker, enterprise, python, dictionaries, addict, SSL, chrome, libaudioverse, audio, algorithmic beauty, plants",
    "title": "Links for cw50"
}

-   [The internet is shit](http://www.internetisshit.org/). I don't know
    if this should be taken too serious, but the following quote is
    gold:

    > Give an infinite number of monkeys typewriters and they'll produce
    > the works of Shakespeare. Unfortunately, I feel like I'm reading
    > all the books where they didn't.

-   [Motivation for
    Monads](http://cs.coloradocollege.edu/~bylvisaker/MonadMotivation/)
    explains the *Why* not the *How*.
-   [Imperative vs
    Declarative](http://latentflip.com/imperative-vs-declarative/) tries
    to give a motivation for using declarative programming style using
    SQL and [d3](http://d3js.org/) examples. If you've ever used a
    language that gives you `map` and `fold` methods on collections you
    will miss them when they're not available.
-   [How or where to begin learning mathematics from the first
    principles?](https://news.ycombinator.com/item?id=8697772). For my
    german readers I can recommend **Mathematik für Informatiker** [Band
    1](http://www.amazon.de/dp/3540708243) which covers Logic, Linear
    Algebra and Discrete Mathematics as well as [Band
    2](http://www.amazon.de/dp/3642542735) where Analysis and Basic
    Statistics are teached. Those books cover all topics in depth and
    have exercises at the end of each chapter. They should be solved
    because mathematics is like programming, you won't learn it without
    doing it. If you want to buy them, take a look on eBay, I got my
    pair nearly unused for a small amount of money.
-   [Seagull](https://github.com/tobegit3hub/seagull) a Web UI to to
    monitor your docker deamon. To try it run this line in your shell
    and open [localhost:10086](http://localhost:10086) afterwards:

``` {.sourceCode .bash}
docker run -d -p 10086:10086 -v /var/run/docker.sock:/var/run/docker.sock tobegit3hub/seagull
```

-   PayPal about [10 Myths of Enterprise
    Python](https://www.paypal-engineering.com/2014/12/10/10-myths-of-enterprise-python/).
    Did you know that the Python language is [4
    years](http://python-history.blogspot.com/2009/01/introduction-and-overview.html)
    older than Java? Since [PyPy](http://pypy.org/) there is no more
    reason to believe that [Python is
    slow](https://www.paypal-engineering.com/2014/12/10/10-myths-of-enterprise-python/#python-is-slow).
-   [Chrome will mark HTTP websites in 2015 as
    non-secure](https://www.chromium.org/Home/chromium-security/marking-http-as-non-secure),
    fair enough because I already switched to
    [HTTPS](//www.klingt.net/posts/klingtnet-goes-ssl-and-spdy/) and you
    should too.
-   [addict](https://github.com/mewwts/addict) is a Python dictionary
    that allows you to set/get values using *attribute* and
    *getitem* syntax.

``` {.sourceCode .python}
from addict import Dict
e = Dict()
e.x.a.m.p.l.e    = 'examble' # attribute syntax
e.x.a.m.p.l['e'] = 'example' # both mixed
```

-   The author of
    [libaudioverse](https://github.com/camlorn/libaudioverse) describes
    the [horror to implement platform independent audio
    output](http://camlorn.net/posts/december2014/horror-of-audio-output.html)
    using existing libraries.
-   [The Algorithmic Beauty of
    Plants](http://algorithmicbotany.org/papers/#abop) as
    [pdf](http://algorithmicbotany.org/papers/abop/abop.pdf).


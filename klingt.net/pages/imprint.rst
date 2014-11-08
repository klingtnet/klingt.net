.. title: Imprint
.. slug: imprint
.. date: 2014-09-28 11:51:36 UTC+02:00
.. tags:
.. link:
.. description: The imprint, you need to have it in germany.
.. type: text

Address information
===================

.. code::
    :name: contactdata
    :class: kn-reverse

    19356112/15194+

    zniL saerdnA
    ten.tgnilk o/c
    25 gnirnegnulebiN
    gizpieL 97240

Note that the address information block is written right-to-left and reversed via CSS [1]_.

Privacy
=======

    Ich widerspreche der Nutzung oder Übermittlung meiner Daten für Zwecke der Werbung oder der Markt- oder Meinungsforschung (§ 28 Absatz 4 Bundesdatenschutzgesetz). [BDSG]_

I disagree to the usage and transmission of data used for the purpose of advertisment- market or opinion research.

This website **doesn't** use any tracker or analysis tools like `Google Analytics <http://www.google.com/analytics/>`_, also i won't record any logs. If you notice anything suspicious please let me know.

Note that I try to serve everything from my own server without using CDNs. Until `KaTeX <https://github.com/Khan/KaTeX>`_ is production ready I have to make one exception for `MathJax <http://www.mathjax.org/>`_. This is because MathJax is quite large and performs better when using their CDN because of caching.

PGP
===

.. code::
    :name: fingerprint

    EC9B CA2A 5BA2 56EC 3143 72A3 FF4A 9E7F 9AA3 F5EC

My `PGP public key`_, you can get it also on the `MIT key-server <https://pgp.mit.edu/pks/lookup?op=vindex&search=0xFF4A9E7F9AA3F5EC>`_ :code:`gpg --keyserver pgp.mit.edu/ --recv-keys 0x9AA3F5EC`.

----

.. [1] I've done in the hope to prevent misuse of address by stupid spam bots. At first I had implemented a solution with simple encryption and a captcha, but this involved javascript, which is -- sadly -- not everywhere available.
.. [BDSG] `§ 28 Absatz 4 Bundesdatenschutzgesetz <http://www.bfdi.bund.de/DE/Themen/GrundsaetzlichesZumDatenschutz/BDSGAuslegung/Artikel/Widerspruchsrecht.html?nn=409922>`_
.. _`PGP Public Key`: /files/public.key
.. title: Automatentheorie Cheat Sheet
.. slug: automatentheorie-cheat-sheet
.. date: 2014-10-29 13:36:13 UTC+01:00
.. tags:
.. link:
.. description: a cheat sheet for the course automata theory
.. type: text
.. hidefromnav: True

A cheat sheet for the course `automata theory <http://www.informatik.uni-leipzig.de/theo/>`_ in WS14/15 at `Uni Leipzig <http://www.zv.uni-leipzig.de/>`_.

Finite automata and languages
-----------------------------

- ein *Alphabet* :math:`A` ist eine nicht leere Menge von Literalen
- ein *Wort* ist eine Sequenz :math:`w=a_1 … a_n` mit :math:`a_1, … ,a_n \in A`
- :math:`|w|` ist die Laenge des Wortes, :math:`\varepsilon` ist das leere Wort
- :math:`A^n = \left\{ w \in A^* | |w| = n\right\}, n \in \mathbb{N}`
- :math:`A^* = \bigcup_{n \leq 0} A^n`
- z.B. :math:`A_2 = \left\{ab|a,b \in A\right\}`
- *Konkatenation* :math:`conc` von Woerten :math:`u, v \in A^*` ist die Hintereinanderschreibung der beiden Woerter
- Die Konkatenation ist assoziativ, also ist :math:`(A^*, conc)` eine `Halbgruppe <http://en.wikipedia.org/wiki/Semigroup>`_, :math:`(A^*, conc, \varepsilon)` sogar ein `Monoid <http://en.wikipedia.org/wiki/Monoid>`_

languages
~~~~~~~~~

- Jede Teilmenge :math:`L \subseteq A^*` wird als *Sprache* ueber A bezeichnet

.. math::

	\begin{aligned}
	L^0 &:= \left\{\varepsilon\right\}\\
	L^1 &:= L\\
	L^{n+1} &:= L^n \cdot L\left(n \geq 0\right)\\
	L^* &:= \bigcup_{n \geq 0} L^n = \left\{ u_1 … u_n \middle| n \geq 0, u_1, … , u_n \in L \right\}\\
		&= \text{Kleene iteration}
	\end{aligned}

automaton
~~~~~~~~~

- :math:`\mathcal{A} = (Q, I, T, F)`
- *Q* Zustandsmenge
- *I*, *F* Initial-/Finalzustaende
- *T* Menge von Transitionen :math:`T \subseteq Q \times A \times Q`
- :math:`\mathcal{A}` ist:
	- *endlich* wenn Q endlich ist
	- *deterministisch* wenn es nur einen Initialzustand gibt und kein Zustand mehrere Transitionen mit dem gleichen Symbol besitzt
	- *vollstaendig* wenn es fuer jeden Zustand Transitionen fuer alle Symbole des Alphabetes gibt
- Transition: :math:`q \xrightarrow{a} r`
- Ein *run* (Pfad, Berechnungssequenz) ist eine Sequenz von Transitionen
- :math:`dom(u) := q_0, cod(u) := q_n` Domain ist Initialzustand, Codomain ist Finalzustand des run **u**
- Gibt es fuer ein Wort **w** einen *erfolgreichen* run **u** in :math:`\mathcal{A}` dann wird **w** akzeptiert
- :math:`L(\mathcal{A}) := \left\{ w \in A^* | \mathcal{A} \text{ accepts } w \right\}` die vom Automaten akzeptierte Sprache
- Wenn :math:`\mathcal{A}` ein endlicher Automat ist dann existiert ein endlicher vollstaendiger und deterministischer Automat :math:`\mathcal{A'}` so dass :math:`L(\mathcal{A'}) = L(\mathcal{A})`. Konstruktion ueber die Potenzmenge der Zustaende des Ausgangsautomaten.
- Ein Automat wird als **Initialzustandsnormalisiert** bezeichnet falls er nur einen Initialzustand besitzt, analog **Finalzustandsnormalisiert**
- Ein **normalisierter** Automat besitzt nur jeweils einen Anfangs- und Endzustand und kann das leere Wort nicht mehr erkennen, da :math:`I \cap F = \varnothing`

Monoids
-------
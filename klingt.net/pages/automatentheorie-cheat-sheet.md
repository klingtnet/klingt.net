A cheat sheet for the course [automata
theory](http://www.informatik.uni-leipzig.de/theo/) in WS14/15 at [Uni
Leipzig](http://www.zv.uni-leipzig.de/).

Finite automata and languages
=============================

-   ein *Alphabet* $A$ ist eine nicht leere Menge von Literalen
-   ein *Wort* ist eine Sequenz $w=a_1 … a_n$ mit $a_1, … ,a_n \in A$
-   $|w|$ ist die Laenge des Wortes, $\varepsilon$ ist das leere Wort
-   $A^n = \left\{ w \in A^* | |w| = n\right\}, n \in \mathbb{N}$
-   $A^* = \bigcup_{n \leq 0} A^n$
-   z.B. $A_2 = \left\{ab|a,b \in A\right\}$
-   *Konkatenation* $conc$ von Woerten $u, v \in A^*$ ist die
    Hintereinanderschreibung der beiden Woerter
-   Die Konkatenation ist assoziativ, also ist $(A^*, conc)$ eine
    [Halbgruppe](http://en.wikipedia.org/wiki/Semigroup),
    $(A^*, conc, \varepsilon)$ sogar ein
    [Monoid](http://en.wikipedia.org/wiki/Monoid)

languages
---------

-   Jede Teilmenge $L \subseteq A^*$ wird als *Sprache* ueber A
    bezeichnet

$$\begin{aligned}
L^0 &:= \left\{\varepsilon\right\}\\
L^1 &:= L\\
L^{n+1} &:= L^n \cdot L\left(n \geq 0\right)\\
L^* &:= \bigcup_{n \geq 0} L^n = \left\{ u_1 … u_n \middle| n \geq 0, u_1, … , u_n \in L \right\}\\
    &= \text{Kleene iteration}
\end{aligned}$$

automaton
---------

-   $\mathcal{A} = (Q, I, T, F)$
-   *Q* Zustandsmenge
-   *I*, *F* Initial-/Finalzustaende
-   *T* Menge von Transitionen $T \subseteq Q \times A \times Q$
-   

    $\mathcal{A}$ ist:

    :   -   *endlich* wenn Q endlich ist
        -   *deterministisch* wenn es nur einen Initialzustand gibt und
            kein Zustand mehrere Transitionen mit dem gleichen Symbol
            besitzt
        -   *vollstaendig* wenn es fuer jeden Zustand Transitionen fuer
            alle Symbole des Alphabetes gibt

-   Transition: $q \xrightarrow{a} r$
-   Ein *run* (Pfad, Berechnungssequenz) ist eine Sequenz von
    Transitionen
-   $dom(u) := q_0, cod(u) := q_n$ Domain ist Initialzustand, Codomain
    ist Finalzustand des run **u**
-   Gibt es fuer ein Wort **w** einen *erfolgreichen* run **u** in
    $\mathcal{A}$ dann wird **w** akzeptiert
-   $L(\mathcal{A}) := \left\{ w \in A^* | \mathcal{A} \text{ accepts } w \right\}$
    die vom Automaten akzeptierte Sprache
-   Wenn $\mathcal{A}$ ein endlicher Automat ist dann existiert ein
    endlicher vollstaendiger und deterministischer Automat
    $\mathcal{A'}$ so dass $L(\mathcal{A'}) = L(\mathcal{A})$.
    Konstruktion ueber die Potenzmenge der Zustaende
    des Ausgangsautomaten.
-   Ein Automat wird als **Initialzustandsnormalisiert** bezeichnet
    falls er nur einen Initialzustand besitzt, analog
    **Finalzustandsnormalisiert**
-   Ein **normalisierter** Automat besitzt nur jeweils einen Anfangs-
    und Endzustand und kann das leere Wort nicht mehr erkennen, da
    $I \cap F = \varnothing$

Monoids
=======

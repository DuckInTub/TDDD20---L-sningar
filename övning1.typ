= Övningsuppgifter 1

== Uppgift 1
En cyklisk rotation X är en rotation utav en sortering av elementen i X.
Någon form utav binary search. Om vi hittar $X[i] > X[i+1]$ så vet vi att $X[i+1]$ är minsta elementet och har index $i+1$.

=== Algorithm
Obs index startar på $0$.
#pseudocode-list(stroke: none)[
  + $L = 0 $
  + $H = n-1 $
  + $"while" L < H: $
  + $M = (L + H) times 1/2 $
    + $"if" X[M] > X[H]: $
      + $L = M + 1 $
    + $"elif" X[M] <= X[H]: $
      + $H = M $
  + $"return" L $
]
=== Korrekthet
Basfall: längden av X är 1. Detta betyder att 0 är det enda korrekta svaret. Eftersom $L=0$ och $H eq.def 0$ i detta fall. Vi återgår helt enkelt till $L = 0$ vilket är korrekt.

Induktionshypotes: Algoritmen är korrekt för viss längd $n = k, k in NN, k >= 1$.

Induktionssteg: Vi visar att algoritmen är korrekt för viss längd $n = k + 1$.
Detta kommer att innebära $L = 0$ och $H = k$, och vi kommer att gå in i loopen.
Vi sätter $M = floor(k/2)$. Från här har vi två fall.

Fall 1: $X[M] > X[H]$ vilket är detsamma som $X[floor(k/2)] > X[k]$. Detta betyder att det minimi elementet är i "högerhalvan" och så vi sätter $L = floor(k/2) + 1$. Vi går nu tillbaka in i iterationen medan vi i huvudsak betraktar $X$ från \
$x_(floor(k/2)+1)$ tills $x_k$. Vi tillämpar nu vår induktionshypotes eftersom vi betraktar X med en längd av $k - floor(k/2)+1$ vilket är mindre än eller lika med $k$.

Fall 2: $X[M] <= X[H]$ vilket är detsamma som $X[floor(k/2)] <= X[k]$, och betyder att det minimi elementet är i "vänsterhalvan" (eller vi är ovanpå det), och så vi sätter $H = floor(k/2)$. Återigen går vi tillbaka in i iterationen medan vi i huvudsak betraktar $X$ från $x_0$ till $x_(floor(k/2))$ vilket har längd $floor(k/2)$. Vi kan nu tillämpa induktionssteget.


=== Tidskomplexitet
Enligt korrekthets beviset går det altså att betrakta algoritmen som att den först körs på $A(n)$ och sedan (ungefär) $A(n / 2)$. Alltså beskrivs storleken av indatan som \ $A(n) = A(n/2) + A(n/4) + ... + A(n/2^x)$. Vilket är $O(log n)$.

#pagebreak()
== Uppgift 2
Algoritmen baseras på dynamisk programering. Låt $T$ vara en tabell sådant att: \
$T[i, j]$ är längden av den längsta gemensamma substrängen för: $a_1a_2...a_i$ och $b_1b_2...b_j$. \
Det följer då att $T[0, 0] = T[0, 1] = T[1, 0] = 0$. Tabellen $T$ byggs sedan upp på följande sätt: \

#pseudocode-list(stroke: none)[
  + $M := 0$
  + $T[0,...,a".length" | 0,dots,b".length"] := 0$ 
  + $"for" i "from" 1 "to" n$
    + $"for" j "from" 1 "to" m$
      + $T[i, j] := T[i - 1, j - 1] + 1 "if" a_i == b_j "else" 0$
      + $M := "max"(T[i, j], M)$
  + return M
]


#pagebreak()
== Uppgift 3

Låt listan $L$ inehålla elementen (med dubletter) från både $S_1$ och $S_2$. Sortera listan med merge sort i $O(n log n)$ tid. Gå sedan igenom listan parvis likt:  $T eq.def {L_1 != L_2, L_2 != L_3 ... L_(n-1) != L_n}$. \  
$S_1$ och $S_2$ är disjunkta om `Falskt` $in.not T$.

=== Korrekthet
Det följer att om merge sort är korrekt får vi alltså den sorterade listan $L$ korrekt. Härifrån föjer det att om $S_1$ och $S_2$ är konjunkta, måste det finnas ett $i$ sådant att $L[i] = L[i+1]$, vilket algoritmen kommer finna när den går igenom $L$ parvis. Och, om inget sådant $i$ finns, måste $S_1$ och $S_2$ vara disjunkta. Det följer alltså att algoritmen är korrekt.

=== Tidskomplexitet
Algoritmen består utav två faser. En fas där vi lägger ihop $S_1$ och $S_2$ och sedan sorterar med merge sort. Detta kommer gå i $O(n log n)$ för att det domineras utav merge sorts tidskomplexitet.

I nästa steg så går vi igenom $L$, som vi konstruera, parvis. Detta går alltså i $O(n)$ tid, men domineras utav $O(n log n)$.

Alltså är den totala tidskomplexiteten $O(n log n)$

== Uppgift 4
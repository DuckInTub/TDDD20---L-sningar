#import "@preview/lovelace:0.3.0": *
#set text(lang: "sv")
#set list(indent: 1em)
#set enum(indent: 1em)

#set document(
  title: [Lösningsförslag till gamla tentor i TDDD20 - Konstruktion och Analys av Algoritmer - Från Linköpings Universitet.]
)
#title()

#heading(outlined: false)[Förord]
Följande dokument innehåller några utav mina lösningar till problem från gamla tentor i TDDD20. 
Notera följande:
- Inga beskrivningar utav själva uppgiften förekommer i detta dokument utan måste hämtas av läsaren själv.
- Notera att lösningarna endast är rubricerade under det datum på tentan som uppgiften kommer ifrån.
- Då det alltid finns flera sätt att lösa ett problem, ska dessa lösningar endast ses som lösningsförslag. 
- Det kan vara svårt att "rätta" en algoritm eller ett bevis. Således kan det finnas mindre fel som indexeringsfel eller "slarviga" argument och resonemang.
- Lösningarna försöker följa en logisk struktur där man i ordning presenterar: algoritmen, tidskomplexiteten och korrektheten.

#outline()
#pagebreak()

= 2023-06-07

== Uppgift 2. (8p)
För att visa att problemet är _NP-svårt_ måste vi skapa en korrekt reduktion, som går i polynomisk tid, från ett känt NP-svårt problem till det nya QUADRATIC-EQS.

*Reduktion från 3SAT*

*Notera:* 
1. För en godtycklig klausul, $(x or y or not z)$, kan vi skriva om den som en ekvation, där $u,v$ är slackvariabler:
$ (x or y or not z) ->_(u,v) x + y + (1 - z) - u - v = 1 | x,y,z,u,v in {0, 1} $
2. Följande ekvationssystem tvingar, om $p, q in QQ$, att $p, q in {0, 1}$:
$ cases(p^2 + q = 1 , q^2 + p = 1) | p, q in QQ arrow.double.r "Lösningar:" cases(p = 0\, space q = 1 , p = 1\, space q = 0) $
Notera att $sqrt(5) in.not QQ$ så endast dessa två lösningar gäller. Det gäller också att $p <=> not q$ och $q <=> not p$. \
För varje unik klausul från 3SAT skapar vi ekvationer enligt följande mönster:
$ (x or y or not z) arrow.r_(u, v) cases(x^2 + hat(x) = 1 , hat(x)^2 + x = 1 , y^2 + hat(y) = 1 , hat(y)^2 + y = 1 , z^2 + hat(z) = 1 , hat(z)^2 + z = 1 , u^2 + hat(u) = 1 , hat(u)^2 + u = 1 , v^2 + hat(v) = 1 , hat(v)^2 + v = 1 , x + y + (1 - z) - u - v = 1) bar x,y,z,u,v in QQ $
Följ detta mönster för alla klausuler där negerade literaler $not l$ sätts till $(1 - l)$ i ekvationen.

*Tidskomplexitet*: \
Reduktionen lägger för varje klausul till 11 ekvationer. Antag att det går i polynomisk tid att skapa en ekvation. Då går det i $O(|C| times 11 times "poly")$-tid, där $C$ är mängden klausuler, att skapa hela den nya instansen. Detta är polynomisk tid.

*Korrekthet*: \
*Om 3SAT ger "ja"* kan man använda samma tilldelning från 3SAT i QUADRATIC-EQS genom att sätta variabler enligt "SANT" $arrow.bar 1$ eller "FALSKT" $arrow.bar 0$. Enligt notering 1 och 2 följer det då att detta är en korrekt lösning till det stora ekvationssystemet. Alltså måste QUADRATIC-EQS svara "ja". \
*Om QUADRATIC-EQS ger "ja"* har vi alltså enligt notering 2 tilldelat en lösning så att varje variabel $x arrow.bar {0, 1}$. Notering 1 säger då att, eftersom alla ekvationer är lösta och lösningen på den 11:e ekvationen i varje grupp är ekvivalent med originalklausulen, måste formeln satisfieras av ekvationssystemets lösning. Alltså måste 3SAT svara "ja".

Det följer alltså att QUADRATIC-EQS är NP-svårt eftersom $3"SAT" <=_p "QUADRATIC-EQS"$.
#align(right)[_Q.E.D_]
#pagebreak()

== Uppgift 3. (8p)
Skapa listan $K$ där $K[i]$ är $1$ om $s[1 dots i]$ är (K)onstruerbar i $X$. Vi får då följande rekursiva relation:
$ K[i] = cases(
  1 & "om" s[1 dots i] in X,
  or.big_(j=1)^(i-1) [K[j] and s[j+1 dots i] in X] & "annars"
) $ 
och kan fylla $K$ med följande algoritm.

*Algoritm:*
#pseudocode-list(stroke: none, title: [KONSTRUERBAR($s, X$)], booktabs: true)[
+ $L := s."length" $
+ $K[0 dots L] := 0 $
+ $K[0] := 1$
+ for $i$ in $[1 dots L]$:
  + $ K[i] := cases(1 & "om" s[1 dots i] in X, or.big_(j=1)^(i-1) [K[j] and s[j+1 dots i] in X] & "annars") $
+ return "ja" om $K[L] = 1$ annars "nej".
]

*Tidskomplexitet:*
Algoritmen fyller i en lista av längd $L$. För varje element som fylls i behöver max $L-1$ föregående element kontrolleras. Algoritmen går således i $O(L^2)$-tid där $L$ är längden på strängen $s$.

*Korrekthet:*
Vi visar korrektheten med ett induktionsbevis över $L := s."length"$.

_Basfall_: $L = 0$ \
Då $K[0] := 1$ i steg 3, kommer algoritmen att returnera "ja". Detta är korrekt då den tomma strängen alltid är konstruerbar (genom att lägga till 0 tecken).

_Hypotes_: Antag att algoritmen är korrekt för alla $L <= k$. \
_Steg_: $L = k + 1$ \
I steg 4–5 kommer algoritmen att kontrollera alla prefix av $s$ upp till längd $k+1$. Notera att en sträng $s$ är konstruerbar i $X$ om och endast om det finns en delningspunkt $i$ så att: \
$K[i] = 1$ och $s[i+1 dots L] in X$. \
Algoritmen letar efter alla sådana delningspunkter. Notera nu också att for-loopen går i stigande ordning så strängar av längd $k$ har redan kontrollerats. Induktionshypotesen kan nu appliceras och det följer att algoritmen är korrekt.
#align(right)[_Q.E.D_]
#pagebreak()

== Uppgift 4. (8p)
1-in-3SAT

*Algoritm*:
För varje variabel sätt den med 50% sannolikhet till 1, annars 0. 

*Tidskomplexitet:* detta går uppenbarligen i O(n) tid över antalet variabler genom att använda en slumpbit.

*Korrekthet*: Vi får nu åtta möjliga utfall för varje klausul, där 3 av dem är satiriserande för klausulen. Notera alla dessa åtta utfall har samma sannolikhet då vi satte 50/50 över variablerna. För varje klausul skapa en stokastisk variabel $X_i$ som är $1$ om klausulen har en och endast en litteral sann annars $0$. Väntevärdet för en sådan variabel är nu $E(X_i) = 3/8$. Väntevärdet av antalet satisfierade klausuler är nu $E(C) = E(sum(X_i)) "for i from 1 to" |C|$. Med linearitet är detta samma som $E(C)= sum(E(X_i))$ för varje $X_i$. Vilket är detsamma som $|C| times 3/8$. Eftersom att $3/8$ är större än $30%=3/10$ så är kravet uppfyllt korrekt.

#align(right)[_Q.E.D_]

#pagebreak()
= 2024-03-22
== Uppgift 2. (8p)
För att visa NP-fullständighet måste vi visa 1. att problemet är i NP och 2. NP-svårhet genom en korrekt reduktion från ett känt NP-svårt problem.

1. Visa att problemet är i NP. \
  En "lösning" till problemet skulle alltså vara två mängder index som tillsammans har längd $k$. Gå helt enkelt igenom de två mängderna, använd indexen och beräkna summorna för de två mängderna och sedan kollar man att summorna är lika. Detta går i $O(k)$ tid, alltså är problemet i NP.
2. Reduktion från _SUBSETSUM_. \
  Om SUBSETSUM ger "ja" har vi en mängd heltal $S$ och något subset som summerar till $T$. Vi vill att listan $L$ för det nya problemet ska tvinga fram att $T$ måste vara en delsumma i båda partitionerna. Gör följande:
  $ A colon.eq sum_(a in S) a $
  $ L colon.eq [S, dots, 2A - T, A + T] $
  Den totala summan för $L$ är $4A$. Alltså måste en partition exakt ha summan $2A$. Notera att det gäller från SUBSETSUM att $T >= A$. Det betyder att elementen $2A - T$ och $A + T$ inte kan vara i samma partition. Eftersom:
  Den partition som väljer elementet $2A - T$ måste då logiskt också välja en delmängd utav $S$ som summerar till exakt $T$. \
  *Om SUBSETSUM ger "ja"* ger det nya problemet "ja". Eftersom $2A - T$ kommer va i den ena partition. Samma partition måste kan sedan, enligt lösningen som existerar för SUBSETSUM, välja en delmängd utav $S$ som summerar exakt till $T$. Denna summa är exakt $2A$ och resten av elementen måste nu vara i den andra partitionen. Alltså svarar det nya problemet "ja". \
  *Om det nya problemet svarar "ja"* så måste återigen $2A - T$ vara i den ena partitionen och $A + T$ i den andra eftersom de inte får överskrida $2A$. För att partitionen som innehåller $2A - T$ ska gå att summera upp till exakt $2A$ måste det alltså finnas en delmängd utav $S$ som summerar till exakt $T$ som inkluderats i denna partition. Detta betyder att SUBSETSUM måste svara "ja".

  Det nya problemet är NP-fullständigt. 
#align(right)[_Q.E.D_]


#pagebreak()
= 2023-08-22
== Uppgift 4. (8p)
För att visa att Horn+SAT är NP-fullständigt måste vi visa två saker: att problemet tillhör komplexitetsklassen NP, samt att det är NP-svårt genom en reduktion från ett känt NP-svårt problem (i detta fall 3SAT).

*1. NP-medlemskap:* \
Horn+SAT är i NP precis som SAT och 3SAT och en lösning kan alltså verifieras i polynomisk tid.

*2. Reduktion från 3SAT:* \
Vi visar NP-svårighet genom reduktion från 3SAT. För godtyckliga 3SAT-klausuler finns det endast två typer som inte uppfyller kraven för Horn+. Dessa är av formerna:
$ (x or y or z) quad "och" quad (x or y or not z) $ _(Notera att inbördes ordning på literalerna kan ändras)_

För varje 3SAT-klausul som bryter mot Horn+-kraven byter vi ut den mot en ekvisatisfierbar mängd nya klausuler. För varje utbyte inför vi 2 eller 3 nya _unika_ variabler för den nya instansen:
  $ (x or y or z) ->_(p,q,w) (x or p) and (y or q) and (z or w) and (not p or not q or not w) $
  $ (x or y or not z) ->_(p, q) (x or not z or not p) and (y or not z or not q) and (p or q) $
*Metod:*
Notera att man kan komma framm till denna reduktion genom att försöka "skriva av" 3SAT formeln till Horn+SAT och göra en ersättning när man skulle brutit mot Horn+SAT kraven. Exempelvis för $(x or y or z)$ börjar man skriva $(x or y)$ eftersom att denna klausulen är godkänd. Man noterar sedan att om endast $z$ från 3SAT är satisfierad funkar inte klausulen. Alltså måste man sätta in en hjälp variabel. Man får då $(x or p) and (y or q) and (z or w)$. Därifrån noterar man att om $x,y,z arrow.bar 0$ är formeln fortfarande satisfierbar genom $p,q,w arrow.bar 1$ och man måste motverka detta genom klausulen $(not p or not q or not w)$, som säger att alla tre hjälp variabler inte får vara sanna samtidigt. Alltså måste minst en av $x, y, z$ vara sann.



*Tidskomplexitet:* \
Reduktionen går uppenbart i polynomisk tid. För varje klausul i originalformeln (om den inte redan uppfyller kraven) inför vi maximalt 4 nya klausuler och högst 3 nya variabler. Detta innebär en linjär expansion, vilket går i $O(|C|)$-tid, där $C$ är mängden klausuler i originalinstansen.

*Korrekthet:* \
Eftersom vi för varje 3SAT-klausul som inte uppfyller Horn+-kraven skapar en mängd nya klausuler som är lokalt ekvisatisfierbara, kommer hela 3SAT-instansen och den nya Horn+-instansen att vara globalt ekvisatisfierbara.
- *Om 3SAT svarar "ja"*: Samma variabeltilldelning gör den nya Horn+-formeln satisfierad, förutsatt att vi tilldelar de nya variablerna $p, q, w$ korrekta sanningvärden. Alltså svarar Horn+SAT "ja".
- *Om Horn+SAT svarar "ja"*: Då kan 3SAT också svara "ja" genom att ta tilldelningen från lösningen för Horn+SAT och helt enkelt bortse från de godtyckligt införda hjälpvariablerna $p, q$ och $w$. De ursprungliga literalerna måste vara tilldelade på ett sätt som satisfierar originalklausulerna.

Således är reduktionen korrekt. Slutsatsen är att Horn+SAT är NP-fullständigt.
#align(right)[_Q.E.D_]

#pagebreak()
= 2023-03-24
== Uppgift 1. (8p)

*Algoritm:*

Skapa tabellen $L$ fylld med $0$ som är $(K+1) times (X+1)$ stor. $L[i][j]$ representerar antalet sätt att skapa summan $j$ med $i$ tal ur $\{1, dots, s\}$.
#pseudocode-list(stroke: none, title: [NR-SOLUTIONS($k, s, X$)], booktabs: true)[
+ $L[0][0] := 1$ \/\/ Basfall: 1 sätt att få summan 0 med 0 element.
+ för $i$ från 1 till $k$: 
  + $S := 0$ \/\/ glidande fönster
  + för $j$ från 1 till $X$:
    + om $j - 1 >= 0$:
      + $S "+=" L[i-1][j-1]$ \/\/ Lägg till nytt element i fönstret.
    + om $j - 1 - s >= 0$:
      + $S minus "=" L[i-1][j-1-s]$ \/\/ Ta bort gammalt element ur fönstret.
    + $L[i][j] := S$
+ Returnera $L[k][X]$
]

*Tidskomplexitet:*
Det framgår från algoritmens for-loopar att den går i $O(k dot X)$-tid.

*Korrekthet:* Bevisas med induktion över antalet variabler $i$.

_Basfall:_ $i = 0$. Algoritmen sätter $L[0][0] = 1$ och $L[0][j] = 0$ för $j > 0$. Detta är korrekt då det enda sättet att bygga en summa med noll variabler är om summan är precis noll.

_Hypotes:_ Antag att algoritmen korrekt beräknar $L[i-1][j]$ för alla summor $j in {0, dots, X}$.

_Steg:_ För att skapa summan $j$ med $i$ stycken variabler $x_1, dots, x_i$, vet vi att $x_i$ kan anta vilket värde $v$ som helst mellan $1$ och $s$. De resterande $i-1$ variablerna måste då summera till $j - v$. Det totala antalet sätt blir då:
$ L[i][j] = sum_(v=1)^s L[i-1][j-v] $

I algoritmen uppdateras variabeln $S$ för varje $j$ genom att vi adderar $L[i-1][j-1]$ och subtraherar det element som ligger $s$ steg bort, $L[i-1][j-1-s]$. Notera alltså att $L[i-1][j-1-s]$ hade "krävt ett tal $v$ sådant att $j-1-s+v = X => v >= s + 1$ vilket inte går. Detta innebär att $S$ exakt håller summan av de senast passerade elementen i intervallet $[j-s, j-1]$ från föregående rad. Matematisk motsvarar detta exakt summan ovan. Hypotesen kan nu appliceras och alla $L[i-1]$ är korrekta, vilket medför att algoritmen korrekt beräknar $L[i][j]$. 

Således är algoritmen korrekt.
#align(right)[_Q.E.D_]


#pagebreak()
== Uppgift 2. (8p)
Vi visar 1. att problemet är i NP och 2. att problemet är NP-svårt. 

=== 1.
Problemet är i NP då en lösning kan verifieras i $O(4 times |C|)$-tid där $C$ är mängden klausuler. Detta sker genom att kontrollera de 4 literalerna i varje klausul.

=== 2. Reduktion från NAE-3SAT:
NAE-3SAT är ett känt NP-fullständigt problem där varje klausul har exakt 3 litteraler och ska tilldelas så att minst 1 litteral är sann och 1 litteral är falsk i varje klausul.

*Notera* detta kan verifieras genom Google.

Notera nu att ingen reduktion krävs eftersom att varje klausul har exakt 3 litteraler. Alltså har alla klausuler högst 4 litteraler.

*Korrekthet:* följer direkt ifrån NAE-3SAT.

#align(right)[_Q.E.D_]



#pagebreak()
== Uppgift 3. (8p)
*Algoritm:*
#pseudocode-list(stroke: none, title: [MULTIPLE-MST], booktabs: true)[
+ $T = (V_T, E_T) := $ är ett MST från Prim/Kruskals algoritm.
+ $Omega := $ Totala vikten av $T$.
+ för $e$ i $E_T$:
  + $E' := E \\ {e}$
  + $G' := $ grafen av $(V, E')$
  + $S := $ är $G'$ sammanhängande? \/\/ Detta kollas med BFS/DFS.
  + om inte $S$:
    + Nästa iteration
  + $A := "MST av " G'$
  + $Omega_A := $ Vikten av $A$
  + om $Omega_A = Omega$:
    + Returnera "ja"
+ Returnera "nej"
]

*Tidskomplexitet:* Notera att: MST kan beräknas i $O(|E| log |V|)$. BFS, DFS samt totala vikten av en graf kan beräknas i $O(|V| + |E|)$. For-loopen går över varje $e in E_T$ och totalt blir det: $ O(|E_T| times |E| log |V|) $ Detta är polynomisk tid, vilket krävdes.

*Korrekthet:* Algoritmen testar uteslutande alla MST av $G'$. Det nya MST $A$ måste vara $A != T$ eftersom $G'$ tagit bort en kant från $E_T$. Algoritmen är således korrekt genom uteslutning.
#align(right)[_Q.E.D_]

#pagebreak()

== Uppgift 4. (8p)
*Algoritm:*
#pseudocode-list(stroke: none, title: [INTERVAL-COVER(I)], booktabs: true)[
+ $n := |I|$
+ if $n <= 0$: return $0$
+ Sortera $I$ på $a_i$ för varje $[a_i, b_i]$, i stigande ordning.
+ $S := 0$; 
+ $a := I[1].a$
+ $b := I[1].b$
+ för varje par $[a_i, b_i]$ och $[a_(i+1), b_(i+1)]$ i $I$:
  + if $a <= a_(i+1) <= b$: \/\/ överlappar!
    + $b := "max"(b, b_(i+1))$
  + else:
    + $S += b - a$
    + $a := a_(i+1)$
    + $b := b_(i+1)$
+ $S += b - a$
+ Returnera $S$
]
*Tidskomplexitet:* Mergesort som går i $O(n log n)$ kan användas för sorteringen. Det framgår då från algoritmen att den är $O(n log n + n times c)$ där $c$ är en konstant. Detta förenklas till $O(n log n)$.

*Korrekthet:* Induktion över antalet intervall $n$.

_Basfall:_ $n=1$. Vi går inte in i for-loopen men $S := b_1 - a_1$ beräknas och returneras korrekt.

_Hypotes:_ Antag att algoritmen korrekt beräknar $S,a,b$ för $n <= k$.

_Steg:_ Beräkningen av intervall $k+1$ kommer alltså ske i det sista steget utanför for-loopen. Om de sista $theta$ intervallen överlappar kommer $b := b_(k+1)$ och $a := a_(k+2-theta)$ i if-satsen eftersom $a <= a_(k+1) <= b$ måste vara sannt på grund av den sorterade ordningen av intervallen. Summan inkrementeras med $b_(k+1) - a_(k-theta)$ från att ha varit korrekt uträknad för de $k+2-theta$ föregående intervallen enligt hypotesen. Notera att $theta >= 2$.

Om de två sista intervallen är disjunkta kommer summan $S$ vara korrekt för de $k$ föregående intervallen enlight hypotsen och eftersom algoritmen märker att de två sista intervallen är disjunkta i else-satsen på grund av den sorterade ordningen och faktumet att $a_(k+1) >= b_(k)$ för att inte överlappa. Nu kommer $a := a_(k+1)$ och $b := b_(k+1)$ i samma else-sats. Sedan inkrementeras $S$ korrekt med $b_(k+1) - a_(k+1)$ i sista steget. 
#align(right)[_Q.E.D_]


#pagebreak()
== Uppgift 5. (8p)
*Algoritm:* För varje nod $V$ tilldelar vi den uniformt, alltså med $1/3$ chans, heltalet 1, 2 eller 3. Detta representerar om noden är i $V_1, V_2$ eller $V_3$.

*Tidskomplexitet:*

Man kan göra varje tilldelning i konstant tid genom rejection sampling, bokens permutationsalgoritm eller en 6-sidig tärning. Alltså går algoritmen i $O(|V|)$-tid vilket är polynomiskt.

*Korrekthet:* 
För varje kant $(u, v) in E$ som har tilldelats $u arrow.bar V_x$ och $v arrow.bar V_y$ finns följande fall enligt mönstret:
$ u arrow.bar 1 <-> v arrow.bar 1 wide u arrow.bar 1 <-> v arrow.bar 2 wide u arrow.bar 1 <-> v arrow.bar 3 $
Notera att $2/3$ av dessa är "gynnsamma". Låt $X_e$ vara 1 om kant $e$ uppfyller kravet, annars 0. Väntevärdet av algoritmen är nu:
$ E(X_1 + dots + X_(|E|)) => "Linjäritet" => E(X_1) + dots + E(X_(|E|)) = |E| times 2/3 times 1 = 2/3 times |E| $
Notera att $2/3 |E| >= 2/3 K$ omm $K <= |E|$, vilket är logiskt.
#align(right)[_Q.E.D_]
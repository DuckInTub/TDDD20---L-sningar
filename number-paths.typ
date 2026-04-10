NUMBER_PATHS(s, t, G := (V, A)):
    // s and t are expected to be integers indices of the respective nodes.
    // s is expected to come before t so that s < t.
    T[0 ... |V|] = The topological sort of G. Calculated in O(|V| + |A|) time.

    P[s ... t] = 0
    P[s] = 1

    for v in T[s ... t - 1]:
        for e := (v, k) in A:
            P[k] += P[v]

    return P[t]

Tidskomplexitet:
Den topologiska sortering går i O(|V| + |A|) tid. Samt går 2-stegs for-loopen i algoritmen i samma tid då den besöker varje nod och kant en gång var.

Korrekthet:
Induktion över T[s ... t].length som defineras som L.
L=1 ger att s=t och P[s] := 1, vilket ger att P[t] == 1 som är korrekt.
Hypotes: antag att algoritmen stämmer för L <= K
Steg: När L=K+1 så räknas P[K+1] ut genom:
Sum(P[k]) for k in {n in V | (k, K+1) is in A}
Notera nu att P[k] antas stämma genom hypotesen eftersom att den topologiska sortering gör att P[k] redan räknats ut. Detta gör alltså att det kan användas för att räkna ut P[k+1].
Q.E.D.
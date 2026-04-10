Algorithm:
1. Gå igenom hela formeln och notera alla monotona variabler i O(c*n)-tid.
2. Sätt monotona enligt hur de förekommer. X sätts till 1 och ¬Y sätts till 0. Går i O(n)-tid.
3. Gå igenom formeln och ta bort alla klausuler som satisfieras utav monotona variabler. Går i O(c*n)-tid. 
4. Ta den nya formeln, som nu inte innehåller några monotona variabler, och bruteforca alla kombinationer. Vilket ger 2^log2(n)=n kombinationer. För varje kombination testa om den satisfierar den resterande formeln. Detta går också i O(c*n)-tid.

Tidskomplexiteten följer och är alltså dominerad utav O(c*n) där c är antal klausuler och n är antal variabler i original formeln.

Korrekthet: De monotona variablerna bidrar endast till stratifiering om de sätts enligt hur algoritmen sätter dem. Den resterande formeln testas uteslutande genom alla kombinationer. Således är algoritmen korrekt.

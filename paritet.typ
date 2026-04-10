```
def parity(n):
    par = [0] * n
    par[0] = 0
    par[1] = 1
    for i in range(2, n):
        par[i] = ( par[i//2] + (i % 2) ) % 2
    return par
```

Modulo 2 kan implementeras $floor(x/2) times 2$
MIN_PALINDROME_PARTITION(S) is:
  L = S.length

  let IS_P(X) be the function that checks if X is a palindrome in O(N) time.

  DP[0 ... L] = INF
  DP[0] = 0
  // Represents minimum number partitions for first `i` chars.

  prev [0 ... L] = NONE

  for n in 1 ... L: // Number of chars
    for p in 1 ... n: // Start index of last palindrome
      if not IS_P(S[p .. n]):
        continue

      if DP[p-1] + 1 < DP[n]:
        DP[n] = DP[p-1] + 1
        prev[n] = p-1

  at = L
  result = []
  while at > 0:
    next = prev[at]
    result.add_left(S[next + 1 ... at])
    at = next

  return join('|', result)

## Exercise 1

z = 1                           #
#
f = function(x, y, z) {         # x=3, y=1, z=2
  z = x+y                       # x=3, y=1, z=4
  # 
  g = function(m = x, n = y) {  # m=3, n=1, z=4
    m/z + n/z                   # = 3/4 + 1/4 = 1
  }                             # 
  # 
  z * g()                       # = 4 * 1
}                               # 
# 
f(1, 2, x = 3)                  # = 4




## Exercise 3

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
            43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)

x = c(3,4,12,19,23,51,61,63,78)

for (x in c(3,4,12,19,23,51,61,63,78)) {
  is_prime = FALSE
  
  for (p in primes) {
    if (x == p) {
      is_prime = TRUE
      break
    } 
  }
  
  if (!is_prime)
    print(x)
}

x[!x %in% primes]





# Find the Shortest Path 

The *Heathrow to London* problem, as seen in 
[Learn You a Haskell](http://learnyouahaskell.com/functionally-solving-problems)

- [`randroute.hs`](randroute.hs) makes a road system with specified number of sections. Unsafe at the time.
- [`shortest.hs`](shortest.hs) finds the optimal path.

#### Benchmark

```
$ runhaskell randroute.hs 500000 > path.txt
$ time runhaskell shortest.hs < path.txt
...
CAAAAACBBBBBBBBBBBBBBCAAAAAAAAAAAAACBBBBC
The price is: 42792040

real	0m22.247s
user	0m20.701s
sys	0m0.980s
```

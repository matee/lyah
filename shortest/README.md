# Find the Shortest Path 

The *Heathrow to London* problem, as seen in 
[Learn You a Haskell](http://learnyouahaskell.com/functionally-solving-problems)

- [`randroute.hs`](randroute.hs) makes a road system with specified number of sections. Unsafe at the time.
- [`shortest.hs`](shortest.hs) finds the optimal path.

#### Efficiency
The algorithm is pretty bad for long paths. For paths with 500,000 sections,
I needed to increase the heap size to 100 MB. Which is a lot. I'm trying to 
fix this, with help of these:

- [swap `String` wih `ByteString.Lazy`][haskell-strings]
- [benchmark the program][benchmarking]
- [profiling][profiling]
- [garbage collection][gc]

I understand the first two, but as of now, I have no skill in reading and 
interpreting the latter two.

#### `time` Benchmark

This is the first version using plain `String` and lazy `foldl`. There is not 
much information in there since it was run interpreted. 

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

[haskell-strings]: http://www.haskell.org/haskellwiki/Performance/Strings "Haskell Wiki: Performance > Strings"
[benchmarking]: http://stackoverflow.com/questions/6623316/how-to-measure-sequential-and-parallel-runtimes-of-haskell-program "StackOverflow: Haskell benchmarking"
[profiling]: http://stackoverflow.com/questions/3276240/tools-for-analyzing-performance-of-a-haskell-program/3276557#3276557 "Stackoverflow: Profiling"
[gc]: http://stackoverflow.com/questions/3171922/ghcs-rts-options-for-garbage-collection "Stackoverflow: Garbage Collection"
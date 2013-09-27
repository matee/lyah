# Benchmark for `shortest`

- all compiled with `ghc --make -O2 -rtsopts`

## [`shortest-simple.hs`](shortest-simple.hs)

The first version.

```
$ ghc --make -O2 -rtsopts -prof shortest-simple.hs
$ ./shortest-simple +RTS -sstderr -K100M -RTS < longpath
The price is: 42848795
   8,048,966,552 bytes allocated in the heap
   1,154,009,088 bytes copied during GC
     175,804,048 bytes maximum residency (14 sample(s))
       3,927,456 bytes maximum slop
             418 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     15377 colls,     0 par    2.64s    2.72s     0.0002s    0.2347s
  Gen  1        14 colls,     0 par    1.70s    3.45s     0.2465s    1.9746s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   15.02s  ( 16.12s elapsed)
  GC      time    4.33s  (  6.18s elapsed)
  RP      time    0.00s  (  0.00s elapsed)
  PROF    time    0.00s  (  0.00s elapsed)
  EXIT    time    0.00s  (  0.07s elapsed)
  Total   time   19.36s  ( 22.37s elapsed)

  %GC     time      22.4%  (27.6% elapsed)

  Alloc rate    536,004,341 bytes per MUT second

  Productivity  77.6% of total user, 67.2% of total elapsed
```

## [`shortest-strict-foldl.hs`](shortest-strict-foldl.hs)
- switch to `foldl'`

```
$ ghc --make -O2 -rtsopts -prof shortest-strict-foldl.hs
$ ./shortest-strict-foldl +RTS -sstderr -K100M -RTS < longpath
The price is: 42848795
   8,048,966,552 bytes allocated in the heap
   1,154,009,112 bytes copied during GC
     175,804,048 bytes maximum residency (14 sample(s))
       3,927,456 bytes maximum slop
             418 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     15377 colls,     0 par    2.64s    2.72s     0.0002s    0.2276s
  Gen  1        14 colls,     0 par    1.73s    2.75s     0.1962s    1.2651s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   15.08s  ( 16.50s elapsed)
  GC      time    4.37s  (  5.46s elapsed)
  RP      time    0.00s  (  0.00s elapsed)
  PROF    time    0.00s  (  0.00s elapsed)
  EXIT    time    0.00s  (  0.07s elapsed)
  Total   time   19.45s  ( 22.04s elapsed)

  %GC     time      22.5%  (24.8% elapsed)

  Alloc rate    533,863,428 bytes per MUT second

  Productivity  77.5% of total user, 68.4% of total elapsed
```
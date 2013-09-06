-- types.hs

removeNonUppercase :: String -> String
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]

factorial :: Int -> Int
factorial n = product [1..n]

circumference :: Double -> Double
circumference r = 2 * pi * r

(?) :: Ord a => a -> a -> Ordering
(?) x y = if x < y
          then LT
          else if x > y
               then GT
               else EQ

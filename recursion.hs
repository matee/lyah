-- file: recursion.hs

replicate' :: Integral a => a -> b -> [b]
replicate' n x
    | n <= 0    = []
    | otherwise = x : replicate' (n - 1) x

take' :: (Num a, Ord a) => a -> [b] -> [b]
take' n _
    | n <= 0   = []
take' _ []     = []
take' n (x:xs) = x : take' (n - 1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' e (x:xs)
    | e == x    = True
    | otherwise = elem' e xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = smallerSorted ++ [x] ++ biggerSorted
    where smallerSorted = quicksort [a | a <- xs, a <= x]
          biggerSorted  = quicksort [a | a <- xs, a >  x]

sum' :: Num a => [a] -> a
sum' = foldr (+) 0

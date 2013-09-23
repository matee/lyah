import Data.List

main = do
    contents <- getContents
    let threes = groupsOf 3 (map read $ lines contents)
        roadSystem = map (\[a,b,c] -> Section a b c) threes
        path = optimalPath roadSystem
        pathString = concat $ map (show . fst) path
        pathPrice = sum $ map snd path
    putStrLn $ "The best path to take is: " ++ pathString
    putStrLn $ "The price is: " ++ show pathPrice

data Section = Section { getA :: Int
                       , getB :: Int
                       , getC :: Int
                       } deriving (Show)

type RoadSystem = [Section]

heathrowToLondon :: RoadSystem
heathrowToLondon = [ Section 50 10 30
                   , Section 5 90 20
                   , Section 40 2 25
                   , Section 10 8 0
                   ]

data Label = A | B | C deriving (Show)
type Path = [(Label, Int)]

optimalPath :: RoadSystem -> Path
optimalPath roadSystem =
    let (bestAPath, bestBPath,_,_) = foldl roadStep ([],[],0,0) roadSystem
    in  if sum (map snd bestAPath) <= sum (map snd bestBPath)
        then reverse bestAPath
        else reverse bestBPath

roadStep :: (Path, Path, Int, Int) -> Section -> (Path, Path, Int, Int)
roadStep (pathA, pathB, priceA, priceB) (Section a b c) =
    let fwdPriceToA   = priceA + a
        crossPriceToA = priceB + b + c
        fwdPriceToB   = priceB + b
        crossPriceToB = priceA + a + c
        (newPathToA, bestPriceToA) = if fwdPriceToA <= crossPriceToA
                                     then ((A,a):pathA, fwdPriceToA)
                                     else ((C,c):(B,b):pathB, crossPriceToA)
        (newPathToB, bestPriceToB) = if fwdPriceToB <= crossPriceToB
                                     then ((B,b):pathB, fwdPriceToB)
                                     else ((C,c):(A,a):pathA, crossPriceToB)
    in  (newPathToA, newPathToB, bestPriceToA, bestPriceToB)
    
groupsOf :: Int -> [a] -> [[a]]
groupsOf 0 _  = undefined
groupsOf _ [] = []
groupsOf n xs = take n xs : groupsOf n (drop n xs)
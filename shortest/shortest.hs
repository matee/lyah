import Data.List(foldl')
import System.Environment
import qualified Data.ByteString.Lazy as B (ByteString,getContents,readFile)
import qualified Data.ByteString.Lazy.Char8 as C (readInt,lines)
import qualified Data.ByteString as B' (ByteString,getContents,readFile)
import qualified Data.ByteString.Char8 as C' (readInt,lines)
-- import Criterion.Main (defaultMain, bench)
-- Criterion is hard
-- main = do
--     let fileName = "5000.route"
--     contents <- readFile fileName
--     bs_contents <- B.readFile fileName
--     bs_contents' <- B'.readFile fileName
--     defaultMain [ bench "simple foldl" (simple contents)
--                 , bench "simple foldl'" (simple' contents)
--                 , bench "ByteString lazy" (bs bs_contents)
--                 , bench "ByteString strict" (bs' bs_contents')
--                 ]

main = do
    (fileName:_) <- getArgs
    -- simple fileName
    -- simple' fileName
    -- bs fileName
    bs' fileName
                
simple :: String -> IO ()
simple file = do
    contents <- readFile file
    let threes = groupsOf 3 (map read $ lines contents)
        roadSystem = map (\[a,b,c] -> Section a b c) threes
        path = optimalPath roadSystem
        pathString = concat $ map (show . fst) path
        pathPrice = sum $ map snd path
    putStrLn $ "The price is: " ++ show pathPrice
    
simple' :: String -> IO ()
simple' file = do
    contents <- readFile file
    let threes = groupsOf 3 (map read $ lines contents)
        roadSystem = map (\[a,b,c] -> Section a b c) threes
        path = optimalPath' roadSystem
        pathString = concat $ map (show . fst) path
        pathPrice = sum $ map snd path
    putStrLn $ "The price is: " ++ show pathPrice
    
bs :: String -> IO ()
bs file = do
    contents <- B.readFile file
    let threes = groupsOf 3 (map bsToInt $ C.lines contents)
        roadSystem = map (\[a,b,c] -> Section a b c) threes
        path = optimalPath' roadSystem
        pathString = concat $ map (show . fst) path
        pathPrice = sum $ map snd path
    putStrLn $ "The price is: " ++ show pathPrice

bs' :: String -> IO ()
bs' file = do
    contents <- B'.readFile file
    let threes = groupsOf 3 (map bsToInt' $ C'.lines contents)
        roadSystem = map (\[a,b,c] -> Section a b c) threes
        path = optimalPath' roadSystem
        pathString = concat $ map (show . fst) path
        pathPrice = sum $ map snd path
    putStrLn $ "The price is: " ++ show pathPrice

bsToInt :: B.ByteString -> Int
bsToInt bs = case C.readInt bs of
                Just (number, _) -> number
                Nothing          -> error "Not a number!"

bsToInt' :: B'.ByteString -> Int
bsToInt' bs = case C'.readInt bs of
                Just (number, _) -> number
                Nothing          -> error "Not a number!"


data Section = Section { getA :: Int
                       , getB :: Int
                       , getC :: Int
                       } -- deriving (Show)

type RoadSystem = [Section]

data Label = A | B | C deriving (Show)

type Path = [(Label, Int)]

optimalPath :: RoadSystem -> Path
optimalPath roadSystem =
    let (bestAPath, bestBPath,_,_) = foldl roadStep ([],[],0,0) roadSystem
    in  if sum (map snd bestAPath) <= sum (map snd bestBPath)
        then reverse bestAPath
        else reverse bestBPath
        
optimalPath' :: RoadSystem -> Path
optimalPath' roadSystem =
    let (bestAPath, bestBPath,_,_) = foldl' roadStep ([],[],0,0) roadSystem
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
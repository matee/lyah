{-# LANGUAGE BangPatterns #-}

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

-- | The main function, where you can switch 
main = do
    args <- getArgs
    let lenArgs = length args
    when lenArgs == 0
        error "Usage: ./shortest routes.file [method_number]"
    let fileName = head args
        num = if lenArgs > 1
              then read . head . tail $ args :: Int
              else (-1)
    case num of
        1 -> simple fileName
        2 -> simple' fileName
        3 -> bs fileName
        otherwise -> bs' fileName

-- | The simple version of the Heathrow-to-London alforithm
-- It tries to use only the basics of Haskell in compiler agnostic way. This
-- means no pre-processor pragmas, etc.                
simple :: String -- ^ Name of the file to consume. There should be an 'Int' on
                 -- each line. There should be total 'n' lines, where
                 -- 'n mod 3 == 0'.
       -> IO ()
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

-- | Convert a 'ByteString' to an 'Int'. Lazy version
-- An easy to use replacement for original 'read'
-- that works on plain 'String's.
bsToInt :: B.ByteString -- ^ A 'ByteString.Lazy' containing digits
        -> Int          -- ^ 'Int' representation of the input
bsToInt bs = case C.readInt bs of
                Just (number, _) -> number
                Nothing          -> error "Not a number!"

-- | Convert a 'ByteString' to an 'Int'. Strict version
-- An easy to use replacement for original 'read'
-- that works on plain 'String's.
bsToInt' :: B'.ByteString -- ^ A strict 'ByteString' containing digits
         -> Int           -- ^ 'Int' representation of the input
bsToInt' bs = case C'.readInt bs of
                Just (number, _) -> number
                Nothing          -> error "Not a number!"

-- | Defines a group of three roads.
data Section = Section { getA :: Int -- ^ Cost of the upper road
                       , getB :: Int -- ^ Cost of the lower road
                       , getC :: Int -- ^ Cost of the crossing at the end of the roads A and B
                       } -- deriving (Show)

-- | A road system is a list of 'Section's
type RoadSystem = [Section]

-- | A label for a road
data Label = A  -- ^ The upper road
           | B  -- ^ The lower road
           | C  -- ^ The crossing
           deriving (Show)

-- | A 'Path' is list of roads ('Label's) and their costs
type Path = [(Label, Int)]

-- | Compute optimal path for a 'RoadSystem'
optimalPath :: RoadSystem -- ^ 'RoadSystem' to compute a 'Path' from
            -> Path       -- ^ The optimal 'Path'
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
roadStep (!pathA, !pathB, !priceA, !priceB) (Section a b c) =
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
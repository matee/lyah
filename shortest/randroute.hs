import System.Random
import System.Environment

putRS :: [Int] -> IO ()
putRS = putStrLn . init . foldr (\i acc -> show i ++ "\n" ++ acc) ""
          
main = do
    args <- getArgs
    gen <- getStdGen
    let numberOfSections = read $ head args :: Int
        roadSystem = makeRoadSystem numberOfSections gen
    putRS roadSystem
    
makeRoadSystem :: RandomGen g => Int -> g -> [Int]
makeRoadSystem i gen = (init (take (i * 3) $ randomRs (1,200) gen)) ++ [0]
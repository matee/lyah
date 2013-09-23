import Data.List
import System.Environment

main = do
    args <- getArgs
    print $ solveRPN args

solveRPN :: [String] -> Float
solveRPN = head . foldl foldingFunction []
    where   foldingFunction (x:y:ys) "*" = (x * y):ys
            foldingFunction (x:y:ys) "+" = (x + y):ys
            foldingFunction (x:y:ys) "-" = (y - x):ys
            foldingFunction (x:y:ys) "/" = (y / x):ys
            foldingFunction (x:y:ys) "^" = (y ** x):ys
            foldingFunction (x:xs) "ln"  = log x:xs
            foldingFunction xs     "sum" = [sum xs]
            foldingFunction xs numberString = read numberString:xs 
-- file: own-types.hs
-- chapter: Making Our Own Types and Typeclasses

data Point = Point Float Float deriving (Show)
data Shape = Circle Point Float
           | Rectangle Point Point
           deriving (Show)
           
surface :: Shape -> Float
surface (Circle _ _ r) = pi * r ^ 2
surface (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)
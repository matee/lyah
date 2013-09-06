{-
   Learn You a Little Haskell
   chapter: Syntax in Functions
   file: syntax.hs
-}

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY!"
lucky _ = "Sorry :("

addVectors :: Num a => (a,a) -> (a,a) -> (a,a)
addVectors (x,y) (p,q) = (x + p, y + q)

head' :: [a] -> a
head' [] = error "Cant't call head on an empty list, dummy!"
head' (x:_) = x

length' :: Num b => [a] -> b
length' [] = 0
length' (x:xs) = 1 + length' xs

bmiTell :: RealFloat a => a -> String
bmiTell bmi
    | bmi <= 18.5 = "You're underweight, you emo, you!"
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
    | otherwise   = "You're a whale, congratulations!"

calcBmis1 :: (RealFloat a) => [(a,a)] -> [a]
calcBmis1 xs = [bmi | (w, h) <- xs, let bmi = w /h ^ 2, bmi >= 25.0]

calcBmis2 :: (RealFloat a) => [(a,a)] -> [a]
calcBmis2 = map bmi
    where bmi (w,h) = w / h ^ 2

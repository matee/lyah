module Tree where

data Tree a = Empty
            | Node a (Tree a) (Tree a)
            deriving (Show, Read, Eq)
            
singleton :: a -> Tree a
singleton x = Node x Empty Empty

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x Empty = singleton x
treeInsert x (Node a left right)
    | x == a = Node x left right
    | x <  a = Node a (treeInsert x left) right
    | x >  a = Node a left (treeInsert x right)
    
treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem _  Empty              = False
treeElem x (Node a left right)
    | x == a = True
    | x <  a = treeElem x left
    | x >  a = treeElem x right
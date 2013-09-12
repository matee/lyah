import Tree

class Tofu t where
    tofu :: j a -> t a j
    
data Frank a b = Frank {frankField :: b a} deriving (Show)

instance Tofu Frank where
    tofu x = Frank x
    
data Barry t k p = Barry { yabba :: p, dabba :: t k } deriving (Show)

instance Functor (Barry a b) where
    fmap f (Barry {yabba = p, dabba = k}) = Barry {yabba = (f p), dabba = k}
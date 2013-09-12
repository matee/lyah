import Tree
import qualified Data.Map as Map

data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
    Red    == Red    = True
    Green  == Green  = True
    Yellow == Yellow = True
    _      == _      = False
    
instance Show TrafficLight where
    show Red    = "Red light"
    show Yellow = "Yellow light"
    show Green  = "Green light"
    
instance Ord TrafficLight where
    Red < Yellow   = True
    Yellow < Green = True
    
class YesNo a where
    yesno :: a -> Bool
    
instance YesNo Int where
    yesno 0 = False
    yesno _ = True
    
instance YesNo [a] where
    yesno [] = False
    yesno _  = True
    
instance YesNo Bool where
    yesno = id
    
instance YesNo (Maybe a) where
    yesno (Just _) = True
    yesno Nothing  = False
    
instance YesNo (Tree a) where
    yesno Empty = False
    yesno _     = True
    
instance YesNo TrafficLight where
    yesno Red = False
    yesno _   = True
    
yf :: (YesNo y) => y -> a -> a -> a
yf yn yes no = if yesno yn
               then yes
               else no
               
instance Functor Tree where
    fmap f Empty = Empty
    fmap f (Node x left right) = Node (f x) (fmap f left) (fmap f right)
    
    
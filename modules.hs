-- file: modules.hs

import Data.List
import Data.Char (ord, chr)
import qualified Data.Map as Map
import qualified Data.Set as Set

numUnique :: (Eq a, Num b) => [a] -> b
numUnique = fromIntegral . length . nub

search :: (Eq a) => [a] -> [a] -> Bool  
search needle haystack =   
    let nlen = length needle  
    in  foldl (\acc x -> if take nlen x == needle then True else acc) False (tails haystack)
    
-- The Caesar cipher
encode :: Int -> String -> String
encode shift msg = map (chr . (+ shift) . ord) msg

-- decode
decode :: Int -> String -> String
decode shift msg = encode (negate shift) msg

-- The Phonebook
phoneBook =   
    [("betty","555-2938")  
    ,("betty","342-2492")  
    ,("bonnie","452-2928")  
    ,("patsy","493-2928")  
    ,("patsy","943-2929")  
    ,("patsy","827-9162")  
    ,("lucille","205-2928")  
    ,("wendy","939-8282")  
    ,("penny","853-2492")  
    ,("penny","555-2111")  
    ]  
    
findKey :: (Eq k) => k -> [(k,v)] -> Maybe v
findKey key = foldr eqKey Nothing
    where eqKey (k,v) acc = if key == k then Just v else acc
    
fromList' :: Ord k => [(k,v)] -> Map.Map k v
fromList' = foldr (\(k,v) acc -> Map.insert k v acc) Map.empty

text1 = "I just had an anime dream. Anime... Reality... Are they so different?"  
text2 = "The old man left his garbage can out and now his trash is all over my lawn!"  
import System.Environment
import System.Directory
import System.IO
import System.IO.Error
import Data.List

dispatch :: [(String, [String] -> IO ())]
dispatch = [ ("add", add)
           , ("view", view)
           , ("remove", remove)
           , ("bump", bump)
           ]

main = do
    (command:args) <- getArgs
    let result = lookup command dispatch
    case result of 
        Just action -> action args
        Nothing     -> errorExit
            
errorExit :: IO ()
errorExit = error ("Bad command\n" ++ usage)

usage = "Usage: todo add file \"A todo item\"\n       todo view file\n       todo remove file number\n       todo bump file number\n"

add :: [String] -> IO ()
add [fileName, todoItem] = appendFile fileName (todoItem ++ "\n")

view :: [String] -> IO ()
view [fileName] = do
    contents <- readFile fileName
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
    putStr $ unlines numberedTasks
    
remove :: [String] -> IO ()
remove [fileName, numberString] = do
    handle <- openFile fileName ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle
    let number = read numberString
        todoTasks = lines contents
        newTodoItems = delete (todoTasks !! number) todoTasks
    hPutStr tempHandle $ unlines newTodoItems
    hClose handle
    hClose tempHandle
    removeFile fileName
    renameFile tempName fileName

bump :: [String] -> IO ()
bump [fileName, numberString] = do
    handle <- openFile fileName ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle
    let number = read numberString
        todoTasks = lines contents
        bumped = todoTasks !! number
        newTodoItems = bumped : (delete bumped todoTasks)
    hPutStr tempHandle $ unlines newTodoItems
    hClose handle
    hClose tempHandle
    removeFile fileName
    renameFile tempName fileName

fileErrorHandler :: IOError -> IO ()
fileErrorHandler e
    | isDoesNotExistError e = putStrLn $ "File doesn't exist: " ++ eFileName e
    | isAlreadyInUseError e = putStrLn $ "File is already in use: " ++ eFileName e
    | isPermissionError   e = putStrLn $ "You have no permissions: " ++ eFileName e
        
eFileName :: IOError -> String
eFileName e = case ioeGetFileName e of
                Just path -> path
                Nothing   -> "N/A"
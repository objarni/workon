module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Node.Process
import Lib
import Data.Maybe
import Data.Array as Array
import Data.Foldable
import Node.FS.Sync
import Node.Encoding

configReader :: Projectname -> Maybe Config
configReader _ = Nothing

eval :: WorkonEffect -> Effect Unit
eval (Print s) = log s
eval (CreateFile name lines) = writeTextFile UTF8 name content
  where content = intercalate "\n" lines <> "\n"
eval command = log $ show command

main :: Effect Unit
main = do
  toParse <- Array.drop 2 <$> argv
  let
    parsed = parse toParse "samuel" configReader
  for_ parsed eval

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Node.Process
import Lib
import Data.Maybe
import Data.Array
import Data.Foldable

configReader :: Projectname -> Maybe Config
configReader _ = Nothing

eval (Print s) = log s
eval command = log $ show command

main :: Effect Unit
main = do
  toParse <- drop 2 <$> argv
  let
    parsed = parse toParse "samuel" configReader
  for_ parsed eval

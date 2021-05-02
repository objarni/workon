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

main :: Effect Unit
main = do
  toParse <- drop 2 <$> argv
  let parsed = parse toParse "samuel" configReader
  for_ parsed \command -> case command of
    Print s -> log s
    _ -> log $ show command

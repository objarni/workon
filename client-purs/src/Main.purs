module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.Process
import Lib
import Data.Maybe

configReader :: Projectname -> Maybe Config
configReader _ = Nothing

main :: Effect Unit
main = do
  toParse <- argv
  let parsed = parse toParse "samuel" configReader
  case parsed of
    [Print s] -> log s
    _ -> log $ show parsed

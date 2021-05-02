module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.Process
import Lib
import Data.Maybe

main :: Effect Unit
main = do
  toParse <- argv
  let configReader = \_ -> Nothing
  let parsed = parse toParse "samuel" configReader
  log $ show parsed

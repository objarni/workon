module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.Process

main :: Effect Unit
main = do
  toParse <- argv
  log $ show toParse

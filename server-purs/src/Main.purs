module Main where

import Prelude
import Data.Array ((:), filter)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Encode.Class (encodeJson)


type Heartbeat =
    { alias :: String
    , workingon :: String
    , timestamp :: Int
    }

type State = Array Heartbeat

getWorkingClients :: State -> Array (Array String)
getWorkingClients = map item
    where item r = [r.alias, r.workingon]

updateState :: Heartbeat -> State -> State
updateState x@{alias, timestamp} xs = x : rest
    where
        ourFilter y = aliasFilter y && timeFilter y
        aliasFilter y = y.alias /= alias
        timeFilter y = (y.timestamp + 30) > timestamp
        rest = filter ourFilter xs

convertToJson :: State -> String
convertToJson state = state
    # getWorkingClients
    # encodeJson
    # stringify


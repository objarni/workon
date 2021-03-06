module Test.Main where

import Data.Maybe (Maybe(..))
import Effect(Effect)
import Effect.Aff (launchAff_)
import Prelude (Unit, discard, (#), ($), (+))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Encode.Class (encodeJson)
import Main


main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "json library" do
    it "converts example" do
        let user = { name: "Tom", age: Just 25 }
        stringify (encodeJson user)
            `shouldEqual` "{\"name\":\"Tom\",\"age\":25}"
    it "converts list" do
        let dataList = ["a", "b", "c"]
        stringify (encodeJson dataList)
            `shouldEqual` "[\"a\",\"b\",\"c\"]"
  describe "Server state" do
    let olofAt5 = { alias: "olof"
                  , workingon: "rescue"
                  , timestamp: 5
                  }
    let sameAt6 = { alias: "samuel"
                  , workingon: "purescript-intellij"
                  , timestamp: 6
                  }
    let olofAt10 = olofAt5 {timestamp = 10}
    let olofAt37 = olofAt5 {timestamp = 6 + 31}
    it "adds heartbeat to state" do
        (updateState olofAt5 []) `shouldEqual` ([olofAt5])
    it "replaces old heartbeat in state" do
        (updateState olofAt10 [olofAt5])
            `shouldEqual` ([olofAt10])
    it "replaces old heartbeat in state" do
        (updateState sameAt6 [olofAt5])
            `shouldEqual` ([sameAt6, olofAt5])
    it "removes old timestamps" do
        []
            # updateState olofAt5
            # updateState sameAt6
            # updateState olofAt37
            # shouldEqual [olofAt37]
    it "exports alias and workingon fields" do
        getWorkingClients [] `shouldEqual` []
        getWorkingClients [olofAt5]
            `shouldEqual` [["olof", "rescue"]]
        getWorkingClients [olofAt5, sameAt6]
            `shouldEqual` [["olof", "rescue"], ["samuel", "purescript-intellij"]]
    it "converts to JSON" do
        convertToJson [olofAt5] `shouldEqual` "[[\"olof\",\"rescue\"]]"

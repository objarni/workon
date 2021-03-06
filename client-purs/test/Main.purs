module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.Traversable (for_)
import Lib

unwords :: Array String -> String
unwords = intercalate " "

exampleConfig :: Maybe Config
exampleConfig = exampleConfigWithServer "http://212.47.253.51:8335"

exampleConfigWithServer :: String -> Maybe Config
exampleConfigWithServer server =
  Just
    { cmdLine: [ "goland", "rescue" ]
    , server: server
    }

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] do
        describe "unwords" do
          it "concatenates string with a space inbetween" do
            unwords [ "olof", "samuel" ] `shouldEqual` "olof samuel"
            unwords [ "olof", "tor" ] `shouldEqual` "olof tor"
        describe "parse" do
          it "prints usage when missing project name" do
            let
              expected = [ Print "Usage: workon <projname>" ]

              readConfig _ = Nothing
            parse ([] :: CommandLine) ("olof" :: User) readConfig `shouldEqual` expected
          for_ [ "rescue", "polarbear" ] \projectName -> do
            it ("prints error message when config cannot be found for " <> projectName) do
              let
                expected = [ Print $ "Did not find '" <> projectName <> ".ini'. Re-run with flag --create to create a default!" ]

                readConfig _ = Nothing
              parse ([ projectName ] :: CommandLine) ("olof" :: User) readConfig `shouldEqual` expected
          it "prints error message when user writes create without project name" do
            let
              expected = [ Print "Create what? --create by itself makes no sense..." ]

              readConfig _ = Nothing
            parse [ "--create" ] "samuel" readConfig `shouldEqual` expected
          for_ [ "rescue", "polarbear" ] \projectName ->
            it ("prints error message when user tries to create already existing project " <> projectName) do
              let
                expected = [ Print $ "'" <> projectName <> ".ini' already exists, cannot create!" ]

                readConfig _ = exampleConfig
              parse ([ "--create", projectName ] :: CommandLine) ("samuel" :: User) readConfig `shouldEqual` expected
          for_
            ( { username: _, projectName: _, reverseCmdLine: _ }
                <$> [ "samuel", "tor" ]
                <*> [ "ijpurs", "polarbear" ]
                <*> [ true, false ]
            ) \{ username, projectName, reverseCmdLine } -> do
            it ("writes correct config file for user " <> username <> " project " <> projectName <> " when create flag is supplied") do
              let
                expected =
                  [ CreateFile
                      (projectName <> ".ini")
                      [ "[workon]"
                      , "cmdline=goland '/path/to the/project'"
                      , "server=http://212.47.253.51:8335"
                      ]
                  , Print $ "'" <> projectName <> ".ini' created."
                  , Print "Open it with your favorite text editor then type"
                  , Print $ "   workon " <> projectName
                  , Print "again to begin samkoding!"
                  ]

                cmdLine = if reverseCmdLine then [ projectName, "--create" ] else [ "--create", projectName ]

                readConfig _ = Nothing
              parse cmdLine username readConfig `shouldEqual` expected
          for_
            ( { username: _, projectName: _, server: _ }
                <$> [ "olof", "samuel" ]
                <*> [ "rescue", "polarbear" ]
                <*> [ "http://212.47.253.51:8335", "http://212.47.253.51:8080" ]
            ) \{ username, projectName, server } -> do
            it ("runs client with config: server " <> server <> ", project " <> projectName <> ", user " <> username) do
              let
                expected =
                  [ Print $ "Working on " <> projectName <> ". Command line: goland rescue"
                  , SetHeartbeatUrl $ server <> "/" <> username <> "/workon/" <> projectName
                  , StartProcess [ "goland", "/path/to/my project/" ]
                  ]

                readConfig _ = exampleConfigWithServer server
              parse [ projectName ] username readConfig `shouldEqual` expected

-- TODO: support / at end of config.server

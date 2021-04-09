module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Maybe (Maybe(..))
import Data.Traversable (for_)

data WorkonEffect
  = Print String
  | CreateFile String (Array String)

type Projectname
  = String

instance showWorkonEffect :: Show WorkonEffect where
  show we = case we of
    Print s -> "Print " <> show s
    CreateFile s lines -> "CreateFile " <> show s <> " " <> show lines

derive instance eqWorkonEffect :: Eq WorkonEffect

parse :: Array String -> String -> (Projectname -> Maybe {}) -> Array WorkonEffect
parse [ "--create" ] _ _ = [ Print "Create what? --create by itself makes no sense..." ]

parse [ "--create", projectName ] username readConfig = parse [projectName, "--create"] username readConfig
parse [ projectName, "--create" ] username readConfig =
  case readConfig projectName of
    Nothing -> [ CreateFile
          (projectName <> ".ini")
          [ "[workon]"
          , "cmdline=goland '/path/to the/project'"
          , "server=http://212.47.253.51:8335"
          , "user=" <> username
          ]
      , Print $ "'" <> projectName <> ".ini' created."
      , Print "Open it with your favorite text editor then type"
      , Print $ "   workon " <> projectName
      , Print "again to begin samkoding!"
      ]
    Just _ -> [Print $ "'" <> projectName <> ".ini' already exists, cannot create!"]

parse [ projectName ] _ _ = [ Print $ "Did not find '" <> projectName <> ".ini'. Re-run with flag --create to create a default!" ]

parse _ _ _ = [ Print "Usage: workon <projname>" ]

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] do
        describe "parse" do
          it "prints usage when missing project name" do
            let
              expected = [ Print "Usage: workon <projname>" ]

              cmdLine = []

              user = "olof"

              readConfig _ = Nothing
            parse cmdLine user readConfig `shouldEqual` expected
          for_ ["rescue", "polarbear"] \projectName -> do
              it ("prints error message when config cannot be found for " <> projectName) do
                let
                  expected = [ Print $ "Did not find '" <> projectName <> ".ini'. Re-run with flag --create to create a default!" ]

                  cmdLine = [ projectName ]

                  user = "olof"

                  readConfig _ = Nothing
                parse cmdLine user readConfig `shouldEqual` expected
          it "prints error message when user writes create without project name" do
            let
              expected = [ Print "Create what? --create by itself makes no sense..." ]

              cmdLine = [ "--create" ]

              user = "samuel"

              readConfig _ = Nothing
            parse cmdLine user readConfig `shouldEqual` expected
          for_ ["rescue", "polarbear"] \projectName -> it ("prints error message when user tries to create already existing project " <> projectName) do
            let
              expected = [ Print $ "'" <> projectName <> ".ini' already exists, cannot create!" ]

              cmdLine = [ "--create", projectName ]

              user = "samuel"

              readConfig _ = Just {}
            parse cmdLine user readConfig `shouldEqual` expected
          for_ ["samuel", "tor"] \username -> do
            for_ ["ijpurs", "polarbear"] \projectName -> do
              for_ [true, false] \reverseCmdLine -> do
                  it ("writes correct config file for user " <> username <> " project " <> projectName <> " when create flag is supplied") do
                    let
                      expected =
                        [ CreateFile
                            (projectName <> ".ini")
                            [ "[workon]"
                            , "cmdline=goland '/path/to the/project'"
                            , "server=http://212.47.253.51:8335"
                            , "user=" <> username
                            ]
                        , Print $ "'" <> projectName <> ".ini' created."
                        , Print "Open it with your favorite text editor then type"
                        , Print $ "   workon " <> projectName
                        , Print "again to begin samkoding!"
                        ]

                      cmdLine = if reverseCmdLine then [ projectName, "--create" ] else ["--create", projectName]

                      user = username

                      readConfig _ = Nothing
                    parse cmdLine user readConfig `shouldEqual` expected

pythonUnitTest :: String
pythonUnitTest =
  """
{-
Python unit tests

def config_does_not_exist_reader(path):
    return None


def config_exists_reader(path):
    return {"hejsan": 5}


class TestWorkon(unittest.TestCase):

    def test_create_flag_when_file_exists_prints_error(self):
        expected = [workon.Print("Cannot create rescue.ini: file already exists!")]
        cmd_line = ["rescue", "--create"]
        got = workon.parse(cmd_line, user="olof", read_config=config_exists_reader)
        self.assertEqual(expected, got)

    def test_green_path(self):
        for projname in ["rescue", "polarbear"]:
            for cmdline in ["subl .", "goland"]:

                def read_rescue_ini(path):
                    return {
                        "cmdline": cmdline,
                        "server": "http://212.47.253.51:8335",
                        "user": "olof",
                    }

                expected = [
                    workon.Print(f"Working on {projname}. Command line: {cmdline}"),
                    workon.SetHeartbeatUrl(
                        f"http://212.47.253.51:8335/olof/workon/{projname}"
                    ),
                    workon.StartProcess(cmdline.split()),
                ]
                got = workon.parse([projname], user="olof", read_config=read_rescue_ini)
                self.assertEqual(expected, got)

-}
"""

module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Maybe (Maybe(..))

data WorkonEffect = Print String
type Projectname = String

instance showWorkonEffect :: Show WorkonEffect where
  show we = case we of
    Print s -> "Print " <> show s

derive instance eqWorkonEffect :: Eq WorkonEffect

parse :: Array String -> String -> (Projectname -> Maybe {}) -> Array WorkonEffect
parse [projectName] _ _ = [Print $ "Did not find '" <> projectName <> ".ini'. Re-run with flag --create to create a default!"]
parse _ _ _ = [Print "Usage: workon <projname>"]

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "parse" do
    it "prints usage when missing project name" do
      let
        expected = [Print "Usage: workon <projname>"]
        cmdLine = []
        user = "olof"
        readConfig _ = Nothing
      parse cmdLine user readConfig `shouldEqual` expected
    it "prints error message when config cannot be found for rescue" do
      let
        expected = [Print "Did not find 'rescue.ini'. Re-run with flag --create to create a default!"]
        cmdLine = ["rescue"]
        user = "olof"
        readConfig _ = Nothing
      parse cmdLine user readConfig `shouldEqual` expected
    it "prints error message when config cannot be found for polarbear" do
      let
        expected = [Print "Did not find 'polarbear.ini'. Re-run with flag --create to create a default!"]
        cmdLine = ["polarbear"]
        user = "olof"
        readConfig _ = Nothing
      parse cmdLine user readConfig `shouldEqual` expected

pythonUnitTest :: String
pythonUnitTest = """
{-
Python unit tests

def config_does_not_exist_reader(path):
    return None


def config_exists_reader(path):
    return {"hejsan": 5}


class TestWorkon(unittest.TestCase):

    def test_config_not_found(self):
        for projname in ["rescue", "polarbear"]:
            expected = [
                workon.Print(
                    f"Did not find '{projname}.ini'. Re-run with flag --create to create a default!"
                ),
            ]

            cmd_line = [projname]
            got = workon.parse(
                cmd_line, user="olof", read_config=config_does_not_exist_reader
            )
            self.assertEqual(expected, got)

    def test_creating_default_config(self):
        expected = [
            workon.CreateFile(
                "rescue.ini",
                [
                    "[workon]",
                    "cmdline=goland '/path/to the/project'",
                    "server=http://212.47.253.51:8335",
                    "user=tor",
                ],
            ),
            workon.Print("'rescue.ini' created."),
            workon.Print("Open it with your favorite text editor then type"),
            workon.Print("   python3 workon.py rescue"),
            workon.Print("again to begin samkoding!"),
        ]
        cmd_line = ["rescue", "--create"]
        got = workon.parse(
            cmd_line, user="tor", read_config=config_does_not_exist_reader
        )
        self.assertEqual(expected, got)

    def test_creating_config_for_polarbear(self):
        expected = [
            workon.CreateFile(
                "polarbear.ini",
                [
                    "[workon]",
                    "cmdline=goland '/path/to the/project'",
                    "server=http://212.47.253.51:8335",
                    "user=olof",
                ],
            ),
            workon.Print("'polarbear.ini' created."),
            workon.Print("Open it with your favorite text editor then type"),
            workon.Print("   python3 workon.py polarbear"),
            workon.Print("again to begin samkoding!"),
        ]
        cmd_line = ["polarbear", "--create"]
        got = workon.parse(
            cmd_line, user="olof", read_config=config_does_not_exist_reader
        )
        self.assertEqual(expected, got)

    def test_create_flag_when_file_exists_prints_error(self):
        expected = [workon.Print("Cannot create rescue.ini: file already exists!")]
        cmd_line = ["rescue", "--create"]
        got = workon.parse(cmd_line, user="olof", read_config=config_exists_reader)
        self.assertEqual(expected, got)

    def test_create_flag_but_no_projname_is_error(self):
        expected = [workon.Print("Create what? --create by itself makes no sense...")]
        cmd_line = ["--create"]
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
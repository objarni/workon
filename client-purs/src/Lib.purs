module Lib where

import Prelude
import Data.Maybe


data WorkonEffect
  = Print String
  | CreateFile String (Array String)
  | SetHeartbeatUrl String
  | StartProcess CommandLine

type CommandLine
  = Array String

type User
  = String

type Projectname
  = String

type Config
  = { cmdLine :: Array String, server :: String }

instance showWorkonEffect :: Show WorkonEffect where
  show we = case we of
    Print s -> "\nPrint " <> show s
    CreateFile s lines -> "\nCreateFile " <> show s <> " " <> show lines
    SetHeartbeatUrl s -> "\nSetHeartbeatUrl " <> s
    StartProcess parts -> "\nStartProcess" <> show parts

derive instance eqWorkonEffect :: Eq WorkonEffect

parse :: CommandLine -> User -> (Projectname -> Maybe Config) -> Array WorkonEffect
parse [ "--create" ] _ _ = [ Print "Create what? --create by itself makes no sense..." ]

parse [ "--create", projectName ] username readConfig = parse [ projectName, "--create" ] username readConfig

parse [ projectName, "--create" ] username readConfig = case readConfig projectName of
  Nothing ->
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
  Just _ -> [ Print $ "'" <> projectName <> ".ini' already exists, cannot create!" ]

parse [ projectName ] user readConfig = case readConfig projectName of
  Nothing -> [ Print $ "Did not find '" <> projectName <> ".ini'. Re-run with flag --create to create a default!" ]
  Just config ->
    [ Print $ "Working on " <> projectName <> ". Command line: goland rescue"
    , SetHeartbeatUrl $ config.server <> "/" <> user <> "/workon/" <> projectName
    , StartProcess [ "goland", "/path/to/my project/" ]
    ]

parse _ _ _ = [ Print "Usage: workon <projname>" ]

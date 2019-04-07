module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Console as Console
import Options (Options)
import Options as Options
import Version as Version

app :: Options -> Effect Unit
app options = do
  if options.version
    then Console.log Version.version
    else Console.logShow options

main :: Effect Unit
main = Options.parse >>= app

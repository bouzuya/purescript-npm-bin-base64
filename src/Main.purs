module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Console as Console
import Options (Options)
import Options as Options

app :: Options -> Effect Unit
app options = do
  Console.logShow options

main :: Effect Unit
main = Options.parse >>= app

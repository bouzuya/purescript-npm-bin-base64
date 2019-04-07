module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Console as Console
import Node.Buffer as Buffer
import Node.Encoding as Encoding
import Node.FS.Sync as FS
import Options (Options)
import Options as Options
import Version as Version

readStdin :: Effect String
readStdin = FS.readTextFile Encoding.UTF8 "/dev/stdin"

decode :: String -> Effect String
decode s = do
  b <- Buffer.fromString s Encoding.Base64
  Buffer.toString Encoding.UTF8 b

encode :: String -> Effect String
encode s = do
  b <- Buffer.fromString s Encoding.UTF8
  Buffer.toString Encoding.Base64 b

app :: Options -> Effect Unit
app options = do
  if options.version
    then Console.log Version.version
    else do
      input <- readStdin
      processed <- (if options.decode then decode else encode) input
      Console.log processed

main :: Effect Unit
main = Options.parse >>= app

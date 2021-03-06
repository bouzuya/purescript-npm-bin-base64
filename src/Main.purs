module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Console as Console
import Node.Buffer as Buffer
import Node.Encoding as Encoding
import Node.FS.Sync as FS
import Node.Process as Process
import Node.Stream as Stream
import Options (Options)
import Options as Options
import Version as Version
import Wrap as Wrap

readStdin :: Effect String
readStdin = FS.readTextFile Encoding.UTF8 "/dev/stdin"

writeStdout :: String -> Effect Unit
writeStdout s = do
  b <- Buffer.fromString s Encoding.UTF8
  void (Stream.write Process.stdout b (pure unit))

decode :: String -> Effect String
decode s = do
  b <- Buffer.fromString s Encoding.Base64
  Buffer.toString Encoding.UTF8 b

encode :: String -> Effect String
encode s = do
  b <- Buffer.fromString s Encoding.UTF8
  Buffer.toString Encoding.Base64 b

app :: Options -> Effect Unit
app options
  | options.version = Console.log Version.version
  | otherwise = do
    input <- readStdin
    let unwrapped = Wrap.unwrap input
    processed <- (if options.decode then decode else encode) unwrapped
    let wrapped = Wrap.wrap options.wrap processed
    writeStdout wrapped

main :: Effect Unit
main = Options.parse >>= app

module Main
  ( main
  ) where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef
import Data.Array.ST as STArray
import Data.String as String
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

unwrap :: String -> String
unwrap s = String.joinWith "" (String.split (String.Pattern "\n") s)

wrap :: Int -> String -> String
wrap n s
  | n <= 0 = s
  | otherwise = ST.run do
      tRef <- STRef.new s
      sta <- STArray.empty
      ST.while
        do
          t <- STRef.read tRef
          let { before: line, after: t' } = String.splitAt n t
          void (STArray.push line sta)
          void (STRef.write t' tRef)
          pure (not (String.null t'))
        (pure unit)
      lines <- STArray.unsafeFreeze sta
      pure (String.joinWith "\n" lines)

app :: Options -> Effect Unit
app options
  | options.version = Console.log Version.version
  | otherwise = do
    input <- readStdin
    let unwrapped = unwrap input
    processed <- (if options.decode then decode else encode) unwrapped
    let wrapped = wrap options.wrap processed
    writeStdout wrapped

main :: Effect Unit
main = Options.parse >>= app

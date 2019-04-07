module Options
  ( Options
  , parse
  ) where

import Prelude

import Effect (Effect)
import Options.Applicative ((<**>))
import Options.Applicative as Options

type Options = { decode :: Boolean, version :: Boolean }

parse :: Effect Options
parse = Options.execParser opts
  where
    opts = Options.info (parser <**> Options.helper)
      ( Options.fullDesc
     <> Options.progDesc "encode/decode base64"
     <> Options.header "base64 - base64 encoder" )

parser :: Options.Parser Options
parser =
  ({ decode: _, version: _ })
    <$> Options.switch
        ( Options.long "decode"
        <> Options.help "decode" )
    <*> Options.switch
        ( Options.long "version"
        <> Options.short 'V'
        <> Options.help "Show version" )

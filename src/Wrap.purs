module Wrap
  ( unwrap
  , wrap
  ) where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef
import Data.Array.ST as STArray
import Data.String as String

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

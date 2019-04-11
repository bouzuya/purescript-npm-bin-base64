module Test.Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Test.Unit.Main as TestUnitMain
import Test.Wrap as Wrap

main :: Effect Unit
main = TestUnitMain.runTest do
  Wrap.tests

module Test.Wrap
  ( tests
  ) where

import Prelude

import Test.Unit (TestSuite)
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert
import Wrap as Wrap

tests :: TestSuite
tests = TestUnit.suite "Wrap" do
  TestUnit.test "unwrap" do
    Assert.equal "abcdefghi" (Wrap.unwrap "abc\ndef\nghi")

  TestUnit.test "wrap" do
    Assert.equal "abcdefghi" (Wrap.wrap 0 "abcdefghi")
    Assert.equal "abc\ndef\nghi" (Wrap.wrap 3 "abcdefghi")

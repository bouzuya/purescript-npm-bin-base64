{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "console"
    , "effect"
    , "node-fs"
    , "node-process"
    , "optparse"
    , "psci-support"
    , "test-unit"
    ]
, packages =
    ./packages.dhall
}

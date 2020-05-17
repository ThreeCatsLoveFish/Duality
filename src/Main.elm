module Main exposing (..)

import Playground exposing (game)
import Components.Init exposing (init)
import Components.View exposing (view)
import Components.Update exposing (update)

main =
  game view update init

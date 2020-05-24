module Main exposing (..)

import Browser

import Bin.Initial exposing (..)
import Bin.Types exposing (..)
import Bin.Message exposing (..)
import Bin.Update exposing (..)
import Bin.View exposing (..)


---- PROGRAM ----


main : Program () GameModel Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

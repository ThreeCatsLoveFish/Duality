module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)

import Bin.Initial exposing (..)
import Bin.Types exposing (..)
import Bin.Message exposing (..)
import Bin.Update exposing (..)
import Bin.View exposing (..)


---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.menu == Running then
            onAnimationFrameDelta Tick

          else
            Sub.none
        , onKeyUp (Decode.map (key False) keyCode)
        , onKeyDown (Decode.map (key True) keyCode)
        , onResize Resize
        ] --TODO: change it.

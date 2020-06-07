module Test exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import Json.Decode as Decode
import Html.Events exposing (keyCode)

import Strangers1.Strangers1 as Strangers1
import Messages exposing (..)
import Model exposing (Model)
import TestUpdate

main : Program () Model Msg
main =
    -- TODO: Change for test
    Browser.element
        { init = \_ -> Strangers1.init
        , view = Strangers1.visualizeStrangers1
        , update = TestUpdate.update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ case model.gameStatus of
            Running _ ->
                onAnimationFrameDelta Tick
            _ ->
                Sub.none
        , onKeyUp (Decode.map keyUp keyCode)
        , onKeyDown (Decode.map keyDown keyCode)
        --, onResize Resize
        ]

keyUp : Int -> Msg
keyUp keycode =
    case keycode of
        37 ->
            RunGame Stay
        39 ->
            RunGame Stay
        32 ->
            NoOp
        _ ->
            NoOp

keyDown : Int -> Msg
keyDown keycode =
    case keycode of
        37 ->
            RunGame Left
        39 ->
            RunGame Right
        32 ->
            ShowStatus Paused
        82 ->
            ShowStatus Prepare
        _ ->
            NoOp

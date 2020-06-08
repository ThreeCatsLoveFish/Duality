module Subscriptions exposing (..)

import Model exposing (..)
import Messages exposing (..)

import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import Json.Decode as Decode
import Html.Events exposing (keyCode)
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
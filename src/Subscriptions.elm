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
            ChangeLevel ->
                onAnimationFrameDelta Tick
            AnimationPass ->
                onAnimationFrameDelta Tick
            Pass ->
                onAnimationFrameDelta Tick
            _ ->
                Sub.none
        , onKeyUp (Decode.map keyUp keyCode)
        , onKeyDown (Decode.map keyDown keyCode)
        , onResize Resize
        ]


keyUp : Int -> Msg
keyUp keycode =
    case keycode of
        37 ->
            KeyUp Key_Left
        39 ->
            KeyUp Key_Right
        32 ->
            NoOp
        _ ->
            NoOp

keyDown : Int -> Msg
keyDown keycode =
    case keycode of
        37 ->
            KeyDown Key_Left
        39 ->
            KeyDown Key_Right
        32 ->
            KeyDown Space
        82 ->
            KeyDown Key_R
        _ ->
            NoOp

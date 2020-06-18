module Subscriptions exposing (..)

import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import Json.Decode as Decode
import Html.Events exposing (keyCode)

import Model exposing (..)
import Messages exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ case model.gameStatus of
            Running _ ->
                onAnimationFrameDelta Tick
            ChangeLevel ->
                onAnimationFrameDelta Tick
            AnimationPrepare ->
                onAnimationFrameDelta Tick
            AnimationPreparePost ->
                onAnimationFrameDelta Tick
            AnimationPass ->
                onAnimationFrameDelta Tick
            Pass ->
                onAnimationFrameDelta Tick
            AnimationEnd ->
                onAnimationFrameDelta Tick
            _ ->
                Sub.none
        , onKeyUp (Decode.map keyUp keyCode)
        , onKeyDown (Decode.map keyDown keyCode)
        , onResize Resize
        ]


keyUp : Int -> Msg
keyUp key_code =
    case key_code of
        37 ->
            KeyUp Key_Left
        39 ->
            KeyUp Key_Right
        _ ->
            NoOp


keyDown : Int -> Msg
keyDown key_code =
    case key_code of
        37 ->
            KeyDown Key_Left
        39 ->
            KeyDown Key_Right
        32 ->
            KeyDown Space
        68 ->
            KeyDown Key_D -- debug
        71 ->
            KeyDown Key_G -- god
        82 ->
            KeyDown Key_R -- restart
        83 ->
            KeyDown Key_S -- skip
        _ ->
            NoOp

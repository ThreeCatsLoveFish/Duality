module Bin.Strangers exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)

import Bin.Initial
import Bin.Message exposing (..)
import Bin.Types exposing (Model)
import Bin.Update
import Bin.View
import Json.Decode as Decode
import Html.Events exposing (keyCode)
--import Html exposing (Html, Attribute, button, div, h1, input, text)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onInput, onClick)
--import Debug exposing (..)
--import Svg
--import Svg.Attributes as SA
--import Random

main : Program () Model Msg
main =
  Browser.element
        { init = \_ -> Bin.Initial.init
        , view = Bin.View.view
        , update = Bin.Update.update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.menu == Running then
            onAnimationFrameDelta Tick
          else
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
            ShowMenu Paused
        82 ->
            ShowMenu Startup
        _ ->
            NoOp

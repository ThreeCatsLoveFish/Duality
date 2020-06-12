module Start0.View exposing (..)

import Html exposing (Html, Attribute, div, img)
import Html.Attributes exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import Bezier exposing (bezierFade)

backgroundColor : Color
backgroundColor = rgb 0 0 0

--pixelWidth : Float
--pixelWidth = 834
--
--pixelHeight : Float
--pixelHeight = 834
---

visualize : Model -> Html Msg
visualize model =
    --let
    --    ( w, h ) =
    --        model.size
    --
    --    r =
    --        if w / h > pixelWidth / pixelHeight then
    --            Basics.min 1 (h / pixelHeight)
    --        else
    --            Basics.min 1 (w / pixelWidth)
    --in
    div
        [ align "center"
        , style "width" "100%"
        , style "height" "100%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" (colorToString backgroundColor)
        ]
        [ img [ src "icon.png"
              , style "width" "50%"
              , style "position" "relative"
              , style "opacity" (String.fromFloat (bezierFade 0 0 1.8 1.8 (getState model.state "fadeInAndOut").t))
              --, style "left" (String.fromFloat ((w - pixelHeight * r) / 2) ++ "px")
              --, style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
              , alt "Network Failure"
              ]
              []
        ]


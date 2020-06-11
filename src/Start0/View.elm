module Start0.View exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text, img)
import Html.Attributes exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)

backgroundColor : Color
backgroundColor = rgb 0 0 0

pixelWidth : Float
pixelWidth =
    834

pixelHeight : Float
pixelHeight =
    834
---

visualize : Model -> Html Msg
visualize model =
    let
        ( w, h ) =
            model.size

        r =
            if w / h > pixelWidth / pixelHeight then
                Basics.min 1 (h / pixelHeight)
            else
                Basics.min 1 (w / pixelWidth)
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" (colorToString backgroundColor)
        ]
        [ img [ src "icon.png"
              , width 834
              , height 834
              , style "position" "relative"
              , style "left" (String.fromFloat ((w - pixelHeight * r) / 2) ++ "px")
              , style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
              , style "opacity" (String.fromFloat (genFadeInAndOut (getState model.state "fadeInAndOut").t))
              , alt "Network Failure"
              ]
              []
        ]

genFadeInAndOut : Float -> Float
genFadeInAndOut t =
        if  ( t < 0.3 ) then
            t / 0.3
        else if ( t >= 0.3 && t <= 0.7 ) then
            1
        else
            ( 1.0 - t ) / 0.3

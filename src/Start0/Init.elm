module Start0.Init exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, style)

import Html.Events exposing (onClick)
import Model exposing (..)
import Messages exposing (..)
import BasicView exposing (..)

init : ( Model, Cmd Msg )
init =
    ( Model Start0 Animation
        [] [] []
        []
        {w=0,h=0} (pixelWidth, pixelHeight) 0 True False
        visualize
    , Cmd.none
    )

visualize : Html Msg
visualize =
    let
        ( w, h ) =
            (pixelWidth, pixelHeight)

        r =
            if w / h > pixelWidth / pixelHeight then
                min 1 (h / pixelHeight)

            else
                min 1 (w / pixelWidth)
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        ]
        [ div
            [ style "width" (String.fromFloat pixelWidth ++ "px")
            , style "height" (String.fromFloat pixelHeight ++ "px")
            , style "position" "absolute"
            , style "left" (String.fromFloat ((w - pixelWidth * r) / 2) ++ "px")
            , style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
            , style "transform-origin" "0 0"
            , style "transform" ("scale(" ++ String.fromFloat r ++ ")")
            ]
            [ button
                [ style "width" (String.fromFloat pixelWidth ++ "px")
                , style "height" (String.fromFloat pixelHeight ++ "px")
                , style "position" "absolute"
                , style "left" (String.fromFloat ((w - pixelWidth * r) / 2) ++ "px")
                , style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
                , style "transform-origin" "0 0"
                , style "transform" ("scale(" ++ String.fromFloat r ++ ")")
                , onClick (KeyDown Space)
                ]
                [ text "Press space to continue" ]
            ]
        ]

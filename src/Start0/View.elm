module Start0.View exposing (..)

import Html exposing (Attribute, Html, button, div, img, p, text)
import Html.Attributes exposing (..)

import Html.Events exposing (onClick)
import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)

backgroundColor : Color
backgroundColor = rgb 0 0 0


visualize : Model -> Html Msg
visualize model =
    let
        ( w, h ) =
            model.size

        r =
            if w / h > 1 then
                Basics.min 1 (h / len)
            else
                Basics.min 1 (w / len)
        len = 700 -- This is the length of the logo, was 834
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
              , width len
              , height len
              , style "position" "relative"
              , style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
              , style "left" (String.fromFloat ((w - len * r) / 2 ) ++ "px")
              , style "opacity" (String.fromFloat (genFadeInAndOut (getState model.state "fadeInAndOut").t))
              , alt "Network Failure"
              ]
              []
        , if model.gameStatus == Paused || model.gameStatus == AnimationPreparePost
            then visualizeHelp model
            else visualizeMenu model
        ]


genFadeInAndOut : Float -> Float
genFadeInAndOut t =
        if  ( t < 0.3 ) then
            t / 0.3
        else if ( t >= 0.3 && t <= 0.7 ) then
            1
        else
            ( 1.0 - t ) / 0.3


visualizeMenu : Model -> Html Msg
visualizeMenu model =
    let
        alpha =
            case model.gameStatus of
                AnimationPrepare ->
                    if List.isEmpty model.state then
                        1
                    else
                        (getState model.state "fadeIn").t
                Prepare ->
                    1
                _ -> 0
    in
    div
        [ style "background" (colorToString backgroundColor)
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "High Tower Text, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "opacity" (String.fromFloat alpha)
        , style "display"
            (if model.gameStatus == AnimationPrepare || model.gameStatus == Prepare || model.gameStatus == AnimationPreparePost then
                "block"
             else
                "none"
            )
        ]
        [ p
            [ style "position" "absolute"
            , style "top" "55%"
            , style "width" "100%"
            , style "text-align" "center"
            , style "font-size" "24px"
            , style "color" "#FFFFFF"
            , align "center"
            ]
            [ text "Menu" ]
        , button
            [ style "position" "absolute"
            , style "outline" "none"
            , style "left" "48.2%"
            , style "top" "75%"
            , style "text-align" "center"
            , style "font-size" "24px"
            , style "border" "1px solid #000000"
            , style "color" "#b7e5d9"
            , style "background" (colorToString backgroundColor)
            , onClick (ShowStatus Paused)
            ]
            [ text "Help" ]
        , p
            [ style "position" "absolute"
            , style "top" "90%"
            , style "width" "100%"
            , style "text-align" "center"
            , style "font-size" "18px"
            , style "color" "#b7e5d9"
            , align "center"
            ]
            [ text "Cattubene" ]
        , button
            [ style "position" "absolute"
            , style "left" "45.6%"
            , style "outline" "none"
            , style "top" "30%"
            , style "text-align" "center"
            , style "font-size" "48px"
            , style "background" (colorToString backgroundColor)
            , style "border" "1px solid #000000"
            , style "color" "#b7e5d9"
            , onClick (ChooseLevel Strangers1)
            ]
            [ text "Duality" ]
        ]


visualizeHelp : Model -> Html Msg
visualizeHelp model =
    let
        alpha =
            case model.gameStatus of
                Paused ->
                    1
                AnimationPreparePost ->
                    (1 - (getState model.state "fadeOut").t)
                _ -> 0
    in
    div
        [ style "background" (colorToString backgroundColor)
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "High Tower Text, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "opacity" (String.fromFloat alpha)
        , style "display"
            (if model.gameStatus == Paused then
                "block"
             else
                "none"
            )
        ]
        [ p
            [ style "position" "absolute"
            , style "top" "55%"
            , style "width" "100%"
            , style "text-align" "center"
            , style "font-size" "24px"
            , style "color" "#FFFFFF"
            , align "center"
            ] -- TODO: Text of document
            [ text "Menu" ]
        , p
            [ style "position" "absolute"
            , style "top" "90%"
            , style "width" "100%"
            , style "text-align" "center"
            , style "font-size" "18px"
            , style "color" "#b7e5d9"
            , align "center"
            ]
            [ text "Cattubene" ]
        , button
            [ style "position" "absolute"
            , style "left" "45.6%"
            , style "outline" "none"
            , style "top" "30%"
            , style "text-align" "center"
            , style "font-size" "48px"
            , style "background" (colorToString backgroundColor)
            , style "border" "1px solid #000000"
            , style "color" "#b7e5d9"
            ]
            [ text "Duality" ]
        ]

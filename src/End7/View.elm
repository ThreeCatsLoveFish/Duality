module End7.View exposing (..)

import Html exposing (Attribute, Html, audio, div, img, p, text)
import Html.Attributes exposing (..)

import Markdown
import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)

backgroundColor : Color
backgroundColor = rgb 0 0 0

--pixelWidth : Float
--pixelWidth =
--    834
--
--pixelHeight : Float
--pixelHeight =
--    834
---

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
        len = 500 -- This is the length of the logo, was 834
        t = if List.isEmpty model.state then 1 else (getState model.state "tMapTop").t
        t_ = if List.isEmpty model.state then 1 else (getState model.state "fade").t
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" (colorToString backgroundColor)
        , style "font-family" "High Tower Text, sans-serif"
        ]
        (
            (subtitle model) ++
            [ img
                [ src "icon.png"
                , width len
                , height len
                , style "position" "fixed"
                , style "left" (String.fromFloat ((w - len * r) / 2) ++ "px")
                , style "top" (String.fromFloat (tMapTop t 160)  ++ "%")
                --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
                , alt "Network Failure"
                ]
                []
            , div
                [ style "width" "100%"
                , style "Height" "40%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "35%"
                --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
                , style "text-align" "center"
                , style "font-size" "36px"
                , style "font-family" "High Tower Text, sans-serif"
                , style "color" "#FFFFFF"
                , style "opacity" (String.fromFloat (tMapFade t_) )
                ]
                [ p [] [text "Thank you for playing!"]
                , p
                    [ style "font-size" "22px"
                    ]
                    [text "Press Space to restart."]
                ]
            ] ++
            [ audio
                [ src "End - The Blowers Daughter (Instrumental).mp3"
                , id "audio7"
                , autoplay True
                , preload "True"
                --, loop True
                , loop True
                ]
                []
            ]
        )

tMapTop : Float -> Float -> Float
tMapTop t posAdjust =
    let
        per = 170
    in
    (0.32 - t) * 2 * per + posAdjust

tMapFade : Float -> Float
tMapFade t =
    if t < 0 then 0
    else if t < 0.1 then t / 0.1
    else if t < 0.2 then 1
    --else if t < 0.4 then (0.3 - t) / 0.1
    else 1

subtitle : Model -> List (Html Msg)
subtitle model =
    let
        t = if List.isEmpty model.state then 1 else (getState model.state "tMapTop").t
    in
    [ p
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 0)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "font-size" "72px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ text "Duality" ]
    , p
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 20)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "font-size" "36px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ text (String.toUpper "Staff") ]
    , div
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 30)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "line-height" "6px"
        , style "font-size" "28px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ p [] [text "Jiang Yuchen"]
        , p [] [text "Tang Rundong"]
        , p [] [text "Sun Zhimin"]
        , p [] [text "Zhou Yuchen"]
        ]
    , p
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 50)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "font-size" "36px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ text "MUSIC" ]
        , div
        [ style "font-family" "High Tower Text, sans-serif"
        , style "line-height" "6px"
        , style "font-size" "24px"
        , style "color" "#FFFFFF"
        ]
        [ p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 62)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "For River"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 62)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 66)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Paper Airplane"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 66)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 70)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Take Me Anywhere"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 70)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 74)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Bata-B"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 74)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 78)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Blower’s Daughter"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 78)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Damien Rice"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 82)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Having Lived"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 82)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 86)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "November"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 86)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Endless Melancholy"]
        , p
            [ style "text-align" "left"
            , style "position" "fixed"
            , style "top" (String.fromFloat (tMapTop t 90)  ++ "%")
            , style "left" "35%"
            , style "width" "20%"
            ]
            [text "Too Bad So Sad"]
        , p
            [ style "text-align" "right"
            , style "top" (String.fromFloat (tMapTop t 90)  ++ "%")
            , style "position" "fixed"
            , style "right" "35%"
            , style "width" "20%"
            ]
            [text "Kan R. Gao"]
        ]
        --[ Markdown.toHtml [] "For River              Kan R. Gao"
        --, Markdown.toHtml [] "Paper Airplane         Kan R. Gao"
        --, Markdown.toHtml [] "Take Me Anywhere       Kan R. Gao"
        --, Markdown.toHtml [] "Bata-B                 Kan R. Gao"
        --, Markdown.toHtml [] "Blower’s Daughter     Damien Rice"
        --, Markdown.toHtml [] "Having Lived           Kan R. Gao"
        --, Markdown.toHtml [] "November       Endless Melancholy"
        --, Markdown.toHtml [] "Too Bad So Sad         Kan R. Gao"
        --]

    , p
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 98)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "font-size" "36px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ text "FONT" ]
    , div
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 110)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "line-height" "6px"
        , style "font-size" "28px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ p [] [text "High Tower Text"]
        , p [] [text "Copperplate Gothic Light"]
        ]
    , p
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 124)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "font-size" "36px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ text "Special Thanks for" ]
    , div
        [ style "width" "100%"
        , style "Height" "40%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" (String.fromFloat (tMapTop t 136)  ++ "%")
        --, style "top" (String.fromFloat ((h - len * r) / 2) ++ "px")
        , style "text-align" "center"
        , style "line-height" "6px"
        , style "font-size" "28px"
        , style "font-family" "High Tower Text, sans-serif"
        , style "color" "#FFFFFF"
        ]
        [ p [] [text "William Shakespeare"]
        , p [] [text "Edgar Allan Poe"]
        , p [] [text "Manuel Charlem"]
        , p [] [text "Michele M. Campbell"]
        , p [] [text "Pan Yu"]
        ]
    ]

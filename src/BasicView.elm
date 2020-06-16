module BasicView exposing (..)

import Html.Events exposing (onClick)
import Model exposing (..)
import Tools exposing (..)

import Html exposing (Attribute, Html, button, div, h1, input, p, text)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Svg
import Svg.Attributes as SA


visualizePrepare : Model -> Color -> Html Msg
visualizePrepare model bColor =
    let
        txt =
            case model.gameLevel of
                Strangers1 -> "Strangers"
                Friends2 -> "Friends"
                Lovers3 -> "Lovers"
                Strangers4 -> "Strangers"
                Companions5 -> "Companions"
                Death6 -> "Death"
                _ -> ""
    in
    div
        [ style "background" (colorToString bColor)
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        --, style "line-height" "500px"
        , style "opacity" (String.fromFloat (getState model.state "fadeInAndOut").value)
        , style "display"
            (if model.gameStatus == AnimationPrepare then
                "block"
             else
                "none"
            )
        ]
        [ div
            [
              style "text-align" "center"
            --, style "display" "table-cell"
            --, style "vertical" "bottom"
            --, style "horizontal" "center"
            ]
            [ p
                [ style "position" "absolute"
                , style "top" "55%"
                , style "width" "100%"
                , style "text-align" "center"
                , style "font-size" "24px"
                ]
                [ text "Press space to start" ]
            , p
                [ style "position" "absolute"
                , style "top" "30%"
                , style "width" "100%"
                , style "text-align" "center"
                , style "font-size" "48px"
                ]
                [ text txt ]

            ]
        ]


visualizeBlock : Model -> Html Msg
visualizeBlock model =
    let
        (status, description) =
            case model.gameStatus of
                Paused ->
                    ( "Paused", "Press Space to continue" )
                Lose ->
                    ( "...The ball of life has dropped...", "Press R to revisit" )
                _ -> ("","")
        alpha =
            case model.gameStatus of
                Paused ->
                    "0.7"
                Lose ->
                    "1"
                _ -> "0"
    in
    div
        [ style "background" (colorToString (rgb 40 40 40))
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        --, style "line-height" "500px"
        , style "opacity" alpha
        , style "display"
            (   if model.gameStatus == Paused then
                    "inline"
                else
                    "none"
            )
        ]
        [ p -- Description / Instruction
            [ style "width" "100%"
            , style "position" "absolute"
            , style "left" "0"
            , style "top" "55%"
            , style "font-size" "20px"
            , style "color" "#AAAAAA"
            ]
            [text description]
        , p -- Title
            [ style "width" "100%"
            , style "position" "absolute"
            , style "left" "0"
            , style "top" "30%"
            , style "font-size" "40px"
            , style "color" "#FFFFFF"
            ]
            [text status]
        ]


visualizeMenu : Model -> Html Msg
visualizeMenu model =
    let
        back_color = rgb 0 0 0
        button_color = rgb 213 210 23
        level =
            case model.gameLevel of
                Start0 -> 0
                Strangers1 -> 1
                Friends2 -> 2
                Lovers3 -> 3
                Strangers4 -> 4
                Companions5 -> 5
                Death6 -> 6
                _ -> 7
    in
    div
        [ style "background" (colorToString back_color)
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "opacity" (String.fromFloat (getState model.state "fadeInAndOut").value)
        ]
        [ div
            [
              style "text-align" "center"
            ]
            [ p
                [ style "position" "absolute"
                , style "top" "25%"
                , style "width" "100%"
                , style "text-align" "center"
                , style "font-size" "48px"
                ]
                [ text "Stranger" ]
            , button
                [ style "top" "35%"
                , style "left" "40%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Start0
                , disabled (level < 1) ]
                [ text "Start" ]
            , button
                [ style "top" "35%"
                , style "left" "60%"
                , style "font-size" "28px"
                , style "color" (colorToString button_color)
                , onClick Strangers1
                , disabled (level < 1) ]
                [ text "Strangers" ]
            , button
                [ style "top" "45%"
                , style "left" "40%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Friends2
                , disabled (level < 2) ]
                [ text "Friends" ]
            , button
                [ style "top" "45%"
                , style "left" "60%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Lovers3
                , disabled (level < 3) ]
                [ text "Lovers" ]
            , button
                [ style "top" "55%"
                , style "left" "40%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Strangers4
                , disabled (level < 4) ]
                [ text "Strangers II" ]
            , button
                [ style "top" "55%"
                , style "left" "60%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Companions5
                , disabled (level < 5) ]
                [ text "Companions" ]
            , button
                [ style "top" "65%"
                , style "left" "40%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick Death6
                , disabled (level < 6) ]
                [ text "Death" ]
            , button
                [ style "top" "65%"
                , style "left" "60%"
                , style "color" (colorToString button_color)
                , style "font-size" "28px"
                , onClick End7
                , disabled (level < 6) ]
                [ text "Ending" ]
            ]
        ]


--visualizePass : Model -> Html Msg
--visualizePass model =
--    div
--        [ style "background" "rgba(244, 244, 244, 0.85)"
--        , style "text-align" "center"
--        , style "height" ((String.fromFloat model.canvas.h)++"px")
--        , style "width" ((String.fromFloat model.canvas.w)++"px")
--        , style "position" "absolute"
--        , style "left" "0"
--        , style "top" "0"
--        , style "font-family" "Helvetica, Arial, sans-serif"
--        , style "font-size" "48px"
--        , style "color" "#F43344"
--        , style "line-height" "500px"
--        , style "display"
--            (if model.gameStatus == Pass then
--                "block"
--             else
--                "none"
--            )
--        ]
--        [text "You win! "]

--visualizeLose : Model -> Html Msg
--visualizeLose model =
--    div
--        [ style "background" "rgba(244, 244, 244, 0.85)"
--        , style "text-align" "center"
--        , style "height" ((String.fromFloat model.canvas.h)++"px")
--        , style "width" ((String.fromFloat model.canvas.w)++"px")
--        , style "position" "absolute"
--        , style "left" "0"
--        , style "top" "0"
--        , style "font-family" "Helvetica, Arial, sans-serif"
--        , style "font-size" "48px"
--        , style "color" "#111111"
--        , style "line-height" "500px"
--        , style "display"
--            (if model.gameStatus == Lose then
--                "block"
--             else
--                "none"
--            )
--        ]
--        [text "You lose! "]


--view : Model -> Html Msg
--view model =
--    let
--        alpha = case model.gameStatus of
--            Running _ ->
--                "1"
--            _ ->
--                "0.3"
--    in
--    div
--        [ style "width" "250px"
--        , style "height" "625px"
--        , style "position" "absolute"
--        , style "left" "0"
--        , style "top" "0"
--        ]
--        [ visualizeGame model alpha
--        , div
--            [ style "background-color" "#F4F4F4"
--            , style "background-position" "center"
--            ]
--            [ visualizePrepare model
--            , visualizePause model
--            , visualizeWin model
--            , visualizeLose model
--            ]
--        ]


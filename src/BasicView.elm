module BasicView exposing (..)

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
        , style "opacity" (String.fromFloat 0.7)
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


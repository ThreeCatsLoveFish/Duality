module Strangers1.ViewTest exposing (..)

import Model exposing (..)
import InitTools exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Svg
import Svg.Attributes as SA



visualizeBall : Ball -> Color -> Svg.Svg Msg
visualizeBall ball color =
    Svg.circle
        [ SA.cx (String.fromFloat ball.pos.x)
        , SA.cy (String.fromFloat ball.pos.y)
        , SA.r (String.fromFloat ball.r)
        , SA.fill (colorToString color) ]
        []

visualizeBrick : Brick -> Svg.Svg Msg
visualizeBrick brick=
    Svg.polygon
        [ SA.points (polyToString brick.collision)
        , SA.fill (colorToString (brick.color))
        ]
        []


{-
visualizeBricks : List Brick -> List (Svg.Svg Msg) -> List (Svg.Svg Msg)
visualizeBricks bricks svgBricks=
    let
        newSvgBricks =
            List.map visualizeBrick bricks
    in
        if List.isEmpty svgBricks then
-}


visualizePaddle : Paddle -> Color -> Html Msg
visualizePaddle paddle color =
    Svg.svg
        [ SA.version "1.1"
        , SA.x "0"
        , SA.y "0"
        , SA.viewBox "0 0 800 600"
        ]
    [ Svg.polygon
        [ SA.points (polyToString paddle.collision)
        , SA.fill (colorToString color)
        ]
        []
    ]

-- dummy for clear coding
visualizeGame : Model -> String -> Html Msg
visualizeGame model opacity =
    let
        elements =
            (List.map visualizeBrick model.bricks) ++ [visualizeBall (getBall model.ball 1) (rgb 33 134 233) ]
              |> (::) (visualizePaddle (getPaddle model.paddle 1) (rgb 0 88 99))
    in
        div
            [ style "width" "600px"
            , style "height" "800px"
            , style "position" "absolute"
            , style "left" "0"
            , style "top" "0"
            , style "opacity" opacity
            ]
            [ Svg.svg
                [ SA.version "1.1"
                , SA.x "0"
                , SA.y "0"
                , SA.viewBox "0 0 800 600"
                ]
                elements
            ]

visualizePrepare : Model -> Html Msg
visualizePrepare model =
    div
        [ style "background" "rgba(244, 244, 244, 0.85)"
        , style "text-align" "center"
        , style "height" "800px"
        , style "width" "600px"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#77C0C5"
        , style "line-height" "500px"
        , style "display"
            (if model.gameStatus == Prepare then
                "block"
             else
                "none"
            )
        ]
        [text "Press space to start. "]

visualizePause : Model -> Html Msg
visualizePause model =
    div
        [ style "background" "rgba(244, 244, 244, 0.85)"
        , style "text-align" "center"
        , style "height" "800px"
        , style "width" "600px"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#77C0C5"
        , style "line-height" "500px"
        , style "display"
            (if model.gameStatus == Paused then
                "block"
             else
                "none"
            )
        ]
        [text "Paused"]

visualizeWin : Model -> Html Msg
visualizeWin model =
    div
        [ style "background" "rgba(244, 244, 244, 0.85)"
        , style "text-align" "center"
        , style "height" "800px"
        , style "width" "600px"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#F43344"
        , style "line-height" "500px"
        , style "display"
            (if model.gameStatus == Pass then
                "block"
             else
                "none"
            )
        ]
        [text "You win! "]

visualizeLose : Model -> Html Msg
visualizeLose model =
    div
        [ style "background" "rgba(244, 244, 244, 0.85)"
        , style "text-align" "center"
        , style "height" "800px"
        , style "width" "600px"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#111111"
        , style "line-height" "500px"
        , style "display"
            (if model.gameStatus == Lose then
                "block"
             else
                "none"
            )
        ]
        [text "You lose! "]

view : Model -> Html Msg
view model =
    let
        alpha = case model.gameStatus of
            Running _ ->
                "1"
            _ ->
                "0.3"
    in
    div
        [ style "width" "600px"
        , style "height" "800px"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        ]
        [ visualizeGame model alpha
        , div
            [ style "background-color" "#F4F4F4"
            , style "background-position" "center"
            ]
            [ visualizePrepare model
            , visualizePause model
            , visualizeWin model
            , visualizeLose model
            ]
        ]


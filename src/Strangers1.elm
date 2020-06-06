module Strangers1 exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)
import Html.Attributes exposing (..)
import Svg
import Svg.Attributes as SA

import Model exposing (..)
import Messages exposing (..)

backgroundColor : Color
backgroundColor = rgb 0 0 0

visualizeBall : Ball -> Svg.Svg Msg
visualizeBall ball =
    Svg.g []
        [ Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat (ball.r * 2.5))
            , SA.fill (colorToString ball.color)
            , SA.filter "url(#glow)"
            ]
            []
        , Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat ball.r)
            , SA.fill (colorToString ball.color)
            ]
            []
        ]

visualizePaddle : Paddle -> Html Msg
visualizePaddle paddle =
    Svg.g []
        [ Svg.circle
            [ SA.cx (String.fromFloat paddle.center.x)
            , SA.cy (String.fromFloat paddle.center.y)
            , SA.r (String.fromFloat (paddle.r + 7.5))
            , SA.fill (colorToString paddle.color)
            ]
            []
        , Svg.circle
            [ SA.cx (String.fromFloat paddle.center.x)
            , SA.cy (String.fromFloat paddle.center.y)
            , SA.r (String.fromFloat paddle.r)
            , SA.fill (colorToString backgroundColor)
            ]
            []
        , Svg.polygon
            [ SA.points (polyToString (posToPoly paddle.r (1.7*paddle.r) paddle.center))
            , SA.color (colorToString backgroundColor)
            ]
            []
        ]

visualizeBrick : Brick -> Svg.Svg Msg
visualizeBrick brick=
    Svg.polygon
        [ SA.points (polyToString brick.collision)
        , SA.fill (colorToString (changeBrickColor brick))
        ]
        []

changeBrickColor : Brick -> Color
changeBrickColor brick =
    case brick.hitTime of
        Hit 0 ->
            brick.color
        _ ->
            backgroundColor

visualizeGame : Model -> String -> Html Msg
visualizeGame model opacity =
    let
        elements =
            (List.map visualizeBrick model.bricks) ++ [visualizeBall (Maybe.withDefault dummyBall (List.head model.ball))] ++ [visualizeBall (Maybe.withDefault dummyBall (List.tail model.ball))]
              |> (::) (visualizePaddle (Maybe.withDefault dummyPaddle (List.head model.paddle)))
    in
        div
            [ style "opacity" opacity
            ]
            [ Svg.svg
                [ SA.version "1.1"
                , SA.x "0"
                , SA.y "0"
                , SA.viewBox "0 0 800 600"
                ]
                elements
            ]


visualizeStrangers1 : Model -> Html Msg
visualizeStrangers1 model =
    let
        alpha = case model.gameStatus of
            Running ->
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
            [ style "background-color" (colorToString backgroundColor)
            , style "background-position" "center"
            ]
            [ visualizeStartup model
            , visualizePause model
            , visualizeWin model
            , visualizeLose model
            ]
        ]




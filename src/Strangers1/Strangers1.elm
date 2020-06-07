module Strangers1.Strangers1 exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)
import Html.Attributes exposing (..)
import Svg
import Svg.Attributes as SA

import Model exposing (..)
import Messages exposing (..)
import InitTools exposing (..)
import Strangers1.ViewTest as ViewTest

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 250, h = 625 }
        ball : Ball
        ball =
            let
                pos =
                    Point
                        (canvas.w/2)
                        (paddle.pos.y - paddle.r - paddle.h - r/2)
                v = Point 5.0 -5.0
                r = 10
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = getBallColl (pos, r, 16)
            , color = rgb 244 244 244
            }
        --TODO: paddle fix
        paddle : Paddle
        paddle =
            let
                r = 15
                h = 3
                angle = 60 * pi / 180
                pos = Point (canvas.w/2) (canvas.h - r + r * cos angle)
                center = Point pos.x (pos.y + r)
            in
            { pos = pos -- may not be necessary
            , collision = getPaddleColl pos r h angle 16 -- for hitCheck
            , block = dummyBlock
            , color = rgb 255 255 255
            , r = r
            , h = h
            , angle = angle
            }

    in
    ( Model Strangers1 Prepare
        [ball] [paddle] []
        canvas 0
        (div [] [])
    , Cmd.none
    )


--- View ---


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
            [ SA.cx (String.fromFloat paddle.pos.x)
            , SA.cy (String.fromFloat paddle.pos.y)
            , SA.r (String.fromFloat (paddle.r + paddle.h))
            , SA.fill (colorToString paddle.color)
            ]
            []
        , Svg.circle
            [ SA.cx (String.fromFloat paddle.pos.x)
            , SA.cy (String.fromFloat paddle.pos.y)
            , SA.r (String.fromFloat paddle.r)
            , SA.fill (colorToString backgroundColor)
            ]
            []
        , Svg.polygon
            [ SA.points (polyToString (posToPoly (2 * (paddle.r + paddle.h + 1)) (2 * paddle.r * cos paddle.angle) paddle.pos))
            , SA.fill (colorToString backgroundColor)
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
            (List.map visualizeBrick model.bricks) ++ [visualizeBall (Maybe.withDefault dummyBall (List.head model.ball))] ++ (List.map visualizeBall (Maybe.withDefault [dummyBall] (List.tail model.ball)))
              |> (::) (visualizePaddle (Maybe.withDefault dummyPaddle (List.head model.paddle)))
    in
        div
            [ style "opacity" opacity
            ]
            [ Svg.svg
                [ SA.version "1.1"
                , SA.x "0"
                , SA.y "0"
                , SA.viewBox ("0 0 " ++ (String.fromFloat model.canvas.w) ++ " " ++ (String.fromFloat model.canvas.h))
                ]
                elements
            ]


visualizeStrangers1 : Model -> Html Msg
visualizeStrangers1 model =
    let
        alpha = case model.gameStatus of
            Running _ ->
                "1"
            _ ->
                "0.3"
    in
    div
        [ style "width" (String.fromFloat model.canvas.w++"px")
        , style "height" (String.fromFloat model.canvas.h++"px")
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" (colorToString backgroundColor)
        ]
        [ visualizeGame model alpha
        --, div
        --    [ style "background-color" (colorToString backgroundColor)
        --    , style "background-position" "center"
        --    ]
        --    [ ViewTest.visualizePrepare model
        --    , ViewTest.visualizePause model
        --    , ViewTest.visualizeWin model
        --    , ViewTest.visualizeLose model
        --    ]
        ]



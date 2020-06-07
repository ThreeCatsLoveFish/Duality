module Strangers1 exposing (..)

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
        canvas = { w = 400, h = 500 }
        ball : Ball
        ball =
            let
                pos =
                    Point
                        (canvas.w/2)
                        (paddle.pos.y - paddle.r - paddle.h - r)
                v = Point 3.0 -3.0
                r = 10
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = getBallColl (pos, r, 16)
            , color = rgb 244 244 244
            }
        ball2 : Ball
        ball2 =
            let
                pos =
                    Point
                        (canvas.w/2)
                        (canvas.h/4)
                v = Point 0 0
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
                r = 60
                h = 3
                angle = 40 * pi / 180
                pos = Point (canvas.w/2) (canvas.h + r * cos angle - 5 - r)
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
        bricks : List Brick
        bricks =
            let
                brickInfo =
                    { layout = {x=10, y=2}
                    , canvas = canvas
                    , brick = {w=39, h=39}
                    , breath = 1
                    , offset = dummyPoint
                    , color = rgb 100 100 100
                    --, color = rgb 233 233 233
                    }
            in
            newBricks brickInfo

    in
    ( Model Strangers1 Prepare
        [ball, ball2] [paddle] bricks
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
        [ Svg.defs
            []
            [ Svg.filter [id "Gaussian_Blur"]
                [ Svg.feGaussianBlur
                    [ SA.in_ "SourceGraphic"
                    , SA.stdDeviation "4"
                    ]
                    []
                ]
            , Svg.filter [id "Gaussian_Blur_in"]
                [ Svg.feGaussianBlur
                    [ SA.in_ "SourceGraphic"
                    , SA.stdDeviation "3"
                    ]
                    []
                ]
            ]
        , Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat (ball.r * 2.5))
            , SA.fill (colorToString (rgb 200 200 200))
            , SA.filter "url(#Gaussian_Blur)"
            , SA.opacity "0.5"
            ]
            []
        , Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat ball.r)
            , SA.fill (colorToString ball.color)
            , SA.filter "url(#Gaussian_Blur_in)"
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
        --, Svg.circle
        --    [ SA.cx (String.fromFloat paddle.pos.x)
        --    , SA.cy (String.fromFloat paddle.pos.y)
        --    , SA.r (String.fromFloat paddle.r)
        --    , SA.fill (colorToString backgroundColor)
        --    ]
        --    []
        , Svg.polygon
            [
              --SA.points (polyToString paddle.collision)
              SA.points (polyToString (posToPoly (2 * (paddle.r + paddle.h + 1)) (2 * paddle.r * (cos paddle.angle)) paddle.pos))
            , SA.fill (colorToString backgroundColor)
            ]
            []
        , Svg.circle
            [ SA.cx (String.fromFloat paddle.pos.x)
            , SA.cy (String.fromFloat paddle.pos.y)
            , SA.r (String.fromFloat (paddle.r + paddle.h))
            , SA.fillOpacity "0"
            , SA.stroke (colorToString paddle.color)
            , SA.strokeWidth (String.fromFloat paddle.h)
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
            (List.map visualizeBrick model.bricks) ++ List.map visualizeBall model.ball ++ (List.map visualizeBall (Maybe.withDefault [dummyBall] (List.tail model.ball)))
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


visualize : Model -> Html Msg
visualize model =
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
        , div
            [ style "background-color" (colorToString backgroundColor)
            , style "background-position" "center"
            ]
            [ ViewTest.visualizePrepare model
            , ViewTest.visualizePause model
            , ViewTest.visualizeWin model
            , ViewTest.visualizeLose model
            ]
        ]



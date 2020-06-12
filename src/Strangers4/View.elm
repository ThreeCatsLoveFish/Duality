module Strangers4.View exposing (..)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (..)
import Svg
import Svg.Attributes as SA

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView as ViewTest


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
            rgb 75 213 232
        Hit 1 ->
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
            [ visualizePrepare model
            , ViewTest.visualizePause model
            , ViewTest.visualizePass model
            , ViewTest.visualizeLose model
            ]
        ]

visualizePrepare : Model -> Html Msg
visualizePrepare model =
    let
        ( w, h ) = model.size
    in
    div
        [ style "background" (colorToString backgroundColor)
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" ((String.fromFloat w)++"px")
        , style "top" ((String.fromFloat h)++"px")
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "line-height" "500px"
        , style "display"
            (if model.gameStatus == Prepare then
                "block"
             else
                "none"
            )
        ]
        [ div [] [ text "Strangers II" ]
        , div [] []
        , div [] [ text "Press space to start. "]
        ]

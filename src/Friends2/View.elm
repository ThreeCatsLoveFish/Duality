module Friends2.View exposing (..)

import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes exposing (..)
import Svg
import Svg.Attributes as SA

import Bezier exposing (bezierColor)
import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView as ViewTest


backgroundColor : Color
backgroundColor = rgb 242 176 173

backgroundColor_ : Model -> Color
backgroundColor_ model=
    let
        state =
            if (List.isEmpty model.state) then
                {dummyState | t = 1}
            else
                getState model.state "fadeIn"
        color = bezierColor (rgb 0 0 0) backgroundColor state.t
    in
    if model.gameStatus==AnimationPrepare then color else backgroundColor

visualizeBall1 : Ball -> Svg.Svg Msg
visualizeBall1 ball =
    Svg.g []
        [ --Svg.defs
        --    []
        --    [ Svg.filter [id "Gaussian_Blur"]
        --        [ Svg.feGaussianBlur
        --            [ SA.in_ "SourceGraphic"
        --            , SA.stdDeviation "4"
        --            ]
        --            []
        --        ]
        --    , Svg.filter [id "Gaussian_Blur_in"]
        --        [ Svg.feGaussianBlur
        --            [ SA.in_ "SourceGraphic"
        --            , SA.stdDeviation "3"
        --            ]
        --            []
        --        ]
        --    ]
          Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat ball.r)
            , SA.fill (colorToString ball.color )
            --, SA.filter "url(#Gaussian_Blur)"
            --, SA.opacity "0.5"
            ]
            []
        --, Svg.circle
        --    [ SA.cx (String.fromFloat ball.pos.x)
        --    , SA.cy (String.fromFloat ball.pos.y)
        --    , SA.r (String.fromFloat ball.r)
        --    , SA.fill (colorToString ball.color)
        --    , SA.filter "url(#Gaussian_Blur_in)"
        --    ]
        --    []
        ]

visualizeBall2 : Ball -> Svg.Svg Msg
visualizeBall2 ball =
    Svg.g []
        [ --Svg.defs
        --    []
        --    [ Svg.filter [id "Gaussian_Blur"]
        --        [ Svg.feGaussianBlur
        --            [ SA.in_ "SourceGraphic"
        --            , SA.stdDeviation "4"
        --            ]
        --            []
        --        ]
        --    , Svg.filter [id "Gaussian_Blur_in"]
        --        [ Svg.feGaussianBlur
        --            [ SA.in_ "SourceGraphic"
        --            , SA.stdDeviation "3"
        --            ]
        --            []
        --        ]
        --    ]
          Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat ball.r)
            , SA.fill (colorToString ball.color)
            --, SA.filter "url(#Gaussian_Blur)"
            , SA.opacity "0.85"
            ]
            []
        --, Svg.circle
        --    [ SA.cx (String.fromFloat ball.pos.x)
        --    , SA.cy (String.fromFloat ball.pos.y)
        --    , SA.r (String.fromFloat ball.r)
        --    , SA.fill (colorToString ball.color)
        --    , SA.filter "url(#Gaussian_Blur_in)"
        --    ]
        --    []
        ]

visualizePaddle : Paddle -> Html Msg
visualizePaddle paddle =
    let
        w = 2 * (paddle.r + paddle.h + 1)
        h = 2 * paddle.r * (cos paddle.angle)
        pos_ = { x= paddle.pos.x, y= paddle.pos.y- h }
    in
    Svg.g []
        [ Svg.defs
            []
            [ Svg.mask [id "mask_"]
                [ Svg.polygon
                    [ SA.points (polyToString (posToPoly w h pos_))
                    , SA.fill (colorToString paddle.color)
                    ]
                    []
                ]
            ]
        , Svg.circle
            [ SA.cx (String.fromFloat paddle.pos.x)
            , SA.cy (String.fromFloat paddle.pos.y)
            , SA.r (String.fromFloat (paddle.r + paddle.h))
            , SA.fill (colorToString paddle.color)
            , SA.mask "url(#mask_)"
            ]
            []
        --, Svg.polygon
        --    [
        --      --SA.points (polyToString paddle.collision)
        --      SA.points (polyToString (posToPoly (2 * (paddle.r + paddle.h + 1)) (2 * paddle.r * (cos paddle.angle)) paddle.pos))
        --    , SA.fill (colorToString backgroundColor)
        --    ]
        --    []
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
    let
        alpha =
            case brick.hitTime of
                Hit 0 ->
                    "1"
                _ ->
                    "0"
    in
    Svg.polygon
        [ SA.points (polyToString brick.collision)
        , SA.fill (colorToString (changeBrickColor brick))
        , SA.opacity alpha
        ]
        []

changeBrickColor : Brick -> Color
changeBrickColor brick =
    case brick.hitTime of
        Hit 0 ->
            brick.color
        _ ->
            backgroundColor

visualizeCanvas : Model -> Svg.Svg Msg
visualizeCanvas model =
    let
        lt = Point 0 0
        lb = Point 0 model.canvas.h
        rb = Point model.canvas.w model.canvas.h
        rt = Point model.canvas.w 0
    in
    Svg.g []
        [ Svg.defs
            []
            [ Svg.filter [id "Gaussian_Blur1"]
                [ Svg.feGaussianBlur
                    [ SA.in_ "SourceGraphic"
                    , SA.stdDeviation "15"
                    ]
                    []
                ]
            , Svg.filter [id "Gaussian_Blur_in1"]
                [ Svg.feGaussianBlur
                    [ SA.in_ "SourceGraphic"
                    , SA.stdDeviation "10"
                    ]
                    []
                ]
            ]
        , Svg.polygon
            [ SA.points (polyToString [lt,lb,rb,rt])
            , SA.fill (colorToString (rgb 255 255 255))
            , SA.filter "url(#Gaussian_Blur1)"
            , SA.opacity "1"
            ]
            []
        , Svg.polygon
            [ SA.points (polyToString [lt,lb,rb,rt])
            , SA.fill (colorToString (backgroundColor_ model))
            , SA.filter "url(#Gaussian_Blur_in1)"
            , SA.opacity "1"
            ]
            []
        ]


visualizeGame : Model -> String -> Html Msg
visualizeGame model opacity =
    let
        elements =
            (List.map visualizeBrick model.bricks) ++ [(visualizeBall1 (getBall model.ball 1)),(visualizeBall2 (getBall model.ball 2))]
              |> (::) (visualizePaddle (getPaddle model.paddle 1))
              |> (::) (visualizeCanvas model)
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
        (w,h) = model.size
        alpha = case model.gameStatus of
            Prepare ->
                "1"
            Running _ ->
                "1"
            Paused ->
                "1"
            AnimationPass ->
                (String.fromFloat (getState model.state "fadeOut").value)
            Pass ->
                "1"
            _ ->
                "0"
        r =
            if w / h > model.canvas.w / model.canvas.h then
                Basics.min 1 (h / model.canvas.h)

            else
                Basics.min 1 (w / model.canvas.w)
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" (colorToString (backgroundColor_ model))]
        [ div
            [ style "width" (String.fromFloat model.canvas.w++"px")
            , style "height" (String.fromFloat model.canvas.h++"px")
            , style "position" "absolute"
            , style "left" (String.fromFloat((w - model.canvas.w * r) / 2) ++ "px")
            , style "top" (String.fromFloat((h - model.canvas.h * r) / 2) ++ "px")
            , style "background-color" (colorToString (backgroundColor_ model))
            ]
            [ visualizeGame model alpha ]
        , div
            [ style "background-color" (colorToString (backgroundColor_ model))
            , style "background-position" "center"
            ]
            [ visualizePrepare model
            , ViewTest.visualizeBlock model
            ]
        ]

visualizePrepare : Model -> Html Msg
visualizePrepare model =
    let
        alpha =
            case model.gameStatus of
                AnimationPrepare ->
                    if List.isEmpty model.state then
                        1
                    else
                        (getState model.state "fadeIn").value
                Prepare ->
                    1
                AnimationPreparePost ->
                    (getState model.state "fadeOut").value
                _ -> 0
        alphaSub =
            case model.gameStatus of
                AnimationPrepare ->
                    if List.isEmpty model.state then
                        1
                    else
                        (getState model.state "fadeInSub").value
                Prepare ->
                    1
                AnimationPreparePost ->
                    (getState model.state "fadeOut").value
                _ -> 0
    in
    div
        [ style "background" (colorToString (backgroundColor_ model))
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "Helvetica, Arial, sans-serif"
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
            , style "opacity" (String.fromFloat alphaSub)
            ]
            [ text "Press space to start" ]
        , p
            [ style "position" "absolute"
            , style "top" "30%"
            , style "width" "100%"
            , style "text-align" "center"
            , style "font-size" "48px"
            , style "opacity" (String.fromFloat alpha)
            ]
            [ text "Friends" ]
        ]


module Death6.View exposing (..)

import Bezier exposing (bezierColor)
import Html exposing (Attribute, Html, audio, div, i, p, text)
import Html.Attributes exposing (..)
import Svg
import Svg.Attributes as SA
--import Markdown

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView as ViewTest


backgroundColor : Color
backgroundColor = rgb 72 65 60

backgroundColor_ : Model -> Color
backgroundColor_ model=
    let
        state =
            if (List.isEmpty model.state) then
                {dummyState | t = 1}
            else
                getState model.state "fadeIn"
        color = bezierColor (rgb 138 182 165) backgroundColor state.t
    in
    if model.gameStatus==AnimationPrepare then color else backgroundColor

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
        --, Svg.circle
        --    [ SA.cx (String.fromFloat ball.pos.x)
        --    , SA.cy (String.fromFloat ball.pos.y)
        --    , SA.r (String.fromFloat (ball.r * 2.5))
        --    , SA.fill (colorToString (rgb 200 200 200))
        --    , SA.filter "url(#Gaussian_Blur)"
        --    , SA.opacity "0.5"
        --    ]
        --    []
        , Svg.circle
            [ SA.cx (String.fromFloat ball.pos.x)
            , SA.cy (String.fromFloat ball.pos.y)
            , SA.r (String.fromFloat ball.r)
            , SA.fill (colorToString ball.color)
            --, SA.filter "url(#Gaussian_Blur_in)"
            ]
            []
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
                    , SA.fill (colorToString (rgb 255 255 255))
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
                    --"0.3"
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
            --rgb 150 0 13
            rgb 110 106 100
        _ ->
            rgb 150 150 150

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
            , SA.fill (colorToString backgroundColor)
            , SA.filter "url(#Gaussian_Blur_in1)"
            , SA.opacity "1"
            ]
            []
        ]

visualizeCanvasDone : Model -> String -> Html Msg
visualizeCanvasDone model opacity =
    div
            [ style "opacity" opacity
            , style "position" "absolute"
            , style "top" "0"
            , style "left" "0"
            , style "width" "100%"
            , style "height" "100%"
            ]
            [ Svg.svg
                [ SA.version "1.1"
                , SA.x "0"
                , SA.y "0"
                , SA.viewBox ("0 0 " ++ (String.fromFloat model.canvas.w) ++ " " ++ (String.fromFloat model.canvas.h))
                ]
                [visualizeCanvas model]
            ]

visualizeGame : Model -> String -> Html Msg
visualizeGame model opacity =
    let
        elements =
            (List.map visualizeBrick model.bricks) ++ List.map visualizeBall model.ball ++ (List.map visualizeBall (Maybe.withDefault [dummyBall] (List.tail model.ball)))
              |> (::) (visualizePaddle (Maybe.withDefault dummyPaddle (List.head model.paddle)))
    in
        div
            [ style "opacity" opacity
            , style "position" "absolute"
            , style "top" "0"
            , style "left" "0"
            , style "width" "100%"
            , style "height" "100%"
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
            Pass ->
                "1"
            AnimationPass ->
                (String.fromFloat (getState model.state "fadeOut").value)
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
        (
            [ div
                [ style "width" (String.fromFloat model.canvas.w++"px")
                , style "height" (String.fromFloat model.canvas.h++"px")
                , style "position" "absolute"
                , style "left" (String.fromFloat((w - model.canvas.w * r) / 2) ++ "px")
                , style "top" (String.fromFloat((h - model.canvas.h * r) / 2) ++ "px")
                , style "background-color" (colorToString (backgroundColor_ model))
                ]
                [ visualizeCanvasDone model alpha
                , visualizeEpitaph model
                , visualizeGame model alpha
                ]
            , div
                [ style "background-color" (colorToString (backgroundColor_ model))
                , style "background-position" "center"
                ]
                [ visualizePrepare model
                , ViewTest.visualizeBlock model
                ]
            ] ++
            if not (List.member model.gameStatus [ Lose ]) then
            [ audio
                [ id "audio6"
                , src "Death - November.mp3"
                , autoplay True
                , preload "True"
                --, loop True
                , loop True
                ]
                []
            ]
            else []
        )

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
                    if (getState model.state "fadeOut").t == 0 && not (List.isEmpty model.state) then
                        1
                    else
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
                    if (getState model.state "fadeOut").t == 0 then
                        1
                    else
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
        , style "font-family" "High Tower Text, sans-serif"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "opacity" (String.fromFloat alpha)
        --, style "line-height" "500px"
        --, style "opacity" (String.fromFloat (getState model.state "fadeInAndOut").value)
        --, style "display"
        --    (if model.gameStatus == Prepare then
        --        "block"
        --     else
        --        "none"
        --    )
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
                , style "opacity" (String.fromFloat alphaSub)
                , style "line-height" "40px"
                ]
                [ p
                    [ style "position" "relative"
                    , style "left" "43%"
                    , style "width" "40%"
                    , style "text-align" "left"
                    ]
                    [ text "Let all bells toll!"
                    ]
                , p
                    [ style "position" "relative"
                    , style "top" "-20px"
                    , style "left" "43%"
                    , style "width" "40%"
                    , style "text-align" "left"
                    , style "color" "#C00000"
                    ]
                    [ text "Let"
                    , i [] [ text " no" ]
                    , text " bell toll."
                    ]
                , p
                    [ style "font-size" "16px"
                    , style "position" "relative"
                    , style "top" "-35px"
                    , style "left" "32%"
                    , style "width" "40%"
                    , style "font-family" "High Tower Text, sans-serif"
                    ]
                    [ text "              - Edgar Allan Poe " ]
                ]
            , p
                [ style "position" "absolute"
                , style "top" "30%"
                , style "width" "100%"
                , style "text-align" "center"
                , style "font-size" "48px"
                ]
                [ text "Death" ]

            ]
        ]


visualizeEpitaph : Model -> Html Msg
visualizeEpitaph model =
    let
        displaying =
            case model.gameStatus of
                Running _ ->
                   "inline"
                Paused ->
                   "inline"
                Pass ->
                    "block"
                AnimationPass ->
                    "block"
                End ->
                    "block"
                AnimationEnd ->
                    "block"
                _ ->
                   "none"
        alpha =
            case model.gameStatus of
                AnimationEnd ->
                    if (List.isEmpty model.state) then "0"
                    else if (getState model.state "fadeOut").t == 0 then
                        "1"
                    else
                        (String.fromFloat (getState model.state "fadeOut").value)
                AnimationPrepare ->
                    "0" -- for next level
                _ ->
                    "1"
    in
    div
        [ style "text-align" "left"
        , style "position" "absolute"
        , style "top" "0"
        , style "left" "0"
        , style "width" "100%"
        , style "height" "100%"
        , style "font-family" "High Tower Text, sans-serif"
        , style "font-size" "20px"
        , style "background-color" "transparent"
        , style "opacity" alpha
        , style "display"
            displaying
        , style "color" "#FFFFFF"
        , style "letter-spacing" "9px"
        --, style "line-height" "1.5px"
        ]
        [ p
            [ style "position" "absolute"
            , style "top" "10%"
            , style "left" "10%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text "Nay, " ]
        , p
            [ style "position" "absolute"
            , style "top" "19%"
            , style "left" "10%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text "if you read this line, " ]
        , p
            [ style "position" "absolute"
            , style "top" "28%"
            , style "left" "10%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text " remember not" ]
        , p
            [ style "position" "absolute"
            , style "top" "37%"
            , style "left" "10%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text "The hand that writ;" ]
        , p
            [ style "position" "absolute"
            , style "top" "46%"
            , style "left" "10%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text "for I " ]
        , p
            [ style "position" "absolute"
            , style "top" "55%"
            , style "left" "54.5%"
            , style "width" "80%"
            , style "height" "20%"
            , style "background-color" "transparent"
            ]
            [ text "love you so." ]
        ]
        --[ Markdown.toHtml [] """
--Nay,
--
--if you read this line,
--
--remember not
--
--The hand that writ;
--
--for I
--
--
--               love you so.
--"""
--        ]

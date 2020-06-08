module Strangers1.Init exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import InitTools exposing (..)

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






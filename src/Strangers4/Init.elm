module Strangers4.Init exposing (..)

import Html exposing (Html, Attribute, div)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView exposing (..)
import Strangers4.View

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 400, h = 600 }
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
                    , color = rgb 75 213 232
                    }
            in
            newBricks brickInfo
        model =
            Model
                Strangers1 Prepare
                [ball] [paddle] bricks
                []
                canvas (pixelWidth, pixelHeight) 0 True False
                (div [] [])
    in
    ( { model | visualization = Strangers4.View.visualize model }
    , Cmd.none
    )


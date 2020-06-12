module Lovers3.Init exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView exposing (..)
import Lovers3.State exposing (bezierBrick, getSpeed)
import Lovers3.View

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
        --TODO: paddle fix
        state : State
        state =
            { name = "heart"
            , value = getSpeed ball.v
            , t = 0
            , function = Func bezierBrick
            , loop = True
            }
        paddle : Paddle
        paddle =
            let
                r = 60
                h = 3
                angle = 40 * pi / 180
                pos = Point (canvas.w/2) (canvas.h + r * cos angle - 5 - r)
                --center = Point pos.x (pos.y + r)
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
                hi = --heartInfo
                    { canvas = canvas
                    , brick = {w=29, h=29}
                    , breath = 1
                    , offset = dummyPoint
                    , color = rgb 233 233 233
                    --, color = rgb 233 233 233
                    }
                posInfo =
                    [ Point 0 -1
                    , Point 0 0
                    , Point 0 1
                    , Point 0 2
                    , Point -1 -2
                    , Point -1 -1
                    , Point -1 0
                    , Point -1 1
                    , Point -2 0
                    , Point -2 -1
                    , Point -2 -2
                    , Point -3 -1
                    , Point 1 -2
                    , Point 1 -1
                    , Point 1 0
                    , Point 1 1
                    , Point 2 0
                    , Point 2 -1
                    , Point 2 -2
                    , Point 3 -1
                    ]

            in
            posInfo
                |> List.map
                    (\p -> Point
                        ((hi.brick.w+hi.breath)*p.x+hi.canvas.w/2+hi.offset.x)
                        ((hi.brick.h+hi.breath)*p.y+hi.canvas.h/2+hi.offset.y)
                    )
                |> List.map
                    (\p -> Brick
                        p
                        (pos2coll p hi.brick)
                        (pos2block p hi.brick)
                        (Hit 0)
                        hi.color
                    )
        model =
            Model
                Lovers3 Prepare
                [ball] [paddle] bricks
                [state]
                canvas (pixelWidth, pixelHeight) 0 True False
                (div [] [])
    in
    ( { model | visualization = Lovers3.View.visualize model }
    , Cmd.none
    )






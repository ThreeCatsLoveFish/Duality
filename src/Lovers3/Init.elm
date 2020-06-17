module Lovers3.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (genFadeIn, genFadeInSub)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import Lovers3.View

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 500, h = 600 }
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
            , color = rgb 252 226 149
            }

        state : List State
        state =
            [ { name = "fadeIn"
              , value = 0
              , t = 0
              , function = Func (genFadeIn 0 0.4 0)
              , loop = False
              }
            , { name = "fadeInSub"
              , value = 0
              , t = 0
              , function = Func (genFadeInSub 0.5 0.5 0)
              , loop = False
              }
            ]

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
                    , offset = Point 0 -40
                    , color = rgb 66 150 240
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
            { dummyModel
            | gameLevel = Lovers3
            , gameStatus = AnimationPrepare
            , ball = [ball]
            , paddle = [paddle]
            , bricks = bricks
            , state = state
            , canvas = canvas
            , size = (canvas.w, canvas.h)
            , clock = 0
            , activeInput = True
            , animateState = AniIn
            }
    in
    ( { model | visualization = Lovers3.View.visualize model }
    , Task.perform GetViewport getViewport
    )






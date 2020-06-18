module Strangers1.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (genFadeIn, genFadeInSub)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import Strangers1.View


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
                v = Point 0.2 -3.0
                r = 10
            in
            { dummyBall
            | active = True
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
                        (canvas.h/5)
                v = Point 0 0
                r = 10
            in
            { dummyBall
            | active = True
            , pos = pos
            , v = v
            , r = r
            , collision = dummyPoly
            , color = rgb 244 244 244
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
            in
            { dummyPaddle
            | pos = pos
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
                    { layout = {x=8, y=3}
                    , canvas = canvas
                    , brick = {w=39, h=39}
                    , breath = 5
                    , offset = Point 0 -10
                    , color = rgb 100 100 100
                    }
            in
            newBricks brickInfo
        model =
            { dummyModel
            | gameLevel = Strangers1
            , gameStatus = AnimationPrepare
            , ball = [ball, ball2]
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
    ( { model | visualization = Strangers1.View.visualize model }
    , Task.perform GetViewport getViewport
    )


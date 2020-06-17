module Friends2.Init exposing (..)

import Fade exposing (genFadeIn, genFadeInSub)
import Browser.Dom exposing (getViewport)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import Friends2.View
import Friends2.Find exposing (getBrick)

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 800, h = 600 }
        ball : Ball
        ball =
            let
                pos =
                    Point
                        (canvas.w/2)
                        (paddle.pos.y - paddle.r - paddle.h - r - 3)
                v = Point 3.0 -3.0
                r = 15
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = getBallColl (pos, r, 16)
            , color = rgb 66 150 240
            }
        ball2 : Ball
        ball2 =
            let
                pos =
                    --Tuple.first (find bricks 1)
                    (getBrick bricks 27).pos
                v = Point 0 0
                r = 15
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = dummyPoly
            , color = rgb 250 200 50
            }
        state : List State
        state =
            [ { name = "fadeIn"
              , value = 0
              , t = 0
              , function = Func (genFadeIn 0 0.4 -0.003)
              , loop = False
              }
            , { name = "fadeInSub"
              , value = 0
              , t = 0
              , function = Func (genFadeInSub 0.5 0.5 -0.003)
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
            { pos = pos -- may not be necessary
            , collision = getPaddleColl pos r h angle 16 -- for hitCheck
            , block = dummyBlock
            , color = rgb 255 255 255
            , r = r
            , h = h
            , angle = angle
            }
        bricksize = {w=60, h=60}
        bricks : List Brick
        bricks =
            let
                brickInfo =
                    { layout = {x=10, y=3}
                    , canvas = canvas
                    , brick = bricksize
                    , breath = 10
                    , offset = Point 0 -120
                    , color = rgb 109 181 161
                    --, color = rgb 138 182 165
                    }
            in
            newBricks brickInfo
        model =
            { dummyModel
            | gameLevel = Friends2
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
    ( { model | visualization = Friends2.View.visualize model }
    , Task.perform GetViewport getViewport
    )






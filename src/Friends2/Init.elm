module Friends2.Init exposing (..)

import Fade exposing (fadeInAndOut)
import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView exposing (..)
import Bezier exposing (..)
import Friends2.State exposing (genBezierBall2,moveBall2)
import Friends2.View
import Friends2.Find exposing (find)

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
                        (paddle.pos.y - paddle.r - paddle.h - r)
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
                    Tuple.first (find bricks 1)
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
            [ { name = "fadeInAndOut"
              , value = 0
              , t = 0
              , function = Func fadeInAndOut
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
                    , color = rgb 100 100 100
                    }
            in
            newBricks brickInfo
        model =
            Model
                Friends2 Prepare
                [ball, ball2] [paddle] bricks
                state
                canvas (pixelWidth, pixelHeight) 0 True False
                (div [] [])
    in
    ( { model | visualization = Friends2.View.visualize model }
    , Cmd.none
    )






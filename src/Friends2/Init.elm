module Friends2.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import BasicView exposing (..)
import Bezier exposing (..)
import Friends2.State exposing (genBezierBall2,genMoveBall2)
import Friends2.View
import Friends2.Find exposing (find)

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
        ball2 : Ball
        ball2 =
            let
                pos =
                    Tuple.first (find bricks 1)
                v = Point 0 0
                r = 10
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = dummyPoly
            , color = rgb 244 244 244
            }
        state : List State
        state =
            [ { name = "bezier"
              , value = 2
              , t = 0
              , function = Func
                  ( genBezierBall2
                    (pos2coll (Tuple.first (find bricks 1)) bricksize)
                  )
              , loop = True
              }
            , { name = "moveBall2"
              , value = 1
              , t = 0
              , function = Func
                  ( genMoveBall2 )
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
        bricksize = {w=39, h=39}
        bricks : List Brick
        bricks =
            let
                brickInfo =
                    { layout = {x=10, y=3}
                    , canvas = canvas
                    , brick = bricksize
                    , breath = 1
                    , offset = dummyPoint
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
    , Task.perform GetViewport getViewport
    )






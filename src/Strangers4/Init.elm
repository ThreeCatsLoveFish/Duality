module Strangers4.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Strangers4.State exposing (fadeIn)
import Html exposing (Html, Attribute, div)
import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)

import Strangers4.View


init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 600, h = 510 }
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
                pos = Point (canvas.w/2) (canvas.h - wh.h/2)
                wh = { w = 100.0, h = 20.0 }
            in
            { pos = pos
            , collision = pos2coll pos wh
            , block = pos2block pos wh
            , color = rgb 255 255 255
            , r = 0
            , h = wh.h
            , angle = 0
            }

        state : List State
        state =
            [
                { name = "fadeIn"
                , value = 0
                , t = 0
                , function = Func fadeIn
                , loop = False
                }
            ]
        bricks : List Brick
        bricks =
            let
                hi = --heartInfo
                    { canvas = canvas
                    , brick = {w=50, h=50}
                    , breath = 1
                    , offset = Point 0 -70
                    , color = dummyColor
                    }
                posInfo =
                    [ Point 0 0
                    , Point 1 1
                    , Point 1 -1
                    , Point -1 1
                    , Point -1 -1
                    , Point 0 1
                    , Point 0 -1
                    , Point 1 0
                    , Point -1 0
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
            | gameLevel = Strangers4
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
    ( { model | visualization = Strangers4.View.visualize model }
    , Task.perform GetViewport getViewport
    )


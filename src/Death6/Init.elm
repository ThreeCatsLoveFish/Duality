module Death6.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (fadeInAndOut)
import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import BasicView exposing (..)
--import Death6.State exposing (genBezierBrick, getSpeed)
import Death6.View

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
            , color = rgb 100 100 100
            }

        state : List State
        state =
            [
                { name = "fadeInAndOut"
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
                posInfo =
                    [ ( Point 97 92 , { w = 43, h = 25 } )
                    , ( Point 146 287 , { w = 50, h = 25 } )
                    , ( Point 195 287 , { w = 43, h = 25 } )
                    , ( Point 240 287 , { w = 43, h = 25 } )
                    , ( Point 280 287 , { w = 28, h = 25 } )
                    , ( Point 344 287 , { w = 96, h = 25 } )
                    ]

            in
            posInfo
                |> List.map
                    (\(p, b) -> Brick
                        p
                        (pos2coll p b)
                        (pos2block p b)
                        (Hit 0)
                        (rgb 0 0 0)
                    )
        model =
            { dummyModel
            | gameLevel = Death6
            , gameStatus = AnimationPrepare
            --, gameStatus = Running Stay --Todo: for brick test
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
    ( { model | visualization = Death6.View.visualize model }
    , Task.perform GetViewport getViewport
    )






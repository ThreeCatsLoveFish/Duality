module Death6.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (genFadeIn, genFadeInSub)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
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
                v = Point -3.0 -3.0
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
                posInfo =
                    [ ( Point 90 90 , { w = 88, h = 25 } )
                    , ( Point 70 145 , { w = 44, h = 25 } )
                    , ( Point 125 145 , { w = 55, h = 25 } )
                    , ( Point 201 145 , { w = 77, h = 25 } )
                    , ( Point 281 145 , { w = 61, h = 25 } )
                    , ( Point 366 145 , { w = 80, h = 25 } )
                    , ( Point 138 198 , { w = 155, h = 25 } )
                    , ( Point 256 198 , { w = 66, h = 25 } )
                    , ( Point 88 253 , { w = 59, h = 25 } )
                    , ( Point 170 253 , { w = 81, h = 25 } )
                    , ( Point 254 253 , { w = 70, h = 25 } )
                    , ( Point 338 253 , { w = 87, h = 25 } )
                    , ( Point 81 307 , { w = 50, h = 25 } )
                    , ( Point 124 307 , { w = 15, h = 25 } )
                    , ( Point 307 364 , { w = 72, h = 25 } )
                    , ( Point 390 364 , { w = 70, h = 25 } )
                    , ( Point 469 364, { w = 55, h = 25 } )
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
            --, gameStatus = AnimationPrepare
            , gameStatus = Paused -- for brick test
            --, gameStatus = Pass -- for AnimationEnd test
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






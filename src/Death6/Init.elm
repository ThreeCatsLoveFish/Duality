module Death6.Init exposing (..)

import Browser.Dom exposing (getViewport)

import Model exposing (..)
import Messages exposing (..)
import Fade exposing (genFadeIn, genFadeInSub)
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
                v = Point -1.6 -1.6
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
            in
            { pos = pos
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
                    [ ( Point 82 91 , { w = 74, h = 25 } )
                    , ( Point 60 148 , { w = 30, h = 25 } ) -- if
                    , ( Point 117 148 , { w = 60, h = 25 } )
                    , ( Point 198 148 , { w = 77, h = 25 } )
                    , ( Point 283 148 , { w = 65, h = 25 } )
                    , ( Point 370 148 , { w = 84, h = 25 } )
                    , ( Point 122 199 , { w = 154, h = 25 } ) -- remember
                    , ( Point 248 199 , { w = 66, h = 25 } )
                    , ( Point 75 253 , { w = 60, h = 25 } ) --- The
                    , ( Point 159 253 , { w = 80, h = 25 } )
                    , ( Point 248 253 , { w = 70, h = 25 } )
                    , ( Point 339 253 , { w = 84, h = 25 } )
                    , ( Point 70 307 , { w = 50, h = 25 } ) -- for
                    , ( Point 122 307 , { w = 24, h = 25 } )
                    , ( Point 302 364 , { w = 74, h = 25 } ) -- love
                    , ( Point 382.5 364 , { w = 53, h = 25 } )
                    , ( Point 451 364, { w = 52, h = 25 } )
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


module End7.Init exposing (..)

import Browser.Dom exposing (getViewport)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (dummyModel, dummyStateManagement)

import End7.View


init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 400, h = 600 }
        state =
            [ { name = "tMapTop"
              , value = 0
              , t = 0
              , function = Func (dummyStateManagement "tMapTop" 1)
              , loop = False
              }
            , { name = "fade"
              , value = 0
              , t = -1
              , function = Func (dummyStateManagement "fade" 0.3)
              , loop = False
              }
            ]

        model =
            { dummyModel
            | gameLevel = End7
            , gameStatus = AnimationPrepare
            , ball = []
            , paddle = []
            , bricks = []
            , state = state
            , canvas = canvas
            , size = (canvas.w, canvas.h)
            , clock = 0
            , activeInput = True
            , animateState = AniIn
            }

    in
    ( { model | visualization = End7.View.visualize model }
    , Task.perform GetViewport getViewport
    )

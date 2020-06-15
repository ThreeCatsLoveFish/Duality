module Start0.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (genFadeIn)
import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import BasicView exposing (..)
import Start0.View
import Task
import Tools exposing (dummyModel)

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 400, h = 600 }
        state =
            [ { name = "fadeInAndOut"
              , value = 0
              , t = 0
              , function = Func (\m _ -> m)
              , loop = False
              }
            , { name = "fadeIn"
              , value = 0
              , t = -1
              , function = Func (genFadeIn 0 0.4 0)
              , loop = False
              }
            ]
        model =
            { dummyModel
            | gameLevel = Start0
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
    ( { model | visualization = Start0.View.visualize model }
    , Task.perform GetViewport getViewport
    )






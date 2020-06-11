module Start0.Init exposing (..)

import Html exposing (Html, Attribute, button, div, h1, input, text)

import Model exposing (..)
import Messages exposing (..)
import Tools exposing (..)
import BasicView exposing (..)
import Start0.State exposing (genFadeInAndOut)
import Start0.View

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 400, h = 600 }
        state =
            { name = "fadeInAndOut"
            , value = 0
            , t = 0
            , function = Func (\m _ -> m)
            , loop = False
            }
        model =
            Model
                Start0 Prepare
                [] [] []
                [state]
                canvas (pixelWidth, pixelHeight) 0 True False
                (div [] [])
    in
    ( { model | visualization = Start0.View.visualize model }
    , Cmd.none
    )






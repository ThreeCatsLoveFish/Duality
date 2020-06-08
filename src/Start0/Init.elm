module Start0.Init exposing (..)

import Html exposing (..)

import Model exposing (..)
import Messages exposing (..)

init : ( Model, Cmd Msg )
init =
    ( Model Start0 NoMenu
        [] [] []
        {w=0,h=0} 0
        visualize
    , Cmd.none
    )

visualize : Html Msg
visualize =
    div [] [] --TODO: Visualize it!
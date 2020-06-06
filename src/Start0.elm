module Start0 exposing (init)

import Html exposing (..)

import Model exposing (..)
import Messages exposing (..)

init : ( Model, Cmd Msg )
init =
    ( Model Start0 NoMenu [] [] [] 0 visualizeStart0, Cmd.none)

visualizeStart0 : Html Msg
visualizeStart0 =
    div [] [] --TODO: Visualize it!

module Start0 exposing (init)

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

view : Model -> Html Msg
view model =
    model.visualization

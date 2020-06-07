module View exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Html exposing (Html)
import Start0
import Strangers1
import Friends2
import Lovers3
import Strangers4
import Companions5
import Death6
import End7

view : Model -> Html Msg
view model =
    case model.gameLevel of
        Start0 ->
            Start0.view
        Strangers1 ->
            Strangers1.view
        Friends2 ->
            Friends2.view
        Lovers3 ->
            Lovers3.view
        Strangers4 ->
            Strangers4.view
        Companions5 ->
            Companions5.view
        Death6 ->
            Death6.view
        End7 ->
            End7.view
        _ ->
            Start0.view

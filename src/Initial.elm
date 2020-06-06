module Initial exposing (..)
import Model exposing (..)
import Messages exposing (..)
import Start0
import Strangers1
import Friends2
import Lovers3
import Strangers4
import Companions5
import Death6
import End7

init : ( Model, Cmd Msg )
init = Start0.init

reinit : Model -> ( Model, Cmd Msg )
reinit model =
    case model.gameLevel of
        Start0 ->
            Start0.init
        Strangers1 ->
            Strangers1.init
        Friends2 ->
            Friends2.init
        Lovers3 ->
            Lovers3.init
        Strangers4 ->
            Strangers4.init
        Companions5 ->
            Companions5.init
        Death6 ->
            Death6.init
        End7 ->
            End7.init

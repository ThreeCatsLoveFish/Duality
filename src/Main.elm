module Main exposing (..)

import Html exposing (Html)
import Browser

import Model exposing (..)
import Messages exposing (..)

import Start0.Init
import Strangers1.Init
import Friends2.Init
import Lovers3.Init
import Strangers4.Init
import Companions5.Init
import Death6.Init
{--
import End7.Init
--}

import Start0.Update
import Strangers1.Update
import Friends2.Update
import Lovers3.Update
import Strangers4.Update
import Companions5.Update
import Death6.Update
{--
import End7.Update
--}

import Subscriptions exposing (subscriptions)

{--
import Test
--}

---- PROGRAM ----

main : Program () Model Msg
main =
    -- Test.main
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    Start0.Init.init
    --Strangers1.Init.init
    --Friends2.Init.init
    --Lovers3.Init.init
    --Strangers4.Init.init
    --Companions5.Init.init
    --Death6.Init.init

{--
reinit : Model -> ( Model, Cmd Msg )
reinit model =
    case model.gameLevel of
        Start0 ->
            Start0.Init.init
        Strangers1 ->
            Strangers1.Init.init
        Friends2 ->
            Friends2.Init.init
        Lovers3 ->
            Lovers3.Init.init
        Strangers4 ->
            Strangers4.Init.init
        Companions5 ->
            Companions5.Init.init
        Death6 ->
            Death6.Init.init
        End7 ->
            End7.Init.init
        _ ->
            Start0.Init.init
--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model.gameStatus of
        ChangeLevel ->
            case model.gameLevel of
                 Start0 ->
                     Start0.Init.init
                 Strangers1 ->
                     Strangers1.Init.init
                 Friends2 ->
                     Friends2.Init.init
                 Lovers3 ->
                     Lovers3.Init.init
                 Strangers4 ->
                     Strangers4.Init.init
                 Companions5 ->
                     Companions5.Init.init
                 Death6 ->
                     Death6.Init.init
                 {--
                 End7 ->
                     End7.Init.init
                 --}
                 _ ->
                     Start0.Init.init
        _ ->
             case model.gameLevel of
                 Start0 ->
                     Start0.Update.update msg model
                 Strangers1 ->
                     Strangers1.Update.update msg model
                 Friends2 ->
                     Friends2.Update.update msg model
                 Lovers3 ->
                     Lovers3.Update.update msg model
                 Strangers4 ->
                     Strangers4.Update.update msg model
                 Companions5 ->
                     Companions5.Update.update msg model
                 Death6 ->
                     Death6.Update.update msg model
                 {--
                 End7 ->
                     End7.Update.update msg model
                 --}
                 _ ->
                     Start0.Update.update msg model


view : Model -> Html Msg
view model =
    model.visualization

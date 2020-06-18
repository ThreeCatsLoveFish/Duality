module Main exposing (..)

import Browser.Dom exposing (getViewport)
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
import End7.Init

import Start0.Update
import Strangers1.Update
import Friends2.Update
import Lovers3.Update
import Strangers4.Update
import Companions5.Update
import Death6.Update
import End7.Update

import Subscriptions exposing (subscriptions)
import Task
import Tools exposing (nextLevel)


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
    --End7.Init.init

reInit : Model -> ( Model, Cmd Msg )
reInit model =
    let
        ( model_, task ) =
            case model.gameLevel of
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
                    ( Tuple.first End7.Init.init |> (\m -> { m | visualization = model.visualization } )
                    , Task.perform GetViewport getViewport
                    )
                _ ->
                    Start0.Init.init
    in
    ( { model_ | finished = model.finished, god = model.god }
    , task
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseLevel level ->
            case level of
                 Strangers1 ->
                     reInit { model | gameLevel = Strangers1 }
                 Friends2 ->
                     reInit { model | gameLevel = Friends2 }
                 Lovers3 ->
                     reInit { model | gameLevel = Lovers3 }
                 Strangers4 ->
                     reInit { model | gameLevel = Strangers4 }
                 Companions5 ->
                     reInit { model | gameLevel = Companions5 }
                 Death6 ->
                     reInit { model | gameLevel = Death6 }
                 End7 ->
                     reInit { model | gameLevel = End7 }
                 _ ->
                     reInit { model | gameLevel = Start0 }
        KeyDown Key_G ->
            ( { model | god = not model.god }
            , Cmd.none
            )
        KeyDown Key_S ->
            if List.member model.gameLevel [ Start0, End7 ] then ( model, Cmd.none )
            else if List.member model.gameStatus
                [ AnimationPass, Pass, Lose, AnimationEnd ]
                then
                ( model |> nextLevel
                , Cmd.none
                )
            else if List.member model.gameStatus
                [ AnimationPrepare, Prepare, AnimationPreparePost, End ]
                then
                ( model
                , Cmd.none
                )
            else
                ( { model | gameStatus = Pass }
                , Cmd.none
                )
        KeyDown Key_D ->
            ( model |> nextLevel
            , Cmd.none
            )
        _ ->
            case model.gameStatus of
                ChangeLevel ->
                    case model.gameLevel of
                        Strangers1 ->
                            reInit { model | gameLevel = Strangers1 }
                        Friends2 ->
                            reInit { model | gameLevel = Friends2 }
                        Lovers3 ->
                            reInit { model | gameLevel = Lovers3 }
                        Strangers4 ->
                            reInit { model | gameLevel = Strangers4 }
                        Companions5 ->
                            reInit { model | gameLevel = Companions5 }
                        Death6 ->
                            reInit { model | gameLevel = Death6 }
                        End7 ->
                            reInit { model | gameLevel = End7 }
                        _ ->
                            reInit { model | gameLevel = Start0 }
                _ ->
                     case model.gameLevel of
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
                         End7 ->
                             End7.Update.update msg model
                         _ ->
                             Start0.Update.update msg model


view : Model -> Html Msg
view model =
    model.visualization

module Start0.Update exposing (..)

import Messages exposing (..)
import Model exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        model0 =
            case msg of
                KeyDown Space ->
                    case model.activeInput of
                        True ->
                            { model
                            | gameLevel = Strangers1
                            , gameStatus = ChangeLevel
                            }
                        False ->
                            model
                Tick _ ->
                    case (model.activeState, model.activeInput) of
                        (True, False) ->
                            let
                                model1 =
                                    model |> stateIterate
                            in
                            case List.isEmpty model1.state of
                                True -> {model1|activeState=False, activeInput=True}
                                _ -> model1
                        (False, True) -> model
                        _ ->
                            { model | activeState = True, activeInput = False}
                _ ->
                    model
    in
    ( model0, Cmd.none )

stateIterate : Model -> Model
stateIterate model = model


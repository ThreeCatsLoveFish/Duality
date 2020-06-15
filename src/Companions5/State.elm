module Companions5.State exposing (..)
import Bezier exposing (bezierPos)
import Fade exposing (fadeOut, genFadeIn)
import Model exposing (..)
import Messages exposing (..)
import Tools exposing (divState, dummyState, getBall)

stateIterate : Model -> Model
stateIterate model =
    case List.isEmpty model.state of
        True ->
            case model.gameStatus of
                AnimationPrepare ->
                    { model
                    | gameStatus = Prepare
                    }
                AnimationPreparePost ->
                    let
                        model1 = model |> getGameState
                    in
                    { model1
                    | gameStatus = Running Stay
                    }
                AnimationPass ->
                    { model
                    | gameStatus = ChangeLevel
                    , gameLevel = Death6
                    }
                _ -> model
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.007) state
                getFunc (Func func) = func
                setModel : State -> Model -> Model
                setModel stat model_ =
                    (getFunc stat.function) model_ stat.t
                newModel =
                    List.foldl (\x y -> (setModel x y)) { model | state = newState } newState

            in
            newModel

getPrepareState : Model -> Model
getPrepareState model = getEndState model

getGameState : Model -> Model
getGameState model =
    { model | state = [dummyState] }

getEndState : Model -> Model
getEndState model =
    let
        s = { name = "fadeOut"
            , value = 1
            , t = 0
            , function = Func (fadeOut)
            , loop = False
            }
    in
    { model | state = [s] }

loopState : State -> Float -> State
loopState state t =
    case state.loop of
        True ->
            if (state.loop == True && state.t < 1) then
                 { state | t = state.t + t}
            else
                 { state | t = state.t - 1}
        False ->
            { state | t = state.t + t}

fadeIn : Model -> Float -> Model
fadeIn model t=
    genFadeIn 0 0.4 0 model t

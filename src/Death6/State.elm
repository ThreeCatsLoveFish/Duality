module Death6.State exposing (..)
import Fade exposing (genFadeOut)
import Model exposing (..)
import Messages exposing (..)


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
                    { model
                    | gameStatus = Running Stay
                    } |> getGameState
                AnimationPass ->
                    { model
                    | gameStatus = End
                    --, gameLevel = End7
                    }
                AnimationEnd ->
                    { model
                    | gameStatus = ChangeLevel
                    , gameLevel = End7
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
getPrepareState model =
    getEndState model

getGameState : Model -> Model
getGameState model =
    { model | state = [] }

getPassState : Model -> Model
getPassState model =
    getEndState model

getEndState : Model -> Model
getEndState model =
    let
        s = { name = "fadeOut"
            , value = 0
            , t = 0
            , function = Func (genFadeOut 0 1 -0.001)
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

module Strangers4.State exposing (..)

import Model exposing (Brick, Color, HitTime(..), Model, Point, State, StateFunc(..), rgb)
import Messages exposing (GameLevel(..), GameStatus(..), Op(..))
import Bezier exposing (bezierColor)
import Fade exposing (genFadeOut)
import Tools exposing (dummyState)


-- Colors of different states
endColor0 = rgb 0 79 102
endColor1 = rgb 15 112 140
endColor2 = rgb 37 136 164
endColor3 = rgb 115 169 184
endColor4 = rgb 158 189 200


genBezierColor : Model -> Float -> Model
genBezierColor =
    let
        bezier0 = bezierColor endColor0 endColor1
        bezier1 = bezierColor endColor1 endColor2
        bezier2 = bezierColor endColor2 endColor3
        bezier3 = bezierColor endColor3 endColor4
        bezierBrickColor : Model -> Float -> Model
        bezierBrickColor model_ t_ =
            let
                targetBrick =
                    model_.bricks
                    |> List.map (\a ->
                                case a.hitTime of
                                    Hit 1 ->
                                        if a.color /= endColor1
                                        then { a | color = bezier0 t_ }
                                        else a
                                    Hit 2 ->
                                        if a.color /= endColor2
                                        then { a | color = bezier1 t_ }
                                        else a
                                    Hit 3 ->
                                        if a.color /= endColor3
                                        then { a | color = bezier2 t_ }
                                        else a
                                    Hit 4 ->
                                        if a.color /= endColor4
                                        then { a | color = bezier3 t_ }
                                        else a
                                    _ -> a
                                )
            in
            { model_ | bricks = targetBrick, state = List.filter (\s -> s.t <= 1) model_.state}
    in
    bezierBrickColor


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
                    , gameLevel = Companions5
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
    let
        s1 = { name = "fadeOut"
            , value = 1
            , t = 0
            , function = Func (genFadeOut 0 1 -0.001)
            , loop = False
            }
    in
    { model | state = [s1] }


getGameState : Model -> Model
getGameState model =
    let
        s = dummyState
    in
    { model | state = [s] }


getEndState : Model -> Model
getEndState model =
    let
        s1 = { name = "fadeOut"
            , value = 1
            , t = 0
            , function = Func (genFadeOut 0 1 -0.001)
            , loop = False
            }
    in
    { model | state = [s1] }


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


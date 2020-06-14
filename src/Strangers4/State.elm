module Strangers4.State exposing (..)
import Bezier exposing (bezierColor)
import Fade exposing (fadeOut)
import Messages exposing (GameLevel(..), GameStatus(..))
import Model exposing (Brick, Color, HitTime(..), Model, Point, State, StateFunc(..), rgb)
import Tools exposing (dummyState)

startColor = rgb 75 213 232
endColor = rgb 208 19 72

genBezierColor : Color -> Color -> (Model -> Float -> Model)
genBezierColor p1 p2 =
    let
        bezier = bezierColor p1 p2
        bezierBrickColor : Model -> Float -> Model
        bezierBrickColor model_ t_ =
            let
                targetBrick =
                    model_.bricks
                    |> List.map (\a ->
                                case a.hitTime of
                                    Hit 1 ->
                                        if a.color /= endColor
                                        then { a | color = bezier t_ }
                                        else a
                                    _ -> a
                                )
            in
            { model_ | bricks = targetBrick}
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
            , value = 0
            , t = -1
            , function = Func (fadeOut)
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

module Strangers4.State exposing (..)
import Bezier exposing (bezierColor)
import Fade exposing (fadeOut)
import Messages exposing (GameLevel(..), GameStatus(..))
import Model exposing (Brick, Color, HitTime(..), Model, Point, State, StateFunc(..), rgb)
import Tools exposing (dummyState)


-- Colors of different states
endColor0 = rgb  75 213 232
endColor1 = rgb 120 213  72
endColor2 = rgb 208 213  72
endColor3 = rgb 208 110  72
endColor4 = rgb 208  19  72


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
                    List.filterMap (\s -> loopState s 0.01) state
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


loopState : State -> Float -> Maybe State
loopState state t =
    if state.t <= 1 then
         Just { state | t = state.t + t}
    else
         Nothing


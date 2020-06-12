module Strangers1.State exposing (..)
import Bezier exposing (bezierPos, bezierColor)
import Messages exposing (GameLevel(..), GameStatus(..), Op(..))
import Tools exposing (divState, getBall, getState)
import Model exposing (Color, Model, Point, State, StateFunc(..), rgb)


genBezierBall2 : Point -> Point -> Point -> Point -> (Model -> Float -> Model)
genBezierBall2 p1 p2 p3 p4 =
    let
        bezier = bezierPos p1 p2 p3 p4
        bezierBall2 : Model -> Float -> Model
        bezierBall2 model_ t_ =
            let
                ball1 = getBall model_.ball 1
                ball2 = getBall model_.ball 2
                ball2_ = { ball2 | pos = bezier t_ }
            in
            { model_ | ball = [ball1, ball2_] }
    in
    bezierBall2

genFadeInAndOut : Model -> Float -> Model
genFadeInAndOut model t =
    let
        val =
            if  ( t < 0.3 ) then
                t / 0.3
            else if ( t >= 0.3 && t <= 0.7 ) then
                1
            else
                ( 1.0 - t ) / 0.3
        (s_, state_) = divState model.state "fadeInAndOut"
        s = { s_ | value = val}
    in
    { model | state = s::state_ }

genChangeBallColor : Model -> Float -> Model
genChangeBallColor model t=
    let
        ball1 = getBall model.ball 1
        ball2 = getBall model.ball 2
        newBall1 = {ball1 | color = bezierColor ball1.color (rgb 66 150 240) t }
        newBall2 = {ball2 | color = bezierColor ball1.color (rgb 250 200 50) t }
        newball = [newBall1, newBall2]
        s_ = getState model.state "changeBallColor"
        state =
            case s_.t>= 1 of
                 True -> []
                 _ -> model.state
    in
    {model | ball = newball, state = state}



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
                    , gameLevel = Friends2
                    }
                _ -> model
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.01) state
                setModel : State -> Model -> Model
                setModel stat model_ =
                    case stat.name of
                        "bezier" ->
                            bezierBall model_ stat
                        _ ->
                            bezierBall model_ stat
                newModel =
                    List.foldl (\x y -> (setModel x y)) { model | state = newState } newState

            in
            newModel

bezierBall : Model -> State -> Model
bezierBall model state =
    let
        getfunc (Func func) = func
        newBalls =
            (getfunc state.function model state.t).ball
    in
    { model | ball = newBalls }

getGameState : Model -> Model
getGameState model =
    let
        s = { name = "bezier"
              , value = 2
              , t = 0
              , function = Func
                  ( genBezierBall2
                    (Point (model.canvas.w/2) (model.canvas.h/4))
                    (Point (model.canvas.w/2 - 40) (model.canvas.h/4 + 40))
                    (Point (model.canvas.w/2 + 40) (model.canvas.h/4 + 40))
                    (Point (model.canvas.w/2) (model.canvas.h/4))
                  )
              , loop = True
              }
    in
    { model | state = [s] }


getEndState : Model -> Model
getEndState model =
    let
        s = { name = "changeBallColor"
            , value = 0
            , t = 0
            , function = Func (genChangeBallColor)
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

module Strangers1.State exposing (..)
import Bezier exposing (bezierPos, bezierColor)
import Fade exposing (fadeOut)
import Messages exposing (GameLevel(..), GameStatus(..), Op(..))
import Tools exposing (divState, getBall, getState)
import Model exposing (..)


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


genChangeBallColor : Model -> Float -> Model
genChangeBallColor model t=
    let
        ball1 = getBall model.ball 1
        ball2 = getBall model.ball 2
        newBall1 = {ball1 | color = bezierColor ball1.color (rgb 66 150 240) t }
        newBall2 = {ball2 | color = bezierColor ball1.color (rgb 250 200 50) t }
        newball = [newBall1, newBall2]
        (s_,state_) = divState model.state "changeBallColor"
        state =
            case s_.t>= 1 of
                 True -> state_
                 _ -> model.state
    in
    {model | ball = newball, state = state}

genChangeBallSize : Model -> Float -> Model
genChangeBallSize model t=
    let
        t_ = min t 1
        r_ = 10
        ball1 = getBall model.ball 1
        ball2 = getBall model.ball 2
        newBall1 = {ball1 | r = r_ * ( 1 + t_ ) }
        newBall2 = {ball2 | r = r_ * ( 1 + t_ ) }
        newball = [newBall1, newBall2]
        (s_,state_) = divState model.state "changeBallSize"
        state =
            case s_.t>= 1 of
                 True -> state_
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
                    List.map (\s -> loopState s 0.007) state
                getFunc (Func func) = func
                setModel : State -> Model -> Model
                setModel stat model_ =
                    case stat.name of
                        "bezier" ->
                            bezierBall model_ stat
                        _ ->
                            (getFunc stat.function) model_ stat.t
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
                  (Point ((getBall model.ball 2).pos.x) ((getBall model.ball 2).pos.y))
                  (Point ((getBall model.ball 2).pos.x - 40) ((getBall model.ball 2).pos.y + 40))
                  (Point ((getBall model.ball 2).pos.x + 40) ((getBall model.ball 2).pos.y + 40))
                  (Point ((getBall model.ball 2).pos.x) ((getBall model.ball 2).pos.y))
                )
            , loop = True
            }
    in
    { model | state = [s] }


getEndState : Model -> Model
getEndState model =
    let
        s1 = { name = "changeBallColor"
            , value = 0
            , t = 0
            , function = Func (genChangeBallColor)
            , loop = False
            }
        s2 = { name = "changeBallSize"
            , value = 0
            , t = 0
            , function = Func (genChangeBallSize)
            , loop = False
            }
        s3 = { name = "fadeOut"
            , value = 0
            , t = -1
            , function = Func (fadeOut)
            , loop = False
            }
    in
    { model | state = [s1,s2,s3] }

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

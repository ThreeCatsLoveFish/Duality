module Friends2.State exposing (..)
import Bezier exposing (..)
import Fade exposing (fadeOut, genFadeIn)
import Tools exposing (getBall, getState)
import Model exposing (..)
import Messages exposing (..)
import Friends2.Find exposing (..)

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

genBezierPoints : Point -> Point -> Float -> Float -> (Model -> Float -> Model)
genBezierPoints p1 p4 degree ratio =
    let
        theta = degree * pi / 180
        a1 = cos theta
        b1 = -(sin theta)
        a2 = -b1
        b2 = a1
        ori = Point ((p1.x+p4.x)/2) ((p1.y+p4.y)/2)
        rot_ = Point ((-p1.x+p4.x)/2) ((-p1.y+p4.y)/2)
        rot =
            Point
            ((a1*rot_.x + b1*rot_.y) * ratio)
            ((a2*rot_.x + b2*rot_.y) * ratio)
        p2 = Point (ori.x - rot.x) (ori.y - rot.y)
        p3 = Point (ori.x + rot.x) (ori.y + rot.y)
    in
    genBezierBall2 p1 p2 p3 p4

moveBall2 : Model -> Model
moveBall2 model =
    let
        state = getState model.state "moveBall2"
        valid = model.bricks |> List.filter (\b -> b.hitTime /= NoMore) |> List.length
        (pos_, index_) =
            if valid < 1 then (pos, round state.value)
            else find model.bricks (round state.value)
        pos = (getBrick model.bricks (round state.value)).pos
        ball = getBall model.ball 2
        statePToK =
            let
                p1 = {x=ball.pos.x, y=ball.pos.y}
                p4 = {x=pos_.x, y=pos_.y}
                degree = 37
                ratio = 0.35
            in
            { state
            | value = toFloat index_
            , t = 0
            , function = Func (genBezierPoints p1 p4 degree ratio)
            , loop = False
            }
        stateKToP =
            let
                p1 = {x=ball.pos.x, y=ball.pos.y}
                p2 = {x=ball.pos.x+20, y=ball.pos.y+5}
                p3 = {x=ball.pos.x- 10, y=ball.pos.y+10}
                p4 = {x=ball.pos.x, y=ball.pos.y}
            in
            { state
            | t = 0
            , function = Func (genBezierBall2 p1 p2 p3 p4)
            , loop = True
            }
        stateKToK =
            let
                p1 = {x=ball.pos.x, y=ball.pos.y}
                p4 = {x=pos.x, y=pos.y}
                degree = -33
                ratio = 0.88
            in
            { state
            | t = 0
            , function = Func (genBezierPoints p1 p4 degree ratio)
            , value = toFloat index_
            }
    in
    case state.loop of
        True -> --potential
            if (getBrick model.bricks (round state.value)).hitTime /= NoMore then
                model
            else
                { model | state = [statePToK] }
        False -> --kinetic
            if (state.t >= 1) then
                { model | state = [stateKToP]}
            else if (getBrick model.bricks (round state.value)).hitTime /= NoMore then
                model
            else
                { model | state = [stateKToK] }
---

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
                    , gameLevel = Lovers3
                    }
                _ -> model
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.01) state
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
    let
        s =
            let
                --(pos, index) = find model.bricks 1
                index = 27
                pos = (getBrick model.bricks index).pos
                p1 = {x=pos.x, y=pos.y}
                p2 = {x=pos.x+10, y=pos.y+10}
                p3 = {x=pos.x- 20, y=pos.y+4}
                p4 = {x=pos.x, y=pos.y}
            in
            { name = "moveBall2"
            , t = 0
            , value = toFloat index
            , function = Func (genBezierBall2 p1 p2 p3 p4)
            , loop = True
            }
    in
    { model | state = [s] }


getEndState : Model -> Model
getEndState model =
    let
        s1 = { name = "fadeOut"
            , value = 1
            , t = 0
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

fadeIn : Model -> Float -> Model
fadeIn model t=
    genFadeIn 0 0.4 0 model t

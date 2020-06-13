module Friends2.State exposing (..)
import Bezier exposing (..)
import Tools exposing (divState, dummyState, getBall, getState)
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

getBezierPoints : Point -> Point -> Float -> Float -> (Model -> Float -> Model)
getBezierPoints p1 p4 degree ratio =
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
        --state = Maybe.withDefault dummyState (List.head model.state) --NB!
        state = getState model.state "moveBall2"
        (pos_, index_) = find model.bricks (round state.value)
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
            , function = Func (getBezierPoints p1 p4 degree ratio)
            , loop = False
            }
        stateKToP =
            let
                p1 = {x=ball.pos.x, y=ball.pos.y}
                p4 = {x=ball.pos.x, y=ball.pos.y}
                degree = 46
                ratio = 0.55
            in
            { state
            | t = 0
            , function = Func (getBezierPoints p1 p4 degree ratio)
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
            , function = Func (getBezierPoints p1 p4 degree ratio)
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
    --case state.name of
    --    "potential" ->
    --        if (getBrick model.bricks (round state.value)).hitTime == NoMore then
    --            { model | state = [{ state | name = "kinetic" }] }
    --        else
    --            model
    --    "kinetic" ->


---
genFadeOut : Model -> Float -> Model
genFadeOut model t =
    let
        val =
            if  ( t < 0.4 ) then
                1
            else if ( t >= 0.4 && t <= 0.7 ) then
                (t - 0.4) / 0.3
            else
                0
        (s_, state_) = divState model.state "fadeOut"
        state =
            case t>2 of
                False -> { s_ | value = val}::state_
                _ -> state_
    in
    { model | state = state }

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
        s = { name = "moveBall2"
            , value = 1
            , t = 0
            , function = Func
                ( genBezierBall2
                  (Point ((getBall model.ball 2).pos.x) ((getBall model.ball 2).pos.y))
                  (Point ((getBall model.ball 2).pos.x - 10) ((getBall model.ball 2).pos.y + 10))
                  (Point ((getBall model.ball 2).pos.x + 10) ((getBall model.ball 2).pos.y + 10))
                  (Point ((getBall model.ball 2).pos.x) ((getBall model.ball 2).pos.y))
                )
            , loop = True
            }
    in
    { model | state = [s] }


getEndState : Model -> Model
getEndState model =
    let
        s1 = { name = "fadeOut"
            , value = 0
            , t = -1
            , function = Func (genFadeOut)
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

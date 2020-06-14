module Lovers3.State exposing (..)
import Bezier exposing (bezierPos)
import Fade exposing (fadeOut, genFadeOut)
import Model exposing (..)
import Messages exposing (..)
import Tools exposing (divState, getBall)


genBezierBrick : List Brick -> (Model -> Float -> Model)
genBezierBrick bricks__ =
    let
        bezierBrick model t_ =
            let
                (s_, state_e) = divState model.state "heart"
                s__ = { s_ | value = speedMap (List.length (List.filter (\b -> b.hitTime /= NoMore) model.bricks)) }

                t_r = -- redundant t for heart leak with proportion to frac
                    let
                        timeMap : Float -> Float -> Float
                        timeMap t__ sp =
                            let
                                vMax = 12
                                frac = 1 - sp/vMax
                            in
                            --if t__ < frac then
                                t__ / frac
                            --else
                            --    1
                    in
                    timeMap t_ s__.value

                ( t, cut ) =
                    let
                        cutTime = 1.5
                    in
                    if t_r < cutTime then
                        ( min t_r 1, False )
                    else
                        ( 0, True )

                s =
                    case cut of
                        True -> { s__ | t = 0 }
                        _ -> s__

                center = Point (model.canvas.w/2) (model.canvas.h/2 - 50)
                pos2curve pos_ =
                    let
                        outpoint = vecAway pos_ center 0.6
                        bezier = bezierPos pos_ outpoint outpoint pos_
                    in
                    bezier

                bricks_m = model.bricks
                bricks_ =
                    --bricks__
                    --    |> List.map (\b ->
                    --            { b
                    --            | pos = (pos2curve b.pos) t
                    --            , block = Block ((pos2curve b.block.lt) t) ((pos2curve b.block.rb) t)
                    --            , collision = List.map (\p -> (pos2curve p) t) b.collision
                    --            }
                    --        )
                    bricks__
                        |> List.map (\b ->
                                let
                                    newPos = (pos2curve b.pos) t
                                in
                                { b
                                | pos = newPos
                                , block = Block (posDiff b.pos newPos b.block.lt) (posDiff b.pos newPos b.block.rb)
                                , collision = List.map (\p -> posDiff b.pos newPos p) b.collision
                                }
                            )
                bricks = List.map2 (\b1 b2 -> { b2 | hitTime = b1.hitTime }) bricks_m bricks_
                ball_ = getBall model.ball 1
                ball = [{ ball_ | v = (convertSpeed ball_.v s.value) }]
            in
            { model | bricks = bricks, ball = ball, state = s :: state_e }
    in
    bezierBrick

getSpeed : Point -> Float
getSpeed v =
    (v.x^2+v.y^2) |> sqrt

vecAway : Point -> Point -> Float -> Point
vecAway target origin distance =
    let
        x = (target.x - origin.x)*distance + target.x
        y = (target.y - origin.y)*distance + target.y
    in
    Point x y

convertSpeed : Point -> Float -> Point
convertSpeed v speed =
    let
        vN = getSpeed v
    in
    Point (v.x/vN*speed) (v.y/vN*speed)

posDiff : Point -> Point -> Point -> Point
posDiff ori new cur =
    let
        x = (new.x - ori.x) + cur.x
        y = (new.y - ori.y) + cur.y
    in
    Point x y

speedMap : Int -> Float
speedMap brickN =
    let
        vInit = 4
        brickInit = 20 -- Todo: sync with brick number in init
        dv = 0.4
    in
    vInit + (toFloat (brickInit - brickN)) * dv

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
                    , gameLevel = Strangers4
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
        s = { name = "heart"
            , value = getSpeed (getBall model.ball 1).v
            , t = 0
            , function = Func (genBezierBrick model.bricks)
            , loop = True
            }
    in
    { model | state = [s] }

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

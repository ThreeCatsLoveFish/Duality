module Strangers1.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)

-- TODO: Change for test
import Strangers1.Collision exposing (..)
import Strangers1.View exposing (..)
import Collision exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case model.gameStatus of
                Paused ->
                    case msg of
                        KeyDown Space ->
                            { model | gameStatus = Running Stay }
                        KeyDown Key_R ->
                            { model | gameStatus = ChangeLevel }
                        _ -> model
                Prepare ->
                    case msg of
                        KeyDown Space ->
                            { model | gameStatus = Running Stay }
                        _ -> model
                Pass ->
                    let
                        model1 = model |> getEndState
                    in
                    { model1 | gameStatus = Animation }
                Animation ->
                    case msg of
                        Tick time ->
                            model |> stateIterate
                        _ ->
                            model
                Running _ ->
                    case msg of
                        KeyDown key ->
                            let
                                status =
                                    case key of
                                        Key_Left -> Running Left
                                        Key_Right -> Running Right
                                        Key_R -> ChangeLevel
                                        _ -> Paused
                            in
                            {model | gameStatus = status}
                        KeyUp key ->
                            let
                                status =
                                    case key of
                                        Key_Left -> Running Stay
                                        Key_Right -> Running Stay
                                        _ -> model.gameStatus
                            in
                            {model | gameStatus = status}
                        Tick time ->
                            model |> move (min time 25)
                                  |> stateIterate
                        _ -> model
                _ ->
                    model
    in
    ( { model0 | visualization = Strangers1.View.visualize model} , Cmd.none )
-- TODO

move : Float -> Model -> Model
move elapsed model =
    let
        elapsed_ =
            model.clock + elapsed
        interval = 15
    in
    if elapsed_ > interval then
        { model | clock = elapsed_ - interval } |> exec

    else
        { model | clock = elapsed_ }

exec : Model -> Model
exec model =
    let
        dir =
            case model.gameStatus of
                Running dr -> dr
                _ -> Stay
    in
    model
        |> movePaddle dir
        |> moveBall
        |> basic_hit
        |> paddleCheck
        |> wallCheck
        |> winJudge

moveBall : Model -> Model -- Done
moveBall model =
    let
        done ball =
            let
                pos = ball.pos
                v = ball.v
                newPos = Point (pos.x + v.x) (pos.y + v.y)
                coll = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) ball.collision
                setPos npos ncoll ball_ =
                    { ball_ | pos = npos, collision = ncoll }
            in
            setPos newPos coll ball
    in
    { model | ball = List.map done model.ball }

movePaddle : Op -> Model -> Model -- Done
movePaddle op model =
    let
        done paddle =
            let
                vNorm = 4 -- the speed of paddle
                v = case op of
                    Left ->
                        case pos.x > 18 of
                            True -> Point -vNorm 0
                            _ -> dummyPoint
                    Right ->
                        case pos.x < model.canvas.w - 18 of
                            True -> Point vNorm 0
                            _ -> dummyPoint
                    Stay -> Point 0 0
                pos = paddle.pos

                newPos =
                    Point (pos.x + v.x) (pos.y + v.y)
                col = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) paddle.collision
                setPaddle npos paddle_ =
                    { paddle_ | pos = npos, collision = col }
            in
            setPaddle newPos paddle
    in
    { model | paddle = List.map done model.paddle }


winJudge : Model -> Model
winJudge model =
    let
        change_brick : Brick -> Brick
        change_brick brick =
            case brick.hitTime of
                Hit 1 -> { brick | hitTime = NoMore, color = backgroundColor}
                _ -> brick
        brick_all = List.map change_brick model.bricks
        ball = getBall model.ball 1
        ball2 = getBall model.ball 2
        closeEnough =
            sqrt ((ball.pos.x - ball2.pos.x)^2 + (ball.pos.y - ball2.pos.y)^2) < 10 * ball.r
        win =
            case closeEnough || ( brick_all |> List.filter (\b -> b.hitTime /= NoMore) |> List.isEmpty ) of
                True ->
                    Pass
                False ->
                    model.gameStatus
                    --case (getBall model.ball 1).pos.y > model.canvas.h+10 of
                    --    True -> Lose
                    --    False -> model.gameStatus
    in
    { model | gameStatus = win, bricks = brick_all }



stateIterate : Model -> Model
stateIterate model =
    case List.isEmpty model.state of
        True ->
            { model
            | gameStatus = ChangeLevel
            , gameLevel = Friends2
            }
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
        ball =
            getBall model.ball state.index
        newBallPos =
            state.bezierCurve state.t
        newBall = { ball | pos = newBallPos }
    in
    { model | ball = [ getBall model.ball 1, newBall ] }

getEndState : Model -> Model
getEndState model =
    model

loopState : State -> Float -> State
loopState state t =
    if (state.loop == True && state.t < 1) then
         { state | t = state.t + t}
    else
         { state | t = state.t - 1}

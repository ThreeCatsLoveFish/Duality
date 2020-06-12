module Lovers3.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)

import CollisionBlock exposing (..)
import CollisionPoly exposing (..)
import Lovers3.State exposing (..)
import Lovers3.View exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
-- Todo: Resize
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
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                Prepare ->
                    case msg of
                        KeyDown Space ->
                            { model | gameStatus = Running Stay }
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                Pass ->
                    let
                        model1 = model |> getEndState
                    in
                    { model1 | gameStatus = AnimationPass }
                AnimationPass ->
                    case msg of
                        Tick time ->
                            model |> stateIterate
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
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
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                _ ->
                    model
    in
    ( { model0 | visualization = Lovers3.View.visualize model} , Cmd.none )
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
        win =
            case ( brick_all |> List.filter (\b -> b.hitTime /= NoMore) |> List.isEmpty ) of
                True ->
                    Pass
                False ->
                    case ball.pos.y > model.canvas.h+10 of
                        True -> Lose
                        False -> model.gameStatus
    in
    { model | gameStatus = win, bricks = brick_all }



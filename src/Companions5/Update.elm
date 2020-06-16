module Companions5.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)

import CollisionBlock exposing (..)
import Companions5.Collision exposing (..)
import Companions5.State exposing (..)
import Companions5.View exposing (..)

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
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                AnimationPrepare ->
                    case msg of
                        Tick _ ->
                            model |> stateIterate
                        GetViewport { viewport } ->
                            { model
                                | size =
                                    ( viewport.width
                                    , viewport.height
                                    )
                            }
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ ->
                            model
                Prepare ->
                    case msg of
                        KeyDown Space ->
                            { model | gameStatus = AnimationPreparePost } |> getPrepareState
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                AnimationPreparePost ->
                    case msg of
                        Tick _ ->
                            model |> stateIterate
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ ->
                            model
                Lose ->
                    case msg of
                        KeyDown Key_R ->
                            { model | gameStatus = ChangeLevel }
                        KeyDown Space ->
                            { model | gameStatus = ChangeLevel }
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
                        Tick _ ->
                            model |> stateIterate
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ ->
                            model
                End ->
                    case msg of
                        KeyDown _ ->
                            {model | gameStatus = AnimationPrepare
                                   , gameLevel = Strangers4
                            }
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
                                        Key_Left ->
                                            if model.gameStatus == Running Left then Running Stay
                                            else model.gameStatus
                                        Key_Right ->
                                            if model.gameStatus == Running Right then Running Stay
                                            else model.gameStatus
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
    ( { model0 | visualization = Companions5.View.visualize model0} , Cmd.none )

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
        |> moveBall
        |> basic_hit
        |> movePaddle dir
        --|> paddleOutwardFix -- Badass
        |> paddleCheckIndex 1
        |> paddleCheckIndex 2
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
        ball = getBall model.ball 1
        paddle1 = getPaddle model.paddle 1
        paddle2 = getPaddle model.paddle 2
        distance : Point -> Point -> Float
        distance p1 p2 =
            sqrt ((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
        --norm = distance (Point 0 0)
        vNorm =  -- the speed of paddle
            case (ball.r + paddle1.r - 1) < distance ball.pos paddle1.pos
            ||   (ball.r + paddle2.r - 1) < distance ball.pos paddle2.pos
            of
                True -> 6
                _ -> 1
        done paddle =
            let
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
            in
            { paddle | pos = newPos, collision = col }
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
                    case (ball.pos.y > model.canvas.h+10) || (ball.pos.y < -10) of
                        True -> Lose
                        False -> model.gameStatus
    in
    { model | gameStatus = win, bricks = brick_all }



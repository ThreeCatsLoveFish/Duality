module Strangers4.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)
import CollisionPoly exposing (wallCheck)

import Strangers4.State exposing (..)
import Strangers4.View exposing (..)
import Strangers4.CollisionBlock exposing (block_hit, paddle_hit)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model4 =
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
                                   , gameLevel = Companions5
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
    ( { model4 | visualization = Strangers4.View.visualize model4} , Cmd.none )


move : Float -> Model -> Model
move elapsed model =
    let
        elapsed_ =
            model.clock + elapsed
        interval = 15
    in
    if elapsed_ > interval then
        { model | clock = elapsed_ - interval } |> exec elapsed

    else
        { model | clock = elapsed_ }


exec : Float -> Model -> Model
exec flow model =
    let
        dir =
            case model.gameStatus of
                Running dr -> dr
                _ -> Stay
    in
    model
        |> movePaddle dir
        |> block_hit
        |> paddle_hit
        |> moveBall flow
        |> wallCheck
        |> winJudge


moveBall : Float -> Model -> Model -- Done
moveBall flow model =
    let
        static_old_ = List.map (\a -> { dummyBall | pos = a.pos, r = 5, color = rgb 232 74 120 }) model.ball
        static_old = griddle flow (getBall model.ball 1) static_old_
        --static_old = List.map (\a -> { a | v = dummyPoint, color = rgb 255 255 255 }) model.ball
        done: Maybe Ball -> Ball
        done ball_maybe =
            let
                ball = Maybe.withDefault dummyBall ball_maybe
                pos = ball.pos
                v = ball.v
                newPos = Point (pos.x + v.x) (pos.y + v.y)
                coll = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) ball.collision
            in
            { ball | pos = newPos, collision = coll }
    in
    { model | ball = [done (List.head model.ball)] ++ static_old }

griddle : Float -> Ball -> List Ball -> List Ball
griddle flow cur ball =
    let
        cutting = round (max (120 - flow) 60)
        grid = [ 3, 7, 8 ,10, 11 ]
        --top = round (max (250 - flow) 100)
        top = 220

        len = List.length ball
        ball_ =
            if len > cutting then
            ( List.take cutting ball
                |> List.indexedMap (\i a ->
                    if ( List.foldr (\d is -> modBy d i  == 0 || is) False grid
                    )
                    && ((distance cur.pos a.pos) < 1.4 * cur.r)
                    then Nothing else Just a )
                |> List.filter (\a ->
                    case a of
                        Just _ -> True
                        _-> False
                    )
                |> List.map (\a -> Maybe.withDefault dummyBall a)
            )
            ++ List.drop cutting ball
            else ball
    in
    ball_
        |> List.take top

movePaddle : Op -> Model -> Model -- Done
movePaddle op model =
    let
        done paddle =
            let
                vNorm = 6 -- the speed of paddle
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
                    case model.god of -- God
                        True -> Point (getBall model.ball 1).pos.x (pos.y + v.y)
                        _ ->
                            Point (pos.x + v.x) (pos.y + v.y)
                block = paddle.block
                newBlock =
                    Block (Point (block.lt.x + v.x) (block.lt.y + v.y)) (Point (block.rb.x + v.x) (block.rb.y + v.y))
                col = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) paddle.collision
                setPaddle npos paddle_ =
                    { paddle_ | pos = npos, block = newBlock, collision = col }
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
                Hit 5 -> { brick | hitTime = NoMore, color = backgroundColor}
                _ -> brick
        brick_all = List.map change_brick model.bricks
        win =
            case ( brick_all |> List.filter (\b -> b.hitTime /= NoMore) |> List.isEmpty ) of
                True ->
                    Pass
                False ->
                    model.gameStatus
    in
    { model | gameStatus = win, bricks = brick_all }


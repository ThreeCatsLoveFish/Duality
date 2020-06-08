module Strangers1.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import InitTools exposing (..)

-- TODO: Change for test
import Strangers1.Collision exposing (..)
import Strangers1.Init
import Strangers1.View

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case msg of
                ShowStatus Paused ->
                    case model.gameStatus of
                        Paused ->
                            { model | gameStatus = Running Nothing }
                        Prepare ->
                            { model | gameStatus = Running Nothing }
                        _ ->
                            { model | gameStatus = Paused }
                ShowStatus Prepare ->
                    case model.gameStatus of
                        Prepare ->
                            { model | gameStatus = Prepare }
                        _ ->
                            Tuple.first Strangers1.Init.init
                ShowStatus menu ->
                    { model | gameStatus = menu }
                RunGame op ->
                    case model.gameStatus of
                        Paused -> model
                        Prepare -> model
                        _ ->
                            {model | gameStatus = Running (Just op)}
                Tick time ->
                    move (min time 25) model
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
                Running (Just dr) -> dr
                Running Nothing -> Stay -- TODO: can be model.gameStatus
                _ -> Stay
    in
    model
        |> movePaddle dir
        |> moveBall
        |> collisionCheck
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
            sqrt ((ball.pos.x - ball2.pos.x)^2 + (ball.pos.y - ball2.pos.y)^2) < 5 * ball.r
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


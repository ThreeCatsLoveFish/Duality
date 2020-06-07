module TestUpdate exposing (..)
import Messages exposing (..)
import Model exposing (..)
import InitTools exposing (..)

-- TODO: Change for test
import Strangers1.Strangers1 as Strangers1 exposing (..)
import Strangers1.Collision exposing (..)

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
                            Tuple.first Strangers1.init
                ShowStatus menu ->
                    { model | gameStatus = menu }
                RunGame op ->
                    {model | gameStatus = Running <| Just op}
                Tick time ->
                    move (min time 25) model
                _ ->
                    model
    in
    ( model0 |> winJudge, Cmd.none )
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

moveBall : Model -> Model -- Done
moveBall model =
    let
        ball = getBall model.ball 1
        pos = ball.pos
        v = ball.v
        newPos = Point (pos.x + v.x) (pos.y + v.y)
        coll = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) ball.collision
        setPos npos ncoll ball_ =
            { ball_ | pos = npos, collision = ncoll }
        setBall ball_ nmodel =
            { nmodel | ball = [ball_]}
    in
    setBall (setPos newPos coll ball) model


movePaddle : Op -> Model -> Model -- Done
movePaddle op model =
    let
        vNorm = 10 -- the speed of paddle (per 1/30 sec)
        v = case op of
            Left -> Point -vNorm 0
            Right -> Point vNorm 0
            Stay -> Point 0 0
        pos = paddle.pos

        paddle = getPaddle model.paddle 1
        newPos = Point (pos.x + v.x) (pos.y + v.y)
        col = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) paddle.collision
        setPaddle npos paddle_ =
            { paddle_ | pos = npos, collision = col }
        setModel paddle_ nmodel =
            { nmodel | paddle = [paddle_]}
    in
    setModel (setPaddle newPos paddle) model


winJudge : Model -> Model
winJudge model =
    let
        change_brick : Brick -> Brick
        change_brick brick =
            case brick.hitTime of
                Hit 1 -> { brick | hitTime = NoMore, color = backgroundColor}
                _ -> brick
        brick_all = List.map change_brick model.bricks
        win =
            case brick_all |> List.filter (\b -> b.hitTime /= NoMore) |> List.isEmpty of
                True -> Pass
                False ->
                    case (getBall model.ball 1).pos.y > model.canvas.h+10 of
                        True -> Lose
                        False -> model.gameStatus
    in
    { model | gameStatus = win, bricks = brick_all }

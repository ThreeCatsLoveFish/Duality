module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)
import Bin.Initial exposing (..)
import Bin.Collision exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case msg of
                ShowMenu Paused ->
                    case model.menu of
                        Paused ->
                            { model | menu = Running }
                        Startup ->
                            { model | menu = Running }
                        _ ->
                            { model | menu = Paused }
                ShowMenu Startup ->
                    case model.menu of
                        Startup ->
                            { model | menu = Startup }
                        _ ->
                            let
                                info : Info
                                info =
                                    { canvas = { w = 800, h = 600 } -- (0, 800), (0, 600)
                                    , brick = { w = 60, h = 37 }
                                    , layout = { x = 12, y = 7 }
                                    , ball = { d = 20, v = Point 3.0 -3.0, precision = 16 }
                                    , paddle = { w = 100, h = 15 }
                                    , breath = 10
                                    }
                            in
                            reInit model info
                ShowMenu menu ->
                    { model | menu = menu }
                RunGame op ->
                    {model | dir = Just op}
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
            case model.dir of
                Just dr -> dr
                Nothing -> Stay
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
        pos = model.ball.pos
        v = model.ball.v
        newPos = Point (pos.x + v.x) (pos.y + v.y)
        coll = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) model.ball.collision
        setPos npos ncoll ball =
            { ball | pos = npos, collision = ncoll }
        setBall ball nmodel =
            { nmodel | ball = ball}
    in
    setBall (setPos newPos coll model.ball) model


movePaddle : Op -> Model -> Model -- Done
movePaddle op model =
    let
        vNorm = 10 -- the speed of paddle (per 1/30 sec)
        v = case op of
            Left -> Point -vNorm 0
            Right -> Point vNorm 0
            Stay -> Point 0 0
        pos = model.paddle.pos

        newPos = Point (pos.x + v.x) (pos.y + v.y)
        col = List.map (\pt -> Point (pt.x+v.x) (pt.y+v.y) ) model.paddle.collision
        setPaddle npos paddle =
            { paddle | pos = npos, collision = col }
        setModel paddle nmodel =
            { nmodel | paddle = paddle}
    in
    setModel (setPaddle newPos model.paddle) model


--gameStatus : Model -> Model
--
--
--brickStatus : Model -> Model


winJudge : Model -> Model
winJudge model =
    let
        change_brick : Brick -> Brick
        change_brick brick =
            case brick.stat of
                Hit 1 -> { brick | stat = NoMore}
                _ -> brick
        brick_all = List.map change_brick model.bricks
        win =
            case brick_all |> List.filter (\b -> b.stat /= NoMore) |> List.isEmpty of
                True -> Win
                False -> model.menu
    in
    { model | menu = win, bricks = brick_all }

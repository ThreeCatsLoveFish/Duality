module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)
import Bin.Collision exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case msg of
                ShowMenu menu ->
                    case menu of
                        Paused ->
                            case model.menu of
                                Paused ->
                                    { model | menu = Running }
                                Startup ->
                                    { model | menu = Running }
                                _ ->
                                    { model | menu = Paused }
                        _ ->
                            { model | menu = menu }
                RunGame op ->
                    {model | dir = op}
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
    model
        |> movePaddle model.dir
        |> moveBall
        |> collisionCheck

moveBall : Model -> Model -- Done
moveBall model =
    let
        pos = model.ball.pos
        v = model.ball.v
        newPos = Point (pos.x + v.x) (pos.y + v.y)
        setPos npos ball =
            { ball | pos = npos }
        setBall ball nmodel =
            { nmodel | ball = ball}
    in
    setBall (setPos newPos model.ball) model


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
        setPos npos paddle =
            { paddle | pos = npos }
        setPaddle paddle nmodel =
            { nmodel | paddle = paddle}
    in
    setPaddle (setPos newPos model.paddle) model


--gameStatus : Model -> Model
--
--
--brickStatus : Model -> Model


winJudge : Model -> Model
winJudge model =
    model

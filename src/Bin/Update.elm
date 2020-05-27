module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
-- TODO


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

movePaddle : Model -> Op -> Model -- Done
movePaddle model op =
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


collisionCheck : Model -> Model
gameStatus : Model -> Model
brickStatus : Model -> Model
winOrLose : Model -> Model

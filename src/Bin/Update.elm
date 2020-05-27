module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
-- TODO


moveBall : Model -> Model
movePaddle : Model -> Model
collisionCheck : Model -> Model
gameStatus : Model -> Model
brickStatus : Model -> Model
winOrLose : Model -> Model

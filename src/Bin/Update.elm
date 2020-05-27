module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)

update : Msg -> GameModel -> ( GameModel, Cmd Msg )
update msg model =
    ( model, Cmd.none )
-- TODO

moveBall : GameModel -> GameModel
movePaddle : GameModel -> GameModel
collisionCheck : GameModel -> GameModel
gameStatus : GameModel -> GameModel
brickStatus : GameModel -> GameModel
winOrLose : GameModel -> GameModel

module Bin.View exposing (..)

import Bin.Types exposing (..)

import Html exposing (Html, div)
import Bin.Message exposing (..)

visualizeBall : Ball -> Html Msg
visualizeBall ball =
    div [] []

visualizeBrick : Brick -> Html Msg
visualizeBrick ball =
    div [] []

visualizePaddle : Paddle -> Html Msg
visualizePaddle paddle =
    div [] []


-- dummy for clear coding
visualizeGame : GameModel -> Html Msg
visualizeGame gamemodel =
    div []
    [ gamemodel.ball |> visualizeBall
    , List.map visualizeBrick gamemodel.bricks -- TODO: Complete the following...
    ]

view : GameModel -> Html Msg
view gamemodel =
    case gamemodel.menu of
        Startup -> visualizeGame gamemodel -- TODO: replace dummy
        Running op -> visualizeGame gamemodel
        Win -> visualizeGame gamemodel
        Lose -> visualizeGame gamemodel
        _ -> div [] [] -- TODO


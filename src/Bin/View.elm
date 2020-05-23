module Bin.View exposing (..)

import Bin.Types exposing (..)

import Html exposing (Html, div)
import Bin.Msg exposing (..)

visualizeBall : Ball -> Html Msg
visualizeBall ball =
    div [] []

visualizeBrick : Brick -> Html Msg
visualizeBrick ball =
    div [] []

visualizePaddle : Paddle -> Html Msg
visualizePaddle paddle =
    div [] []

view : GameModel -> Html Msg
view gamemodel =
    div []
    [ gamemodel.ball |> visualizeBall
    , List.map visualizeBrick gamemodel.bricks -- TODO: Complete the following...
    ]

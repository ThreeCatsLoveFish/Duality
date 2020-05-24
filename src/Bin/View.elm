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

visualizeGame : GameModel -> Html Msg
visualizeGame gamemodel =
    div []
    [ gamemodel.ball |> visualizeBall
    , List.map visualizeBrick gamemodel.bricks -- TODO: Complete the following...
    ]

visualizeMenu : MenuModel -> Html Msg -> Html Msg
visualizeMenu html menu =
    div [] [] -- TODO

view : GameModel -> Msg -> Html Msg
view gamemodel msg =
    case msg of
        Startup -> visualizeGame gamemodel
        Running op -> visualizeGame gamemodel
        Win menumodel -> visualizeGame gamemodel |> (visualizeMenu menumodel)
        Lose menumodel -> visualizeGame gamemodel |> (visualizeMenu menumodel)
        _ -> div [] [] -- TODO


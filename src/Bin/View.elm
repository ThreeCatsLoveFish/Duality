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
visualizeGame : Model -> Html Msg
visualizeGame model =
    div []
    [ model.ball |> visualizeBall
    , List.map visualizeBrick model.bricks -- TODO: Complete the following...
    ]

view : Model -> Html Msg
view model =
    case model.menu of
        Startup -> visualizeGame model -- TODO: replace dummy
        Running -> visualizeGame model
        Paused -> visualizeGame model
        Win -> visualizeGame model
        Lose -> visualizeGame model
        _ -> div [] [] -- TODO


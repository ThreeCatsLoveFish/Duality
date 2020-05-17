module Components.View exposing (view)

import Components.Structure exposing (GameParas)
import Playground exposing (..)

view : Computer -> GameParas -> List Shape
view computer game =
  [ words (if game.ball.y < -200 then red else white) "You Lose!"
    |> scale 3
  , words black "Press Enter to Start!"
    |> scale 3
    |> fade (toFloat game.lock)
  , rectangle brown 60 14
    |> move game.board.x game.board.y
  , circle darkBlue 10
    |> move game.ball.x game.ball.y
  ]
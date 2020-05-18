module Components.View exposing (view)

import Components.Structure exposing (GameParas, Pos)
import Playground exposing (..)

-- Change the list of bricks to list of shapes
brick_shapes : Pos -> List Shape -> List Shape
brick_shapes brick shapes =
  shapes ++
  [ rectangle orange brick.width brick.height
  |> move brick.x brick.y         -- Move X Y
  |> fade (toFloat brick.status)  -- If broken
  ]

view : Computer -> GameParas -> List Shape
view computer game =
  [ rectangle lightGray 820 420 -- Background
  , words (if game.ball.y < -200 then red else lightGray) "You Lose!"
    |> scale 3.2
    -- Lose
  , words green "You Win! Press ENTER to restart!"
    |> scale 3.4
    |> fade (toFloat game.win)
    -- Win
  , words black "Welcome! Press Enter to Start!"
    |> scale 2.8
    |> fade (if (game.win == 0) then (toFloat game.lock) else 0)
    -- Start
  , rectangle (if game.board.status == 1 then green else red) game.board.width game.board.height
    |> move game.board.x game.board.y
    -- board
  , circle darkBlue game.ball.radius
    |> move game.ball.x game.ball.y
    -- ball
  ] -- Bricks
  ++ List.foldl brick_shapes [] game.brick

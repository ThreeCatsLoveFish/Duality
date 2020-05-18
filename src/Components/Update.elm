module Components.Update exposing (update)

import Playground exposing (..)
import Components.Structure exposing (..)
import Components.Init exposing (init)

-- Judge the distance and check hit or not (board/brick)
check_hit : PosDir -> Pos -> Bool
check_hit ball board =
  if (abs(ball.y - board.y) < (ball.radius + board.height / 2)  -- (Y) just above board
  &&  abs(ball.x - board.x) < (ball.radius + board.width / 2))  -- (X) close to board
  then True else False

-- Judge whether the ball hit on the board
bounce : PosDir -> Pos -> Bool
bounce ball board =
  ball.toy < 0
  && abs(ball.x - board.x) < (ball.radius + board.width / 2)
  && (ball.y - board.y) < (ball.radius + board.height / 2)
  && ball.radius < (ball.y - board.y)

-- Judge whether the ball hit on the bricks
help_break : PosDir -> Pos -> Bool
help_break ball brick =
  brick.status == 1 &&  -- brick can be broken
  check_hit ball brick  -- check whether it hit

-- Ball hit the brick(s)
ball_hit : PosDir -> List Pos -> Bool
ball_hit ball bricks =
  List.any (help_break ball) bricks

-- Break the bricks
brick_break : PosDir -> Pos -> Pos
brick_break ball brick =
  if (help_break ball brick) then
    { brick | status = 0 }
  else
    brick

-- Judge whether all the bricks are broken
win_game : Pos -> Bool
win_game brick =
  if (brick.status == 0) then True else False

-- Update the main game process parameters
update : Computer -> GameParas -> GameParas
update computer game =
  -- Win the game!
  if game.win == 1 then
    { game | win =
      if computer.keyboard.enter then 0 else 1
      , lock = 1
    }
  -- Start Game Lock
  else if game.lock == 1 then
    { init | lock =
      if computer.keyboard.enter then 0 else 1
    }
  -- Normal Game
  else
    { board =
        { x =
            if game.board.x > 370 then 370                -- right wall
            else if game.board.x < -370 then -370         -- left wall
            else game.board.x + 2 * toX computer.keyboard -- go left or right
        , status =
            if game.ball.toy > 0 then 1 else 0
        , y = game.board.y
        , width = game.board.width
        , height = game.board.height
        }
    , ball =
        { tox =
            if (game.ball.x > 400 && game.ball.tox > 0)   -- right wall
            || (game.ball.x < -400 && game.ball.tox < 0)  -- left wall
            then -1 * game.ball.tox
            else game.ball.tox
        , toy =
            if (game.ball.y > 200 && game.ball.toy > 0)   -- ceiling
            || (bounce game.ball game.board)              -- hit the board
            || (ball_hit game.ball game.brick)            -- hit the board
            then -1 * game.ball.toy
            else game.ball.toy
        , x = game.ball.x + game.ball.tox
        , y = game.ball.y + game.ball.toy
        , radius = game.ball.radius
        }
    , lock =
        if game.ball.y < -450 then 1 else 0               -- Too low lose the game
    , brick =
        game.brick
        |> List.map (brick_break game.ball)
    , win =
        if (List.all win_game game.brick) then 1 else 0
    }
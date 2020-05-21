module Components.Update exposing (update)

import Playground exposing (..)
import Components.Structure exposing (..)
import Components.Init exposing (init)

-- Judge whether the ball hit on the board Y
bounce_x : PosDir -> Pos -> Bool
bounce_x ball board =
  (ball.tox > 0
  && (board.x - ball.x) >= (board.width / 2)
  && (board.x - ball.x) < (ball.radius + board.width / 2)
  && (ball.y - board.y) < (ball.radius + board.height / 2)
  && ball.radius < (ball.y - board.y))
  || (ball.tox < 0
  && (ball.x - board.x) >= (board.width / 2)
  && (ball.x - board.x) < (ball.radius + board.width / 2)
  && (ball.y - board.y) < (ball.radius + board.height / 2)
  && ball.radius < (ball.y - board.y))

-- Judge whether the ball hit on the board Y
bounce_y : PosDir -> Pos -> Bool
bounce_y ball board =
  ball.toy < 0
  && abs(ball.x - board.x) < (ball.radius + board.width / 2)
  && (ball.y - board.y) < (ball.radius + board.height / 2)
  && ball.radius < (ball.y - board.y)

-- Judge the distance and check hit or not (brick) X
check_hit_x : PosDir -> Pos -> Bool
check_hit_x ball board =
  if (abs(ball.y - board.y) <= (board.height / 2)  -- (Y) just above board
  &&  abs(ball.x - board.x) < (ball.radius + board.width / 2))  -- (X) close to board
  then True else False

-- Judge the distance and check hit or not (brick) Y
check_hit_y : PosDir -> Pos -> Bool
check_hit_y ball board =
  if (abs(ball.y - board.y) < (ball.radius + board.height / 2)  -- (Y) just above board
  &&  abs(ball.x - board.x) <= (board.width / 2))  -- (X) close to board
  then True else False

-- Judge the distance and check hit or not (brick) Corner
check_hit_corner : PosDir -> Pos -> Bool
check_hit_corner ball board =
  if -1 * ball.toy / abs(ball.toy) * (ball.y - board.y) > (board.height / 2)
  -- (Y) just above board
  && -1 * ball.toy / abs(ball.toy) * (ball.y - board.y) < (ball.radius + board.height / 2)
  -- (Y) just above board
  &&  -1 * ball.tox / abs(ball.tox) * (ball.x - board.x) > (board.width / 2)
  -- (X) close to board
  &&  -1 * ball.tox / abs(ball.tox) * (ball.x - board.x) < (ball.radius + board.width / 2)
  -- (X) close to board
  then True else False

-- Judge whether the ball hit on the bricks
judge_brick_break_x : PosDir -> Pos -> Bool
judge_brick_break_x ball brick =
  brick.status == 1 &&  -- brick can be broken
  ( check_hit_x ball brick
  || check_hit_corner ball brick  -- check whether it hit
  )

-- Judge whether the ball hit on the bricks
judge_brick_break_y : PosDir -> Pos -> Bool
judge_brick_break_y ball brick =
  brick.status == 1 &&  -- brick can be broken
  ( check_hit_y ball brick
  || check_hit_corner ball brick  -- check whether it hit
  )

-- Judge whether the ball hit on the bricks
judge_brick_break_all : PosDir -> Pos -> Bool
judge_brick_break_all ball brick =
  brick.status == 1 &&  -- brick can be broken
  ( check_hit_x ball brick || check_hit_y ball brick
  || check_hit_corner ball brick  -- check whether it hit
  )

-- Ball hit the brick(s) X
ball_hit_x : PosDir -> List Pos -> Bool
ball_hit_x ball bricks =
  List.any (judge_brick_break_x ball) bricks

-- Ball hit the brick(s) Y
ball_hit_y : PosDir -> List Pos -> Bool
ball_hit_y ball bricks =
  List.any (judge_brick_break_y ball) bricks

-- Break the bricks -> Change the brick's status
brick_break : PosDir -> Pos -> Pos
brick_break ball brick =
  if (judge_brick_break_all ball brick) then
    { brick | status = 0 }
  else
    brick

-- Judge whether all the bricks are broken -> Win or not
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
            if game.board.x > 370 + game.ball.radius
              then 370 + game.ball.radius                   -- right wall
            else if game.board.x < -370 - game.ball.radius
              then -370 - game.ball.radius                  -- left wall
            else game.board.x + 2 * toX computer.keyboard   -- go left or right
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
            || (bounce_x game.ball game.board)            -- hit the board
            || (ball_hit_x game.ball game.brick)          -- hit the brick
            then -1 * game.ball.tox
            else if (bounce_y game.ball game.board)       -- hit the board
            then game.ball.tox + 0.8 * toX computer.keyboard
            else game.ball.tox
        , toy =
            if (game.ball.y > 200 && game.ball.toy > 0)   -- ceiling
            || (bounce_y game.ball game.board)            -- hit the board
            || (ball_hit_y game.ball game.brick)          -- hit the brick
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
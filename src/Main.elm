module Main exposing (..)

import Playground exposing (..)

main =
  game view update init

-- Position (x, y) and direction (tox, toy)
type alias PosDir =
  { x : Number
  , y : Number
  , tox : Number
  , toy : Number
  }

-- Initialize the game
type alias GameParas =
  { lock : Int
  , board : PosDir
  , ball : PosDir
  , block : PosDir
  }

init : GameParas
init =
  { board =
      { x = 0
      , y = -200
      , tox = 0
      , toy = 0
      }
  , ball =
      { x = 0
      , y = -183
      , tox = 1
      , toy = 1
      }
  , block =
      { x = 20
      , y = 20
      , tox = 0
      , toy = 0
      }
  , lock =
      1
  }

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

update : Computer -> GameParas -> GameParas
update computer game =
  -- Start Game Lock
  if game.lock == 1 then
    { init | lock =
      if computer.keyboard.enter then
        0
      else
        game.lock
    }
  -- Normal Game
  else
    { board =
        { x =
           if game.board.x > 370 then
            370
           else if game.board.x < -370 then
            -370
           else
            game.board.x + 2 * toX computer.keyboard
        , y = game.board.y
        , tox = game.board.tox
        , toy = game.board.tox
        }
    , ball =
        { tox =
           if (game.ball.x > 400 && game.ball.tox > 0)
           || (game.ball.x < -400 && game.ball.tox < 0) then
            -1 * game.ball.tox
           else
            game.ball.tox
        , toy =
           if (game.ball.y > 200 && game.ball.toy > 0)
           || (abs(game.board.x - game.ball.x) <= 40 && game.ball.toy < 0
           && game.ball.y >= -190 && game.ball.y <= -187) then
            -1 * game.ball.toy
           else
             game.ball.toy
        , x = game.ball.x + game.ball.tox
        , y = game.ball.y + game.ball.toy
        }
    , lock =
        if game.ball.y < -250 then
          1
        else
          game.lock
    , block = game.block
    }

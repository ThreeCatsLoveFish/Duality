module Components.Update exposing (update)

import Playground exposing (..)
import Components.Structure exposing (GameParas)
import Components.Init exposing (init)

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
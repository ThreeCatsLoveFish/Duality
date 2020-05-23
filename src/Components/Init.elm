module Components.Init exposing (init)

import Components.Structure exposing (GameParas)

init : GameParas
init =
  { board =
      { x = 0, y = -200, status = 1, width = 60, height = 14}
  , ball =
      { x = 0, y = -183, tox = 2, toy = 2, radius = 10}
  , brick =
      -- Put your bricks here!
      [ { x = -40, y = -40, status = 1, width = 38, height = 18}
      , { x = -20, y = 40, status = 1, width = 38, height = 18}
      , { x = 0, y = -40, status = 1, width = 38, height = 18}
      , { x = 20, y = 40, status = 1, width = 38, height = 18}
      , { x = 40, y = -40, status = 1, width = 38, height = 18}
      ]
  , lock = 1
  , win = 0
  }
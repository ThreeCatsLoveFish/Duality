module Components.Init exposing (init)

import Components.Structure exposing (GameParas)

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
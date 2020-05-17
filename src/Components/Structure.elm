module Components.Structure exposing (GameParas)

-- Position (x, y) and direction (tox, toy)
type alias PosDir =
  { x : Float
  , y : Float
  , tox : Float
  , toy : Float
  }

-- Structure the game
type alias GameParas =
  { lock : Int
  , board : PosDir
  , ball : PosDir
  , block : PosDir
  }
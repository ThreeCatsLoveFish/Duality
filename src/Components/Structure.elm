module Components.Structure exposing (..)

-- Position (x, y) and direction (tox, toy)
type alias PosDir =
  { x : Float           -- X pos
  , y : Float           -- Y pos
  , tox : Float         -- Move X direction
  , toy : Float         -- Move Y direction
  , radius : Float      -- Radius
  }

-- Position (x, y)
type alias Pos =
  { x : Float           -- X pos
  , y : Float           -- Y pos
  , status : Int        -- Used for changing color
  , width : Float       -- Width
  , height : Float      -- Height
  }

-- Structure the game
type alias GameParas =
  { win : Int           -- Win the game
  , lock : Int          -- Control the game
  , board : Pos         -- User control the board
  , ball : PosDir       -- Ball
  , brick : List Pos    -- Brick
  }
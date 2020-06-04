module Bin.Types exposing (..)

import Bin.Message exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }

type alias Block =
    { lt : Point -- left top
    , rb : Point -- right bottom
    }

type alias Poly = List Point -- polygons for collision detection

type BrickStat
    = Hit Int -- Tim
    | NoMore

type alias Brick =
    { pos: Point -- may not be necessary
    , collision: Poly -- for hitCheck
    , block: Block
    , stat: BrickStat
    --, visual: Visual -- can get by collision
    }

type alias Wall =
    { block: Block
    }

type alias Ball =
    { pos: Point
    , v: Point -- Could be a function related to time?
    , r: Float
    , collision: Poly -- save for future change
    --, visible: Float -- Visible -- save for future change
    --, visual: Visual
    }

type PaddleStat
    = Ascending
    | Descending

type alias Paddle =
    { pos: Point -- may not be necessary
    , collision: Poly -- for hitCheck
    , block: Block
    , stat: PaddleStat
    --, visual: Visual -- can get by collision
    }

type alias Model =
    { ball: Ball
    , bricks: List Brick
    , paddle: Paddle
    , menu: Menu
    }

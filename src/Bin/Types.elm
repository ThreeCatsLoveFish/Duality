module Bin.Types exposing (..)

import Html exposing (Html, div)
import Bin.Msg exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }

type alias Block =
    { lb : Point -- left bottom
    , rt : Point
    }


-- Check if is in block
blockCheck : Block -> Point -> Bool
blockCheck block point =
    let
        lb = block.lb
        rt = block.rt
    in
    point.x >= lb.x && point.x <= rt.x && point.y >= lb.y && point.y <= rt.y

type alias Poly = List Point -- polygons for collision detection

-- Check if is hit
hitCheck : Poly -> Poly -> Bool
hitCheck ball brick =
    False
--    TODO: implement it

type alias Visual = Html Msg -- TODO: Could be replaced by separated view functions?

type BrickStat
    = Hit Int -- Tim
    | NoMore

type alias Brick =
    { pos: Point -- may not be necessary
    , collision: Poly --
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
    {-
    , collision: Poly -- save for future change
    , visible: Float/Visible -- save for future change
    -}
    --, visual: Visual
    }

type PaddleStat
    = Ascending
    | Descending

type alias Paddle =
    { pos: Point -- may not be necessary
    , collision: Poly --
    , block: Block
    , stat: PaddleStat
    --, visual: Visual -- can get by collision
    }

type alias GameModel =
    { ball: Ball
    , bricks: List Brick
    , paddle: Paddle
    }


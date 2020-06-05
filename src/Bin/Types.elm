module Bin.Types exposing (..)

import Bin.Message exposing (..)


type alias AnimationState =
    Maybe
        { active : Bool
        , elapsed : Float
        }

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


type alias Info =
    { canvas : { w:Float, h:Float }
    , brick : { w:Float, h:Float }
    , layout : { x:Int, y:Int }
    , ball : { d:Float, v:Point, precision:Int }
    , paddle : { w:Float, h:Float }
    , breath : Float
    }


type alias Model =
    { ball: Ball
    , bricks: List Brick
    , paddle: Paddle
    , menu: Menu

    , dir: Maybe Op
    , clock: Float
    }

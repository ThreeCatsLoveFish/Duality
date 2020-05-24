module Bin.Initial exposing (..)
import Bin.Types exposing (..)
import Bin.Message exposing (..)

-- this file is somehow debug friendly; this gives lots of handly initializations

init : ( GameModel, Cmd Msg )
init =
    ( { ball = {pos={x=0,y=0}, v={x=0,y=0}, r=1 }
      , bricks = [brickZero]
      , paddle = paddleZero
      }
    , Cmd.none
    )

pointZero : Point
pointZero = Point 0 0

-- return a rectangle collision
polySquare : Point -> Float -> Float -> Poly
polySquare center height width =
    [ { x = center.x - width/2, y = center.y - height/2}
    , { x = center.x - width/2, y = center.y + height/2}
    , { x = center.x + width/2, y = center.y + height/2}
    , { x = center.x + width/2, y = center.y - height/2}
    ]

brickZero : Brick
brickZero =
    { pos=pointZero
    , collision=(polySquare pointZero 1 1)
    , block={lb=(Point -1 -1),rt=(Point 1 1)}
    , stat=Hit 0
    }

paddleZero : Paddle
paddleZero =
    { pos=pointZero
    , collision=(polySquare pointZero 1 1)
    , block={lb=(Point -1 -1),rt=(Point 1 1)}
    , stat=Ascending
    }

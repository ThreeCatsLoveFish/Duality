module Bin.Initial exposing (..)
import Bin.Types exposing (..)
import Bin.Message exposing (..)

-- this file is somehow debug friendly; this gives lots of handly initializations
--import List exposing (range, map)

init : ( Model, Cmd Msg )
--init : Model
init =
    let -- easy to change the value or add input
        canvas = { w = 800, h = 600 } -- (-400, 400), (-300, 300)
        brick = { w = 60, h = 37 }
        layout = { x = 12, y = 7 }
        ball = { d = 20 }
        paddle = { w = 100, h = 15 }

        -- Ball part
        newBall = Ball (Point 0 (-canvas.h/2+paddle.h+ball.d/2)) (Point 0 0) 1

        -- transfer prepare
        pos2coll pos object =
            let
                w = object.w /2
                h = object.h /2
                x = pos.x
                y = pos.y
            in
            [ Point (x + w) (y + h)
            , Point (x - w) (y + h)
            , Point (x - w) (y - h)
            , Point (x + w) (y - h)
            ]
        pos2block pos object =
            let
                w = object.w /2
                h = object.h /2
                x = pos.x
                y = pos.y
            in
            Block (Point (x - w) (y - h)) (Point (x + w) (y + h))

        -- Brick part
        positionConvert len unit =
            (List.range 1 len)
                |> List.map toFloat
                |> List.map (\x -> x - 0.5 - (toFloat len) /2 )
                |> List.map (\x -> x * unit)
        posBrickX = positionConvert layout.x brick.w -- get x
        posBrickY = positionConvert layout.y brick.h |> List.map (\x -> x + (layout.y*brick.h/2) ) -- get y by proportion TODO: beautify
        posBricks = List.map (\x -> List.map (Point x) posBrickY) posBrickX |> List.concat -- get pos
        --newBrick pos =
        --    Brick pos (pos2coll pos) (pos2block pos) (Hit 0)
        newBricks = List.map (\pos -> Brick pos (pos2coll pos brick) (pos2block pos brick) (Hit 0)) posBricks -- get bricks

        -- Paddle part
        newPaddle =
            let
                pos = Point 0 (-canvas.h/2+paddle.h/2)
            in
            Paddle pos (pos2coll pos paddle) (pos2block pos paddle) Ascending
    in
    {--}
    ( Model newBall newBricks newPaddle Startup
    , Cmd.none
    )
    --}
    --Model newBall newBricks newPaddle Startup


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

module Bin.Initial exposing (init, reInit)
import Bin.Types exposing (..)
import Bin.Message exposing (..)

-- this file is somehow debug friendly; this gives lots of handy initializations
--import List exposing (range, map)

init : ( Model, Cmd Msg )
--init : Model
init =
    let -- easy to change the value or add input
        info : Info
        info =
            { canvas = { w = 800, h = 600 } -- (0, 800), (0, 600)
            , brick = { w = 60, h = 37 }
            , layout = { x = 12, y = 7 }
            , ball = { d = 20, v = Point 3.0 -3.0, precision = 16 }
            , paddle = { w = 100, h = 15 }
            , breath = 10
            }
        xm = info.canvas.w
        ym = info.canvas.h
        lw = Block (Point -100 0) (Point 0 ym)
        rw = Block (Point xm 0) (Point (xm+100) ym)
        tw = Block (Point 0 -100) (Point xm 0)
        dw = Block (Point 0 ym) (Point xm (ym+100))
    in
    {--}
    ( Model ( newBall info ) ( newBricks info ) ( newPaddle info ) [lw, rw] [tw] [dw]
    Startup ( Just Stay ) 0 info
    , Cmd.none
    )
    --}
    --Model newBall newBricks newPaddle Startup

reInit : Model -> Info -> Model
reInit model info =
    let
        xm = info.canvas.w
        ym = info.canvas.h
        lw = Block (Point -100 0) (Point 0 ym)
        rw = Block (Point xm 0) (Point (xm+100) ym)
        tw = Block (Point 0 -100) (Point xm 0)
        dw = Block (Point 0 ym) (Point xm (ym+100))
    in
    Model ( newBall info ) ( newBricks info ) ( newPaddle info ) [lw, rw] [tw] [dw]
    Startup ( Just Stay ) 0 info


-- Ball part
newBall : Info -> Ball
newBall info =
    let
        position = Point (info.canvas.w/2) (info.canvas.h - info.paddle.h - info.ball.d/2 - info.breath)
        -- Get the collision, precision: how many points
        getColl : (Point, Float, Int) -> Poly
        getColl (pos, r, precision) =
            let
                angle = List.range 0 (precision - 1) |> List.map (\x -> (toFloat x) / (toFloat precision) * 2 * pi)
                points = angle |> List.map (\t -> Point (pos.x + r * cos t) (pos.y + r * sin t))
            in
            points
    in
    Ball position info.ball.v (info.ball.d/2) (getColl (position,(info.ball.d/2), info.ball.precision))


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

newBricks : Info -> List Brick
newBricks info =
    let
        positionConvert len unit =
            (List.range 1 len)
                |> List.map toFloat
                |> List.map (\x -> x - 0.5 - (toFloat len) /2 )
                |> List.map (\x -> x * unit)
        posBrickX =
            positionConvert info.layout.x (info.brick.w + 0.5*info.breath)
            |> List.map (\x -> x + info.canvas.w/2) -- get x
        posBrickY =
            positionConvert info.layout.y (info.brick.h + 0.5*info.breath)
            |> List.map (\x -> x + (toFloat info.layout.y*info.brick.h/2) + 2*info.breath)
            -- get y by proportion TODO: beautify
        posBricks =
            List.map (\x -> List.map (Point x) posBrickY) posBrickX |> List.concat -- get pos
        --newBrick pos =
        --    Brick pos (pos2coll pos) (pos2block pos) (Hit 0)
    in
    List.map (\pos -> Brick pos (pos2coll pos info.brick) (pos2block pos info.brick) (Hit 0)) posBricks
    -- get bricks

-- Paddle part
newPaddle : Info -> Paddle
newPaddle info =
    let
        pos = Point (info.canvas.w/2) (info.canvas.h - info.paddle.h/2 - info.breath)
    in
    Paddle pos (pos2coll pos info.paddle) (pos2block pos info.paddle) Ascending

{-

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
    { pos = pointZero
    , collision = (polySquare pointZero 1 1)
    , block = { lt = (Point -1 -1), rb = (Point 1 1) }
    , stat = Hit 0
    }

paddleZero : Paddle
paddleZero =
    { pos = pointZero
    , collision = (polySquare pointZero 1 1)
    , block = { lt = (Point -1 -1), rb = (Point 1 1) }
    , stat = Ascending
    }
-}

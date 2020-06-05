module Bin.Initial exposing (init)
import Bin.Types exposing (..)
import Bin.Message exposing (..)

-- this file is somehow debug friendly; this gives lots of handy initializations
--import List exposing (range, map)

init : ( Model, Cmd Msg )
--init : Model
init =
    let -- easy to change the value or add input
        canvas = { w = 800, h = 600 } -- (0, 800), (0, 600)
        brick = { w = 60, h = 37 }
        layout = { x = 12, y = 7 }
        ball = { d = 20 }
        paddle = { w = 100, h = 15 }
        breath = 10

        -- Ball part
        newBall =
            let
                position = Point (canvas.w/2) (canvas.h - paddle.h - ball.d/2 - breath)
                -- Get the collision, precision: how many points
                getColl : (Point, Float, Int) -> Poly
                getColl (pos, r, precision) =
                    let
                        angle = List.range 0 (precision - 1) |> List.map (\x -> (toFloat x) / (toFloat precision) * 2 * pi)
                        points = angle |> List.map (\t -> Point (pos.x + r * cos t) (pos.y + r * sin t))
                    in
                    points
            in
            Ball position (Point 7.07 -7.07) (ball.d/2) (getColl (position,(ball.d/2),16))


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
        posBrickX = positionConvert layout.x (brick.w + 0.5*breath) 
            |> List.map (\x -> x + canvas.w/2) -- get x
        posBrickY = positionConvert layout.y (brick.h + 0.5*breath) 
            |> List.map (\x -> x + (layout.y*brick.h/2) + 2*breath) -- get y by proportion TODO: beautify
        posBricks = List.concatMap (\x -> List.map (Point x) posBrickY) posBrickX -- get pos
        --newBrick pos =
        --    Brick pos (pos2coll pos) (pos2block pos) (Hit 0)
        newBricks =
            List.map (\pos -> Brick pos (pos2coll pos brick) (pos2block pos brick) (Hit 0)) posBricks
            -- get bricks

        -- Paddle part
        newPaddle =
            let
                pos = Point (canvas.w/2) (canvas.h - paddle.h/2 - breath)
            in
            Paddle pos (pos2coll pos paddle) (pos2block pos paddle) Ascending
    in
    {--}
    ( Model newBall newBricks newPaddle Startup Stay 0
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

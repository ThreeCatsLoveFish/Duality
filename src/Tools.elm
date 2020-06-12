module Tools exposing (..)

import Html exposing (div)
import Messages exposing (GameLevel(..), GameStatus(..))
import Model exposing (..)


dummyPoint : Point
dummyPoint =
    Point 0 0

dummyBlock : Block
dummyBlock =
    Block dummyPoint dummyPoint

dummyPoly : Poly
dummyPoly =
    List.repeat 4 dummyPoint

dummyColor : Color
dummyColor =
    rgb 0 0 0

dummyBall : Ball
dummyBall =
    let
        pos = dummyPoint
        v = dummyPoint
        r = 0
    in
    { active = False
    , pos = pos
    , v = v
    , r = r
    , collision = dummyPoly
    , color = dummyColor
    }

getBall : List Ball -> Int -> Ball
getBall lst n =
    case n of
        1 ->
            List.head lst
                |> Maybe.withDefault dummyBall
        _ -> getBall (List.drop 1 lst) (n - 1)

getBallColl : (Point, Float, Int) -> Poly
getBallColl (pos, r, precision) =
    let
        angle = List.range 0 (precision - 1) |> List.map (\x -> (toFloat x) / (toFloat precision) * 2 * pi)
        points = angle |> List.map (\t -> Point (pos.x + r * cos t) (pos.y + r * sin t))
    in
    points

dummyPaddle : Paddle
dummyPaddle =
    Paddle dummyPoint dummyPoly dummyBlock dummyColor 0 0 0

getPaddle : List Paddle -> Int -> Paddle
getPaddle lst n =
    case n of
        1 ->
            List.head lst
                |> Maybe.withDefault dummyPaddle
        _ -> getPaddle (List.drop 1 lst) (n - 1)

getPaddleColl : Point -> Float -> Float -> Float -> Int -> Poly
getPaddleColl pos r h angle precision =
    let
        unitAngle = 2*angle/(toFloat precision - 1)
        points = List.range 0 (precision - 1) |> List.map (\x -> toFloat x)
        initAngle = (pi/2) - angle
        surfaceR = r + h
        toPoints t =
            Point
                (pos.x + surfaceR * cos (unitAngle * t + initAngle))
                (pos.y - surfaceR * sin (unitAngle * t + initAngle))
    in
    List.reverse <| List.map toPoints points

dummyState : State
dummyState = { name = "dummy"
             , value = 0
             , t = 0
             , function = Func (\m _ -> m)
             , loop = False
             }

getState : List State -> String -> State
getState states name =
    let
        state_ = List.filter (\s -> s.name == name) states
        state = Maybe.withDefault dummyState (List.head state_)
    in
    state

divState : List State -> String -> (State, List State)
divState states name =
    let
        (state_, lst) = List.partition (\s -> s.name == name) states
        state = Maybe.withDefault dummyState (List.head state_)
    in
    ( state, lst )

dummyBrick : Brick
dummyBrick =
    Brick dummyPoint dummyPoly dummyBlock NoMore dummyColor

-- Brick part

type alias BrickInfo =
    { layout : {x:Int, y:Int}
    , canvas : {w:Float, h:Float}
    , brick : {w:Float, h:Float}
    , breath : Float
    , offset : Point
    , color : Color
    }

newBricks : BrickInfo -> List Brick
newBricks info =
    let
        positionConvert len unit =
            (List.range 1 len)
                |> List.map toFloat
                |> List.map (\x -> x - 0.5 - (toFloat len) /2 )
                |> List.map (\x -> x * unit)
        posBrickX =
            positionConvert info.layout.x (info.brick.w + info.breath)
            |> List.map (\x -> x + info.canvas.w/2 + info.offset.x) -- get x
        posBrickY =
            positionConvert info.layout.y (info.brick.h + info.breath)
            |> List.map (\y -> y + info.canvas.h/2 + info.offset.y)
            -- get y by proportion TODO: beautify
        posBricks =
            List.concatMap (\x -> List.map (Point x) posBrickY) posBrickX -- get pos
        --newBrick pos =
        --    Brick pos (pos2coll pos) (pos2block pos) (Hit 0)
    in
    List.map (\pos -> Brick pos (pos2coll pos info.brick) (pos2block pos info.brick) (Hit 0) info.color) posBricks
    -- get bricks

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


dummyModel : Model
dummyModel =
    Model Start0 AnimationPass
        [] [] []
        []
        {w=0,h=0} (0, 0) 0 True False
        (div [] [])

divState : List State -> String -> (State, List State)
divState states name =
    let
        (state_, lst) = List.partition (\s -> s.name == name) states
        state = Maybe.withDefault dummyState (List.head state_)
    in
    ( state, lst )

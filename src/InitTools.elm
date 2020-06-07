module InitTools exposing (..)

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



dummyBrick : Brick
dummyBrick =
    Brick dummyPoint dummyPoly dummyBlock NoMore dummyColor

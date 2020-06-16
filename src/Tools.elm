module Tools exposing (..)

import Html exposing (div)
import Messages exposing (GameLevel(..), GameStatus(..))
import Model exposing (..)


dummyPoint : Point
dummyPoint =
    Point 0 0


distance : Point -> Point -> Float
distance p1 p2 =
    sqrt ((p1.x - p2.x)^2 + (p1.y - p2.y)^2)

--norm : Point -> Float
--norm = distance (Point 0 0)


dummyBlock : Block
dummyBlock =
    Block dummyPoint dummyPoint


dummyPoly : Poly
dummyPoly =
    --List.repeat 4 dummyPoint
    []


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
        pos_ = Point (pos.x) (pos.y+5)
        rulerAngle = angle+1.2
        length = toFloat (precision - 1)
        points = List.range 0 (precision - 1)
            |> List.map (\x -> ( (toFloat x) - length / 2) / length)
        surfaceR = r + h + 5
        toPoints t =
            Point
                (pos_.x + surfaceR * sin (rulerAngle * t))
                (pos_.y - surfaceR * cos (rulerAngle * t))
    in
    List.map toPoints points
    --let
    --    unitAngle = 2*(angle+0.2)/(toFloat precision - 1)
    --    points = List.range 0 (precision - 1) |> List.map (\x -> toFloat x)
    --    initAngle = (pi/2) - angle
    --    surfaceR = r + h + 4
    --    toPoints t =
    --        Point
    --            (pos.x + surfaceR * cos (unitAngle * t + initAngle))
    --            (pos.y - surfaceR * sin (unitAngle * t + initAngle))
    --in
    --List.reverse <| List.map toPoints points

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


getStateValue : List State -> Float -> State
getStateValue states value =
    let
        state_ = List.filter (\s -> s.value == value) states
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

dummyStateManagement : String -> Float -> (Model -> Float -> Model)
dummyStateManagement name end =
    let
        dummy_ model _ =
            let
                (s_, state_) = divState model.state name
            in
            case s_.t > end of
                True ->
                    { model | state = state_ }
                _ ->
                    { model | state = s_ :: state_ }
    in
    dummy_

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
            -- get y by proportion
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

pos2blockL pos object =
    let
        w = object.w /2 + 3.51
        h = object.h /2 + 3.51
        x = pos.x
        y = pos.y
    in
    Block (Point (x - w) (y - h)) (Point (x + w) (y + h))


dummyModel : Model
dummyModel =
    Model Start0 AnimationPass
        [] [] []
        []
        {w=0,h=0} (0, 0) 0 True AniStop False
        (div [] [])

nextLevel model =
    let
        next =
            case model.gameLevel of
                Start0 -> Strangers1
                Strangers1 -> Friends2
                Friends2 -> Lovers3
                Lovers3 -> Strangers4
                Strangers4 -> Companions5
                Companions5 -> Death6
                Death6 -> End7
                _ -> Start0
    in
    { model
    | gameStatus = ChangeLevel
    , gameLevel = next
    }
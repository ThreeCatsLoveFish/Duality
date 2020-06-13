module Friends2.Find exposing (..)

import Tools exposing (..)
import Model exposing (..)

find : List Brick -> Int -> (Point, Int)
find bricks lastIndex =
    let
        index = (modBy (List.length bricks) ) lastIndex * 1664525
        pos = (getBrick bricks index).pos
    in
    (pos,index)

getBrick : List Brick -> Int -> Brick
getBrick lst n =
    List.indexedMap (\i brick -> if (i==n) then Just brick else Nothing ) lst
        |> List.filter (\e -> e /= Nothing)
        |> List.map (\b -> Maybe.withDefault dummyBrick b)
        |> List.head
        |> Maybe.withDefault dummyBrick
    --case n of
    --    1 ->
    --        (List.head lst)
    --            |> Maybe.withDefault {dummyBrick|pos=Point(30)(20)}
    --    _ -> getBrick (List.drop 1 lst) (n - 1)

--find : List Brick -> Int -> (Brick, Int)
--find bricks lastIndex =
--    let
--        index = (modBy (List.length bricks) ) lastIndex * 1664525
--        brick = (getBrick bricks index)
--    in
--    case brick.hitTime of
--        NoMore ->
--            (find bricks index)
--        _ ->
--            (brick, index)

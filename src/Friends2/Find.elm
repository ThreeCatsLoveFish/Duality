module Friends2.Find exposing (..)

import Tools exposing (..)
import Model exposing (..)

find : List Brick -> Int -> (Point, Int)
find bricks lastIndex =
    let
        vb = List.filter (\b -> b.hitTime /= NoMore) bricks
        i = modBy (List.length vb) (lastIndex * 77) + 1
        pos = (getBrick vb i).pos
        index = getIndexByPoint bricks pos
    in
    ( pos, index )

getIndexByPoint : List Brick -> Point -> Int
getIndexByPoint bricks point =
    bricks
        |> List.indexedMap (\i b -> if point == b.pos then i else -1 )
        |> List.foldl (\a r -> max a r) -1
        |> (+) 1

getBrick : List Brick -> Int -> Brick
getBrick lst n =
    lst
        |> List.indexedMap (\i brick -> if (i+1==n) then Just brick else Nothing )
        |> List.filter (\e -> e /= Nothing)
        |> List.map (\b -> Maybe.withDefault dummyBrick b)
        |> List.head
        |> Maybe.withDefault dummyBrick
    --case n of
    --    1 ->
    --        (List.head lst)
    --            |> Maybe.withDefault {dummyBrick|pos=Point(30)(20)}
    --    _ -> getBrick (List.drop 1 lst) (n - 1)


--find : List Brick -> Int -> (Point, Int)
--find bricks lastIndex =
--    let
--        i = modBy (List.length bricks) (lastIndex * 77 + 2) + 1
--        --i = modBy (List.length bricks) (lastIndex * 1664525) + 1
--        brick = getBrick bricks i
--    in
--    case brick.hitTime of
--        NoMore -> find bricks (i+1)
--        _ -> (brick.pos, i)


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

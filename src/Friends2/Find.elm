module Friends2.Find exposing (..)

import Tools exposing (dummyBrick)
import Model exposing (..)
import Messages exposing (..)

find : List Brick -> Int -> (Point, Int)
find bricks lastIndex =
    let
        index = (modBy (List.length bricks) ) lastIndex * 1664525
        get : List Brick -> Int -> Brick
        get lst n =
            case n of
                1 ->
                    List.head lst
                        |> Maybe.withDefault dummyBrick
                _ -> get (List.drop 1 lst) (n - 1)
        pos = (get bricks index).pos
    in
    (pos,index)

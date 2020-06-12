module Strangers4.State exposing (..)
import Bezier exposing (bezierColor)
import Model exposing (Brick, Color, HitTime(..), Model, Point, rgb)


genBezierColor : Color -> Color -> (Model -> Float -> Model)
genBezierColor p1 p2 =
    let
        bezier = bezierColor p1 p2
        bezierBrickColor : Model -> Float -> Model
        bezierBrickColor model_ t_ =
            let
                targetBrick =
                    model_.bricks
                    |> List.map (\a ->
                                case a.hitTime of
                                    Hit 1 ->
                                        if a.color /= rgb 208 19 72
                                        then { a | color = bezier t_ }
                                        else a
                                    _ -> a
                                )
            in
            { model_ | bricks = targetBrick}
    in
    bezierBrickColor

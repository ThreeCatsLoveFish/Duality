module Strangers4.State exposing (..)
import Bezier exposing (bezierColor)
import Fade exposing (fadeOut)
import Model exposing (Brick, Color, HitTime(..), Model, Point, StateFunc(..), rgb)

startColor = rgb 75 213 232
endColor = rgb 208 19 72

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
                                        if a.color /= endColor
                                        then { a | color = bezier t_ }
                                        else a
                                    _ -> a
                                )
            in
            { model_ | bricks = targetBrick}
    in
    bezierBrickColor

getEndState : Model -> Model
getEndState model =
    let
        s1 = { name = "fadeOut"
            , value = 0
            , t = -1
            , function = Func (fadeOut)
            , loop = False
            }
    in
    { model | state = [s1] }

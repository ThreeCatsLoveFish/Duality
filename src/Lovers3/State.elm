module Lovers3.State exposing (..)
import Bezier exposing (bezierPos)
import Model exposing (Model, Point, Block)


bezierBrick : Model -> Float -> Model
bezierBrick model t =
    let
        center = Point (model.canvas.w/2) (model.canvas.h/2)
        pos2curve pos =
            let
                outpoint = vecAway pos center 30
                bezier = bezierPos center outpoint outpoint center
            in
            bezier
        bricks_ = model.bricks
        bricks =
            bricks_
                |> List.map (\b ->
                        { b
                        | pos = (pos2curve b.pos) t
                        , block = Block ((pos2curve b.block.lt) t) ((pos2curve b.block.rb) t)
                        , collision = List.map (\p -> (pos2curve p) t) b.collision
                        }
                    )
    in
    { model | bricks = bricks }

getSpeed : Point -> Float
getSpeed v =
    (v.x^2+v.y^2) |> sqrt

vecAway : Point -> Point -> Float -> Point
vecAway target origin distance =
    let
        x = (target.x - origin.x)*distance + target.x
        y = (target.y - origin.y)*distance + target.y
    in
    Point x y

convertSpeed : Point -> Float -> Point
convertSpeed v speed =
    let
        vN = getSpeed v
    in
    Point (v.x/vN*speed) (v.y/vN*speed)
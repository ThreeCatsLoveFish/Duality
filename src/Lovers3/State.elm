module Lovers3.State exposing (..)
import Bezier exposing (bezierPos)
import Model exposing (Model, Point, Block)
import Tools exposing (divState, getBall, getState)


bezierBrick : Model -> Float -> Model
bezierBrick model t_ =
    let
        (s_, state_e) = divState model.state "heart"
        s = s_

        t = timeMap t_

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
        ball_ = getBall model.ball 1
        ball = [{ ball_ | v = (convertSpeed ball_.v s.value) }]
    in
    { model | bricks = bricks, ball = ball, state = s :: state_e }

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

timeMap : Float -> Float
timeMap t_ =
    t_

speedMap : Int -> Float
speedMap int =
    let
        vInit = 4
        brickInit = 0
    in
    4 + (0)


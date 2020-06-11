module Strangers1.State exposing (..)
import Bezier exposing (bezierPosPos)
import Tools exposing (getBall)
import Model exposing (Model, Point)


genBezierBall2 : Point -> Point -> Point -> Point -> (Model -> Float -> Model)
genBezierBall2 p1 p2 p3 p4 =
    let
        bezier = bezierPosPos p1 p2 p3 p4
        bezierBall2 : Model -> Float -> Model
        bezierBall2 model_ t_ =
            let
                ball1 = getBall model_.ball 1
                ball2 = getBall model_.ball 2
                ball2_ = { ball2 | pos = bezier t_ }
            in
            { model_ | ball = [ball1, ball2_] }
    in
    bezierBall2

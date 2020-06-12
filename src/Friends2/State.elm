module Friends2.State exposing (..)
import Bezier exposing (bezierPoly)
import Tools exposing (getBall, getState)
import Model exposing (Model, Point, Poly)
import Friends2.Find exposing (..)


genBezierBall2 : Poly -> (Model -> Float -> Model)
genBezierBall2 poly=
    let
        bezier = bezierPoly poly
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

genMoveBall2 : (Model -> Float -> Model)
genMoveBall2 =
    let
        moveBall2 : Model -> Float -> Model
        moveBall2 model_ t_ =
            let
                ball1 = getBall model_.ball 1
                ball2 = getBall model_.ball 2
                ball2_ =
                    ( if (t_==0) then
                        { ball2 | pos = Tuple.first (find model_.bricks (round (getState model_.state "moveBall2").value)) }
                      else ball2
                    )
            in
            { model_ | ball = [ball1, ball2_] }
    in
    moveBall2

module Strangers4.CollisionBlock exposing (block_hit, paddle_hit)
import Tools exposing (getBall)
import Model exposing (Ball, Block, Brick, HitTime(..), Model, Paddle, StateFunc(..))
import CollisionBlock exposing (Hit(..), block_black_box_hit, xyToCorner)

import Strangers4.State exposing (..)


-- Direction
ball_direction : Ball -> List Brick -> Hit
ball_direction ball box =
    let
        init = Safe
        hit block status =
            let
                tmp = List.head block
                next_tmp = List.tail block
            in
            case next_tmp of
                Just tail ->
                    case tmp of
                        Just head ->
                            case head.hitTime of
                                Hit _ ->
                                    xyToCorner status (hit tail (block_black_box_hit ball head.block))
                                _ -> hit tail status
                        Nothing -> status
                Nothing ->
                    case tmp of
                        Just head ->
                            case head.hitTime of
                                Hit _ ->
                                    xyToCorner status (hit [] (block_black_box_hit ball head.block))
                                _ -> status
                        Nothing -> status
    in
    hit box init


-- Direction
ball_direction_paddle : Ball -> List Paddle -> Hit
ball_direction_paddle ball box =
    let
        init = Safe
        hit paddle status =
            let
                tmp = List.head paddle
                next_tmp = List.tail paddle
            in
            case next_tmp of
                Just tail ->
                    case tmp of
                        Just head ->
                            xyToCorner status (hit tail (block_black_box_hit ball head.block))
                        Nothing -> status
                Nothing ->
                    case tmp of
                        Just head ->
                            xyToCorner status (hit [] (block_black_box_hit ball head.block))
                        Nothing -> status
    in
    hit box init


-- Black Box
block_black_box_hitTime: Ball -> Block -> Int -> HitTime
block_black_box_hitTime ball block a =
    let
        hit =
            block_black_box_hit ball block
        hit_time =
            case hit of
                Safe -> Hit a
                _ -> Hit (a + 1)
    in
    hit_time


-- Model
block_hit : Model -> Model
block_hit model =
    let
        now_ball1 = getBall model.ball 1
        now_bricks = model.bricks
        status = ball_direction now_ball1 now_bricks
    in
    { model
    | bricks =
        now_bricks
        |> List.map (\a ->
                        case a.hitTime of
                            Hit b -> { a | hitTime = block_black_box_hitTime now_ball1 a.block b }
                            _ -> a
                        )
    , ball = [{ now_ball1
                | v =
                    case status of
                        Safe -> now_ball1.v
                        X -> { x = -now_ball1.v.x, y = now_ball1.v.y }
                        Y -> { x = now_ball1.v.x, y = -now_ball1.v.y }
                        Corner -> { x = -now_ball1.v.x, y = -now_ball1.v.y }
             }] ++ model.ball
    , state =
        model.state ++
        case status of
            Safe -> []
            _ -> [{ name = "Color"
                  , value = 0
                  , t = 0
                  , function = Func genBezierColor
                  , loop = True
                  }]
    }


-- Model
paddle_hit : Model -> Model
paddle_hit model =
    let
        now_ball1 = getBall model.ball 1
        now_paddle = model.paddle
        status = ball_direction_paddle now_ball1 now_paddle
    in
    { model
    | ball = [{ now_ball1
                | v =
                    case status of
                        Safe -> now_ball1.v
                        X -> { x = -now_ball1.v.x, y = now_ball1.v.y }
                        Y -> { x = now_ball1.v.x, y = -now_ball1.v.y }
                        Corner -> { x = -now_ball1.v.x, y = -now_ball1.v.y }
             }] ++ model.ball
    }


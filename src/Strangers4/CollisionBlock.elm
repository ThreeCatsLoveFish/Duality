module CollisionBlock4 exposing (basic_hit4)
import Tools exposing (getBall)
import Model exposing (Ball, Block, Brick, HitTime(..), Model, StateFunc(..), rgb)
import CollisionBlock exposing (Hit(..), ball_direction, block_black_box_hit)
import Strangers4.State exposing (..)

-- Black Box 1
block_black_box_hitTime1: Ball -> Block -> HitTime
block_black_box_hitTime1 ball block =
    let
        hit =
            block_black_box_hit ball block
        hit_time =
            case hit of
                Safe -> Hit 0
                _ -> Hit 1
    in
    hit_time

-- Black Box 2
block_black_box_hitTime2: Ball -> Block -> HitTime
block_black_box_hitTime2 ball block =
    let
        hit =
            block_black_box_hit ball block
        hit_time =
            case hit of
                Safe -> Hit 1
                _ -> Hit 2
    in
    hit_time


-- Model
basic_hit4 : Model -> Model
basic_hit4 model =
    let
        now_ball1 = getBall model.ball 1
        now_ball2 = getBall model.ball 2
        now_bricks = model.bricks
        status = ball_direction now_ball1 now_bricks
    in
    { model
    | bricks =
        now_bricks
        |> List.map (\a ->
                        case a.hitTime of
                            Hit 0 -> { a | hitTime = block_black_box_hitTime1 now_ball1 a.block }
                            Hit 1 -> { a | hitTime = block_black_box_hitTime2 now_ball1 a.block }
                            _ -> a
                        )
    , ball = [{ now_ball1
                | v =
                    case status of
                        Safe -> now_ball1.v
                        X -> { x = -now_ball1.v.x, y = now_ball1.v.y }
                        Y -> { x = now_ball1.v.x, y = -now_ball1.v.y }
                        Corner -> { x = -now_ball1.v.x, y = -now_ball1.v.y }
             }, now_ball2]
    , state =
        model.state ++
        case status of
            Safe -> []
            _ -> [{ name = "Color"
                  , value = 2
                  , t = 0
                  , function = Func (genBezierColor (rgb 75 213 232) (rgb 208 19 72))
                  , loop = True
                  }]
    }


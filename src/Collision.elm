module Collision exposing (basic_hit)
import Tools exposing (getBall)
import Model exposing (Ball, Brick, Block, Model, HitTime(..))


-- Status of collision
type Hit
    = Safe
    | X
    | Y
    | Corner


-- Judge whether the ball hit on the Block -X
block_x : Ball -> Block -> Hit
block_x ball block =
    let
        lt = block.lt
        rb = block.rb
    in
    if ((ball.v.x > 0 -- to right
    && lt.x + ball.r >= ball.pos.x && lt.x - ball.pos.x <= ball.r)
    || (ball.v.x < 0 -- to left
    && rb.x - ball.r <= ball.pos.x && rb.x - ball.pos.x >= -ball.r))
    && ball.pos.y > lt.y && ball.pos.y < rb.y
    then X else Safe


-- Judge whether the ball hit on the Block -Y
block_y : Ball -> Block -> Hit
block_y ball block =
    let
        lt = block.lt
        rb = block.rb
    in
    if ((ball.v.y > 0 -- to down
    && ball.pos.y - lt.y <= ball.r && ball.pos.y + ball.r >= lt.y)
    || (ball.v.y < 0 -- to up
    && ball.pos.y - rb.y >= -ball.r && ball.pos.y - ball.r <= rb.y))
    && ball.pos.x < rb.x && ball.pos.x > lt.x
    then Y else Safe


-- Judge whether the ball hit on the Block Corner
block_corner : Ball -> Block -> Hit
block_corner ball block =
    let
        bx = (block.rb.x + block.lt.x) / 2
        by = (block.rb.y + block.lt.y) / 2
        height = block.rb.y - block.lt.y
        width = block.rb.x - block.lt.x
    in
    if -1 * ball.v.y / abs(ball.v.y) * (ball.pos.y - by) > (height / 2)
    -- (Y) just above board
    && -1 * ball.v.y / abs(ball.v.y) * (ball.pos.y - by) < (ball.r / 3 + height / 2)
    -- (Y) just above board
    && -1 * ball.v.x / abs(ball.v.x) * (ball.pos.x - bx) > (width / 2)
    -- (X) close to board
    && -1 * ball.v.x / abs(ball.v.x) * (ball.pos.x - bx) < (ball.r / 3 + width / 2)
    -- (X) close to board
    then Corner else Safe

-- Black Box
block_black_box_hitTime: Ball -> Block -> HitTime
block_black_box_hitTime ball block =
    let
        hit =
            block_black_box_hit ball block
        hit_time =
            case hit of
                Safe -> Hit 0
                _ -> Hit 1
    in
    hit_time

-- Black Box
block_black_box_hit: Ball -> Block -> Hit
block_black_box_hit ball block =
    let
        hit_x = block_x ball block
        hit_y = block_y ball block
        hit_corner = block_corner ball block
        hit =
            case hit_corner of
                Corner -> Corner
                _ ->
                    case (hit_x, hit_y) of
                        (X, Y) -> Corner
                        (X, _) -> X
                        (_, Y) -> Y
                        _ -> Safe
    in
    hit


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
                                Hit 0 ->
                                    case status of
                                        Corner -> Corner
                                        X -> X
                                        Y -> Y
                                        _ -> hit tail (block_black_box_hit ball head.block)
                                _ -> hit tail status
                        Nothing -> status
                Nothing ->
                    case tmp of
                        Just head ->
                            case head.hitTime of
                                Hit 0 ->
                                    case status of
                                        Corner -> Corner
                                        X -> X
                                        Y -> Y
                                        _ -> hit [] (block_black_box_hit ball head.block)
                                _ -> status
                        Nothing -> status
    in
    hit box init


-- Model
basic_hit : Model -> Model
basic_hit model =
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
                            Hit 0 -> { a | hitTime = block_black_box_hitTime now_ball1 a.block }
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
    }


module BaseCollision exposing (..)
import Model exposing (..)

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
    if (ball.v.x > 0 -- to right
    && lt.x >= ball.pos.x && lt.x - ball.pos.x <= ball.r)
    || (ball.v.x < 0 -- to left
    && rb.x <= ball.pos.x && rb.x - ball.pos.x >= -ball.r)
    && ball.pos.y <= lt.y && ball.pos.y >= rb.y
    then X else Safe


-- Judge whether the ball hit on the Block -Y
block_y : Ball -> Block -> Hit
block_y ball block =
    let
        lt = block.lt
        rb = block.rb
    in
    if (ball.v.y > 0 -- to down
    && ball.pos.y - lt.y <= ball.r && ball.pos.y >= lt.y)
    || (ball.v.y < 0 -- to up
    && ball.pos.y - rb.y >= -ball.r && ball.pos.y <= rb.y)
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
    && -1 * ball.v.y / abs(ball.v.y) * (ball.pos.y - by) < (ball.r + height / 2)
    -- (Y) just above board
    && -1 * ball.v.x / abs(ball.v.x) * (ball.pos.x - bx) > (width / 2)
    -- (X) close to board
    && -1 * ball.v.x / abs(ball.v.x) * (ball.pos.x - bx) < (ball.r + width / 2)
    -- (X) close to board
    then Corner else Safe


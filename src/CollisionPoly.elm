module CollisionPoly exposing (..)
import Tools exposing (..)
import Model exposing (..)


type Hit
    = Danger ( List ( Point, Point ) )
    | Safe

-- Check if is hit
hitCheck : Poly -> Poly -> Hit
hitCheck ball brick =
    let
        vector : Point -> Point -> Point
        vector a b =
            { x = b.x - a.x, y = b.y - a.y }

        cross : Point -> Point -> Float
        cross va vb =
            va.x * vb.y - va.y * vb.x

        cross_lines : ( (Point, Point), (Point, Point) ) -> Maybe (Point, Point)
        cross_lines ((ma, mb), (na, nb)) =
            let
                ma_mb = vector ma mb
                na_nb = vector na nb
                ma_na = vector ma na
                ma_nb = vector ma nb
                na_ma = vector na ma
                na_mb = vector na mb
            in
            if ( cross ma_mb ma_na ) * ( cross ma_mb ma_nb ) < 0
            && ( cross na_nb na_ma ) * ( cross na_nb na_mb ) < 0
            then Just ( ma, mb )
            else Nothing

        gene_lines : Poly -> Poly -> List ( Point, Point )
        gene_lines remain_points all_points =
            let
                first : Result String Point
                first =
                    case List.head remain_points of
                        Just head -> Ok head
                        Nothing -> Err "No lines"

                next : Poly
                next =
                    case List.tail remain_points of
                        Just tail -> tail
                        Nothing -> all_points

                second : Result String Point
                second =
                    case List.head next of
                        Just all_head -> Ok all_head
                        Nothing -> Err "No lines"

                result =
                    case ( first, second ) of
                        ( Ok l, Ok r ) -> ( l, r )
                        _ -> ( Point 0 0, Point 0 0 )

            in
            case List.length remain_points of
                1 -> [ result ]
                _ ->
                    let
                        remains =
                            case List.tail remain_points of
                                Just tail -> tail
                                Nothing -> all_points

                    in
                    [ result ] ++
                    gene_lines remains all_points

        ball_lines =
            gene_lines ball ball

        bricks_lines =
            gene_lines brick brick

        all_lines =
            bricks_lines
            |> List.concatMap ( \(a, b) -> List.map ( \(c, d) -> ((a, b), (c, d)) ) ball_lines)

        final =
            List.filterMap cross_lines all_lines
    in
    case List.isEmpty final of
        True -> Safe
        False -> Danger final


-- Check if is hit - in a style of ball
ballCheck : Paddle -> Ball -> Ball
ballCheck paddle ball =
    let
        blood = -projection*3/4 -- used in printing industry, same as margin
        breath = 4 -- reset margin
        tar = vector paddle.pos ball.pos
        dir = ball.v
        projection = (dot dir tar) / (norm tar)
        dir_ =
            if norm tar > ( paddle.r + paddle.h + ball.r + blood ) then dir
            else if norm tar <= ( paddle.r + ball.r - breath ) then scale (norm dir) (normalize tar)
            else
                if projection < 0 then
                    let
                        t = -2 * projection
                        offset = scale t (normalize tar)
                    in
                    combine dir offset
                else dir
        pos_ =
            if norm tar <= ( paddle.r + ball.r - breath )
            then combine  paddle.pos <| scale (paddle.r + paddle.h + ball.r + blood + breath ) (normalize tar)
            else ball.pos
    in
    { ball | v = dir_, pos = pos_ }


paddleBall : Model -> Model
paddleBall model =
    let
        ball = getBall model.ball 1
        new_ball = List.foldl ballCheck ball model.paddle
    in
    { model | ball = [ new_ball ] ++ List.drop 1 model.ball }


wallCheck : Model -> Model
wallCheck model =
    let
        old = (getBall model.ball 1)
        v = old.v
        pos = old.pos
        hcBall =
            case (pos.x <= 10 && v.x < 0) || (pos.x >= (model.canvas.w - 10) && v.x > 0) of
                True -> (\b -> { b | v = Point -v.x v.y })
                False -> identity
        vcBall =
            case ( pos.y <= 10 && v.y < 0)
                || (pos.y >= (model.canvas.h - 10) && v.y > 0 && model.god == True)
                of
                True -> (\b -> { b | v = Point v.x -v.y })
                False -> identity
    in
    { model | ball = [old |> hcBall |> vcBall] ++ List.drop 1 model.ball }

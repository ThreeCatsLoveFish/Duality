module Companions5.Collision exposing (..)

import Model exposing (..)
import Tools exposing (..)


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


paddleCheckIndex : Int -> Model -> Model
paddleCheckIndex index model =
    let
        check_hit =
            [ hitCheck (getBall model.ball 1).collision (getPaddle model.paddle index).collision ]

        hit_turn_lines : Hit -> Maybe (List (Point, Point))
        hit_turn_lines hit =
            case hit of
                Danger list -> Just list
                Safe -> Nothing

        total_hit =
            List.filterMap hit_turn_lines check_hit
            |> List.concat

        total_lines =
            total_hit
            |> List.map (\(a, b) -> { x = b.x - a.x, y = b.y - a.y })
            |> List.foldl (\a -> \b -> { x = a.x + b.x, y = a.y + b.y } ) { x = 0, y = 0 }

        symmetric : Point -> Point -> Point
        symmetric xy mn =
            let
                lineH = 2
            in
            if xy.y < -lineH && index == 1
            || xy.y > lineH && index == 2
            then xy
            else
            { x = (2*mn.x*mn.y*xy.y + xy.x*(mn.x*mn.x - mn.y*mn.y)) / (mn.x*mn.x + mn.y*mn.y)
            , y = (2*mn.x*mn.y*xy.x + xy.y*(mn.y*mn.y - mn.x*mn.x)) / (mn.x*mn.x + mn.y*mn.y)
            }

        ball = getBall model.ball 1
        ball2 = getBall model.ball 2

    in
    case List.isEmpty total_hit of
            True -> model
            False ->
                { model | ball = [{ ball | v = symmetric ball.v total_lines }, ball2] }


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
            let
                ball = getBall model.ball 1
                paddle1 = getPaddle model.paddle 1
                paddle2 = getPaddle model.paddle 2
            in
            case
                ( pos.y <= 0 && v.y < 0 && model.god == True)
                || ( pos.y >= (model.canvas.h - 10) && v.y > 0 && model.god == True)
                || ( (ball.r + paddle1.r - 1) > distance ball.pos paddle1.pos && v.y > 0)
                || ( (ball.r + paddle2.r - 1) > distance ball.pos paddle2.pos && v.y < 0)
                of
                True -> (\b -> { b | v = Point v.x -v.y })
                False -> identity
    in
    { model | ball = [old |> hcBall |> vcBall, getBall model.ball 2] }


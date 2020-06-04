module Bin.Types exposing (..)

import Bin.Message exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }

type alias Block =
    { lt : Point -- left top
    , rb : Point -- right bottom
    }


-- Check if is in block
blockCheck : Block -> Point -> Bool
blockCheck block point =
    let
        lt = block.lt
        rb = block.rb
    in
    point.x >= lt.x && point.x <= rb.x && point.y >= rb.y && point.y <= lt.y

type alias Poly = List Point -- polygons for collision detection

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
            then Just ( na, nb )
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
                        Just next -> next
                        Nothing -> all_points

                second : Result String Point
                second =
                    case List.head next of
                        Just all_head -> Ok all_head
                        Nothing -> Err "No lines"

                result =
                    case ( first, second ) of
                        ( Ok l, Ok r ) -> ( l, r )

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


type BrickStat
    = Hit Int -- Tim
    | NoMore

type alias Brick =
    { pos: Point -- may not be necessary
    , collision: Poly -- for hitCheck
    , block: Block
    , stat: BrickStat
    --, visual: Visual -- can get by collision
    }

type alias Wall =
    { block: Block
    }

type alias Ball =
    { pos: Point
    , v: Point -- Could be a function related to time?
    , r: Float
    , collision: Poly -- save for future change
    --, visible: Float -- Visible -- save for future change
    --, visual: Visual
    }

type PaddleStat
    = Ascending
    | Descending

type alias Paddle =
    { pos: Point -- may not be necessary
    , collision: Poly -- for hitCheck
    , block: Block
    , stat: PaddleStat
    --, visual: Visual -- can get by collision
    }

type alias Model =
    { ball: Ball
    , bricks: List Brick
    , paddle: Paddle
    , menu: Menu
    }

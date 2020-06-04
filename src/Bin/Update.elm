module Bin.Update exposing (..)
import Bin.Message exposing (..)
import Bin.Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
-- TODO


moveBall : Model -> Model -- Done
moveBall model =
    let
        pos = model.ball.pos
        v = model.ball.v
        newPos = Point (pos.x + v.x) (pos.y + v.y)
        setPos npos ball =
            { ball | pos = npos }
        setBall ball nmodel =
            { nmodel | ball = ball}
    in
    setBall (setPos newPos model.ball) model


movePaddle : Model -> Op -> Model -- Done
movePaddle model op =
    let
        vNorm = 10 -- the speed of paddle (per 1/30 sec)
        v = case op of
            Left -> Point -vNorm 0
            Right -> Point vNorm 0
            Stay -> Point 0 0
        pos = model.paddle.pos

        newPos = Point (pos.x + v.x) (pos.y + v.y)
        setPos npos paddle =
            { paddle | pos = npos }
        setPaddle paddle nmodel =
            { nmodel | paddle = paddle}
    in
    setPaddle (setPos newPos model.paddle) model


collisionCheck : Model -> Model -- Done
-- TODO: Waiting for Debug!
collisionCheck model =
    let
        check_hit =
            model.bricks
            |> List.map
            ( \a ->
                case a.stat of
                    Hit 0 ->
                        hitCheck model.ball.collision a.collision
                    _ ->
                        Safe
            )

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
            { x = (2*mn.x*mn.y*xy.y + xy.x*(mn.x*mn.x - mn.y*mn.y)) / (mn.x*mn.x + mn.y*mn.y)
            , y = (2*mn.x*mn.y*xy.x + xy.y*(mn.y*mn.y - mn.x*mn.x)) / (mn.x*mn.x + mn.y*mn.y)
            }

        ball = model.ball

    in
    case List.isEmpty total_hit of
        True -> model
        False -> {
            model
            | ball = { ball | v = symmetric ball.v total_lines }
            , bricks =
                model.bricks
                |> List.map
                    ( \a ->
                        case total_hit
                            |> List.any
                            (\(x, y) ->
                                (List.member x a.collision) &&
                                (List.member y a.collision) )
                        of
                            True ->
                                { a | stat = Hit 1 }
                            False ->
                                a
                    )
            }


gameStatus : Model -> Model


brickStatus : Model -> Model


winOrLose : Model -> Model

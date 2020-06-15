module Companions5.Init exposing (..)

import Browser.Dom exposing (getViewport)
import Fade exposing (fadeInAndOut)
import Html exposing (Html, Attribute, button, div)

import Model exposing (..)
import Messages exposing (..)
import Task
import Tools exposing (..)
import BasicView exposing (..)
--import Companions5.State exposing (genBezierBrick, getSpeed)
import Companions5.View

init : ( Model, Cmd Msg )
init =
    let
        canvas = { w = 550, h = 700 }
        ball : Ball
        ball =
            let
                pos =
                    Point
                        (canvas.w/2)
                        (paddle.pos.y - paddle.r - paddle.h - r)
                v = Point 3.0 -3.0
                r = 15
            in
            { active = True
            , pos = pos
            , v = v
            , r = r
            , collision = getBallColl (pos, r, 32)
            , color = rgb 244 244 244
            }

        state : List State
        state =
            [
                { name = "fadeInAndOut"
                , value = 0
                , t = 0
                , function = Func fadeInAndOut
                , loop = False
                }
            ]

        paddle : Paddle
        paddle =
            let
                r = 60
                h = 3
                angle = 40 * pi / 180
                pos = Point (canvas.w/2) (canvas.h + r * cos angle - 5 - r)
                getPaddleColl_ : Int -> Poly
                getPaddleColl_ precision =
                    let
                        pre = toFloat precision
                        unit = 2 * pi / pre
                        iter = List.range 0 ( precision - 1 )
                    in
                    iter
                        |> List.map
                            (\t ->
                                Point
                                (pos.x + r * sin (unit*(toFloat t)))
                                (pos.y + r * cos (unit*(toFloat t)))
                            )

            in
            { pos = pos -- may not be necessary
            , collision =
                getPaddleColl_ 48 -- for hitCheck
                    |> List.reverse
            , block = dummyBlock
            , color = rgb 66 150 240
            , r = r
            , h = h
            , angle = angle
            }

        paddle2 : Paddle
        paddle2 =
            let
                pos_ = paddle.pos
                reflect p =
                    Point (canvas.w - p.x) (canvas.h - p.y)
            in
            { paddle
            | pos = reflect pos_
            , collision = paddle.collision
                |> List.map reflect
            , color = rgb 250 200 50
            }
        bricksize = {w=39, h=39}
        bricks : List Brick
        bricks =
            let
                brickInfo =
                    { layout = {x=10, y=6}
                    , canvas = canvas
                    , brick = bricksize
                    , breath = 10
                    , offset = Point 0 0
                    --, color = rgb 20 70 20
                    , color = rgb 255 255 255
                    }
                valid a = (abs a) > 2
                newBricks_ : BrickInfo -> List Brick
                newBricks_ info =
                    let
                        positionConvert len unit orientation =
                            let
                                ori =
                                    case orientation of
                                        True -> List.filter (\x -> valid x)
                                        False -> identity
                            in
                            (List.range 1 len)
                                |> List.map toFloat
                                |> List.map (\x -> x - 0.5 - (toFloat len) /2 )
                                |> ori
                                |> List.map (\x -> x * unit)
                        posBrickX =
                            positionConvert info.layout.x (info.brick.w + info.breath) True
                            |> List.map (\x -> x + info.canvas.w/2 + info.offset.x)
                        posBrickY =
                            positionConvert info.layout.y (info.brick.h + info.breath) False
                            |> List.map (\y -> y + info.canvas.h/2 + info.offset.y)
                        posBricks =
                            List.concatMap (\x -> List.map (Point x) posBrickY) posBrickX -- get pos
                    in
                    List.map (\pos -> Brick pos (pos2coll pos info.brick) (pos2block pos info.brick) (Hit 0) info.color) posBricks
            in
            newBricks_ brickInfo
        model =
            { dummyModel
            | gameLevel = Companions5
            , gameStatus = AnimationPrepare
            , ball = [ball]
            , paddle = [paddle]
            , bricks = bricks
            , state = state
            , canvas = canvas
            , size = (canvas.w, canvas.h)
            , clock = 0
            , activeInput = True
            , animateState = AniIn
            }
    in
    ( { model | visualization = Companions5.View.visualize model }
    , Task.perform GetViewport getViewport
    )






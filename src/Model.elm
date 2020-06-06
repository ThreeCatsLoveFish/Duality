module Model exposing (..)
import Messages exposing (..)
import Html.Attributes exposing (..)
import Html exposing (..)

type alias Point =
    { x : Float
    , y : Float
    }

type alias Poly = List Point

type alias Block =
    { lt : Point -- left top
    , rb : Point -- right bottom
    }

type Color
    = Color { red : Int, green : Int, blue : Int }

rgb : Int -> Int -> Int -> Color
rgb red green blue =
    Color { red = red, green = green, blue = blue }

colorToString : Color -> String
colorToString (Color { red, green, blue }) =
    "rgb("
        ++ String.fromInt red
        ++ ","
        ++ String.fromInt green
        ++ ","
        ++ String.fromInt blue
        ++ ")"

pointToString : Point -> String
pointToString point =
    String.fromFloat (point.x) ++ ", " ++ String.fromFloat (point.y)

polyToString : Poly -> String
polyToString poly =
    String.join " " (List.map pointToString poly)

posToPoly : number -> number -> Point -> List Point
posToPoly w h center =
    [ Point (center.x + w/2) (center.x + h/2)
    , Point (center.x - w/2) (center.y + h/2)
    , Point (center.x - w/2) (center.y - h/2)
    , Point (center.x + w/2) (center.y - h/2)
    ]

---
type alias Ball =
    { pos : Point
    , v : Point -- Could be a function related to time?
    , r : Float
    , collision : Poly -- save for future change
    , color : Color
    }

type alias Paddle =
    { pos : Point -- may not be necessary
    , collision : Poly -- for hitCheck
    , block : Block
    , color : Color
    , center : Point
    , r : Float
    }

type alias Brick =
    { pos: Point -- may not be necessary
    , collision: Poly -- for hitCheck
    , block : Block
    , hitTime: HitTime
    , color : Color
    --, visual: Visual -- can get by collision
    }

type HitTime
    = Hit Int -- Tim
    | NoMore

---
type alias Model =
    { gameLevel : GameLevel
    , gameStatus : GameStatus

    , ball : List Ball
    , paddle : List Paddle
    , bricks : List Brick
    , clock : Float

    , visualization : Html Msg
    }

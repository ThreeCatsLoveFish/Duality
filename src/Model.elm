module Model exposing (..)

import Messages exposing (..)
import Html exposing (Html)

type alias Point =
    { x : Float
    , y : Float
    }

type alias Poly =
    List Point

type alias Block =
    { lt : Point -- left top
    , rb : Point -- right bottom
    }

pointToString : Point -> String
pointToString point =
    String.fromFloat (point.x) ++ ", " ++ String.fromFloat (point.y)

polyToString : Poly -> String
polyToString poly =
    String.join " " (List.map pointToString poly)

posToPoly : Float -> Float -> Point -> List Point
posToPoly w h center =
    [ Point (center.x + w/2) (center.y + h/2)
    , Point (center.x + w/2) (center.y - h/2)
    , Point (center.x - w/2) (center.y - h/2)
    , Point (center.x - w/2) (center.y + h/2)
    ]

---

type Color = Color { red : Int, green : Int, blue : Int }

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

---

type alias Ball =
    { active : Bool
    , pos : Point       -- position of center
    , v : Point         -- direction
    , r : Float         -- radius
    , collision : Poly  -- for hitCheck
    , color : Color
    }

type alias Paddle =
    { pos : Point       -- position of center
    , collision : Poly  -- for hitCheck
    , block : Block
    , color : Color
    , r : Float         -- radius
    , h : Float         -- thickness
    , angle : Float     -- half paddle's angle
    }

type alias Brick =
    { pos: Point        -- position of center
    , collision: Poly   -- for hitCheck
    , block : Block
    , hitTime: HitTime  -- hit times
    , color : Color
    }

type HitTime
    = Hit Int -- Tim
    | NoMore

---

type alias State =
    { name : String
    , value : Float
    , t : Float
    , function : StateFunc
    , loop : Bool
    }

type StateFunc = Func ( Model -> Float -> Model )

---

type AniState
    = AniIn
    | AniStatic
    | AniOut
    | AniStop

---

type alias Model =
    { gameLevel : GameLevel
    , gameStatus : GameStatus

    , ball : List Ball
    , paddle : List Paddle
    , bricks : List Brick

    , state : List State

    , canvas : { w : Float, h : Float }
    , size : ( Float, Float )
    , clock : Float
    , activeInput : Bool -- deprecated
    , animateState : AniState -- deprecated
    , god : Bool
    , finished : Int -- Test if finished >= 6 for second loop

    , visualization : Html Msg
    }

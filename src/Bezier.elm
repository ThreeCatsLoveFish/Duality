module Bezier exposing (..)
import InitTools exposing (getBall)
import Model exposing (..)

-- Functions realized by using Bézier curve

-- Fade in / Fade out
bezierFade : Float -> Float
bezierFade =
    let
        start = 1
        end = 1
        mid1 = 1/4
        mid2 = 1/3
        curve time =
            let
                now = 1 - time
            in
            start*now^3 + 3*mid1*time*now^2 + 3*mid2*now*time^2 + end*time^3
    in
    curve

-- Move position
bezierPos : Point -> Point -> ( Float -> Point )
bezierPos start end =
    let
        newPoint a pa b pb =
            { x = a * pa.x + (1 - a) * pb.x, y = b * pa.y + (1 - b) * pb.y }
        mid1 =
            newPoint (3/4) start (5/6) end
        mid2 =
            newPoint (1/4) start (1/6) end
        curve time =
            let
                now = 1 - time
            in
            { x = start.x*now^3 + 3*mid1.x*time*now^2 + 3*mid2.x*now*time^2 + end.x*time^3
            , y = start.y*now^3 + 3*mid1.y*time*now^2 + 3*mid2.y*now*time^2 + end.y*time^3
            }
    in
    curve

bezierPosPos : Point -> Point -> Point -> Point -> ( Float -> Point )
bezierPosPos start mid1 mid2 end =
    let
        --newPoint a pa b pb =
        --    { x = a * pa.x + (1 - a) * pb.x, y = b * pa.y + (1 - b) * pb.y }
        --mid1 =
        --    newPoint (3/4) start (5/6) end
        --mid2 =
        --    newPoint (1/4) start (1/6) end
        curve time =
            let
                now = 1 - time
            in
            { x = start.x*now^3 + 3*mid1.x*time*now^2 + 3*mid2.x*now*time^2 + end.x*time^3
            , y = start.y*now^3 + 3*mid1.y*time*now^2 + 3*mid2.y*now*time^2 + end.y*time^3
            }
    in
    curve


-- Change Color
bezierColor : Color -> Color -> ( Float -> Color )
bezierColor (Color startInt) (Color endInt) =
    let
        intToFloat int =
            { red = toFloat int.red
            , green = toFloat int.green
            , blue = toFloat int.blue
            }
        start = intToFloat startInt
        end = intToFloat endInt
        newPoint a pa pb =
            { red = a * pa.red + (1 - a) * pb.red
            , green = a * pa.green + (1 - a) * pb.green
            , blue = a * pa.blue + (1 - a) * pb.blue
            }
        mid1 =
            newPoint (4/5) start end
        mid2 =
            newPoint (1/5) start end
        curve time =
            let
                now = 1 - time
            in
            rgb
            (round (start.red*now^3   + 3*mid1.red*time*now^2   + 3*mid2.red*now*time^2   + end.red*time^3)  )
            (round (start.green*now^3 + 3*mid1.green*time*now^2 + 3*mid2.green*now*time^2 + end.green*time^3)  )
            (round (start.blue*now^3  + 3*mid1.blue*time*now^2  + 3*mid2.blue*now*time^2  + end.blue*time^3)  )
    in
    curve


module Bezier exposing (..)

import Model exposing (..)


-- Functions realized by using Bézier curve

-- Fade in / Fade out
bezierFade : Float -> Float -> Float -> Float -> (Float -> Float)
bezierFade start end mid1 mid2 =
    let
        curve time =
            let
                now = 1 - time
            in
            start*now^3 + 3*mid1*time*now^2 + 3*mid2*now*time^2 + end*time^3
    in
    curve


-- Move position
bezierPos : Point -> Point -> Point -> Point -> ( Float -> Point )
bezierPos start mid1 mid2 end =
    let
        curve time =
            let
                now = 1 - time
            in
            { x = start.x*now^3 + 3*mid1.x*time*now^2 + 3*mid2.x*now*time^2 + end.x*time^3
            , y = start.y*now^3 + 3*mid1.y*time*now^2 + 3*mid2.y*now*time^2 + end.y*time^3
            }
    in
    curve


bezierPoly : Poly -> ( Float -> Point )
bezierPoly poly =
    case poly of
        start::mid1::mid2::end::_ ->
            let
                curve time =
                    let
                        now = 1 - time
                    in
                    { x = start.x*now^3 + 3*mid1.x*time*now^2 + 3*mid2.x*now*time^2 + end.x*time^3
                    , y = start.y*now^3 + 3*mid1.y*time*now^2 + 3*mid2.y*now*time^2 + end.y*time^3
                    }
            in
            curve
        _ ->
            let
                curve _ = {x=0,y=0}
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


-- Change Color Manual
bezierManualColor : Color -> Color -> Color -> Color -> ( Float -> Color )
bezierManualColor (Color startInt) (Color mid1Int) (Color mid2Int) (Color endInt) =
    let
        intToFloat int =
            { red = toFloat int.red
            , green = toFloat int.green
            , blue = toFloat int.blue
            }
        start = intToFloat startInt
        end   = intToFloat endInt
        mid1  = intToFloat mid1Int
        mid2  = intToFloat mid2Int
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


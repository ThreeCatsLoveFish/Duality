module Fade exposing (..)

import Model exposing (..)
import Tools exposing (divState)

genFadeIn : Float -> Float -> Float -> (Model -> Float -> Model)
genFadeIn break interval speedAdjust =
    let
        fadeIn_ model t_ =
            let
                val =
                    if  ( t_ < break ) then
                        0
                    else if ( t_ >= break && t_ <= break+interval ) then
                        ( t_ - break) / interval
                    else
                        1
                (s_, state_) = divState model.state "fadeIn"
                state =
                    case t_>1 of
                        False -> { s_ | value = val, t = s_.t + speedAdjust}::state_
                        _ -> state_
            in
            { model | state = state }
    in
    fadeIn_
genFadeInSub : Float -> Float -> Float -> (Model -> Float -> Model)
genFadeInSub break interval speedAdjust =
    let
        fadeIn_ model t_ =
            let
                val =
                    if  ( t_ < break ) then
                        0
                    else if ( t_ >= break && t_ <= break+interval ) then
                        ( t_ - break) / interval
                    else
                        1
                (s_, state_) = divState model.state "fadeInSub"
                state =
                    case t_>1 of
                        False -> { s_ | value = val, t = s_.t + speedAdjust}::state_
                        _ -> state_
            in
            { model | state = state }
    in
    fadeIn_

fadeInAndOut : Model -> Float -> Model
fadeInAndOut model t =
    let
        val =
            if  ( t < 0.3 ) then
                t / 0.3
            else if ( t >= 0.3 && t <= 0.7 ) then
                1
            else
                ( 1.0 - t ) / 0.3
        (s_, state_) = divState model.state "fadeInAndOut"
        state =
            case t>1 of
                False -> { s_ | value = val}::state_
                _ -> state_
    in
    { model | state = state }

-- break: before fade;
-- interval: time to fade;
-- speedAdjust: how much to change during flow,
--     preferably slowing down by using -0.002, etc.
genFadeOut : Float -> Float -> Float -> (Model -> Float -> Model)
genFadeOut break interval speedAdjust =
    let
        fadeOut_ model t =
            let
                val =
                    if  ( t < break ) then
                        1
                    else if ( t >= break && t <= break+interval ) then
                        (break + interval - t) / interval
                    else
                        0
                (s_, state_) = divState model.state "fadeOut"
                state =
                    case t>1 of
                        False -> { s_ | value = val, t = s_.t + speedAdjust}::state_
                        _ -> state_
            in
            { model | state = state }
    in
    fadeOut_

fadeOut : Model -> Float -> Model
fadeOut model t =
    let
        val =
            if  ( t < 0.4 ) then
                1
            else if ( t >= 0.4 && t <= 0.7 ) then
                (0.7 - t) / 0.3
            else
                0
        (s_, state_) = divState model.state "fadeOut"
        state =
            case t>1 of
                False -> { s_ | value = val}::state_
                _ -> state_
    in
    { model | state = state }


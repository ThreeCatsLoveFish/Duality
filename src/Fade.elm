module Fade exposing (..)

import Model exposing (Model)
import Tools exposing (divState)


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
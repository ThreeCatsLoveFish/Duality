module Start0.Update exposing (..)

import Messages exposing (..)
import Model exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

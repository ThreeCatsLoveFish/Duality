module Update exposing (..)
import Model exposing (..)
import Messages exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

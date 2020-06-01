module Bin.Test exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)

import Bin.Initial
import Bin.Types exposing (..)
import Bin.Message exposing (..)
import Bin.View
import Html exposing (Html, Attribute, button, div, h1, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Debug exposing (..)
import Svg
import Svg.Attributes as SA
import Random

main : Program () Model Msg
main =
  Browser.element
        { init = \_ -> Bin.Initial.init
        , view = Bin.View.view
        , update = update
        , subscriptions = subscriptions
        }

--type alias Model = Types.Model -- change it!

--type Msg
--    = ChangeIt

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = (model, Cmd.none)-- anything you like!

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none --TODO: change it.

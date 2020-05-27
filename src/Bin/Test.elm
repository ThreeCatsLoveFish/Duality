module Bin.Test exposing (..)

import Browser
import Html exposing (Html, Attribute, button, div, h1, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Debug exposing (..)

import Random

main =
  Browser.sandbox{ init = init, update = update, view = view }

lst = [1,2,3]

type alias Model = Int -- change it!

init : Model
init =
    case lst of
        x :: xs ->
            x
        _ ->
            -1

type Msg
    = ChangeIt

update : Msg -> Model -> Model
update msg model = model -- anything you like!

view : Model -> Html Msg
view model =
    div []
    [ h1
        [ style "text-align" "center"
        , style "color" "#1B72BD"
        ]
        [ text (Debug.toString model) ]
    ]

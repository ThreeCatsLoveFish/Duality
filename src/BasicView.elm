module BasicView exposing (..)

import Html.Events exposing (onClick)
import Model exposing (..)

import Html exposing (Attribute, Html, audio, button, div, p, text)
import Html.Attributes exposing (..)
import Messages exposing (..)


visualizeBlock : Model -> Html Msg
visualizeBlock model =
    let
        (status, description) =
            case model.gameStatus of
                Paused ->
                    ( "Paused", "Press Space to continue" )
                Lose ->
                    ( "... The orb of life was smashed ...", "Press R to revisit" )
                _ -> ("","")
        alpha =
            case model.gameStatus of
                Paused ->
                    "0.7"
                Lose ->
                    "1"
                _ -> "0"
    in
    div
        [ style "background" (colorToString (rgb 40 40 40))
        , style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-family" "High Tower Text, sans-serif"
        , style "opacity" alpha
        , style "display"
            (   if List.member model.gameStatus [ Paused, Lose ] then
                    "inline"
                else
                    "none"
            )
        ]
        (
            [ p -- Description / Instruction
                [ style "width" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "55%"
                , style "font-size" "20px"
                , style "color" "#AAAAAA"
                ]
                [text description]
            , p -- Title
                [ style "width" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "30%"
                , style "font-size" "40px"
                , style "color" "#FFFFFF"
                ]
                [text status]
            , (visualizeMenu model)
            ] ++
            if model.gameStatus == Lose then
                [ audio
                    [ src "Lose - Too Bad So Sad.mp3"
                    , id "audioLose"
                    , loop False
                    , autoplay True
                    ]
                    []
                ]
            else []
        )

visualizeMenu : Model -> Html Msg
visualizeMenu model =
    let
        level =
            case model.gameLevel of
                Start0 -> 0
                Strangers1 -> 1
                Friends2 -> 2
                Lovers3 -> 3
                Strangers4 -> 4
                Companions5 -> 5
                Death6 -> 6
                _ -> 7
        hiding bool = if bool then "0" else "1"
    in
    div
        [ style "text-align" "center"
        , style "height" "100%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "font-size" "48px"
        , style "color" "#FFFFFF"
        , style "opacity" "1"
        , style "display" "inline"
        ]
        [ div
            [ style "text-align" "center"
            ]
            [ button
                [ id "toStart0"
                , style "font-size" "28px"
                , onClick (ChooseLevel Start0)
                , style "opacity" (hiding (level < 0))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 0)
                ]
                [ text "Start" ]
            , button
                [ id "toStranger1"
                , style "font-size" "28px"
                , onClick (ChooseLevel Strangers1)
                , style "opacity" (hiding (level < 1))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 1)
                ]
                [ text "Strangers" ]
            , button
                [ id "toFriends2"
                , style "font-size" "28px"
                , onClick (ChooseLevel Friends2)
                , style "opacity" (hiding (level < 2))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 2)
                ]
                [ text "Friends" ]
            , button
                [ id "toLovers3"
                , style "font-size" "28px"
                , onClick (ChooseLevel Lovers3)
                , style "opacity" (hiding (level < 3))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 3)
                ]
                [ text "Lovers" ]
            , button
                [ id "Strangers4"
                , style "font-size" "28px"
                , onClick (ChooseLevel Strangers4)
                , style "opacity" (hiding (level < 4))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 4)
                ]
                [ text "Strangers II" ]
            , button
                [ id "toCompanions5"
                , style "font-size" "28px"
                , onClick (ChooseLevel Companions5)
                , style "opacity" (hiding (level < 5))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 5)
                ]
                [ text "Companions" ]
            , button
                [ id "toDeath6"
                , style "font-size" "28px"
                , onClick (ChooseLevel Death6)
                , style "opacity" (hiding (level < 6))
                , style "font-family" "High Tower Text, sans-serif"
                , disabled (level == 6)
                ]
                [ text "Death" ]
            , button
                [ style "font-size" "28px"
                , onClick (KeyDown Key_S)
                , style "opacity" (hiding False)
                , style "font-family" "High Tower Text, sans-serif"
                , disabled False
                ]
                [ text "Skip" ]
            ]
        ]


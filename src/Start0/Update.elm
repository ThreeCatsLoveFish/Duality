module Start0.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)

import Start0.View exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case model.gameStatus of
                Pass ->
                    let
                        model1 = model |> getEndState
                    in
                    { model1 | gameStatus = Animation }
                Animation ->
                    case msg of
                        Tick time ->
                            model |> stateIterate
                        _ ->
                            model
                        Tick time ->
                            model |> move (min time 25)
                                  |> stateIterate
                        _ -> model
                _ ->
                    model
    in
    ( { model0 | visualization = Start0.View.visualize model} , Cmd.none )
-- TODO

move : Float -> Model -> Model
move elapsed model =
    let
        elapsed_ =
            model.clock + elapsed
        interval = 15
    in
    if elapsed_ > interval then
        { model | clock = elapsed_ - interval } |> exec

    else
        { model | clock = elapsed_ }

exec : Model -> Model
exec model =
    let
        dir =
            case model.gameStatus of
                Running dr -> dr
                _ -> Stay
    in
    model
        |> fadeImg

stateIterate : Model -> Model
stateIterate model =
    case List.isEmpty model.state of
        True ->
            { model
            | gameStatus = ChangeLevel
            , gameLevel = Friends2
            }
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.01) state
                setModel : State -> Model -> Model
                setModel stat model_ =
                    case stat.name of
                        "fadeImg" ->
                            --TODO: fixit
                        _ ->
                            model_
                newModel =
                    List.foldl (\x y -> (setModel x y)) { model | state = newState } newState

            in
            newModel

getEndState : Model -> Model
getEndState model =
    model

loopState : State -> Float -> State
loopState state t =
    if (state.loop == True && state.t < 1) then
         { state | t = state.t + t}
    else
         { state | t = state.t - 1}

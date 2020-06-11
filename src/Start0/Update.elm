module Start0.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)
import Start0.View exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case model.gameStatus of
                Animation ->
                    case msg of
                        Tick time ->
                            model |> move (min time 25)
                                  |> stateIterate
                        _ -> model
                _ ->
                    model
    in
    ( { model0 | visualization = Start0.View.visualize model} , Cmd.none )

exec : Model -> Model
exec model =
    let
        dir =
            case model.gameStatus of
                Running dr -> dr
                _ -> Stay
    in
    model
        |> winJudge

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

stateIterate : Model -> Model
stateIterate model =
    case List.isEmpty model.state of
        True ->
            { model
            | gameStatus = ChangeLevel
            , gameLevel = Strangers1
            }
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.005) state
                newModel =
                    { model | state = newState }

            in
            newModel

winJudge : Model -> Model
winJudge model =
    if ((getState model.state "fadeInAndOut").t > 1) then
        { model | gameStatus = ChangeLevel
                , gameLevel = Strangers1 }
    else
        model

getEndState : Model -> Model
getEndState model =
    model

loopState : State -> Float -> State
loopState state t =
    case state.loop of
        True ->
            if (state.loop == True && state.t < 1) then
                 { state | t = state.t + t}
            else
                 { state | t = state.t - 1}
        False ->
            { state | t = state.t + t}

module End7.Update exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Tools exposing (..)
import End7.View exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        model0 =
            case model.gameStatus of
                AnimationPrepare ->
                    case msg of
                        Tick time ->
                            model
                                |> stateIterate
                        GetViewport { viewport } ->
                            { model
                                | size =
                                    ( viewport.width
                                    , viewport.height
                                    )
                            }
                        Resize w h ->
                            { model | size = (toFloat w,toFloat h)}
                        _ -> model
                Prepare ->
                    case msg of
                        KeyDown Space ->
                            { model
                            | gameStatus = ChangeLevel
                            , gameLevel = Start0
                            }
                        _ -> model
                _ ->
                    model
    in
    ( { model0 | visualization = End7.View.visualize model0} , Cmd.none )


stateIterate : Model -> Model
stateIterate model =
    case List.isEmpty model.state of
        True ->
            case model.gameStatus of
                AnimationPrepare ->
                    { model | gameStatus = Prepare }
                _ ->
                    { model
                    | gameStatus = ChangeLevel
                    , gameLevel = Start0
                    }
        _ ->
            let
                state = model.state
                newState =
                    List.map (\s -> loopState s 0.0012) state
                getFunc (Func func) = func
                setModel : State -> Model -> Model
                setModel stat model_ =
                    (getFunc stat.function) model_ stat.t
                newModel =
                    List.foldl (\x y -> (setModel x y)) { model | state = newState } newState

            in
            newModel

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

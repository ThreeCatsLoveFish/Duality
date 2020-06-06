module Messages exposing (..)

type GameLevel
    = Start0
    | Strangers1
    | Friends2
    | Lovers3
    | Strangers4
    | Companions5
    | Death6
    | End7

type GameStatus
    = Startup
    | Paused  -- stop updating game model, still updating the menu, show Paused
    | Pass -- stop game model and frame, still menu, show Win
    | Lose -- stop game model and frame, still menu, show Win
    | Running -- the game is on
    | NoMenu -- just in case...

type Op
    = Left
    | Right
    | Stay -- maybe useless..

type Msg
    = RunGame Op -- running the game, update and view
    | ShowStatus GameStatus -- show menu on top
    | ChooseLevel GameLevel
    | Tick Float
    | NoOp -- somehow redundant...

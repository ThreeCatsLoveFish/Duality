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
    = Animation
    | ChangeLevel
    | Prepare
    | Paused  -- stop updating game model, still updating the menu, show Paused
    | Pass -- stop game model and frame, still menu, show Win
    | Lose -- stop game model and frame, still menu, show Win
    | Running Op -- the game is on
    | NoMenu -- just in case...

type Op
    = Left
    | Right
    | Stay -- maybe useless..

type KeyType
    = Space
    | Key_Left
    | Key_Right
    | Key_R

type Msg
    = RunGame Op -- abandoned
    | ShowStatus GameStatus -- show menu on top
    | ChooseLevel GameLevel
    | Resize Int Int

    | KeyDown KeyType
    | KeyUp KeyType
    | Tick Float

    | NoOp -- somehow redundant...
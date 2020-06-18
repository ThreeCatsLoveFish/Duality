module Messages exposing (..)

import Browser.Dom exposing (Viewport)

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
    = AnimationPrepare
    | AnimationPreparePost
    | AnimationPass
    | ChangeLevel
    | Prepare
    | Paused    -- stop updating game model, still updating the menu, show Paused
    | Lose      -- stop game model and frame, still menu, show Lose
    | Pass      -- stop game model and frame, still menu, show Win
    | End       -- after animationPass
    | AnimationEnd
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
    | Key_S
    | Key_D
    | Key_G

type Msg
    = ShowStatus GameStatus -- show menu on top
    | ChooseLevel GameLevel

    | GetViewport Viewport
    | Resize Int Int

    | KeyDown KeyType
    | KeyUp KeyType
    | Tick Float

    | NoOp -- somehow redundant...

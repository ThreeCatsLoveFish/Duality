module Bin.Message exposing (..)

type Op
    = Left
    | Right
    | Stay -- maybe useless..

type Menu
    = Startup -- before start; welcome
    | Paused  -- stop updating game model, still updating the menu, show Paused
    | Win -- stop game model and frame, still menu, show Win
    | Lose -- stop game model and frame, still menu, show Win
    | Running -- the game is on
    | NoMenu -- just in case...

type Msg
    = RunGame Op -- running the game, update and view
    | ShowMenu Menu -- show menu on top
    | NoOp -- somehow redundant...


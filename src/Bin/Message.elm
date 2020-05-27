module Bin.Message exposing (..)
import Bin.Types exposing (MenuModel)

type Op
    = Left
    | Right
    | Stay -- maybe useless..

type Menu
    = Startup -- before start; welcome
    | Paused  -- stop updating game model, still updating the menu, show Paused
    | Win -- stop game model and frame, still menu, show Win
    | Lose -- stop game model and frame, still menu, show Win
    | NoMenu -- just in case...

type Msg
    = Running Op -- running the game, update and view
    | ShowMenu Menu -- show menu on top
    | NoOp -- somehow redundant...


module Bin.Message exposing (..)
import Bin.Types exposing (MenuModel)
type Op
    = Left
    | Right
    | Stay -- maybe useless

type Msg
    = Startup -- before start; welcome
    | Running Op -- running the game, update and view
    | Paused MenuModel  -- stop updating game model, still updating the menu, show Paused
    | Win MenuModel -- stop game model and frame, still menu, show Win
    | Lose MenuModel -- stop game model and frame, still menu, show Win
    | NoOp


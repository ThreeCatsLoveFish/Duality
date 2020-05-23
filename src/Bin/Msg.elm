module Bin.Msg exposing (..)

type Op
    = Left
    | Right
    | Stay -- maybe useless

type Msg
    = Startup -- before start; welcome
    | Running Op -- running the game, update and view
    | Paused -- stop updating game model, still updating the menu, show Paused
    | Win -- stop game model and frame, still menu, show Win
    | Lose -- stop game model and frame, still menu, show Win
    | NoOp


git clone git@github.com:ThreeCatsLoveFish/VG100_Project_One.git

# Stranger

## Table of Content
- [Title](#Stranger)
- [Menu](#Table-of-Content)
- [Description](#Description)
- [Structure](#File-Structure)
- [Usage](#Usage)
- [Functions](#Functions)
- [History Versions](ChangeLog.md)

## Description
**Stranger** is a modified game of *Break the Bricks*,
and this project is *2020SU VG100 Project One*, done by following members:
- Rundong Tang
- Yuchen Jiang
- Yuchen Zhou
- Zhimin Sun

## File Structure
```
|- README.md
|- ChangeLog.md
|- src
   |- Main.elm
   |- Bin
      |- Strange.elm
      |- Type.elm
      |- Message.elm
      |- Initial.elm
      |- View.elm
      |- Collision.elm
      |- Update.elm
   |- ...
|- ...
```

## Usage
1. User should press **SPACE** to *start* the game and **ENTER** to *restart* the game.
1. Press the left or right direction button to move the board.
1. Enjoy it!

## Functions
1. The **start** and **end** UI.
1. The ball can bounce between walls and the paddle that users control.
1. Board can move left and right, and won't go beyond the walls.
1. The bricks exist and will be broken.
1. The speed of ball will change when it touches the moving board.
1. Ball will bounce back when it hit the corner of bricks or board.

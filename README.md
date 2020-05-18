# Break the Bricks
## 2020SU VG100 Project One 

### Menu
- [Title](#Break-the-Bricks)
- [Menu of README](#Menu)
- [Description of Project](#Description)
- [Structure of Project](#File-Structure)
- [Usage](#Usage)
- [Functions](#Functions)
- [History Versions](ChangeLog.md)

### Description
**Break the Bricks** is a game, and this project is finished by Zhimin Sun. 

### File Structure
```
|- README.md
|- ChangeLog.md
|- LICENSE
|- src
   |- Main.elm
   |- Components
      |- Structure.elm
      |- Init.elm
      |- View.elm
      |- Update.elm
   |- ...
|- ...
```

### Usage
1. User should press **ENTER** to (re)start the game.
1. Press the left or right direction button to move the board.
1. Enjoy it!

### Functions
1. The **start** and **end** UI.
1. The ball can bounce between walls and the board that users control.
1. Board can move left and right, and won't go beyond the walls.
1. The bricks exist and will be broken.
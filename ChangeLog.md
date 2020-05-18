# ChangeLog

### Version 0.1.0
##### 2020.5.17 By Zhimin Sun
#### Release the first release version
All basic functions complete

### Version 0.0.1
##### 2020.5.17 By Zhimin Sun
#### Main change
1. **Add usage of this game.**
1. Optimize the structure and add comments.
1. Add bricks, and the function of break bricks.
1. Leave the init part of bricks for further design.
1. Add the winner part!
1. Change the traditional number to data (easier to change). 
1. Add MIT LICENSE

### Version 0.0.0
##### 2020.5.14 By Zhimin Sun
#### Main change
Setup the whole structure:
```
|- Main.elm
|- Components
   |- Structure.elm
   |- Init.elm
   |- View.elm
   |- Update.elm
|- ...
```
#### Functions so far
1. The **start** and **end** UI.
1. The ball can bounce between walls, and the board that users control.
1. Board can move left and right, and won't go beyond the walls. 
# Duality

## Table of Content

[TOC]

## Description

**Duality** is a modified version of *Breakout* game,
and this project is *2020SU VG100 Project One*, made by following members:
- Rundong Tang
- Yuchen Jiang
- Yuchen Zhou
- Zhimin Sun

## File Structure
```
Duality
|- README.md
|- ChangeLog.md
|- Makefile
|- elm.json
|> src
   |> Start0
   |> Stranger1
   |> Friend2
   |> Lovers3
   |> Stranger4
   |> Companion5
   |> Death6
   |> End7
   |- Main.elm
   |- Message.elm
   |- Model.elm
   |- BasicView.elm
   |- Bezier.elm
   |- CollisionBlock.elm
   |- CollisionPoly.elm
   |- Fade.elm
   |- Subscription.elm
   |- Tool.elm
   |- ...
|> public
   |- index.html
   |- main.css
   |- favicon.ico
   |- icon.png
   |- *.mp3
   |- ... (Other sources)
|- ...
```

## Usage
1. User should press **SPACE** to *start or pause* the game.
1. User should press **S** to *skip* the level, **R** to *restart* the level.
1. User should press **G** for god mode. All levels rebound, and the fourth level will automatically catch the ball for the game experience.
1. Press the **Left** or **Right** direction button to move the board.
1. Enjoy it!

## Story
Our story is a love story between two people, and our storyline follows the passage of time.
Two strangers met. They got to know each other and became friends. With their relationship closer
and closer, they finally fall in love with each other. However, something happened which made their
relationship lost of control. Their love was destroyed, and they became strangers again. After a long time,the wound in their relationship was gradually healing. They started to renew their love and eventually became couples.
In the end, death came, which gave an end to the romantic love story.

Our storyline is divided into several plots, each is shown in one game level.

### Level 1 Strangers

In this level, the player can find that the background is black and there are two shiny white balls, which present two people who haven’t met each other. One ball is moving and can be controlled by the player using the paddle, and the other ball is still behind the bricks. The goal for the player is to use the paddle to help one ball bump into the other one after hitting some bricks. When the two balls meet each other, there will be a small animation and one of the balls turns yellow, while the other turns green.

### Level 2 Friends
In this level, the background becomes lavender, which indicates that the two people get closer. The blue ball is moving controlled by the player using the paddle while the yellow ball is hiding in one brick. Each time the blue ball hits the brick where the yellow ball hides, the yellow ball jumps into another brick. This setting indicates the state that one person chases the other one and the other person flee away shyly. Therefore, the goal for the player is to use the blue ball to hit every brick so that it will finally meet the yellow ball.

### Level 3 Lovers
In this level, the bricks are placed to be like the shape of heart, and they are shrinking and expanding like heartbeats, which shows that the two people fall in love with each other. The bricks are red initially, when hit they become gray. The player can find that the speed of the ball and frequency of the heartbeat become larger and larger, which indicates the relationship between the two people becomes out of control. Finally when all the bricks are hit, the heart becomes gray and the level is over.

### Level 4 Strangers
At the beginning of this level, the ball, which is shining and white like the ball in Level 1, will go through a track in the shape of a heart. There are only 9 bricks in this level, which are placed in the middle of the screen in the shape of a square. The bricks are initially all blue, and a brick hit once will become green; a brick hit twice will become yellow; a brick hit three times will become orange; a brick hit four times will become red; a brick hit five times will finally disappear. The goal for the player is to eliminate all the bricks, which indicates that the estrangement between the two people is finally eliminated.

### Level 5 Companions
The two balls appear again. However, they are no longer balls. Instead, become paddles in this level: the blue ball is on the bottom and the yellow ball is on the top. The player should control both the paddles to let the ball to hit the bricks which are places on the left and right sides of the screen. This setting indicates that the two people live with each other and dealing with everything together as companions.

### Level 6 Death
In this level, there are one word behind each brick. When a brick is hit by the ball, the word behind it appears. The goal for the player is to hit all the bricks and finally find the whole sentence, which presents the epitaph of the two people.


## Features
1. We have set different game levels, and each level has a unique story to tell. The stories of different levels are set to be coherent, which are the plots of a complete story.
1. We have added some animations among the game levels to beautify our game and make our storytelling more fluent.
1. We have added different shapes of paddles instead of just rectangles. The paddles can even be like a ball in some game levels, which can absolutely add more fun to our game.
1. In some game levels, there are 2 balls instead of just one, and the balls are given anthropomorphic meaning, where they represents the pair of lovers.
1. The backgrounds in our game are no longer gray at all time. We give different backgrounds to different game levels to create the atmospheres which can suit the stories in different game levels.
1. Some interesting settings are also applied in our game to better suit the plots of the story, like in one game level, the player may find that he is dealing with two balls and an extra paddle is hidden; in one game level, the game is set to be extremely hard so that the player must fail, which leads to the next plot.

## Tech Aspect

### Features, not Bugs!

- Strangers - the level will pass only if the two balls meet. 
- Lovers - the ball speeds up; if the remaining blocks are less than 5, the game will be sure to pass, since it's already "heart broken".
- Strangers II - The paddle is flattened for a standardized game experience. If the browser performance is good enough, the music and the game will stop simultaneously. [ G ] od mod recommended.
- Strangers II - At some point the ball **directly hit through** the block. This is a metaphor for breaking the ice, namely, a **feature**. All the other collisions are good, in all the other levels.
- Press D will force skip level - designed for [ D ] ebug
- The buttons on Pause menu are clickable even if the player haven't played to that level. This is because we want to let the players who figure this out on their second try and to be surprised. In fact, if you inspect our code, you'll find the signs that we've done the level check before, but removed just for fun. 
- **All** fade animations and music-starting time on the cover of each level are deliberately designed to be that way. Don't feel shock if they aren't "standard". 
- This is a game suitable for 15-20 mins, not just 6 mins. 
- 43 files and a handful of music, this, is a serious plot-based game.  

### How we did this - Game Model Design

#### State

All the fade-in-and-outs, brick-moving, and color-shifts, are done by the State mechanism. It's a List in our Model for containing animation states. Any animation can be abstracted as a function inputting a model and some $t\in[0,1]$, and then output the new model. The curve in VV285, for example, is done this way. 

We mainly designed two basic maps, Linear and Bezier. We use the type `State` defined in `Model.elm` to record the `t` of any animation, `value` for some map of `t`, and `function` for the change of animation on model, i.e. the change of ball position, which is a `Func (Model -> Float -> Model)` to avoid type alias recursion (since it involves a Model within a Model).

#### Static and Passive

`gameStatus` and `visualization` are fields in `Model`. They are updated in every Tick, and `visualization` will be shown. `gameStatus`, on the other side, takes the place of `Msg` to control the whole `update` function. `Msg` is only used when being called by certain `gameStatus`. In this way, the Model is the boss, not some random user input. Don't worry about frequent submission. It's minimized.

#### separated `init, update & view`

Every level has their own system, which is team-work friendly. Important arguments are passed by `reInit` in `Main.elm`, for united game experience.

### How we did this - Work divided

One guy: Game Model and Game idea design, building up the structure as well as many detailed levels. This is the control flow guy.

One guy: With all the difficult collision at hand, this guy checks the collision and make sure all the hits are good, also making many detailed levels. Meet the collision guy.

Yet another guy: Visualization of the game, subtle and delicate color design, and fade animations; also many detailed levels. Come and see our visual guy...or lady.

Still another guy: Hardworking and learning fast, he's the one you must get to if you need a hand for any miscellaneous work. Check out the debug guy.

Everyone is contributing a lot, both to the project as their part and to every level in detail, this is an ideal teamwork pattern. Really. Personally I just like this team. A lot.

### Reflection

#### What, if?

This is about if expressions. We'll see if it can be updated in time.

#### Type System in Elm

Similarly, we'll see.
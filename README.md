===========================================================
#              README : HEXASWEEPER PROJECT
===========================================================

## 1/ What is the hexa sweeper project ?

It's a response to a challenge launched by the [L&Ouml;VE][LOVE] cummunity. ([link to the project on the forum][tpe1])
The aim of the challenge is to create a game in only one month (february) with the theme "Wrong places".
So, i came up with this idea : "What was your worst experience (gammingly speaking) about wrong places ? Sweeper !"

And here is my project : make a sweeper ! but... with an hexagonal map (i love hexagones !). The first goal i want to achieve is a working game with the regular rules, and if i got good ideas and the time to do it, add an alternate gamemode.


## 2/ Project plan

Here is the list of steps i will follow :

    - Create the file architecture
    - Build a state application framework
    - Make a main menu with credits, difficulty/size choice, music/sounds options ...
    - Make a grid generator
    - Display the grid
    - Add user interactions with the grid
    - Winning / loosing the game
    - Make a background music and sound effects
    - Add the hypothetic second game mode
    - Make a mathematically advanced generator so you can resolve the grid by pure logic, and don't end up with a 50/50 % to explode ! (a bit ambicious ^^)
    

## 3/ Advancements

    - Architecture : Done
    - Apps framework : Done
    - Main menu : 90%
    - Grid generator : done [ramdom]
    - Grid display : simplest [6 edges circles] + colored counts
    - Grid annalyser : trapped neighboors counts
    - HexaTiles : Guesses and activations (game is playable ^^)
    - Zoom capabillities
    - Winning and loosing
    - Tweaked the difficulty a bit
    - Alpha 0.1 released !

## 4/ Credits

Some images I use here were found at [openClipart][ocp] , other were made using [the Gimp][gimp].



pakoskyfrog, the 4th of february

ps : I'm french so i may make some english mistakes ! ^^

[LOVE]: http://love2d.org
[ocp]: http://openclipart.org
[gimp]: http://www.gimp.org/
[tpe1]: https://love2d.org/forums/viewtopic.php?f=3&t=13519
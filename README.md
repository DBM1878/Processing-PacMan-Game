# Processing-PacMan-Game
Group project where we created a PacMan like game in Processing

This game was made in processing-3.5.4
Processing is an integrated development environment and graphics library that utilizes the Java programming language with additional simplifications.


# Project Overview
In this PacMan like game you play as a student trying to graduate their classes for the semester.
Your goal is to comlete the 15 levels which will increase in difficulty over time with as high of a Grades scroe as possible.
The obsatcle trying to stop you from completing this game are bullies and professors who will track the player location and try to stop them. 

Each level, as shown below, starts with the player on the center left of the screen and the goal on the bottom right of the screen. When the player comes in contact with the goal, the will go to the next level. The bully starts at the center right of the screen and will start heading toward the player. As the player progresses through the levels the bully will get faster. Additionally, upon reaching level 10, a second slower bully will be present in the levels. Shown in the top left corner, will the number of lives that the player currently has, the player will start with 3 lives. Should the bully come in contact with the player, the player will lose a life and the current level will be reset. In the top right corner, the current level, labeled as "week" will be shown, along with the amount of powerups that the player has collected. Scattered around the screen in random locations will be 15 powerups, 5 Happiness powerups, 5 Grades powerups, and 5 wealth powerups. These powerups will provide different bonuses to the player depending on how many they collect.
![image](https://github.com/DBM1878/Processing-PacMan-Game/assets/138180545/5f3c67b3-2414-44f9-9dd4-b7874ba45892)

When the player completes the current level, they will be taken a level transition screen. This screen will tell the player about the next level and the players current stats. The player has 3 stats, Happiness, Wealth and Grades which will increase as the player collects the tokens. Grades is the players overall score that they are trying to maximize as they play. The Happinness stat affects how many lives the player has. After reaching certain thresholds, the player will gain an additional life for a maximum of 5 lives. The Wealth stat affects the players movement speed. After reaching certain thresholds, the players movement speed will increase.
![image](https://github.com/DBM1878/Processing-PacMan-Game/assets/138180545/86923a31-1968-4034-aea6-72268054ffc0)

The level transition screen will also let the player know about what kind of level they are heading into.
![image](https://github.com/DBM1878/Processing-PacMan-Game/assets/138180545/4f930158-53dd-4093-8071-ca147f4ac505)

In this game there are 2 different kinds of levels, normal levels and quiz levels. In normal levels the player can dodge the bully and collect as many tokens as they wish before heading to the goal. In quiz levels, the player must dodge the professor and collect every question token present in the level before they can comlete the level.
![image](https://github.com/DBM1878/Processing-PacMan-Game/assets/138180545/bfb1c0f1-b785-4d3a-80b0-1859aa1c5909)

![image](https://github.com/DBM1878/Processing-PacMan-Game/assets/138180545/67f9ea6c-63fe-4157-a897-d696a9ec313b)

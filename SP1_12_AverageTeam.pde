/*************
 **  File: SP2_12_AverageTeam
 **  Author: Average Team
 **  Date: 12/4/20
 **  Class + Section: COMP 101 Innovation  
 **  Email: amaarm1@umbc.edu, ncrutch1@umbc.edu, mle5@umbc.edu
 **  , dmiddou1@umbc.edu, gu26414@umbc.edu 
 **  Description:
 **  This program allows you to control a character from a selection of 5 in several levels in order to collect
 **  happiness, wealth, and grades dots.
 **  The player collects dots by eating them, however in each level there is an enemy
 **  that can take lives from you if contact is made.
 **  Lives, speed boosts, and overall grade score are determined by how many dots you collect
 **  If you lose all lives, you see a defeat screen. Every three levels, there will be a quiz level
 **  that will require you to collect all question dots to pass through. After 15 weeks have been
 **  completed, the game will end and the player will pass or fail depending on the value of grades being
 **  below or above 60.
 **  Improvements since Demo:
 **  Added a character select screen with 5 characters, made the game continue until 15 weeks/levels, added more stylistic additions
 **  to introScreen() and inbetweenWeek(), changed the scaling of stat increases from collection of wealth and lives,
 **  added more images to enemies on quiz and test levels, made quiz and test levels progressively harder
 */

//import processing.sound.*;
//SoundFile file;
int lives = 3;
int happiness = 0;
int grades = 0;
int wealth = 0;
int week = 0;
int maxWeek = 15;
float gameStart = 0;
PImage wealthDot;
PImage happinessDot;
PImage gradesDot;
PImage player1;
PImage player2;
PImage player3;
PImage player4;
PImage player5;
PImage enemy;
PImage questionDot;
PImage chalkboard;
PImage[] teacher = new PImage[5];
PImage door;
PFont font;
float playerX = 100;
float playerY = 500;
float enemyX = 900;
float enemyY = 500;
float enemyX2 = 900;
float enemyY2 = 800;
float speedDelta = 2;
float xSpeedDelta = 2;
float ySpeedDelta = 2;
int assignDotH = 0;
int assignDotW = 0;
int assignDotG = 0;
int assignDotQM = 0;
final float STARTBUTTON_X = 500;
final float STARTBUTTON_Y = 600;
final float STARTBUTTON_SIZE = 200;
final float PLAYER_SIZE = 100;
final float ENEMY_SIZE = 100;
final float DOT_SIZE = 40;
final float INTROSCREENBUTTON_X = 800;
final float INTROSCREENBUTTON_Y = 800;
float[] dotsHX = new float[5];
float[] dotsHY = new float[5];
float[] dotsWX = new float[5];
float[] dotsWY = new float[5];
float[] dotsGX = new float[5];
float[] dotsGY = new float[5];
float[] dotsQuestionMarksX = new float[30];
float[] dotsQuestionMarksY = new float[30];
PImage[] backgrounds = new PImage[16];
final float EXIT_X = 900;
final float EXIT_Y = 900;
float enemySpeedDelta = 1;
float enemySpeedDelta2 = 1.5;
float livesX1 = 50;
float livesX2 = 100;
float livesX3 = 150;
float livesX4 = -100;
float livesX5 = -100;
float livesY1 = 50;
float livesY2 = 50;
float livesY3 = 50;
float livesY4 = -100;
float livesY5 = -100;
int livesGained = 0;
int questionMarksCollected = 0;
int playerSelect = 0;
int characterSelected = 0;

//void setup() loads all of the images for the icons, characters, backgrounds, and sounds
//while also establishing the canvas's size and plays BGM
void setup() {
  size(1000, 1000);
  
  wealthDot = loadImage("8bitdollar.png");
  happinessDot = loadImage("8bitpartyhat.png");
  gradesDot = loadImage("8bitpencilandpaper.png");
  questionDot = loadImage("8bitquestionmark.png");
  
  player1 = loadImage("player1.png");
  player2 = loadImage("player2.png");
  player3 = loadImage("player3.png");
  player4 = loadImage("player4.png");
  player5 = loadImage("player5.png");
  enemy = loadImage("enemy.png");
  loadTeacher();
  
  chalkboard = loadImage("8bitchalkboard.jpg");
  door = loadImage("8bitdoor.png");
  font = createFont("8bitfont.ttf", 32);
  textFont(font);
  loadBackgrounds();

  //file = new SoundFile(this, "happyIntroMusic.mp3");
  //file.loop();
  //file.amp(0.1);
}

//draw() continuously draws the level of the game or in between week screens based on the state of gameStart
void draw() {
  if (gameStart == 0) {
    startScreen();
  }
  if (gameStart == 1 && week == 1) {
    introScreen();
  }
  if (gameStart == 3) {
    characterSelect();
  }
  if (gameStart == 2) {
    drawLevel();
  }
  if (gameStart == 1 && week > 1) {
    inbetweenWeek();
  }
}

//drawStartButton() draws a rectangle with text Start inside of it
void drawStartButton() {
  stroke(250, 240, 90);
  strokeWeight(4);
  rectMode(CENTER);
  fill(255);
  rect(STARTBUTTON_X, STARTBUTTON_Y, STARTBUTTON_SIZE, STARTBUTTON_SIZE, 50);
  textAlign(CENTER);
  textSize(36);
  fill(255);
  rect(500, 235, 825, 100);
  fill(0);
  text("UMBC Student Simulator", width / 2, height / 4);
  text("Start", width / 2, height / 2 + 100);
}

//startScreen() creates the initial start screen with a background and start button which starts the game if pressed
void startScreen() {

  //draws background0 image and creates a rectangle with "start" inside of it.
  drawBackgrounds();
  drawStartButton();

  //calculates distance between mouse and start button and if pressed, gamestart++
  float dist = sqrt((mouseX - STARTBUTTON_X) * (mouseX - STARTBUTTON_X) + (mouseY - STARTBUTTON_Y) * (mouseY - STARTBUTTON_Y));
  if (mousePressed == true && dist <= 150) {
    gameStart ++;
    week ++;
    background(0);
  }
}

//drawLevel() calls various functions that draw components of each week level, checks conditions, and assign locations of dots
void drawLevel() {
  if (week > maxWeek) {
    endSemester();
  }
  if (week <= maxWeek) {
    //clears background entirely, calls image background
    background(0);
    drawBackgrounds();

    //draw dots based on assignment from assign(Happiness,Wealth,Grades,Question)dots
    drawDots();

    //redraws player and enemy, moves them, and draws condition board
    drawPlayer();
    displayConditions();
    drawEnemy();
    moveEnemy();
    keyPressed();

    //checks bounds for players and enemy, draws lives, and ends week if bottom right is met by player
    playerBounds();
    enemyBounds();
    endWeek();
    drawLives();

    devEndSemester();
    //assigns x and y coordinates to happiness, wealth, grades, and question dots
    if (week % 3 != 0) {
      if (assignDotH == 0) {
        assignHappinessDots();
      }
      if (assignDotW == 0) {
        assignWealthDots();
      }
      if (assignDotG == 0) {
        assignGradeDots();
      }
    }
    if (week % 3 == 0) {
      if (assignDotQM == 0) {
        assignQuestionDots();
      }
    }
  }
}

//assignHappinessDots() assigns random x and y values for happiness icons
void assignHappinessDots() {
  for (int i = 0; i < 5; i++) {
    dotsHX[i] = random(20, 880);
    dotsHY[i] = random(160, 880);
    assignDotH = 1;
  }
}

//assignWealthDots() assigns random x and y values for wealth icons
void assignWealthDots() {
  for (int i = 0; i < 5; i++) {
    dotsWX[i] = random(20, 880);
    dotsWY[i] = random(160, 880);
    assignDotW = 1;
  }
}

//assignGradeDots() assigns random x and y values for grade icons
void assignGradeDots() {
  for (int i = 0; i < 5; i++) {
    dotsGX[i] = random(20, 880);
    dotsGY[i] = random(160, 880);
    assignDotG = 1;
  }
}

//drawDots() draws all of the happiness, wealth, and grade icons for each level
//and also removes the icons when the player has passed over them.
void drawDots() {
  if (week % 3 != 0) {

    //draws grades, happiness, and wealth icons 5 times each at their x and y values in their respective arrays
    for (int i = 0; i < 5; i++) {
      imageMode(CENTER);
      image(happinessDot, dotsHX[i], dotsHY[i], DOT_SIZE, DOT_SIZE);
      image(wealthDot, dotsWX[i], dotsWY[i], DOT_SIZE, DOT_SIZE);
      image(gradesDot, dotsGX[i], dotsGY[i], DOT_SIZE, DOT_SIZE);

      //calculates the distance between player and all the dot and adds to happiness, wealth, or grades values if player reaches icons
      float distH = sqrt((dotsHX[i] - playerX) * (dotsHX[i] - playerX) + (dotsHY[i] - playerY) * (dotsHY[i] - playerY));
      if (distH <= 40) {
        dotsHX[i] = -100;
        dotsHY[i] = -100;
        happiness += 1;
      }

      float distW = sqrt((dotsWX[i] - playerX) * (dotsWX[i] - playerX) + (dotsWY[i] - playerY) * (dotsWY[i] - playerY));
      if (distW <= 40) {
        dotsWX[i] = -100;
        dotsWY[i] = -100;      
        wealth += 1;
      }

      float distG = sqrt((dotsGX[i] - playerX) * (dotsGX[i] - playerX) + (dotsGY[i] - playerY) * (dotsGY[i] - playerY));
      if (distG <= 40) {
        dotsGX[i] = -100;
        dotsGY[i] = -100;
        grades += 1;
      }
    }

    //draws question mark dots on week 3 and adds to questionMarksCollected if player reaches question mark dots
  } else if (week % 3 == 0) {
    int i = 0;
    if (week == 3) {
      i = 20;
    }
    if (week == 6) {
      i = 15;
    }
    if (week == 9) {
      i = 10;
    }
    if (week == 12) {
      i = 5;
    }
    for (int g = i; g < 30; g++) {
      imageMode(CENTER);
      image(questionDot, dotsQuestionMarksX[g], dotsQuestionMarksY[g], DOT_SIZE, DOT_SIZE);

      float distQM = sqrt((dotsQuestionMarksX[g] - playerX) * (dotsQuestionMarksX[g] - playerX) + (dotsQuestionMarksY[g] - playerY) * (dotsQuestionMarksY[g] - playerY));
      if (distQM <= 40) {
        dotsQuestionMarksX[g] = -100;
        dotsQuestionMarksY[g] = -100;
        questionMarksCollected ++;
      }
    }
  }
}

// This code draws text explaining the objective and important concepts of the game
// It also has images to show the player the different icons that they can pick up
// and a button in the bottom left that will send them to the first level.
void introScreen() {
  textAlign(CENTER);
  textSize(12);
  fill(250, 240, 90, 220);
  text("Welcome to UMBC Student Simulator!", 500, 200);
  text("You will go through the life and process of a student during a semester.", 500, 225);
  text("Once the game begins, you dictate how your semester will go.", 500, 250);
  text("During each week or level, of the semester, you can pick up dots.", 500, 275);
  text("These dots: happiness, wealth, or grades, are necessary for a successful semester.", 500, 300);
  text("Based on the dots you collect, you will obtain stat increases in speed and lives", 500, 325);
  text("Be cautious though, there are enemies, quizzes, and test levels up ahead,", 500, 350);
  text("with your final being on week 15. Be prepared!", 500, 375);
  rectMode(CENTER);
  fill(255);
  textSize(22);
  text("Grades", 700, 510);
  text("Wealth", 300, 510);
  text("Happiness", 500, 510);
  image(wealthDot, 300, 600, 150, 150);
  image(happinessDot, 500, 600, 150, 150);
  image(gradesDot, 700, 600, 150, 150);
  continueButton();
  float dist2 = sqrt((mouseX - INTROSCREENBUTTON_X) * (mouseX - INTROSCREENBUTTON_X) + (mouseY - INTROSCREENBUTTON_Y) * (mouseY - INTROSCREENBUTTON_Y));
  if (mousePressed == true && dist2 <= 150) {
    gameStart = 3;
    background(0);
  }
}

//drawPlayer() centers image player and draws the player character to the screen at playerX and playerY
void drawPlayer() {
  imageMode(CENTER);
  if (playerSelect == 1) {
    image(player1, playerX, playerY);
  }
  if (playerSelect == 2) {
    image(player2, playerX, playerY);
  }
  if (playerSelect == 3) {
    image(player3, playerX, playerY);
  }
  if (playerSelect == 4) {
    image(player4, playerX, playerY);
  }
  if (playerSelect == 5) {
    image(player5, playerX, playerY);
  }
}

//playerBounds() checks PLAYER_SIZE in relation to width and height and makes sure playerX and playerY
//don't go out of bounds
void playerBounds() {
  if (playerX > width - PLAYER_SIZE / 2) {
    playerX = width - PLAYER_SIZE / 2;
  } else if (playerX < PLAYER_SIZE / 2) {
    playerX = PLAYER_SIZE / 2;
  }
  if (playerY > height - PLAYER_SIZE / 2) {
    playerY = height - PLAYER_SIZE / 2;
  } else if (playerY < PLAYER_SIZE / 2) {
    playerY = PLAYER_SIZE / 2;
  }
}

//keyPressed() moves the character according to which arrow keys are pressed
void keyPressed() {
  if (keyCode == UP) {
    playerY -= ySpeedDelta;
  } else if (keyCode == DOWN) {
    playerY += ySpeedDelta;
  } else if (keyCode == LEFT) {
    playerX -= xSpeedDelta;
  } else if (keyCode == RIGHT) {
    playerX += xSpeedDelta;
  }
}

//drawEnemy() centers and draws image "enemy" and "teacher" to the screen at enemyX and enemyY
void drawEnemy() {
  imageMode(CENTER);
  if (week % 3 != 0) {
    image(enemy, enemyX, enemyY);
  }
  if (week == 10 || week == 11 || week == 13 || week == 14) {
    image(enemy, enemyX2, enemyY2);
  }
  drawTeacher();
}

//enemyBounds() checks ENEMY_SIZE in relation to width and height and makes sure enemyX and enemyY
//don't go out of bounds
void enemyBounds() {
  if (enemyX > width - ENEMY_SIZE / 2) {
    enemyX = width - ENEMY_SIZE / 2;
  } else if (enemyX < ENEMY_SIZE / 2) {
    enemyX = ENEMY_SIZE / 2;
  }
  if (playerY > height - ENEMY_SIZE / 2) {
    enemyY = height - ENEMY_SIZE / 2;
  } else if (enemyY < ENEMY_SIZE / 2) {
    enemyY = ENEMY_SIZE / 2;
  }
}

//moveEnemy() moves enemy based on enemySpeedDelta, changing per week
void moveEnemy() {
  float distX = abs(enemyX - playerX);
  float distY = abs(enemyY - playerY);
  float distX2 = abs(enemyX2 - playerX);
  float distY2 = abs(enemyY2 - playerY);
  if (week == 1 || week == 2) {
    enemySpeedDelta = 1.25;
  }
  if (week == 3 || week == 4 || week == 5) {
    enemySpeedDelta = 1.50;
  }
  if (week == 6 || week == 7 || week == 8) {
    enemySpeedDelta = 1.75;
  }
  if (week == 9 || week == 10 || week == 11) {
    enemySpeedDelta = 2.0;
  }
  if (week == 12 || week == 13 || week == 14) {
    enemySpeedDelta = 2.25;
  }
  if (week == 15) {
    enemySpeedDelta = 2.5;
  }

  //enemyX and enemyY chase towards playerX and playerY at speed of enemySpeedDelta
  if (distX > distY && enemyX <= playerX) {
    enemyX = enemyX + enemySpeedDelta;
  }
  if (distX > distY && enemyX >= playerX) {
    enemyX = enemyX - enemySpeedDelta;
  } 
  if (distY > distX && enemyY <= playerY) {
    enemyY = enemyY + enemySpeedDelta;
  }
  if (distY > distX && enemyY >= playerY) {
    enemyY = enemyY - enemySpeedDelta;
  }

  // Movement of enemy 2
  if (distX2 > distY2 && enemyX2 <= playerX) {
    enemyX2 = enemyX2 + enemySpeedDelta2;
  }
  if (distX2 > distY2 && enemyX2 >= playerX) {
    enemyX2 = enemyX2 - enemySpeedDelta2;
  } 
  if (distY2 > distX2 && enemyY2 <= playerY) {
    enemyY2 = enemyY2 + enemySpeedDelta2;
  }
  if (distY2 > distX2 && enemyY2 >= playerY) {
    enemyY2 = enemyY2 - enemySpeedDelta2;
  }
}

//displayConditions() displays a chalkboard condition board on the top right with values of happiness, grades, wealth, and week
void displayConditions() {

  //draws chalkboard and four white text lines with values from week, happiness, wealth, and grades
  imageMode(CENTER);
  fill(0, 255, 0);
  image(chalkboard, width - 225, 50, 300, 120);
  fill(255);
  textSize(12);
  text("Week " + week, width - 225, 25);
  text("Happiness: " + happiness, width - 225, 50);
  text("Wealth: " + wealth, width - 225, 65);
  text("Grades: " + grades, width - 225, 80);

  //if week is 3, adds a line to chalkboard conditions including "Question Completed" and collected question marks
  if (week % 3 == 0) {
    text("Questions Completed: " + questionMarksCollected, width - 225, 95);
  }
}

//endWeek() draws a rectangle on the bottom right and if the player is there, exits level and calls inbetweenWeek()
void endWeek() {

  //draws an exit rectangle.
  fill(0, 250, 0);
  imageMode(CENTER);
  image(door, EXIT_X, EXIT_Y);

  //calculates distance between player and exit, and if < 50, transitions to inbetweenWeek() with gameStart = 1
  float dist = sqrt((playerX - EXIT_X) * (playerX - EXIT_X) + (playerY - EXIT_Y) * (playerY - EXIT_Y));
  if (week % 3 != 0) {
    if (dist <= 50) {
      week ++;
      gameStart = 1;
    }
  }

  //calculates distance between player and exit as well as if 20 question marks collected, transitions to endSemester()
  //and grades +=10 if week is 3.
  if (week % 3 == 0) {
    if (dist <= 50 && questionMarksCollected == 10 && week == 3 ||
      dist <= 50 && questionMarksCollected == 15 && week == 6 ||
      dist <= 50 && questionMarksCollected == 20 && week == 9 ||
      dist <= 50 && questionMarksCollected == 25 && week == 12 ||
      dist <= 50 && questionMarksCollected == 30 && week == 15) {
      week ++;
      gameStart = 1;
      grades += 10;
      assignDotQM = 0;
      if (week == 15) {
        endSemester();
      }
    }
  }
}

//inbetweenWeek() creates a black screen with text with information on the week completed after the level is done
//it also displays newly changed speed values, grade levels, lives, resets the level, and shares information on the next week
void inbetweenWeek() {

  //draws standard week completion screen with text and updated values from drawDots()
  if (week % 3 != 0) {
    background(0);
    fill(250, 240, 90, 235);
    stroke(255);
    strokeWeight(4);
    rect(500, 500, 700, 300, 75);
    fill(0, 255, 0);
    textAlign(CENTER);
    textSize(50);
    text("Week Completed!", 500, 150);
    textSize(25);
    fill(255);
    text("You have completed week " + (week - 1) + ".", 500, 410);
    text("Your attributes are now:", 500, 440);
    textSize(20);
    text("Happiness: " + happiness + " with " + lives + " lives ", 500, 550);
    text("Wealth: " + wealth + " with a speed of " + speedDelta, 500, 580);
    text("Grades: " + grades, 500, 610);
  }

  //draws a new week completion screen with text and updated values and information on the "boss" level
  if (week % 3 == 0 ) {
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(50);
    text("Week Completed", 500, 150);
    textSize(14);
    text("You have completed week " + (week - 1) + ".", 500, 350);
    if (week == 3 || week == 6 || week == 9 || week == 12) {
      text("The next level is a quiz level.", 500, 380);
      text("If you complete the level successfully, you gain +10 grade!", 500, 440);
    }
    if (week == 15) {
      text("The next level is your final test level.", 500, 380);
      text("After you complete, you will be done with your semester.", 500, 440);
    }
    text("To complete the level, you must collect all of the question dots.", 500, 410);
    text("After collecting the dots, go to the exit as usual.", 500, 470);
    text("Your attributes are now:", 500, 500);
    textSize(20);
    text("Happiness: " + happiness + " with " + lives + " lives ", 500, 600);
    text("Wealth: " + wealth + " with a speed of " + speedDelta, 500, 630);
    text("Grades: " + grades, 500, 660);
  }

  //resets coordinates of images on the week level to allow everything to be in new positions for next level
  changeInSpeed();
  continueButton();
  assignDotW = 0;
  assignDotG = 0;
  assignDotH = 0;
  playerX = 100;
  playerY = 500;
  enemyX = 900;
  enemyY = 500;
  questionMarksCollected = 0;
}

//continueButton() draws a "continue" button and if mouse is clicked on top of it, game transitions to next level
void continueButton() {

  //draws rectangle with "continue" inside
  stroke(250, 240, 90, 220);
  strokeWeight(4);
  rectMode(CENTER);
  fill(255);
  rect(INTROSCREENBUTTON_X, INTROSCREENBUTTON_Y, STARTBUTTON_SIZE, STARTBUTTON_SIZE, 50);
  fill(0);
  textSize(24);
  text("Continue", INTROSCREENBUTTON_X, INTROSCREENBUTTON_Y);

  //calculates distance between the continue button and mouse and if pressed, starts next level
  float dist2 = sqrt((mouseX - INTROSCREENBUTTON_X) * (mouseX - INTROSCREENBUTTON_X) + (mouseY - INTROSCREENBUTTON_Y) * (mouseY - INTROSCREENBUTTON_Y));
  if (mousePressed == true && dist2 <= 150 && playerSelect != 0) {
    if (gameStart == 3) {
      gameStart = 2;
    }
    else {
    gameStart ++;
    }
  }
}

//loadBackgrounds() loads background images from data folder into backgrounds[] array
void loadBackgrounds() {
  for (int i = 0; i < backgrounds.length; i++) {
    backgrounds[i] = loadImage("background" + i + ".jpg");
  }
}

//drawBackgrounds() draws background images from backgrounds[] array based on week
void drawBackgrounds() {
  for (int i = 0; i < backgrounds.length; i++) {
    if (week == i) {
      imageMode(CENTER);
      image(backgrounds[i], 500, 500);
    }
  }
}

//loadTeacher() loads teacher0-4.png images from data folder to teacher[] array.
void loadTeacher() {
  for (int i = 0; i < teacher.length; i++) {
    teacher[i] = loadImage("teacher" + i + ".png");
  }
}

//drawTeacher() draws teacher images from teacher[] array based on week
void drawTeacher() {
  if (week == 3) {
    image(teacher[0], enemyX, enemyY);
  } else if (week == 6) {
    image(teacher[1], enemyX, enemyY);
  } else if (week == 9) {
    image(teacher[2], enemyX, enemyY);
  } else if (week == 12) {
    image(teacher[3], enemyX, enemyY);
  } else if (week == 15) {
    image(teacher[4], enemyX, enemyY);
  }
}

// drawLives() draws and tracks the number of lives the player has as well as
// adding additional lives once certain conditions have been met.
// This code also adds a lose screen if all lives are lost
void drawLives() {
  imageMode(CENTER);

  //if happiness reaches the certain values, the user gains a life and an extra image is drawn on the top left
  if (happiness == 10 && livesGained == 0) {
    lives += 1;
    livesGained = 1;
  }
  if (happiness == 20 && livesGained == 1) {
    lives += 1;
    livesGained = 2;
  }
  if (happiness == 30 && livesGained == 2) {
    lives += 1;
    livesGained = 3;
    if (lives > 5) {
      lives = 5;
    }
  }
  if (happiness == 40 && livesGained == 3) {
    lives += 1;
    livesGained = 4;
    if (lives > 5) {
      lives = 5;
    }
  }
  if (happiness == 50 && livesGained == 4) {
    lives += 1;
    livesGained = 5;
    if (lives > 5) {
      lives = 5;
    }
  }
  if (lives == 2) {
    livesX2 = 100;
    livesY2 = 50;
  }
  if (lives == 3) {
    livesX3 = 150;
    livesY3 = 50;
  }
  if (lives == 4) {
    livesX4 = 200;
    livesY4 = 50;
  }
  if (lives == 5) {
    livesX5 = 250;
    livesY5 = 50;
  }
  if (playerSelect == 1) {
    image(player1, livesX1, livesY1, 75, 75);
    image(player1, livesX2, livesY2, 75, 75);
    image(player1, livesX3, livesY3, 75, 75);
    image(player1, livesX4, livesY4, 75, 75);
    image(player1, livesX5, livesY5, 75, 75);
  }
  if (playerSelect == 2) {
    image(player2, livesX1, livesY1, 75, 75);
    image(player2, livesX2, livesY2, 75, 75);
    image(player2, livesX3, livesY3, 75, 75);
    image(player2, livesX4, livesY4, 75, 75);
    image(player2, livesX5, livesY5, 75, 75);
  }
  if (playerSelect == 3) {
    image(player3, livesX1, livesY1, 75, 75);
    image(player3, livesX2, livesY2, 75, 75);
    image(player3, livesX3, livesY3, 75, 75);
    image(player3, livesX4, livesY4, 75, 75);
    image(player3, livesX5, livesY5, 75, 75);
  }
  if (playerSelect == 4) {
    image(player4, livesX1, livesY1, 75, 75);
    image(player4, livesX2, livesY2, 75, 75);
    image(player4, livesX3, livesY3, 75, 75);
    image(player4, livesX4, livesY4, 75, 75);
    image(player4, livesX5, livesY5, 75, 75);
  }
  if (playerSelect == 5) {
    image(player5, livesX1, livesY1, 75, 75);
    image(player5, livesX2, livesY2, 75, 75);
    image(player5, livesX3, livesY3, 75, 75);
    image(player5, livesX4, livesY4, 75, 75);
    image(player5, livesX5, livesY5, 75, 75);
  }

  //player loses life if enemy is within distance of player character and locations are reset
  float dist = sqrt((playerX - enemyX)*(playerX - enemyX) + (playerY - enemyY)*(playerY - enemyY));
  if (dist < 40) {
    if (livesX2 == -100 && livesY2 == -100) {
      livesX1 = -100;
      livesY1 = -100;
    }
    if (livesX3 == -100 && livesY3 == -100) {
      livesX2 = -100;
      livesY2 = -100;
    }
    if (livesX4 == -100 && livesY4 == -100) {
      livesX3 = -100;
      livesY3 = -100;
    }
    if (livesX5 == -100 && livesY5 == -100) {
      livesX4 = -100;
      livesY4 = -100;
    }
    livesX5 = -100;
    livesY5 = -100;
    playerX = 100;
    playerY = 500;
    enemyX = 900;
    enemyY = 500;
    enemyX2 = 900;
    enemyY2 = 800;
    lives -= 1;
  }

  //draws lose screen if player loses all lives
  if (livesX1 == -100 && livesY1 == -100) {
    background(0);
    textAlign(CENTER);
    textSize(40);
    fill(255, 0, 0);
    text("You Failed The Semester!", width/2, height/2);
    stop();
  }
}

//assignQuestionDots() assigns values to arrays dotsQuestionMarksX and dotsQuestionMarksY to correspond to
//x and y values of question mark dots of week 3
void assignQuestionDots() {
  for (int i = 0; i < 30; i++) {
    dotsQuestionMarksX[i] = random(20, 880);
    dotsQuestionMarksY[i] = random(160, 880);
    assignDotQM = 1;
  }
  assignDotQM = 1;
}

//changeInSpeed() checks for certain wealth values and if met, speed of player increases
void changeInSpeed() {
  if (wealth >= 10 && wealth < 20) {
    xSpeedDelta = 2.2;
    ySpeedDelta = 2.2;
    speedDelta = xSpeedDelta;
  }
  if (wealth >= 20 && wealth < 30) {
    xSpeedDelta = 2.4;
    ySpeedDelta = 2.4;
    speedDelta = xSpeedDelta;
  }
  if (wealth >= 30 && wealth < 40) {
    xSpeedDelta = 2.6;
    ySpeedDelta = 2.6;
    speedDelta = xSpeedDelta;
  }
  if (wealth >= 40 && wealth < 50) {
    xSpeedDelta = 2.8;
    ySpeedDelta = 2.8;
    speedDelta = xSpeedDelta;
  }
  if (wealth == 50) {
    xSpeedDelta = 3;
    ySpeedDelta = 3;
    speedDelta = xSpeedDelta;
  }
}

//endSemester() draws a text screen that signifies completion of the game based on grade level after week 15
void endSemester() {
  stop();
  
  //displays winning text screen with "sucessfully passed" text and team member names
  if (grades > 60) {
    background(0);
    fill(0, 250, 0);
    textAlign(CENTER);
    textSize(50);
    text("Congratulations!", 500, 150);
    textSize(22);
    fill(255);
    text("You have successfully passed the semester.", 500, 410);
    text("Thank you for playing.", 500, 440);
    text("Credits: ", 500, 500);
    text("Nathaniel Crutchfield", 500, 530);
    text("Mikey Le", 500, 560);
    text("David Middour", 500, 590);
    text("Amaar Mir", 500, 620);
    text("William Mo", 500, 650);
  }
  
  //displays losing text screen if grades are not high enough with failing text and group names
  if (grades < 60) {
    background(0);
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(50);
    text("You have failed.", 500, 150);
    textSize(22);
    fill(255);
    text("Throughout the weeks, you were unable to", 500, 410); 
    text("maintain a high enough grade.", 500, 440);
    text("Your ending grade was: " + grades, 500, 470);
    text("Credits: ", 500, 530);
    text("Nathaniel Crutchfield", 500, 560);
    text("Mikey Le", 500, 590);
    text("David Middour", 500, 620);
    text("Amaar Mir", 500, 650);
    text("William Mo", 500, 680);
  }
}

//characterSelect() allows player to select which character icon to use when playing the game
void characterSelect() {

  noStroke();
  fill(255);
  textSize(32);
  textMode(CENTER);
  text("Character Selection", width / 2, 100);
  rectMode(CENTER);
  fill(255);
  rect(500, 300, 100, 100);
  rect(250, 300, 100, 100);
  rect(750, 300, 100, 100);
  rect(666, 600, 100, 100);
  rect(333, 600, 100, 100);
  imageMode(CENTER);
  image(player1, 500, 300);
  image(player2, 250, 300);
  image(player3, 750, 300);
  image(player4, 666, 600);
  image(player5, 333, 600);

  //calculates distance between mouse and character portaits
  float dist3 = sqrt((mouseX - 500) * (mouseX - 500) + (mouseY - 300) * (mouseY - 300));
  if (mousePressed == true && dist3 <= 100) {
    playerSelect = 1;
    characterSelected = 1;
  }
  float dist4 = sqrt((mouseX - 250) * (mouseX - 250) + (mouseY - 300) * (mouseY - 300));
  if (mousePressed == true && dist4 <= 100) {
    playerSelect = 2;
    characterSelected = 2;
  }
  float dist5 = sqrt((mouseX - 750) * (mouseX - 750) + (mouseY - 300) * (mouseY - 300));
  if (mousePressed == true && dist5 <= 100) {
    playerSelect = 3;
    characterSelected = 3;
  }
  float dist6 = sqrt((mouseX - 666) * (mouseX - 666) + (mouseY - 600) * (mouseY - 600));
  if (mousePressed == true && dist6 <= 100) {
    playerSelect = 4;
    characterSelected = 4;
  }
  float dist7 = sqrt((mouseX - 333) * (mouseX - 333) + (mouseY - 600) * (mouseY - 600));
  if (mousePressed == true && dist7 <= 100) {
    playerSelect = 5;
    characterSelected = 5;
  }

  //Code to show which character is selected
  if (characterSelected == 1) {
    rectMode(CENTER);
    fill(255);
    rect(500, 230, 100, 30);
    textMode(CENTER);
    fill(0);
    textSize(12);
    text("Selected", 500, 240);
  } else {
    rectMode(CENTER);
    fill(0);
    rect(500, 230, 100, 30);
  }
  if (characterSelected == 2) {
    rectMode(CENTER);
    fill(255);
    rect(250, 230, 100, 30);
    textMode(CENTER);
    fill(0);
    textSize(12);
    text("Selected", 250, 240);
  } else {
    rectMode(CENTER);
    fill(0);
    rect(250, 230, 100, 30);
  }
  if (characterSelected == 3) {
    rectMode(CENTER);
    fill(255);
    rect(750, 230, 100, 30);
    textMode(CENTER);
    fill(0);
    textSize(12);
    text("Selected", 750, 240);
  } else {
    rectMode(CENTER);
    fill(0);
    rect(750, 230, 100, 30);
  }
  if (characterSelected == 4) {
    rectMode(CENTER);
    fill(255);
    rect(666, 530, 100, 30);
    textMode(CENTER);
    fill(0);
    textSize(12);
    text("Selected", 666, 540);
  } else {
    rectMode(CENTER);
    fill(0);
    rect(666, 530, 100, 30);
  }
  if (characterSelected == 5) {
    rectMode(CENTER);
    fill(255);
    rect(333, 530, 100, 30);
    textMode(CENTER);
    fill(0);
    textSize(12);
    text("Selected", 333, 540);
  } else {
    rectMode(CENTER);
    fill(0);
    rect(333, 530, 100, 30);
  }
  continueButton();
}

//devEndSemester() creates key shortcuts to get to the end of the game, both pass and fail
void devEndSemester() {
  if (keyPressed) {
    if (key == '-' || key == '_') {
      week = 16;
      gameStart = 1;
    }
  }
  if (keyPressed) {
    if (key == '+' || key == '=') {
      week = 16;
      gameStart = 1;
      grades = 100;
    }
  }
  if (keyPressed) {
    if (key == 'l' || key == 'L') {
      week = 15;
      gameStart = 1;
      grades = 50;
    }
  }
}

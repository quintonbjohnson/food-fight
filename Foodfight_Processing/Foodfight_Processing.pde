import processing.serial.*;


// INSTANCE VARIABLES
Serial tray1;
Serial tray2;
Animation playerShooting; // Animation for shooting
Animation enemyShooting; // Animation for shooting
Animation meatballFly; // Animation for flying meatball
Animation enemyMeatballFly; // Animation for flying enemy meatball
Animation mashedFly; // Animation for flying mashed potatoes
Animation peasFly; // Animation for flying peas
Animation jelloFly; // Animation for flying jello
Animation playerWin; // Image for winning
Animation enemyWin; // Image for other player winning
Animation playerTray; // Animation for player hiding behind tray
Animation enemyTray; // Animation for enemy hiding behind tray
Meatball meat; // Meatball type object
Mashed mashed; // Mashed potato type object
Peas peas; // Peas type object
Jello jello; // Jello type object
EnemyMeatball enemyMeat; // Meatball type object
EnemyMashed enemyMashed; // Mashed potato type object
EnemyPeas enemyPeas; // Peas type object
EnemyJello enemyJello; // Jello type object
Arrow playerArrow; // Arrow for keeping track of spoon trajectory
EnemyArrow enemyArrow; // Arrow for keeping track of spoon trajectory
boolean playerDidFire = false; // Check to see whether or not the spoon just fired
boolean enemyDidFire = false; // Check to see whether or not the spoon just fired
boolean playerIsFlying = false; // Whether or not there is food in the air
boolean enemyIsFlying = false; // Whether or not there is food in the air
boolean didStart = false; // Whether or not the game has started yet
boolean playerDidWin = false; // Whether or not the player has won
boolean enemyDidWin = false; // Whether or not the enemy has won
boolean isPlayerHiding = false; // Whether or not the player is hiding behind the tray
boolean isEnemyHiding = false; // Whether or not the enemy is hiding behind the tray
boolean playerHasShownAnimation = false; // Whether or not the tray animation has been shown
boolean enemyHasShownAnimation = false; // Whether or not the tray animation has been shown
float theta = radians(-35); // Shooting angle
int playerOldVal = 0; // Keep track of the old trigger value
int enemyOldVal = 0; // Keep track of the old trigger value
int playerSpoonVal = 512; // Variable to keep track of the spoon's power
int enemySpoonVal = 512; // Variable to keep track of the second spoon's power
int numFrames = 12;  // The number of frames in the animation
int currentFrame = 0; // Current frame for animating
int playerHealth = 100; // Health of the bully
int enemyHealth = 100; // Health of the player
int playerSpoonTrigger; // Keeps track of if the spoon has been fired
int enemySpoonTrigger; // Keeps track of if the spoon has been fired
int[] playerSpoonValues; // Keep track of the last 5 values of the spoon
int[] enemySpoonValues; // Keep track of the last 5 values of the spoon
int playerTilted; // If the player has tilted the tray
int enemyTilted; // If the player has tilted the tray
int playerBaseX = 0; // Starting X position for hit box
int playerEndX = 150; // Starting X position for hit box
int playerBaseY = 450; // Starting X position for hit box
int playerEndY = 680; // Starting Y position for hit box
int enemyBaseX = 1180; // Starting X position for hit box
int enemyEndX = 1330; // Starting X position for hit box
int enemyBaseY = 475; // Starting X position for hit box
int enemyEndY = 695; // Starting Y position for hit box
int playerWhichFood = 0; // Index for which food is currently selected by the player
int enemyWhichFood = 0; // Index for which food is currently selected by the player
PImage player1; // Image for nerd
PImage player2; // Image for bully
PImage background; // Image for the background
PImage jelloThumb; // Image for ammo thumbnail
PImage mashedThumb; // Image for ammo thumbnail
PImage peasThumb; // Image for ammo thumbnail
PImage meatballThumb; // Image for ammo thumbnail
PImage start; //Image for start screen
PImage playerHoldTray; // Image for holding a tray up
PImage enemyHoldTray; // Image for holding a tray up
String playerAmmoType = "Peas"; // The ammo currently selected
String enemyAmmoType = "Peas"; // The ammo currently selected



// SETUP
void setup() {
  // Setting the size of the screen
  size(1440, 900);
  frameRate(60);
  
  // Creating the arrow
  stroke(Arrow.OUTLINE);
  strokeWeight(Arrow.BOLD);
  playerArrow = new Arrow(width/2 - 465, 480, 0);
  enemyArrow = new EnemyArrow(width/2 - 465, 480, 0);
  playerSpoonValues = new int[7];
  enemySpoonValues = new int[7];
  
  peas = new Peas(new PVector(0,0), new PVector(1440,900));
  mashed = new Mashed(new PVector(0,0), new PVector(1440,900));
  meat = new Meatball(new PVector(0,0), new PVector(1440,900));
  jello = new Jello(new PVector(0,0), new PVector(1440,900));
  enemyPeas = new EnemyPeas(new PVector(0,0), new PVector(1440,900));
  enemyMashed = new EnemyMashed(new PVector(0,0), new PVector(1440,900));
  enemyMeat = new EnemyMeatball(new PVector(0,0), new PVector(1440,900));
  enemyJello = new EnemyJello(new PVector(0,0), new PVector(1440,900));
  
  
  // Loading images for players and win state
  player1 = loadImage("player_01.png");
  player2 = loadImage("jock_01.png");
  background = loadImage("bg.png");
  jelloThumb = loadImage("jello_thumb.png");
  meatballThumb = loadImage("meatball_thumb.png");
  mashedThumb = loadImage("mashed_thumb.png");
  peasThumb = loadImage("peas_thumb.png");
  start = loadImage("start.png");
  playerHoldTray = loadImage("player_tray_02.png");
  enemyHoldTray = loadImage("enemy_tray_02.png");
  playerShooting = new Animation("player_", 30);
  enemyShooting = new Animation("jock_", 30);
  meatballFly = new Animation("meatball_", 30);
  enemyMeatballFly = new Animation("enemy_meatball_", 30);
  mashedFly = new Animation("mash_", 30);
  peasFly = new Animation("peas_", 30);
  jelloFly = new Animation("jello_", 30);
  playerWin = new Animation("player_win_", 30);
  enemyWin = new Animation("enemy_win_", 30);
  playerTray = new Animation("player_tray_", 30);
  enemyTray = new Animation("enemy_tray_", 30);
 
  //PRINT LIST OF SERIAL PORTS IN CONSOLE. TAKE NOTE OF WHICH IS THE ARDUINO PORT: FIRST=0, SECOND=1 ...
  println(Serial.list());

  //CHANGE THE SERIAL PORT TO THE ONE THAT ARDUINO IS CONNECTED TO
  //BY EDITING THE NUMBER x INSIDE Serial.list()[x]
  tray1 = new Serial(this, Serial.list()[3], 115200); 
  tray2 = new Serial(this, Serial.list()[4], 115200);  
}


// DRAW
void draw() {
  
  //READ DATA SENT OVER SERIAL
  String val = "";
  String val2 = "";
  
  // Keep track of the previous spoon trigger value
  playerOldVal = playerSpoonTrigger;
  enemyOldVal = enemySpoonTrigger;
  
  if (tray2.available() > 0 ) {
    val2 = tray2  .readStringUntil('\n');
    println("Val2:" + val2);
  }
  
  if (tray1.available() > 0 ) {
    val = tray1.readStringUntil('\n');
    println(val);
  }
  
  

  // FIRST SPOON READINGS
  if (val != null) {
    //REMOVE WHITE SPACE/NOISE
    val = trim(val);
    
    //READINGS CONTAINS AN ARRAY OF "STRINGS" SENT OVER FROM ARDUINO SEPARATED BY A COMMA
    String[] readings = split(val, ',');
    //ENSURE THAT ONLY THREE VALUES HAVE BEEN RECEIVED
    
    if (readings.length == 10) {
      
      //ENSURE IT IS NOT AN EMPTY STRING
      if (readings[0].length() > 0) {

        //PARSE VALUES IN READINGS ARRAY FROM STRING TO INTEGER
        playerSpoonVal = int(readings[0]);
        playerUpdateArray();
        playerSpoonTrigger = int(readings[9]);
        playerTilted = int(readings[1]);
        
        if (int(readings[2]) == 1 && playerWhichFood == 0) {
          playerAmmoType = "Mashed";
        } else if (int(readings[4]) == 1 && playerWhichFood == 0) {
          playerAmmoType = "Peas";
        } else if (int(readings[6]) == 1 && playerWhichFood == 0) {
          playerAmmoType = "Jello";
        } else if (int(readings[8]) == 1 && playerWhichFood == 0) {
          playerAmmoType = "Meatball";
        }
        if (playerTilted == 0) {
          isPlayerHiding = true;
        } else {
          isPlayerHiding = false;
        }
        // Spooon was released
        if (playerSpoonTrigger == 0 && playerOldVal == 1 && playerSpoonValues[4] > 0 && didStart && !(enemyDidWin && playerDidWin)) {
          isPlayerHiding = false;
          // Setting the flag that a piece of food was fired and that it is starting its trajectory
          playerIsFlying = true;  
          playerDidFire = true;
      
          // Initialize the food object with proper velocity and position
          int spoonCalibration = 32;
          
          // Create a new food object based on the type of food currently selected
          switch(playerAmmoType) {
            case "Peas":
              peas = new Peas(new PVector((max(playerSpoonValues) / spoonCalibration) * cos(theta), (max(playerSpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(200, 400));
              break;
              
            case "Mashed":
              mashed = new Mashed(new PVector((max(playerSpoonValues) / spoonCalibration) * cos(theta), (max(playerSpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(200, 400));
              break;
              
            case "Meatball":
              meat = new Meatball(new PVector((max(playerSpoonValues) / spoonCalibration) * cos(theta), (max(playerSpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(200, 400));
              break;
              
            case "Jello":
              jello = new Jello(new PVector((max(playerSpoonValues) / spoonCalibration) * cos(theta), (max(playerSpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(200, 400));
              break;
        }
            
        } else {
          playerDidFire = false;
          playerArrow.upSize(playerSpoonVal);
        }
      }
    }
  }
  
  // SECOND SPOON READINGS
  if (val2 != null) {
    //REMOVE WHITE SPACE/NOISE
    val2 = trim(val2);
    
    //READINGS CONTAINS AN ARRAY OF "STRINGS" SENT OVER FROM ARDUINO SEPARATED BY A COMMA
    String[] readings2 = split(val2, ',');
    //ENSURE THAT ONLY THREE VALUES HAVE BEEN RECEIVED
    
    if (readings2.length == 10) {
      
      //ENSURE IT IS NOT AN EMPTY STRING
      if (readings2[0].length() > 0) {

        //PARSE VALUES IN READINGS ARRAY FROM STRING TO INTEGER
        enemySpoonVal = int(readings2[0]);
        enemyUpdateArray();
        enemySpoonTrigger = int(readings2[9]);
        enemyTilted = int(readings2[1]);
        
        if (int(readings2[2]) == 1 && enemyWhichFood == 0) {
          enemyAmmoType = "Mashed";
        } else if (int(readings2[4]) == 1 && enemyWhichFood == 0) {
          enemyAmmoType = "Peas";
        } else if (int(readings2[6]) == 1 && enemyWhichFood == 0) {
          enemyAmmoType = "Jello";
        } else if (int(readings2[8]) == 1 && enemyWhichFood == 0) {
          enemyAmmoType = "Meatball";
        }
        if (enemyTilted == 0) {
          isEnemyHiding = true;
        } else {
          isEnemyHiding = false;
        }
        // Spooon was released
        if (enemySpoonTrigger == 0 && enemyOldVal == 1 && enemySpoonValues[4] > 0 && didStart && !(enemyDidWin && playerDidWin)) {
          isEnemyHiding = false;
          // Setting the flag that a piece of food was fired and that it is starting its trajectory
          enemyIsFlying = true;  
          enemyDidFire = true;
      
          // Initialize the food object with proper velocity and position
          int spoonCalibration = 32;
          
          // Create a new food object based on the type of food currently selected
          switch(enemyAmmoType) {
            case "Peas":
              enemyPeas = new EnemyPeas(new PVector(-(max(enemySpoonValues) / spoonCalibration) * cos(theta), (max(enemySpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(950, 400));
              break;
              
            case "Mashed":
              enemyMashed = new EnemyMashed(new PVector(-(max(enemySpoonValues) / spoonCalibration) * cos(theta), (max(enemySpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(950, 400));
              break;
              
            case "Meatball":
              enemyMeat = new EnemyMeatball(new PVector(-(max(enemySpoonValues) / spoonCalibration) * cos(theta), (max(enemySpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(950, 400));
              break;
              
            case "Jello":
              enemyJello = new EnemyJello(new PVector(-(max(enemySpoonValues) / spoonCalibration) * cos(theta), (max(enemySpoonValues) / (spoonCalibration * (width / height)) * sin(theta))), new PVector(950, 400));
              break;
        }
            
        } else {
          enemyDidFire = false;
          enemyArrow.upSize(enemySpoonVal);
        }
      }
    }
  }
  
  // If a player flings food, start the game
  if (playerSpoonTrigger >= 0 && playerOldVal == 1 && playerSpoonValues[4] > 0 
    || enemySpoonTrigger >= 0 && enemyOldVal == 1 && enemySpoonValues[4] > 0) {
    didStart = true;
  }
  
  // If the ggame has started
  if (didStart) {
    // Clear background
    background(0, 204, 204);
    image(background, 0, 0);
    
    // Update position of flying food
    if (playerIsFlying) {
      switch(playerAmmoType) {
        case "Peas":
          peas.updatePosition();
          peas.display();
          break;
          
        case "Mashed":
          mashed.updatePosition();
          mashed.display();
          break;
          
        case "Meatball":
          meat.updatePosition();
          meat.display();
          break;
          
        case "Jello":
          jello.updatePosition();
          jello.display();
          break;
      }
    }
    
    // Update position of flying food
    if (enemyIsFlying) {
      switch(enemyAmmoType) {
        case "Peas":
          enemyPeas.updatePosition();
          enemyPeas.display();
          break;
          
        case "Mashed":
          enemyMashed.updatePosition();
          enemyMashed.display();
          break;
          
        case "Meatball":
          enemyMeat.updatePosition();
          enemyMeat.display();
          break;
          
        case "Jello":
          enemyJello.updatePosition();
          enemyJello.display();
          break;
      }
    }
    
    // If the player just fired, show the shooting animation
    if (playerDidFire) {
      playerShooting.display(0, 480);
    } else  if (isPlayerHiding) {
      if (!playerHasShownAnimation) {
        playerTray.display(0, 480);
        playerHasShownAnimation = true;
      }
      image(playerHoldTray, 0, 480);
    } else {
      playerHasShownAnimation = false;
      image(player1, 0, 480);
    }
    
    // If the player just fired, show the shooting animation
    if (enemyDidFire) {
      enemyShooting.display(1180, 495);
    } else if (isEnemyHiding) {
      if (!enemyHasShownAnimation) {
        enemyTray.display(1180, 495);
        enemyHasShownAnimation = true;
      }
      image(enemyHoldTray, 1180, 495);
    } else {
      enemyHasShownAnimation = false;
      image(player2, 1180, 495);
    }
    
    // Show arrow and players
    playerArrow.display();
    enemyArrow.display();
    
    // Health bars
    strokeWeight(12);
    stroke(225,0,0);
    line(1285, 480, 1285 + enemyHealth, 480);
    strokeWeight(12);
    stroke(225,0,0);
    line(80, 465, 80 + playerHealth, 465);
    
    // Show ammo
    fill(0, 204, 204);
    stroke(255, 255, 255);
    textSize(25);
    fill (255, 255, 255);
    text(playerAmmoType, width/2 - 620, 55);
    fill(0, 0, 0, 0);
    strokeWeight(10);
    rect(width/2 - 690, width/2 - 700, width/2 - 665, width/2 - 665, 7);
    fill(51, 67, 34);
    stroke(51,67,34);
    switch(playerAmmoType) {
        case "Peas":
          image(peasThumb, width/2 - 701, width/2 - 710);
          break;
          
        case "Mashed":
          image(mashedThumb, width/2 - 708, width/2 - 722);
          break;
          
        case "Meatball":
          image(meatballThumb, width/2 - 688, width/2 - 699);
          break;
          
        case "Jello":
          image(jelloThumb, width/2 - 715, width/2 - 722);
          break;
    }
    
    // Show enemy ammo
    fill(0, 204, 204);
    stroke(255, 255, 255);
    textSize(25);
    fill (255, 255, 255);
    text(enemyAmmoType, width/2 + 585, 55);
    fill(0, 0, 0, 0);
    strokeWeight(10);
    rect(width/2 + 510, width/2 - 700, width/2 - 665, width/2 - 665, 7);
    fill(51, 67, 34);
    stroke(51,67,34);
    switch(enemyAmmoType) {
        case "Peas":
          image(peasThumb, width/2 + 498, width/2 - 710);
          break;
          
        case "Mashed":
          image(mashedThumb, width/2 + 493, width/2 - 722);
          break;
          
        case "Meatball":
          image(meatballThumb, width/2 + 512, width/2 - 699);
          break;
          
        case "Jello":
          image(jelloThumb, width/2 + 485, width/2 - 722);
          break;
    }
    
    // If the enemey health is less than 0, you have won
    if (enemyHealth <= 0) {
      background(0, 174, 239);
      playerDidWin = true;
      playerWin.display(0,0);
    }
    
    // If the player health is less than 0, the enemy has won
    if (playerHealth <= 0) {
      background(0, 174, 239);
      enemyDidWin = true;
      enemyWin.display(0,0);
    }
    
     // If a player flings food, start the game
    if ((playerSpoonTrigger >= 0 && playerOldVal == 1 && playerSpoonValues[4] > 0 
      || enemySpoonTrigger >= 0 && enemyOldVal == 1 && enemySpoonValues[4] > 0) && (enemyDidWin || playerDidWin)) {
      playerHealth = 100;
      enemyHealth = 100;
      enemyDidWin = false;
      playerDidWin = false;
    }
  
  } else {
    // Show start screen
    background(0, 174, 239);
    image(start, 0, 0);
  }
}

// HELPER FUNCTIONS
// Remove hitpoints from enemy
void hitMashed() {
  if (enemyHealth > 0 && !isEnemyHiding) {
    enemyHealth = enemyHealth - (2 + ((int)((mashed.vel.x)*1.2)));
    mashed.pos.x = 1440;
    mashed.pos.y = 900;
  }
}

void hitPeas() {
  if (enemyHealth > 0 && !isEnemyHiding) {
    enemyHealth = enemyHealth - (2 + ((int)((peas.vel.x)*0.5)));
    peas.pos.x = 1440;
    peas.pos.y = 900;
    
  }
}

void hitJello() {
  if (enemyHealth > 0 && !isEnemyHiding) {
    enemyHealth = enemyHealth - (2 + ((int)((jello.vel.x)*0.8)));
    jello.pos.x = 1440;
    jello.pos.y = 900;
  }
}

void hitMeatball() {
  if (enemyHealth > 0 && !isEnemyHiding) {
    enemyHealth = enemyHealth - (2 + ((int)((meat.vel.x)*2)));
    meat.pos.x = 1440;
    meat.pos.y = 900;
  }
}

// Remove hitpoints from enemy
void enemyHitMashed() {
  if (playerHealth > 0 && !isPlayerHiding) {
    playerHealth = playerHealth - (2 + ((int)((enemyMashed.vel.x)*-1.2)));
    enemyMashed.pos.x = 1440;
    enemyMashed.pos.y = 900;
  }
}

void enemyHitPeas() {
  if (playerHealth > 0 && !isPlayerHiding) {
    playerHealth = playerHealth - (2 + ((int)((enemyPeas.vel.x)*-0.5)));
    enemyPeas.pos.x = 1440;
    enemyPeas.pos.y = 900;
    
  }
}

void enemyHitJello() {
  if (playerHealth > 0 && !isPlayerHiding) {
    playerHealth = playerHealth - (2 + ((int)((enemyJello.vel.x)*-0.8)));
    enemyJello.pos.x = 1440;
    enemyJello.pos.y = 900;
  }
}

void enemyHitMeatball() {
  if (playerHealth > 0 && !isPlayerHiding) {
    playerHealth = playerHealth - (2 + ((int)((enemyMeat.vel.x)*-2)));
    enemyMeat.pos.x = 1440;
    enemyMeat.pos.y = 900;
  }
}

// Push arrays back in spoon readings
void playerUpdateArray() {
  playerSpoonValues[6] = playerSpoonValues[5];
  playerSpoonValues[5] = playerSpoonValues[4];
  playerSpoonValues[4] = playerSpoonValues[3];
  playerSpoonValues[3] = playerSpoonValues[2];
  playerSpoonValues[2] = playerSpoonValues[1];
  playerSpoonValues[1] = playerSpoonValues[0];
  playerSpoonValues[0] = playerSpoonVal;
}

// Push arrays back in spoon readings
void enemyUpdateArray() {
  enemySpoonValues[6] = enemySpoonValues[5];
  enemySpoonValues[5] = enemySpoonValues[4];
  enemySpoonValues[4] = enemySpoonValues[3];
  enemySpoonValues[3] = enemySpoonValues[2];
  enemySpoonValues[2] = enemySpoonValues[1];
  enemySpoonValues[1] = enemySpoonValues[0];
  enemySpoonValues[0] = enemySpoonVal;
}


// Meatball food object
class Meatball {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  Meatball(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    meatballFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.7;
    if ((pos.x >= enemyBaseX && pos.x <= enemyEndX) && (pos.y > enemyBaseY && pos.y < enemyEndY)) {
      contact = true;
      hitMeatball();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Meatball food object
class EnemyMeatball {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  EnemyMeatball(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    enemyMeatballFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.7;
    if ((pos.x >= playerBaseX && pos.x <= playerEndX) && (pos.y > playerBaseY && pos.y < playerEndY)) {
      contact = true;
      enemyHitMeatball();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Mashed potatoes food object
class Mashed {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  Mashed(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    mashedFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.5;
    if ((pos.x >= enemyBaseX && pos.x <= enemyEndX) && (pos.y > enemyBaseY && pos.y < enemyEndY)) {
      contact = true;
      hitMashed();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Mashed potatoes food object
class EnemyMashed {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  EnemyMashed(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    mashedFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.5;
    if ((pos.x >= playerBaseX && pos.x <= playerEndX) && (pos.y > playerBaseY && pos.y < playerEndY)) {
      contact = true;
      enemyHitMashed();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Peas food object
class Peas {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  Peas(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    peasFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.4;
    if ((pos.x >= enemyBaseX && pos.x <= enemyEndX) && (pos.y > enemyBaseY && pos.y < enemyEndY)) {
      contact = true;
      hitPeas();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Peas food object
class EnemyPeas {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  EnemyPeas(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    peasFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.4;
    if ((pos.x >= playerBaseX && pos.x <= playerEndX) && (pos.y > playerBaseY && pos.y < playerEndY)) {
      contact = true;
      enemyHitPeas();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
   
}


// Jello food object
class Jello {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  Jello(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    jelloFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.4;
    if ((pos.x >= enemyBaseX && pos.x <= enemyEndX) && (pos.y > enemyBaseY && pos.y < enemyEndY)) {
      contact = true;
      hitJello();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
}


// Jello food object
class EnemyJello {

  PVector pos;
  PVector vel;
  PImage[] animate;
  boolean contact = false;
  
  EnemyJello(PVector velocity, PVector position) {
    vel = velocity;
    pos = position;
  }
  
  void display() {
    jelloFly.display(pos.x, pos.y);
  }
  
  void updatePosition() {
    
    pos = new PVector(pos.x + vel.x, pos.y + vel.y);
    vel.y = vel.y + 0.4;
    if ((pos.x >= playerBaseX && pos.x <= playerEndX) && (pos.y > playerBaseY && pos.y < playerEndY)) {
      contact = true;
      enemyHitJello();
    } else {
      contact = false;
    }
  }
  
  // Check to see if it made contact with an enemy
  boolean getContact() {
    return contact;
  }
}


// Class that represents the spoon's trajectory
class Arrow {
  static final color INK = #008000, OUTLINE = 0;
  static final float BOLD = 2.0;

  int x, y;
  int lengthOfArrow;

  Arrow(int xx, int yy, int inputLength) {
    x = xx;
    y = yy;
    lengthOfArrow = inputLength;
  }
  
  void display() {
    stroke(255);
    strokeWeight(7);
    int lengthOfArrowCorrect = (lengthOfArrow+60)/3;
    line(x, y, x+(lengthOfArrowCorrect)/sqrt(2), y-(lengthOfArrowCorrect )/sqrt(2));
    line(x+(lengthOfArrowCorrect)/sqrt(2), y-lengthOfArrowCorrect/sqrt(2), x+lengthOfArrowCorrect/sqrt(2)-25, y-lengthOfArrowCorrect/sqrt(2));
    line(x+lengthOfArrowCorrect/sqrt(2), y-lengthOfArrowCorrect/sqrt(2), x+lengthOfArrowCorrect/sqrt(2), y-lengthOfArrowCorrect/sqrt(2)+25);
  }
  
  void upSize(int newLength) {
    lengthOfArrow = newLength;
  }
}


// Class that represents the enemy spoon's trajectory
class EnemyArrow {
  static final color INK = #008000, OUTLINE = 0;
  static final float BOLD = 2.0;

  int x, y;
  int lengthOfArrow;

  EnemyArrow(int xx, int yy, int inputLength) {
    x = xx;
    y = yy;
    lengthOfArrow = inputLength;
  }
  
  void display() {
    stroke(255);
    strokeWeight(7);
    int lengthOfArrowCorrect = (lengthOfArrow+60)/3;
    line(width-x, y, width-(x+(lengthOfArrowCorrect)/sqrt(2)), y-(lengthOfArrowCorrect )/sqrt(2));
    line(width-(x+(lengthOfArrowCorrect)/sqrt(2)), y-lengthOfArrowCorrect/sqrt(2), width-(x+lengthOfArrowCorrect/sqrt(2)-25), y-lengthOfArrowCorrect/sqrt(2));
    line(width-(x+lengthOfArrowCorrect/sqrt(2)), y-lengthOfArrowCorrect/sqrt(2), width-(x+lengthOfArrowCorrect/sqrt(2)), y-lengthOfArrowCorrect/sqrt(2)+25);
  }
  
  void upSize(int newLength) {
    lengthOfArrow = newLength;
  }
}


// Class for animating a sequence of GIFs
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < 10; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(0, 2) + ".png";
      images[i] = loadImage(filename);
    }
    
    for (int i = 10; i < 20; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(1, 2) + ".png";
      images[i] = loadImage(filename);
    }
    
    for (int i = 20; i < 30; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(2, 2) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
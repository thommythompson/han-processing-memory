// show screen var's
boolean showStartMenu = true;
boolean showGame = false;
boolean showEndMenu = false;

// game settings var's
int playersCount = 1;
int cardSetCount = 12;
int[] cardSetCountOptions = {12, 18, 32};
boolean deathCardsEnabled = false;
int deathCardCount; // initlialized in addDeathCards function

// in game card var's
int playersTurn = 1;
int[] playersScore = new int[2];
int[] playersTurns = new int[2];
int[] cardsClicked = {99, 99};
int[] cardsOrder; // initlialized in radomizeGrid function
boolean[] cardsRemoved; // initlialized in resetGame function
int[][] cardsCoordinates; // initlialized in resetGame function

// image var's
PImage[] cardImages = new PImage[34];
PImage background;
PShape arrowR;
PShape arrowL;

// other var's
int grid;
int delay = 0;

void setup(){

    // set screen size
    size(800,800);
    grid = int(width/20);

    // load images
    arrowR = loadShape("arrow.svg");
    arrowL = loadShape("arrow.svg");
    arrowL.rotate(radians(180));
    background = loadImage("background.jpeg");

    // load card image array
    String[] cardImageNames = {"alien.png", "bag.png", "bat.png", "bone.png", "broom.png", "candle.png", "casket.png", "cat.png", "day.png", "devil.png", "eye.png", "frankenstein.png", "hand.png", "hat.png", "house.png", "lolly.png", "moon.png", "mummy.png", "owl.png", "pan.png", "potion.png", "pumpkin.png", "rip.png", "werewolf.png", "spider.png", "spooky1.png", "suprise.png", "tree.png", "vampire.png", "web.png", "witch2.png", "zombie.png",
        "skull.png", // deathcard @ index 32
        "placeholder.png" // placeholder @ index 33
    };
    for(int i = 0; i < cardImages.length; i++){
        cardImages[i] =  loadImage(cardImageNames[i]);
    }
}

void draw(){

    // set background
    background(background);

    // div
    fill(255,255,255,int(255 * 0.9));
    noStroke();
    rect(grid * 2, grid * 2, width - (grid * 4), height - (grid * 4));

    delay(delay);
    if(showStartMenu) showStartMenu();
    if(showGame) showGame();
    if(showEndMenu) showEndMenu();
}

void changeScreen(String screen){
    switch(screen){
        case "startMenu":
            showStartMenu = true;
            showGame = false;
            showEndMenu = false;
            break;
        case "game":
            showStartMenu = false;
            showGame = true;
            showEndMenu = false;
            break;
        case "endMenu":
            showStartMenu = false;
            showGame = false;
            showEndMenu = true;
            break;
    }
}

boolean gameIsFinished(int[] cardsOrder, boolean[] cardsRemoved, int deathCardCount, int[][] cardsCoordinates){
  boolean returnValue = false;
  
  int cardsGuessed = 0; 
  for(int i = 0; i < cardsOrder.length; i++){
    if(cardsOrder[i] != 32)
       if(cardsRemoved[i]) cardsGuessed++;
  }
  
  if(cardsGuessed == (cardsCoordinates.length - deathCardCount)) returnValue = true;
  
  return returnValue;
}

int switchPlayerTurns(int playersTurn){
    int returnValue = playersTurn;

    switch(playersTurn){
        case 1:
            returnValue = 2;
            break;
        case 2:
            returnValue = 1;
            break;
    }

    return returnValue;
}

int returnCardClicked(int[][] cardsCoordinates, boolean[] cardsRemoved, int[] cardsClicked){
    int returnValue = 99;
    
    for(int i = 0; i < cardsCoordinates.length; i++){
        if(!cardsRemoved[i] && !arrayContainsValue(cardsClicked, i))
            if(rectHitTest(cardsCoordinates[i][0],cardsCoordinates[i][1],cardsCoordinates[i][2],cardsCoordinates[i][2]))
                returnValue = i;
    }

    return returnValue;
}

boolean arrayContainsValue(int[] array, int value){
    boolean arrayContainsValue = false;
  
    for (int i = 0; i < array.length; ++i)
        if (array[i] == value) arrayContainsValue = true;
    
    return arrayContainsValue;
}

void resetGame(){
    playersTurn = 1;
    playersScore[0] = playersScore[1] = 0;
    playersTurns[0] = playersTurns[1] = 0;
    cardsClicked[0] = cardsClicked[1] = 99;
    
    cardsCoordinates = calculateCardCoordinates(grid, width, cardSetCount);
    cardsRemoved = new boolean[cardsCoordinates.length];
    cardsOrder = randomizeGrid(cardsCoordinates, deathCardsEnabled);
}

int[][] calculateCardCoordinates(int grid, int width, int cardSetCount){
    
    // determine grid size & offset
    int offsetY = grid * 4;
    int offsetX = grid * 3;
    int gridSize = width - (offsetY * 2);

    // determine amount of cards per x & y axis
    int cellsPerAxis = 0;
    switch(cardSetCount){
        case 12:
            cellsPerAxis = 5;
            break;
        case 18:
            cellsPerAxis = 6;
            break;
        case 32:
            cellsPerAxis = 8;
            break;
    }

    // determine card size & offset
    int gridCellSize = int(gridSize / cellsPerAxis);
    int cardOffset = int(gridCellSize * 0.5);
    int cardSize = int(gridCellSize * 0.9);
    
    // calculating grid coordinates
    int[][] array = new int[(cellsPerAxis * cellsPerAxis)][3];
    int i = 0;
    for(int x = 0; x < cellsPerAxis; x++){
        for(int y = 0; y < cellsPerAxis; y++){
        
            array[i][0] = offsetX + cardOffset + (x * gridCellSize); // x left offset
            array[i][1] = offsetY + cardOffset + (y * gridCellSize); // y top offset
            array[i][2] = cardSize; 
            
            i++;
        }
    }
  
    return array;
}

int[] randomizeGrid(int[][] cardsCoordinates, boolean deathCardsEnabled){
    int cardCount = cardsCoordinates.length;
    boolean[] filledSpots = new boolean[cardCount];
    int[] returnValue = new int[cardCount];

    if(deathCardsEnabled){
        returnValue = addDeathCards(cardCount);
    }else if(cardCount == 25){
        // remove card in the middle
        cardsRemoved[12] = true;
        filledSpots[12] = true;
    }
    
    // count spots already filled by deathcards
    int filledSpotsCount = 0; 
    for(int i = 0; i < filledSpots.length; i++){
        if(returnValue[i] == 32) filledSpots[i] = true;
        if(filledSpots[i]) filledSpotsCount++;
    }
        
    int assignToIndex = int(random(0, cardCount));
    for(int i = 1; i <= ((cardCount - filledSpotsCount)/2); i++){
        
        // assign first card to index
        while(filledSpots[assignToIndex] == true){
            assignToIndex = int(random(0, cardCount));
        }
        returnValue[assignToIndex] = i;
        filledSpots[assignToIndex] = true;
        
        // assign second card to index
        while(filledSpots[assignToIndex] == true){
            assignToIndex = int(random(0, cardCount));
        }
        returnValue[assignToIndex] = i;
        filledSpots[assignToIndex] = true;
    }

    return returnValue;
}

int[] addDeathCards(int cardCount){
    boolean[] filledSpots = new boolean[cardCount];
    int[] returnValue = new int[cardCount];
  
    switch(cardCount){
        case 25:
            deathCardCount = 3;
            break;
        case 36:
            deathCardCount = 6;
            break;
        case 64:
            deathCardCount = 10;
            break;
    }

    int assignToIndex = int(random(0, cardCount));
    for(int i = 0; i < deathCardCount; i++){
        
        // assign first card to index
        while(filledSpots[assignToIndex] == true) assignToIndex = int(random(0, cardCount));
        returnValue[assignToIndex] = 32;
        filledSpots[assignToIndex] = true;
    }

    return returnValue; //<>//
}

String calculateWinner(int playersCount, int[] playersScore){
    String returnValue = "player1";

    if(playersCount > 1){
        if(playersScore[0] == playersScore[1]){
            returnValue = "tie";
        }
        if(playersScore[0] > playersScore[1]){
            returnValue = "player1";
        }
        if(playersScore[1] > playersScore[0]){
            returnValue = "player2";
        }
    }

    return returnValue;
}

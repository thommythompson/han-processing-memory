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

void showGame(){

    if(gameIsFinished()){
        changeScreen("endMenu");
    }

    delay = 0;
    
    showPlayerScore(grid * 4, int(grid * 2.75), 1);
    if(playersCount == 2) showPlayerScore(grid * 16, int(grid * 2.75), 2);
    
    showCardGrid();
    
    int cardClicked = returnCardClicked();
    if(cardClicked != 99){
        if(cardsOrder[cardClicked] == 32){
            cardsClicked[0] = cardClicked;
            playersTurns[playersTurn - 1]++;
            playersScore[playersTurn - 1]--;

            showCardGrid();

            cardsRemoved[cardsClicked[0]] = true;
            delay = 2000;
            if(playersCount == 2) switchPlayerTurns();
            cardsClicked[0] = cardsClicked[1] = 99;
        }else{
            if(cardsClicked[0] == 99){
                cardsClicked[0] = cardClicked;
            }else{
                cardsClicked[1] = cardClicked;
                playersTurns[playersTurn - 1]++;
                delay = 2000;

                if(cardsOrder[cardsClicked[0]] == cardsOrder[cardsClicked[1]]){
                    playersScore[playersTurn - 1]++;
                      
                    showCardGrid();

                    cardsRemoved[cardsClicked[0]] = true;
                    cardsRemoved[cardsClicked[1]] = true;
                }else{
                    showCardGrid();

                    if(playersCount == 2) switchPlayerTurns();
                }
                
                cardsClicked[0] = cardsClicked[1] = 99;
            }
        }
    }
}

boolean gameIsFinished(){
  boolean returnValue = false;
  
  int cardsGuessed = 0; 
  for(int i = 0; i < cardsOrder.length; i++){
    if(cardsOrder[i] != 32)
       if(cardsRemoved[i]) cardsGuessed++;
  }
  
  if(cardsGuessed == (cardsCoordinates.length - deathCardCount)) returnValue = true;
  
  return returnValue;
}

void showPlayerScore(int x, int y, int player){
    int score = playersScore[player-1];
    int turn = playersTurns[player-1];

    color textColor = 0;
    if(player == playersTurn) textColor = #00FF00;

    drawTextBox("Player " + player, "center", textColor, x, y, 0, grid);
    drawTextBox("Score " + score, "center", textColor, x, int(y + grid * 0.5), 0, grid);
    drawTextBox("Turn " + turn, "center", textColor, x, int(y + grid * 1), 0, grid);
}

void switchPlayerTurns(){
    switch(playersTurn){
        case 1:
            playersTurn = 2;
            break;
        case 2:
            playersTurn = 1;
            break;
    }
}

int returnCardClicked(){
    int cardPressed = 99;
    
    for(int i = 0; i < cardsCoordinates.length; i++){
        if(!cardsRemoved[i] && !arrayContainsValue(cardsClicked, i))
            if(rectHitTest(cardsCoordinates[i][0],cardsCoordinates[i][1],cardsCoordinates[i][2],cardsCoordinates[i][2]))
                cardPressed = i;
    }

    return cardPressed;
}

void showCardGrid(){
    for(int i = 0; i < cardsCoordinates.length; i++){
        if(cardsRemoved[i]){
            // card is removed from the game
        }else if(arrayContainsValue(cardsClicked, i)){
            // kaart is aangeklikt
            image(cardImages[cardsOrder[i]], cardsCoordinates[i][0], cardsCoordinates[i][1], cardsCoordinates[i][2], cardsCoordinates[i][2]);
        }else{
            // show placeholder
            image(cardImages[33], cardsCoordinates[i][0], cardsCoordinates[i][1], cardsCoordinates[i][2], cardsCoordinates[i][2]);
        }

        if(rectHoverTest(cardsCoordinates[i][0], cardsCoordinates[i][1], cardsCoordinates[i][2], cardsCoordinates[i][2])){
            fill(255,255,255,int(255 * 0.1));
            noStroke();
            rect(cardsCoordinates[i][0], cardsCoordinates[i][1], cardsCoordinates[i][2], cardsCoordinates[i][2]);
        }
    }
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
    
    cardsCoordinates = calculateCardCoordinates();
    cardsRemoved = new boolean[cardsCoordinates.length];
    randomizeGrid();
}

int[][] calculateCardCoordinates(){
    
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

void randomizeGrid(){
    int cardCount = cardsCoordinates.length;
    boolean[] filledSpots = new boolean[cardCount];
    cardsOrder = new int[cardCount];

    if(deathCardsEnabled){
        filledSpots = addDeathCards(cardCount, filledSpots);
    }else if(cardCount == 25){
        // remove card in the middle
        cardsRemoved[12] = true;
        filledSpots[12] = true;
    }
    
    // count spots already filled by deathcards
    int filledSpotsCount = 0; 
    for(int i = 0; i < filledSpots.length; i++)
        if(filledSpots[i]) filledSpotsCount++;
    
    int assignToIndex = int(random(0, cardCount));
    for(int i = 1; i <= ((cardCount - filledSpotsCount)/2); i++){
        
        // assign first card to index
        while(filledSpots[assignToIndex] == true){
            assignToIndex = int(random(0, cardCount));
        }
        cardsOrder[assignToIndex] = i;
        filledSpots[assignToIndex] = true;
        
        // assign second card to index
        while(filledSpots[assignToIndex] == true){
            assignToIndex = int(random(0, cardCount));
        }
        cardsOrder[assignToIndex] = i;
        filledSpots[assignToIndex] = true;
    }
}

boolean[] addDeathCards(int cardCount, boolean[] filledSpots){
  
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
        cardsOrder[assignToIndex] = 32;
        filledSpots[assignToIndex] = true;
    }
    return filledSpots;

}

void showEndMenu(){

    String winner = calculateWinner();

    String text = "Error determining winner";
    switch(winner){
        case "tie":
            text = "It's a tie!";
            break;
        case "player1":
            text = "Player 1 has won!";
            break;
        case "player2":
            text = "Player 2 has won!";
            break;
    }

    drawTextBox(text, "center", 0, grid * 10, grid * 3,  0, grid * 3);
    drawTextBox("Player 1, score: " + playersScore[0] + ", turns: " + playersTurns[0] , "center", 0, grid * 10, grid * 6,  0, grid * 2);

    if(playersCount > 1){
        drawTextBox("Player 2, score: " + playersScore[1] + ", turns: " + playersTurns[1] , "center", 0, grid * 10, grid * 8,  0, grid * 2);
    }

    if(drawButtonWithText(grid * 3, grid * 12, width - (grid * 6), grid * 2, #8FBC8F, "Speel opnieuw")){
        changeScreen("game");
        resetGame();
    }

    if(drawButtonWithText(grid * 3, grid * 15, width - (grid * 6), grid * 2, #8FBC8F, "Naar menu")){
        changeScreen("startMenu");
    }
}

String calculateWinner(){
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

void showStartMenu(){
    
    drawTextBox("Aantal spelers", "left", 0, grid * 3, grid * 3, 0, grid * 2);
    playersCount = drawIncrementControl(width - (grid * 9), grid * 3, grid * 6, grid * 2, #808080, 1, 2, playersCount);

    drawTextBox("Doodskaarten?", "left", 0, grid * 3, grid * 6, 0, grid * 2);
    String[] options = {"Ja", "Nee"};
    String currentlySelected = deathCardsEnabled ? "Ja" : "Nee";
    switch(drawStringSegmentControl(grid * 11, grid * 6, grid* 6, grid * 2, #808080, options, currentlySelected)){
        case "Ja":
            deathCardsEnabled = true;
            break;
        case "Nee":
            deathCardsEnabled = false;
            break;
    }

    drawTextBox("Aantal Setjes", "left", 0, grid * 3, grid * 9, 0, grid * 2);
    cardSetCount = drawIntSegmentControl(grid * 3, grid * 11, width - (grid * 6), grid * 2, #808080, cardSetCountOptions, cardSetCount);
    
    if(drawButtonWithText(grid * 3, grid * 14, width - (grid * 6), grid * 3, #8FBC8F, "Start Game")){
        changeScreen("game");
        resetGame();
    }
}

int drawIncrementControl(int x, int y, int btnWidth, int btnHeight, color btnColor, int min, int max, int currentValue){
    int returnValue = currentValue;
    btnWidth = btnWidth / 3;

    // arrow left 
    if(drawArrowButton(x, y, btnWidth, btnHeight, btnColor, "left")) returnValue = constrain(returnValue - 1, min, max);
    
    // integer
    x = x + btnWidth;
    drawTextBox(nf(currentValue), "center", 0, x, y, btnWidth, btnHeight);

    // arrow right
    x = x + btnWidth;
    if(drawArrowButton(x, y, btnWidth, btnHeight, btnColor, "right")) returnValue = constrain(returnValue + 1, min, max);
    
    return returnValue;
}

boolean drawArrowButton(int x, int y, int btnWidth, int btnHeight, color btnColor, String oriented){
    
    if(rectHoverTest(x, y, btnWidth, btnHeight)) btnColor = changeColorBrightness(btnColor, +15);
    
    switch(oriented){
      case "left":
        int shapeX = x + btnWidth;
        int shapeY = y + btnHeight;
        arrowL.disableStyle();
        fill(btnColor);
        shape(arrowL, shapeX, shapeY, btnWidth, btnHeight);
        break;
      case "right":
        arrowR.disableStyle();
        fill(btnColor);
        shape(arrowR, x, y, btnWidth, btnHeight);
        break;
    }

    boolean returnValue = rectHitTest(x, y, btnWidth, btnHeight);
    return returnValue;
}

int drawIntSegmentControl(int x, int y, int btnWidth, int btnHeight, color btnColor, int[] options, int currentlySelected){

    int returnValue = currentlySelected;
    btnWidth = btnWidth / options.length;
    color newBtnColor = btnColor;

    for(int i = 0; i < options.length; i++){
        if(options[i] == currentlySelected){
            newBtnColor = changeColorBrightness(btnColor, -30);
        }else{
            newBtnColor = btnColor;
        }
        if(drawButtonWithText(x + (i * btnWidth), y, btnWidth, btnHeight, newBtnColor, nf(options[i]))){
            returnValue = options[i];
        }
    }

    return returnValue;
}

String drawStringSegmentControl(int x, int y, int btnWidth, int btnHeight, color btnColor, String[] options, String currentlySelected){

    String returnValue = currentlySelected;
    btnWidth = btnWidth / options.length;
    color newBtnColor = btnColor;

    for(int i = 0; i < options.length; i++){
        if(options[i] == currentlySelected){
            newBtnColor = changeColorBrightness(btnColor, -30);
        }else{
            newBtnColor = btnColor;
        }
        if(drawButtonWithText(x + (i * btnWidth), y, btnWidth, btnHeight, newBtnColor, options[i])){
            returnValue = options[i];
        }
    }

    return returnValue;
}

boolean drawButtonWithText(int x, int y, int btnWidth, int btnHeight, color btnColor, String btnText){

    if(rectHoverTest(x, y, btnWidth, btnHeight)){
        fill(changeColorBrightness(btnColor, +15));
    }else{
        fill(btnColor);
    }
    rect(x, y, btnWidth, btnHeight);

    drawTextBox(btnText, "center", 0, x, y, btnWidth, btnHeight);

    boolean returnValue = rectHitTest(x, y, btnWidth, btnHeight);
    return returnValue;
}

void drawTextBox(String text, String allignment, color textColor, int x, int y, int textBoxWidth, int textBoxHeight){
    
    fill(textColor);
    textSize(textBoxHeight * 0.6);
    y = y + int((textBoxHeight / 2) * 1.25);
    if(allignment == "left"){
        textAlign(LEFT);
    }else{
        textAlign(CENTER);
        x = x + (textBoxWidth / 2);
    }
    text(text, x, y);
}

color changeColorBrightness(color originalColor, int factor){
  int red = constrain(int(red(originalColor)) + factor, 0, 255);
  int green = constrain(int(green(originalColor)) + factor, 0, 255);
  int blue = constrain(int(blue(originalColor)) + factor, 0, 255);
  
  return color(red, green, blue);
}

boolean rectHoverTest(int x, int y, int btnWidth, int btnHeight){
    boolean returnValue = false;

    if(mouseX >= x && mouseX <= (x + btnWidth)){
        if(mouseY >= y && mouseY <= (y + btnHeight)){
            returnValue = true;
        }
    }

    return returnValue;
}

boolean rectHitTest(int x, int y, int btnWidth, int btnHeight){
    boolean returnValue = false;

    if(rectHoverTest(x, y, btnWidth, btnHeight)){
        if(mousePressed){
            returnValue = true;
            
            // to avoid dubble press
            delay(50);
            mousePressed = false;
        }
    }

    return returnValue;
}

// show screen var's
boolean showStartMenu = true;
boolean showGame = false;
boolean showEndMenu = false;

// game settings var's
int playersCount = 1;
int cardSetCount = 12;
int[] cardSetCountOptions = {12, 18, 32};
boolean deathCardsEnabled = false;

// in game cars var's
int playersTurn = 1;
int[] playersScore = new int[2];
int[] playersTurns = new int[2];
int cardClicked1;
int cardClicked2;
IntList cardsOrder = new IntList();
IntList cardsRemoved = new IntList();
ArrayList<Integer[]> cardsCoordinates = new ArrayList<Integer[]>();

// image var's
PImage[] cardsImages = new PImage[32];
PImage deathCard;
PImage cardBackside;
PImage background;
PShape arrowR;
PShape arrowL;

// screen values
int grid;
int grid;

void setup(){

    // set screen size
    size(800,800);
    grid = int(width/20);
    grid = int(height/20);

    // load images
    arrowR = loadShape("arrow.svg");
    arrowL = loadShape("arrow.svg");
    arrowL.rotate(radians(180));
    background = loadImage("background.jpeg");
}

void draw(){

    // set background
    background(background);

    // div
    fill(255,255,255,int(255 * 0.9));
    noStroke();
    rect(grid * 2, grid * 2, width - (grid * 4), height - (grid * 4));

    if(showStartMenu) showStartMenu();
    // if(showGame) showGame();
    // if(showEndMenu) showEndMenu();
}

void changeScreen(String screen){
    switch(screen){
        case "startMenu":
            showStartMenu = true;
            showGame = false;
            showEndMenu = false;
            // resetGame();
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
            // resetGame();
            break;
    }
}

void resetGame(){
    // reset variables
    // cardsCoordinates = calculateCardCoordinates();
    // cardsOrder = randomizeGrid();
}

void showEndMenu(){

    
    // if aantalspeler ne 1 
        // int winner = calculateWinner();
        // if winner eq tie
            // else show winner and loser score & turns
    // else
        // show player 1 score & turns

    drawTextBox("Aantal spelers", "center", grid * 3, grid * 14, width - (grid * 6), grid * 3);


    if(drawButtonWithText(grid * 3, grid * 12, width - (grid * 6), grid * 2, #8FBC8F, "Speel opnieuw")){
        changeScreen("game");
        resetGame();
    }

    if(drawButtonWithText(grid * 3, grid * 15, width - (grid * 6), grid * 2, #8FBC8F, "Naar menu")){
        changeScreen("startMenu");
        resetGame();
    }
}

void showStartMenu(){
    
    drawTextBox("Aantal spelers", "left", 0, grid * 3, grid * 3, 0, grid * 2);
    playersCount = drawIncrementControl(width - (grid * 9), grid * 3, grid * 6, grid * 2, #808080, 1, 2, playersCount);

    drawTextBox("Doodskaarten?", "left", 0, grid * 3, grid * 6, 0, grid * 2);
    // drawStringSegmentControl

    drawTextBox("Aantal Setjes", "left", 0, grid * 3, grid * 9, 0, grid * 2);
    cardSetCount = drawIntSegmentControl(grid * 3, grid * 11, width - (grid * 6), grid * 2, #808080, cardSetCountOptions, cardSetCount);
    
    if(drawButtonWithText(grid * 3, grid * 14, width - (grid * 6), grid * 3, #8FBC8F, "Start Gane")){
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
            delay(50);
            returnValue = true;
        }
    }

    return returnValue;
}

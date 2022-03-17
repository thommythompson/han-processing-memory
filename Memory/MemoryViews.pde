void showGame(){

    if(gameIsFinished(cardsOrder, cardsRemoved, deathCardCount)){
        changeScreen("endMenu");
    }

    delay = 0;
    
    showPlayerScore(grid * 4, int(grid * 2.75), 1);
    if(playersCount == 2) showPlayerScore(grid * 16, int(grid * 2.75), 2);
    
    showCardGrid();
    
    int cardClicked = returnCardClicked(cardsCoordinates, cardsRemoved, cardsClicked);
    if(cardClicked != 99){
        if(cardsOrder[cardClicked] == 32){
            cardsClicked[0] = cardClicked;
            playersTurns[playersTurn - 1]++;
            playersScore[playersTurn - 1]--;

            showCardGrid();

            cardsRemoved[cardsClicked[0]] = true;
            delay = 2000;
            if(playersCount == 2) playersTurn = switchPlayerTurns(playersTurn);
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

                    if(playersCount == 2) playersTurn = switchPlayerTurns(playersTurn);
                }
                
                cardsClicked[0] = cardsClicked[1] = 99;
            }
        }
    }
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

void showEndMenu(){

    String winner = calculateWinner(playersCount, playersScore);

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
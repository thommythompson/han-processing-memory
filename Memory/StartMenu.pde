void startMenu(){

    int offsetX = width/5;
    int offsetY = height/6;
    int lineHeight = height/20;

    noStroke();

    aantalSpelers           = startMenuLine1(offsetX, offsetY, lineHeight, aantalSpelers);
    offsetY                 = offsetY + height/6;
    doodsKaartenGeactiveerd = startMenuLine2(offsetX, offsetY, lineHeight, doodsKaartenGeactiveerd);
    offsetY                 = offsetY + height/6;
    aantalSetjesKaarten     = startMenuLine3(offsetX, offsetY, lineHeight, aantalSetjesKaarten);
    offsetY                 = offsetY + height/6;
    spelIsGestart           = startMenuLine4(offsetX, offsetY, lineHeight, spelIsGestart);
    
    if(spelIsGestart){
        spelGridCoordinaten = berekenSpelGrid(aantalSetjesKaarten, offsetX, offsetY);
        kaartenUitHetSpel = new boolean[spelGridCoordinaten.length];        
        kaartenVolgorde = schudKaarten(spelGridCoordinaten.length);
        
        // delay to avoid accidental double press
        delay(50);
    }
}

int startMenuLine1(int offsetX, int offsetY, int lineHeight, int aantalSpelers){
    
    // text
    textSize(lineHeight);
    textAlign(LEFT);
    fill(#FFFFFF);
    text(
        "AANTAL SPELERS",
        offsetX,
        (offsetY + int(lineHeight * 0.8))
    );

    // arrow 1
    int[] arrow1 = {
        (width - (lineHeight * 3 + offsetX)), (offsetY + (lineHeight / 2)), // punt links
        (width - (lineHeight * 2 + offsetX)), offsetY, // punt boven
        (width - (lineHeight * 2 + offsetX)), (offsetY + lineHeight)  // punt onder
    };
    triangle(arrow1[0], arrow1[1], arrow1[2], arrow1[3], arrow1[4], arrow1[5]);

    // arrow 2
    int[] arrow2 = {
        (width - offsetX), (offsetY + (lineHeight / 2)), // punt rechts
        (width - (lineHeight + offsetX)), offsetY, // punt boven
        (width - (lineHeight + offsetX)), (offsetY + lineHeight)  // punt onder
    };
    triangle(arrow2[0], arrow2[1], arrow2[2], arrow2[3], arrow2[4], arrow2[5]);

    // text between arrows
    plaatsTekstInRect(nf(aantalSpelers), arrow1[2], arrow1[3], (arrow1[2] - arrow1[0]), (arrow1[5] - arrow1[3]), lineHeight);

    // detecteer klik
    if(mousePressed){
      if(raaktGelikt(arrow1[0], arrow1[3], (arrow1[2] - arrow1[0]), (arrow1[5] - arrow1[3]))){
          aantalSpelers = constrain(aantalSpelers - 1, 1, 2);
      }
      if(raaktGelikt(arrow2[2], arrow2[3], (arrow2[0] - arrow2[2]), (arrow2[5] - arrow2[3]))){
          aantalSpelers = constrain(aantalSpelers + 1, 1, 2);
      }
    }
    return aantalSpelers;
}

boolean startMenuLine2(int offsetX, int offsetY, int lineHeight, boolean doodsKaartenGeactiveerd){
    
    // text
    textSize(lineHeight);
    textAlign(LEFT);
    fill(#FFFFFF);
    text(
        "DOODSKAARTEN?",
        offsetX,
        (offsetY + int(lineHeight * 0.75))
    );

    // box 1
    int[] rect1 = {
        width - (offsetX + (lineHeight * 4)),
        offsetY,
        lineHeight * 2,
        lineHeight
    };
    if(doodsKaartenGeactiveerd){
        fill(#F0F0F0);
    }else{
        fill(#FFFFFF);
    }
    rect(rect1[0], rect1[1], rect1[2], rect1[3]);

    // box 2
    int[] rect2 = {
        width - (offsetX + (lineHeight * 2)),
        offsetY,
        lineHeight*2,
        lineHeight
    };
    if(!doodsKaartenGeactiveerd){
        fill(#F0F0F0);
    }else{
        fill(#FFFFFF);
    }
    rect(rect2[0], rect2[1], rect2[2], rect2[3]);

    // text box 1 & 2
    fill(#000000);
    plaatsTekstInRect("JA", rect1[0], rect1[1], rect1[2], rect1[3], lineHeight);
    plaatsTekstInRect("NEE", rect2[0], rect2[1], rect2[2], rect2[3], lineHeight);

    // detecteer klik
    if(mousePressed){
        if(raaktGelikt(rect1[0], rect1[1], rect1[2], rect1[3])){
            doodsKaartenGeactiveerd = true;
        }
        if(raaktGelikt(rect2[0], rect2[1], rect2[2], rect2[3])){
            doodsKaartenGeactiveerd = false;
        }
    }
    return doodsKaartenGeactiveerd;
}

int startMenuLine3(int offsetX, int offsetY, int lineHeight, int aantalSetjesKaarten){
    
    // teken
    textSize(lineHeight);
    textAlign(LEFT);
    fill(#FFFFFF);
    text(
        "AANTAL SETJES",
        offsetX, 
        (offsetY + (lineHeight / 2))
    );
    
    int[] opties = {12, 18, 32};
    int boxWidth = (width - (offsetX * 2))/opties.length;

    // teken box 1 tm 5
    for (int i = 0; i < opties.length; i++){
        int[] rect = {
            offsetX + (i * boxWidth),
            int(offsetY + (lineHeight * 1.5)),
            boxWidth,
            lineHeight
        };
        if(opties[i] == aantalSetjesKaarten){
            fill(#F0F0F0);
        }else{
            fill(#FFFFFF);
        }
        rect(rect[0], rect[1], rect[2], rect[3]);
        fill(#000000);
        plaatsTekstInRect(nf(opties[i]), rect[0], rect[1], rect[2], rect[3], lineHeight);

        // detecteer klik
        if(mousePressed){
            if(raaktGelikt(rect[0], rect[1], rect[2], rect[3])){
                aantalSetjesKaarten = opties[i];
            }
        }
    }
    return aantalSetjesKaarten;
}

boolean startMenuLine4(int offsetX, int offsetY, int lineHeight, boolean spelIsGestart){
    
    // teken
    int[] rect = {
        offsetX,
        offsetY,
        (width - (offsetX * 2)),
        lineHeight*2
    };

    fill(#FFFFFF);
    rect(rect[0], rect[1], rect[2], rect[3]);
    fill(#000000);
    plaatsTekstInRect("START SPEL", rect[0], rect[1], rect[2], rect[3], lineHeight);
    
    // detecteer klik
    if(mousePressed){
        if(raaktGelikt(rect[0], rect[1], rect[2], rect[3])){
            spelIsGestart = true;
        }
    }
    return spelIsGestart;
}

int[][] berekenSpelGrid(int aantalSetjes, int offsetX, int offsetY){
  
    int gridSize = width - (offsetX * 2);

    // determine grid size
    int cardSize = 0;
    int cardOffset = 0;
    int xMax = 0;
    int yMax = 0;
    
    switch(aantalSetjes){
        case 12:
            xMax = 5;
            yMax = 5;
            break;
        case 18:
            xMax = 6;
            yMax = 6;
            break;
        case 32:
            xMax = 8;
            yMax = 8;
            break;
    }

    int gridSquareSize = gridSize / xMax;
    cardOffset = int((gridSquareSize * 0.1) / 2);
    cardSize = int(gridSquareSize * 0.9);
        
    int[][] array = new int[(xMax * yMax)][3];
    int index = 0;
    for(int x = 0; x < xMax; x++){
        for(int y = 0; y < yMax; y++){
        
        array[index][0] = offsetX + cardOffset + (x * gridSquareSize); // x left offset
        array[index][1] = offsetX + cardOffset + (y * gridSquareSize); // y top offset
        array[index][2] = cardSize; 
        
        index++;
        }
    }
  
    return array;
}

int[] schudKaarten(int aantalKaarten){

    boolean[] gevuld = new boolean[aantalKaarten];
    kaartenVolgorde = new int[aantalKaarten];
    
    if(doodsKaartenGeactiveerd){
        gevuld = toevoegenDoodsKaarten(aantalKaarten, gevuld); 
    }else if(aantalKaarten == 25){
        kaartenUitHetSpel[12] = true;
        gevuld[12] = true;
    }
    
    int aantalGevuld = 0; //<>//
    for(int i = 0; i < gevuld.length; i++){
      if(gevuld[i]){
        aantalGevuld++;
      }
    }
    
    int assignToIndex = int(random(0, aantalKaarten));
    for(int i = 1; i <= ((aantalKaarten - aantalGevuld)/2); i++){ //<>//
        
        // assign first card to index
        while(gevuld[assignToIndex] == true){
            assignToIndex = int(random(0, aantalKaarten));
        }
        kaartenVolgorde[assignToIndex] = i;
        gevuld[assignToIndex] = true;
        
        // assign second card to index
        while(gevuld[assignToIndex] == true){
            assignToIndex = int(random(0, aantalKaarten));
        }
        kaartenVolgorde[assignToIndex] = i;
        gevuld[assignToIndex] = true;
    }

    return kaartenVolgorde; //<>//
} //<>//

boolean[] toevoegenDoodsKaarten(int aantalKaarten, boolean[] gevuld){

    int aantalDoodsKaarten = 0;
    switch(aantalKaarten){
        case 25:
            aantalDoodsKaarten = 3;
            break;
        case 36:
            aantalDoodsKaarten = 5;
            break;
        case 64:
            aantalDoodsKaarten = 7;
            break;
    }

    int assignToIndex = int(random(0, aantalKaarten));
    for(int i = 0; i < aantalDoodsKaarten; i++){
        
        // assign first card to index
        while(gevuld[assignToIndex] == true){
            assignToIndex = int(random(0, aantalKaarten));
        }
        kaartenVolgorde[assignToIndex] = 33;
        gevuld[assignToIndex] = true;
    }
    return gevuld;
}

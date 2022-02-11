void speelSpel(){

    delay = 0;
    int lineHeight = height/30;

    // show current scores
    for(int i = 1; i <= aantalSpelers; i++){
        toonSpelerScore(i, spelerScores, lineHeight, spelerAanZet);
    }
    
    toonSpelGrid(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt, kaartenAfbeeldingen);

    if(mousePressed){
      
        // delay to avoid accidental double press
        delay(100);
        
        int indexVanAangeklikteKaart = toonIndexVanAangeklikteKaart(spelGridCoordinaten, kaartenUitHetSpel, kaartenAangeklikt);
        if(kaartenVolgorde[indexVanAangeklikteKaart] == 33){
            kaartenAangeklikt[0] = indexVanAangeklikteKaart;
            spelerBeurten[spelerAanZet - 1]++;
            spelerScores[spelerAanZet - 1]--;
            
            delay = 1000;
            toonSpelGrid(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt, kaartenAfbeeldingen);
            
            kaartenAangeklikt[0] = 99; kaartenAangeklikt[1] = 99;
            kaartenUitHetSpel[indexVanAangeklikteKaart] = true;

            if(aantalSpelers == 2){
                switch(spelerAanZet){
                    case 1:
                        spelerAanZet = 2;
                        break;
                    case 2:
                        spelerAanZet = 1;
                        break;
                }
            }
            
        }else{
            if(kaartenAangeklikt[0] == 99){
                kaartenAangeklikt[0] = indexVanAangeklikteKaart;
            }else{
                kaartenAangeklikt[1] = indexVanAangeklikteKaart;

                if(kaartenVolgorde[kaartenAangeklikt[0]] == kaartenVolgorde[kaartenAangeklikt[1]]){
                    spelerScores[spelerAanZet - 1]++;
                    
                    delay = 2000;
                    toonSpelGrid(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt, kaartenAfbeeldingen);
                    
                    // kaart uit het spel halen na het aanroepen van toolSpelGrid functie om het paar voor 2sec te laten zien
                    kaartenUitHetSpel[kaartenAangeklikt[0]] = true;
                }else{
                    spelerBeurten[spelerAanZet - 1]++;
                    if(aantalSpelers == 2){
                        switch(spelerAanZet){
                            case 1:
                                spelerAanZet = 2;
                                break;
                            case 2:
                                spelerAanZet = 1;
                                break;
                        }
                    }
                    delay = 1000;
                    toonSpelGrid(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt, kaartenAfbeeldingen);
                }
                
                kaartenAangeklikt[0] = 99; kaartenAangeklikt[1] = 99;
            }
        }
    }
}

void toonSpelGrid(int[][] spelGridCoordinaten, int[] kaartenVolgorde, boolean[] kaartenUitHetSpel, int[] kaartenAangeklikt, PImage[] kaartenAfbeeldingen){
  
    
    for(int i = 0; i < spelGridCoordinaten.length; i++){
        if(kaartenUitHetSpel[i]){
            // kaart is al geraden
        }else if(arrayBevatWaarde(kaartenAangeklikt, i)){
            // kaart is aangeklikt
            image(
                kaartenAfbeeldingen[kaartenVolgorde[i]], 
                spelGridCoordinaten[i][0],
                spelGridCoordinaten[i][1],
                spelGridCoordinaten[i][2],
                spelGridCoordinaten[i][2]
            );
        }else{
            // toon placeholder
            image(
                kaartenAfbeeldingen[34], 
                spelGridCoordinaten[i][0], 
                spelGridCoordinaten[i][1], 
                spelGridCoordinaten[i][2],
                spelGridCoordinaten[i][2]
            );
        }
    }
}

int toonIndexVanAangeklikteKaart(int[][] spelGridCoordinaten, boolean[] kaartenUitHetSpel, int[] kaartenAangeklikt){
    int cardPressed = 99;
    
    for(int i = 0; i < spelGridCoordinaten.length; i++){
        if(
            !kaartenUitHetSpel[i]
            && !arrayBevatWaarde(kaartenAangeklikt, i)
        ){
            if(
                raaktGelikt(
                    spelGridCoordinaten[i][0], 
                    spelGridCoordinaten[i][1], 
                    spelGridCoordinaten[i][2], 
                    spelGridCoordinaten[i][2]
                )
            ){
                cardPressed = i;
            }
        }
    }

    return cardPressed; 
}

void toonSpelerScore(int player, int[] spelerScores, int lineHeight, int spelerAanZet){
    int xOffset = width / 30;
    int score = spelerScores[player-1];
    int turn = spelerBeurten[player-1];

    switch(player){
        case 1:
        xOffset = xOffset;
        break;
        case 2:
        xOffset = width - int(xOffset * 4.5);
        break;
    }
    
    if(player == spelerAanZet){
      fill(#00FF00);
    }else{
      fill(#FFFFFF);
    }
    
    textSize(lineHeight);
    textAlign(LEFT);
    text("Player " + player, xOffset, lineHeight);
    text("Score: " + score, xOffset, lineHeight * 2);
    text("Turns: " + turn, xOffset, lineHeight * 3);
}

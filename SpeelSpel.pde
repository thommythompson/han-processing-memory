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
        
        int indexVanAangeklikteKaart = toonIndexVanAangeklikteKaart(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt);
        if(kaartenAangeklikt[0] == 99){
            kaartenAangeklikt[0] = indexVanAangeklikteKaart;
        }else{
            kaartenAangeklikt[1] = indexVanAangeklikteKaart;

            if(kaartenVolgorde[kaartenAangeklikt[0]] == kaartenVolgorde[kaartenAangeklikt[1]]){
                spelerScores[spelerAanZet - 1]++;
                
                delay = 2000;
                toonSpelGrid(spelGridCoordinaten, kaartenVolgorde, kaartenUitHetSpel, kaartenAangeklikt, kaartenAfbeeldingen);
                
                // kaart uit het spel halen na het aanroepen van toolSpelGrid functie om het paar voor 2sec te laten zien
                kaartenUitHetSpel[kaartenVolgorde[kaartenAangeklikt[0]]] = true;
            }else{
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

void toonSpelGrid(int[][] spelGridCoordinaten, int[] kaartenVolgorde, boolean[] kaartenUitHetSpel, int[] kaartenAangeklikt, PImage[] kaartenAfbeeldingen){
  
    for(int i = 0; i < kaartenVolgorde.length; i++){
        if(kaartenUitHetSpel[kaartenVolgorde[i]]){
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
                kaartenAfbeeldingen[22], 
                spelGridCoordinaten[i][0], 
                spelGridCoordinaten[i][1], 
                spelGridCoordinaten[i][2],
                spelGridCoordinaten[i][2]
            );
        }
    }
}

int toonIndexVanAangeklikteKaart(int[][] spelGridCoordinaten, int[] kaartenVolgorde, boolean[] kaartenUitHetSpel, int[] kaartenAangeklikt){
    int cardPressed = 99;
    
    for(int i = 0; i < kaartenVolgorde.length; i++){
        if(
            !kaartenUitHetSpel[kaartenVolgorde[i]] 
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

    return cardPressed; //<>//
}

void toonSpelerScore(int player, int[] spelerScores, int lineHeight, int spelerAanZet){
    int xOffset = width / 30;
    int score = spelerScores[player-1];

    switch(player){
        case 1:
        xOffset = 20;
        break;
        case 2:
        xOffset = 520;
        break;
    }
    
    if(player == spelerAanZet){
      fill(#00FF00);
    }else{
      fill(#FFFFFF);
    }
    
    textSize(lineHeight);
    textAlign(LEFT);
    text("Player " + player, xOffset, 20);
    text("Score: " + score, xOffset, 40);
}

// globale configuratie vars
int aantalSpelers = 1;
boolean doodsKaartenGeactiveerd = false;
int aantalSetjesKaarten = 12;

// globale spel status vars
boolean spelIsGestart = false;
int spelerAanZet = 1;
int[] spelerScores = new int[2];
int[] spelerBeurten = new int[2];
int[] kaartenAangeklikt = {99, 99};
boolean[] kaartenUitHetSpel;
int[] kaartenVolgorde;
int[][] spelGridCoordinaten;
int gameOver = 0;
int delay;

// PImage vars

PImage[] kaartenAfbeeldingen = new PImage[35];

void setup(){
    size(800,800);

    kaartenAfbeeldingen[0] = null;
    kaartenAfbeeldingen[1] = loadImage("egg.png");
    kaartenAfbeeldingen[2] = loadImage("boom.png"); 
    kaartenAfbeeldingen[3] = loadImage("chemical.png"); 
    kaartenAfbeeldingen[4] = loadImage("christmastree.png"); 
    kaartenAfbeeldingen[5] = loadImage("crown.png"); 
    kaartenAfbeeldingen[6] = loadImage("wolk.png"); 
    kaartenAfbeeldingen[7] = loadImage("fire.png"); 
    kaartenAfbeeldingen[8] = loadImage("flower.png"); 
    kaartenAfbeeldingen[9] = loadImage("gem.png"); 
    kaartenAfbeeldingen[10] = loadImage("heart.png"); 
    kaartenAfbeeldingen[11] = loadImage("leaf.png"); 
    kaartenAfbeeldingen[12] = loadImage("moon.png"); 
    kaartenAfbeeldingen[13] = loadImage("pinkthing.png"); 
    kaartenAfbeeldingen[14] = loadImage("pumpkin.png"); 
    kaartenAfbeeldingen[15] = loadImage("rock.png"); 
    kaartenAfbeeldingen[16] = loadImage("snow.png"); 
    kaartenAfbeeldingen[17] = loadImage("star.png");
    kaartenAfbeeldingen[18] = loadImage("storm.png");
    kaartenAfbeeldingen[19] = loadImage("sun.png");
    kaartenAfbeeldingen[20] = loadImage("water.png");
    kaartenAfbeeldingen[21] = loadImage("water.png");
    kaartenAfbeeldingen[22] = loadImage("water.png");
    kaartenAfbeeldingen[23] = loadImage("water.png");
    kaartenAfbeeldingen[24] = loadImage("water.png");
    kaartenAfbeeldingen[25] = loadImage("water.png");
    kaartenAfbeeldingen[26] = loadImage("water.png");
    kaartenAfbeeldingen[27] = loadImage("water.png");
    kaartenAfbeeldingen[28] = loadImage("water.png");
    kaartenAfbeeldingen[29] = loadImage("water.png");
    kaartenAfbeeldingen[30] = loadImage("water.png");
    kaartenAfbeeldingen[31] = loadImage("water.png");
    kaartenAfbeeldingen[32] = loadImage("water.png");
    kaartenAfbeeldingen[33] = loadImage("joker.jpg"); // 20 doodskaarten
    kaartenAfbeeldingen[34] = loadImage("placeholder.jpeg"); // 21 placeholder

}

void draw(){
    background(#000000);

    if(!spelIsGestart && gameOver == 0){
        startMenu();
    }else{
        delay(delay);
        speelSpel();
    }
}

// Helper functions
void plaatsTekstInRect(String text, int x, int y, int width, int height, int textSize){
    textAlign(CENTER);
    textSize(textSize);
    text(
        text,
        (x + (width / 2)),
        (y + (height / 2)) + ((textSize / 2) * 0.8)
    );
    textAlign(LEFT);
}

boolean raaktGelikt(int x, int y, int width, int height){
    boolean raaktGelikt = false;
    
    int yMax = y + height;
    int xMax = x + width;

    if(mouseY >= y 
        && mouseY <= yMax
        && mouseX >= x
        && mouseX <= xMax
    ){
        raaktGelikt = true;
    }
        
    return raaktGelikt;
}

boolean arrayBevatWaarde(int[] array, int waarde){
  boolean arrayContainsValue = false;
  
  for (int i = 0; i < array.length; ++i)
  {
     if (array[i] == waarde)
       arrayContainsValue = true;
  }
  
  return arrayContainsValue;
}

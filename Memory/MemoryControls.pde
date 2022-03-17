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
HashMap<Integer,Boolean> keyState = new HashMap<Integer,Boolean>();
HashMap<Integer,Boolean> keyPulseState = new HashMap<Integer,Boolean>();

void keyPressed() {
    addBall();
    if (key == ESC) {
        key = 0;
    }
    keyState.put(keyCode,true);
    keyPulseState.put(keyCode,true);

    println(keyCode);
    if (gameState == 3 || gameState == 4) {
        if (keyCode == 8) {
            if (!playerName.isEmpty()) {
                playerName = playerName.substring(0,playerName.length()-1);
            }
        } else if (key != CODED && key != '\n' && key != ' ') {
            playerName += key;
        }
    }
}

void keyReleased() {
    keyState.put(keyCode,false);
}

void mousePressed() {
    switch(mouseButton) {
        case LEFT:
            keyState.put(-1,true);
            keyPulseState.put(-1,true);
            break;
        case RIGHT:
            keyState.put(-2,true);
            keyPulseState.put(-2,true);
            break;
        case CENTER:
            keyState.put(-3,true);
            keyPulseState.put(-3,true);
            break;
    }
}

void mouseReleased() {
    switch(mouseButton) {
        case LEFT:
            keyState.put(-1,false);
            break;
        case RIGHT:
            keyState.put(-2,false);
            break;
        case CENTER:
            keyState.put(-3,false);
            break;
    }
}
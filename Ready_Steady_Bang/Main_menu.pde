void mainmenu() {
  if (start2){
    background(255);
    stroke(0);
    rectMode(CORNERS);
    fill(255);
    rect(10,160,470,260);
    rect(10,300,470,400);
    rect(10,440,470,540);
    rect(240,684,479,733);
    fill(0);
    textFont(mmf);
    text("EASY",240,222);
    text("MEDIUM",240,362);
    text("HARD",240,502);
    textFont(bf);
    text("Quit?", 355,716);
    start2=false;
  }
}

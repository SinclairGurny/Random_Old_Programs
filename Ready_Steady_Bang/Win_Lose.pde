void win(){
  if (start2){
    grid();
    textFont(bf);
    text("You Win", 240,200);
    start2=false;
  }
  if (wins==5) {
    mode=5;
    start2=true;
  } else {
    mode=3;
    count++;
  }
}

void lose(){
  if (start2){
    grid();
    textFont(bf);
    text("You Lose", 240,200);
    start2=false;
  }
  if (loses==5) {
    mode=6;
    start2=true;
  } else {
    mode=4;
    count++;
  }
}

void grid(){
  fill(220);
  noStroke();
  rect(0,0,480,100);
  stroke(180);
  line(40,50,340,50);
  line(120,10,120,90);
  
  noStroke();
  fill(0);
  //textFont(mmf);
  textFont(bf);
  text("ME",80,40);
  text("HIM",80,80);
  
  fill(200);
  rectMode(CENTER);
  for (int i=0; i<5; i++){
    rect(150+i*40,30,20,20);
    rect(150+i*40,70,20,20);
  }
  fill(0);
  for (int i=0; i<wins; i++){
    rect(150+i*40,30,20,20);
  }
  for (int i=0; i<loses; i++){
    rect(150+i*40,70,20,20);
  }
  rectMode(CORNERS);
  if (rc > 0){
    text(rc/60.0,400,40);
  } else {
    text("-",400,40);
  }
  text(bangE/60.0,400,80);
  fill(255);
  stroke(0);
  rect(0,684,239,733);
  rect(240,684,479,733);
  fill(0);
  text("Continue",110,716);
  text("Quit?", 355,716);
}
  

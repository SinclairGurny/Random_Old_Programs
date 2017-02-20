void life(){
  if (start2){
    println("Its running");
    background(255);
    grid();
    fill(0);
    textFont(ldf);
    text("YOU WIN",240,200);
    //average
    int sum=0;
    int count=0;
    for (int i=0; i<round; i++){
      if (times[i]>0){
        sum+=times[i];
        ++count;
      }
    }
    text("Average Speed",240,350);
    float s=sum/((float)count);
    if (sum>0) {
      text(s/60.0,240,400);
    } else {
      text("-",240,400);
    }
    //buttons
    fill(255);
    rect(0,684,239,734);
    rect(240,684,479,734);
    fill(0);
    textFont(bf);
    text("Replay?",110,716);
    text("Quit?", 355,716);
    start2=false;
  }
}

void death(){
  if (start2){
    if (ldcount == 0) {
      background(255);
      ldcount++;
    }else if (ldcount<60){
      noStroke();
      fill(255,0,0,5);
      rect(0,0,480,696);
      ldcount++;
    } else {
      stroke(0);
      fill(0);
      textFont(ldf);
      text("You Lose",240,200);
      //buttons
      fill(255);
      rect(0,684,239,733);
      rect(240,684,479,733);
      fill(0);
      textFont(bf);
      text("Replay?",110,716);
      text("Quit?", 355,716);
      start2=false;
    }
  }
}

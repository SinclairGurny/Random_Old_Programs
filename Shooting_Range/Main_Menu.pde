void main_menu(){
  if (!started){
    started=true;
    rectMode(CORNERS);
    noStroke();
    background(60);
    for (int i=0; i<3; i++){
      fill(200); rect(4, i*200+100, 476, i*200+200, 4);
      fill(0); text("targets",270,i*200+160);
               text((i+1)*10, 210, i*200+160);
    }
  }
}

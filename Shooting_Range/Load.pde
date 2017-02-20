int targets[]=new int[30];
int rating[]=new int[30];

int ccount=0;
boolean clicked=false;

void load(){
  if (!started){
    textFont(font2);
    started=true;
    background(200);
    text("Ready?",240,250);
    for (int i=0; i<30; i++){
      targets[i]=(int)random(0,3);
      rating[i]=-1;
    }
    
  } else if (clicked) {
    ccount++;
    if (ccount > 120){
      change(3);
      clicked=false;
      ccount=0;
    }
  }
}

//Shooting_Range
//3 different modes for # of targets (20,30,40)?
//3 different types of targets
//  hostile- shoot immediately
//  civilian- don't shoot
//  hostage- wait for green bar at top

int mode=1;
boolean started=false;
PFont font, font2;
int tnum=-1;
color back=color(200);
color c[]=new color[3];
//1-enemy(red), 2-civilian(blue), 3-bar(green)

void setup(){
  size(480,734);
  orientation(PORTRAIT);
  smooth(); stroke(0);
  frameRate(60);
  font=createFont("Arial Narrow",24);
  font2=createFont("Arial",36);
  textAlign(CENTER);
  textFont(font);
  
  c[0]=color(255,84,104);
  c[1]=color(41,255,255);
  c[2]=color(39,232,51);
}

void draw(){
  switch(mode){
    case 1:
      main_menu();
      break;
    case 2:
      load();
      break;
    case 3:
      game();
      break;
    case 4:
      score();
      break;
  }
}

void mouseReleased(){
  switch(mode){
    case 1:
      if (mouseY >= 100 && mouseY <= 200){
        tnum=10;
        change(2);
      } else if (mouseY >= 300 && mouseY <= 400){
        tnum=20;
        change(2);
      } else if (mouseY >= 500 && mouseY <= 600){
        tnum=30;
        change(2);
      } else if (mouseY <= 10){
        exit();
      }
      break;
    case 2:
      if(mouseY < 10){
        change(1);
        clicked=false;
        ccount=0;
      }
      clicked=true;
      break;
    case 3:
      if (shot==0) { shot=1; }
      break;
    case 4:
      if (mouseY < 10){
        reset();
        change(1);
      }
  }
}

void change(int m){
  if (m<4){ textFont(font); }
  else { textFont(font2); }
  mode=m;
  started=false;
}

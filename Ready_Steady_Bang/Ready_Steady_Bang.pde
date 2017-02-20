//Ready, Steady, Bang!

boolean start2=true;

byte mode = 1; //menu, playing, win, lose, life, death
int loses=0;
int wins=0;
byte diff=0; //enemy difficulty
int round=0; //index for times
int times[]=new int[10];

//mode 1 vars
PFont mmf; //main menu font and RDB font

//mode2 vars
int fc = 0; //counts frames and mode
int rc = -1; //reaction count
boolean start=false; //starts game properly
int bang=-1; //bang count down timer
//int bang2=-1; //secondary bang counter 'immutable'
int bangE=-1; //enemy bang

//mode 3/4
int count=0;

//mode 5/6 vars
int ldcount=0;
PFont ldf; //win or lose font
PFont bf; //button font

void setup() {
  size(480,734);
  orientation(PORTRAIT);
  smooth();
  stroke(0);
  frameRate(60);
  
  mmf = createFont("Arial", 24);
  ldf = createFont("Arial Narrow",45);
  bf = createFont("Arial Narrow",21);
  textAlign(CENTER);
  
  for (int i=0; i<10; i++){
    times[i]=-1;
  }
}

void draw() {
  switch (mode) {
    case 1:
      mainmenu();
      break;
    case 2:
      playing();
      break;
    case 3:
      win();
      break;
    case 4:
      lose();
      break;
    case 5:
      life();
      break;
    case 6:
      death();
  }
}

void mouseReleased(){
  switch (mode) {
    case 1:
      if (mouseX >= 10 && mouseX <= 470){ 
        if (mouseY >= 160 && mouseY <= 260) {
           play((byte)1);
        }else if (mouseY >= 300 && mouseY <= 400) {
           play((byte)2);
        }else if (mouseY >= 440 && mouseY <= 540) {
           play((byte)3);
        }
      }
      if (mouseX >= 240 && mouseY >= 684) {
        exit();
      }
      break;
    case 3:
      if (mouseY >= 684){
        if (mouseX <= 240){
          reset();
        } else {
          quit();
        }
      }
      break;    
    case 4:
      if (mouseY >= 684){
        if (mouseX <= 240){
          reset();
        } else {
          quit();
        }
      }
      break;
    case 5:
      if (mouseY >= 684){
        if (mouseX <= 240){
          restart();
        } else {
          quit();
        }
      }
      break;
    case 6:
      if (mouseY >= 684){
        if (mouseX <= 240){
          restart();
        } else {
          quit();
        }
      }
  }
}

void mousePressed(){
  switch(mode){
    case 2:
      //println(times);
      if (start && fc == -1 && bang==0){
        if (rc < bangE){
          ++wins;
          times[round++]=rc;
          start2=true;
          win();
        } else {
          ++loses;
          times[round++]=rc;
          start2=true;
          lose();
        }
      } else if (start && bang>0){
        ++loses;
        times[round++]=-1;
        start2=true;
        lose();
      }
      break;
  }
}

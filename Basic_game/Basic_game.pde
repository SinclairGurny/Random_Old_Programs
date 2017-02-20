int x=0; int y=360;
int count=0; int gravCount=0; int gravYCount=0;
int doneJump=1; int doneGrav=1; int doneGravY=1;
int direction=0;
int timer=0;
int startTime=0;
int z=0;
int start=0;
int play=1;
float time=0;

int level=1;

void setup(){
  orientation(LANDSCAPE);
  background(255);
  frameRate(60);
  size(480,320);
  font=createFont("Arial", 100);
  smooth();
}
void draw(){
  if(start==1){
    if(z==0){
      startTime=frameCount;
      z=1;
    }
    timer=frameCount;
  }
  if(play==1){
    translate(0,50);
    scale(0.6);
    if(x>690 && x<730){
      if(y>40 && y<80){
        x=0;y=360;
        time=(float)((timer-startTime)/60.0);
        println(time);
        play=0;
      }
    }
      
    background(color(119,184,240));
    noStroke();
    fill(color(37,124,26));
  
    rect( -1,380,801,20);//flat ground
      rect(-2,400,802,400);
    rect(400,360,400,20);//raised right side
        fill(color(100,0,150));
    rect(600,300,100,20);//platform 1
        fill(color(37,124,26));
    rect(380,240,200,20);//platform 2
    rect(220,220,100,20);//platform 3
    rect(100,180,100,20);//platform 4
    rect(  0,130, 60,20);//platform 5
    rect(130, 80,600,20);//platform 6
  
    fill(color(255,0,0));
    rect(690,40,40,40);//finish
    fill(0);
    rect(690,40,40,10);
  
    rect(x,y,20,20);//character
  //-----------------------------------------
    if(true){
      if(count>0){jump();}
      if(gravCount>0){gravity2();}
      gravity();
      if(!keyPressed){direction=0;}
    }
  }else{
    level_over();
    if(qwerty==180){
      play=1;
      timer=0;
      startTime=0;
      z=0;
      start=0;
      qwerty=0;
    }
  }
}

void keyPressed(){
  if(timer==0){
    start=1;
  }
  if(keyCode==38 || key==113){
    //println("UP");
    if(gravCount==0 && count==0){
      doneJump=0;
      jump();
    }
  }
  else if(keyCode==40 || key==115){
    //println("DOWN");
  }
  else if(keyCode==37 || key==111){
    //println("LEFT");
    x=x-5;
    if(x<0){
      x=0;
    }if(x>780){
      x=780;
    }
    if(objectDetection()==1){x=x+5;}
    doneJump=1;
    direction=1;
  }
  else if(keyCode==39 || key==112){
    //println("RIGHT");
    x=x+5;
    if(x<0){
      x=0;
    }if(x>780){
      x=780;
    }
    if(objectDetection()==1){x=x-5;}
    doneJump=1;
    direction=2;
  }
  else{
    //println("ERROR");
  }
}



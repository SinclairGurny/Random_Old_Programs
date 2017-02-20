import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Basic_game_comp extends PApplet {

int x=0;
int y=360;
int count=0;
int gravCount=0;
int doneJump=0;
int direction=0;

int play=1;

public void setup(){
  size(800,500);
}
public void draw(){
  translate(0,50);
  if(x>690 && x<730){
    if(y>40 && y<80){
      x=0;y=360;
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
    gravity();
    if(!keyPressed){
      direction=0;
    }
  }
}

public void keyPressed(){
  if(keyCode==38 || key==113){
    //println("UP");
    jump();
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

public void jump(){
  if(objectDetection()==0){
    y=y-5;
    if(x<0){
      x=0;
    }
    if(x>780){
      x=780;
    }
    if(direction==1){
      x=x-4;
    }
    if(direction==2){
      x=x+4;
    }
    count++;
    if(count==20){
      count=0;
      doneJump=1;
    }
  }
  else{
    if(direction==1){
      x=x+4;
    }
    if(direction==2){
      x=x-4;
    }
    count=0;
    doneJump=1;
  }
}

public void gravity(){  
  if(doneJump==1){
    int gravY=0;
    if(x<=380){//base gravity "left"
      gravY=360;
    }
    if(x>380){//base gravity "right"
      gravY=340;
    }
    //-----platforms---------
    if(x>580 && x<700){//platform 1
      if(y<=280){
        gravY=280;
      }
    }
    if(x>360 && x<580){//platform 2
      if(y<=220){
        gravY=220;
      }
    }
    if(x>200 && x<320){//platform 3
      if(y<=200){
        gravY=200;
      }
    }
    if(x>80 && x<200){//platform 4
      if(y<=160){
        gravY=160;
      }
    }
    if(x>=0 && x<60){//platform 5
      if(y<=110){
        gravY=110;
      }
    }
    if(x>110 && x<730){//platform 6
      if(y<=60){
        gravY=60;
      }
    }
    y=gravY;
  }
    doneJump=0;
}

public int objectDetection(){
  int ret=0;
  if(x<0 || x>780){//off edges
    ret=1;
  }
  if(x<=380){
    if(y<=360){//left side
      ret= 0;
    }else{
      ret= 1;
    }
  }else if(x>380){//right side
    if(y<=340){
      ret= 0;
    }else{
      ret= 1;
    }
  }
  //if(x>580 && x<700){//platform 1
  //  if(y>280 && y<320){
  //    ret=1;
  //  }
  //}
  if(x>360 && x<580){//platform 2
    if(y>220 && y<260){
      ret=1;
    }
  }
  if(x>200 && x<320){//platform 3
    if(y>200 && y<240){
      ret=1;
    }
  }
  if(x>80 && x<200){//platform 4
    if(y>160 && y<200){
      ret=1;
    }
  }
  if(x>=0 && x<60){//platform 5
    if(y>110 && y<150){
      ret=1;
    }
  }
  if(x>110 && x<730){//platform 6
    if(y>60 && y<100){
      ret=1;
    }
  }
  return ret;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Basic_game_comp" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

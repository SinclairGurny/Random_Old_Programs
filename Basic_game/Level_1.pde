void jump(){
  doneJump=0;
  if(objectDetection()==0){
    y=y-5;
    if(x<0){x=0;}
    if(x>780){x=780;}
    if(direction==1){
      x=x-4;
    }
    if(direction==2){
      x=x+4;
    }
    count++;
    if(count==15){
      count=0;
      doneJump=1;
      gravity2();
    }
  }
  else{
    y=y+5;
    if(direction==1){
      x=x+4;
    }
    if(direction==2){
      x=x-4;
    }
    count=0;
    doneJump=1;
    gravity2();
  }
}
void gravity(){
  doneGravY=0;
  if(doneJump==1 && doneGrav==1){
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
    if(objectDetection()==0){
      if(y != gravY){
        y=y+5;
      }
      if(x<0){x=0;}
      if(x>780){x=780;}
      //if(direction==1){
      //  x=x-4;
      //}
      //if(direction==2){
      //  x=x+4;
      //}
      gravYCount++;
      if(y==gravY){
        gravYCount=0;
        doneGravY=1;
      }
    }
    else{
      //if(direction==1){
      //  x=x+4;
      //}
      //if(direction==2){
      //  x=x-4;
      //}
      gravYCount=0;
      doneGravY=1;
    }
  }
  doneGravY=0;
}
void gravity2(){
  doneGrav=0;
  if(objectDetection()==0){
    y=y+5;
    if(x<0){x=0;}
    if(x>780){x=780;}
    if(direction==1){
      x=x-4;
    }
    if(direction==2){
      x=x+4;
    }
    gravCount++;
    if(y==platform() || gravCount==15){
      gravCount=0;
      doneGrav=1;
    }
  }
  else{
    y=y-5;
    if(direction==1){
      x=x+4;
    }
    if(direction==2){
      x=x-4;
    }
    gravCount=0;
    doneGrav=1;
  }
}


int objectDetection(){
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
int platform(){
  int g=0;
    if(x>580 && x<700){//platform 1
      if(y<=280){
        g=280;
      }
    }
    if(x>360 && x<580){//platform 2
      if(y<=220){
        g=220;
      }
    }
    if(x>200 && x<320){//platform 3
      if(y<=200){
        g=200;
      }
    }
    if(x>80 && x<200){//platform 4
      if(y<=160){
        g=160;
      }
    }
    if(x>=0 && x<60){//platform 5
      if(y<=110){
        g=110;
      }
    }
    if(x>110 && x<730){//platform 6
      if(y<=60){
        g=60;
      }
    }
    return g;
}
  

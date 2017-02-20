void gravity(){
  if(doneGrav && !doneJump){return;}
  //if(objectDetect(x,y+2)==1){return;}
  y+=Gspeed;
  if(objectDetect(x,y)==1){
    y+=-Gspeed;
    canJump=true;
    doneGrav=true;
    return;
  }
  if(direc==1){
    x+= -XYspeed;
    if(objectDetect(x,y)==1){
      x+=XYspeed;
      canJump=true;
      doneGrav=true;
      return;
    }
  }if(direc==2){
    x+= XYspeed;
    if(objectDetect(x,y)==1){
      x+=-XYspeed;
      canJump=true;
      doneGrav=true;
      return;
    }
  }
  return;
}
void jump(){
  if(doneJump && !canJump){return;}
  if(jumpCount>=20){
    doneJump=true;
    doneGrav=false;
    jumpCount=0;
    canJump=false;
    return;
  }
  if(jumpCount==0){
    if(objectDetect(x,y+5)==0){
      doneJump=true;
      doneGrav=false;
      jumpCount=0;
      canJump=false;
      return;
    }
  }
  if(jumpCount<20){
  y+=-Jspeed;
  if(objectDetect(x,y)==1){
    y+=Jspeed;
    doneJump=true;
    doneGrav=false;
    jumpCount=0;
    canJump=false;
    return;
  }
  if(direc==1){
    x+= -XYspeed;
    if(objectDetect(x,y)==1){
      x+=XYspeed;
      doneJump=true;
    doneGrav=false;
    jumpCount=0;
    canJump=false;
    return;
    }
  }else if(direc==2){
    x+= XYspeed;
    if(objectDetect(x,y)==1){
      x+=-XYspeed;
      doneJump=true;
    doneGrav=false;
    jumpCount=0;
    canJump=false;
    return;
    }
  }
  jumpCount++;
  return;
}}


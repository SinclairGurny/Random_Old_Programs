void keyPressed(){
  if(keyCode==38 || key==113){
    println("UP");
    doneJump=false;
    doneGrav=true;
    //y+=+5;
    if(objectDetect(x,y+5)==1){
      //y+=-5;
      jump();
    }//else{y+=5;}
    
  }if(keyCode==40 || key==115){
    println("DOWN");
  }if(keyCode==37 || key==111){
    println("LEFT");
    x+= -XYspeed;
    if(objectDetect(x,y)==1){
      x+= XYspeed;
    }
  }if(keyCode==39 || key==112){
    println("RIGHT");
    x+= XYspeed;
    if(objectDetect(x,y)==1){
      x+= -XYspeed;
    }
  }
}

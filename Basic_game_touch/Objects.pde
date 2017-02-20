class Platform{
  int Sx;
  int Sy;
  int Ex;
  int Ey;
  long time;
  Platform(){
    Sx=0;
    Sy=0;
    Ex=0;
    Ey=0;
    time=300;
  }
  void place(int x1, int y1, int x2, int y2){
    Sx=x1;
    Sy=y1;
    Ex=x2;
    Ey=y2;
    time=300;
  }
  int objDet(int o, int p){
    int ret=0;
    int topX; int topY;
    int botX; int botY;
    if(Sx < Ex){
      topX=Sx; botX=Ex;
    }else{
      topX=Ex; botX=Sx;
    }
    if(Sy < Ey){
      topY=Sy; botY=Ey;
    }else{
      topY=Ey; botY=Sy;
    }
    if(o < topX || o > botX){
      ret=0;
    }
    if(p < topY || p > botY){
      ret=0;
    }
    if((o+5>=topX && o-5<=botX) && (p+5>=topY && p-5<=botY)){
      ret=1;
    }
    return ret;
  }
}
int objectDetect(int a, int b){
  int ret=0;
  if(a-5<0 || a+5>480){
    ret=1;
  }
  if(b-5<0 || b+5>300){
    ret=1;
  }
  if(p1.objDet(a,b)==1){
    ret=1;
  }
  if(p2.objDet(a,b)==1){
    ret=1;
  }
  if(p3.objDet(a,b)==1){
    ret=1;
  }
  if(obs1.objDet(a,b)==1){
    ret=1;
  }
  if(obs2.objDet(a,b)==1){
    ret=1;
  }
  if(obs3.objDet(a,b)==1){
    ret=1;
  }
  return ret;
}

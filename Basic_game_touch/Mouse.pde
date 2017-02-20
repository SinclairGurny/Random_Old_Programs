void mousePressed(){
  mousePx=mouseX;
  mousePy=mouseY;
}
void mouseReleased(){
  mouseRx=mouseX;
  mouseRy=mouseY;
  if(count==0){
    p1.place(mousePx,mousePy,mouseRx,mouseRy);
    mousePx=0;
    mousePy=0;
    mouseRx=0;
    mouseRy=0;
  }
  if(count==1){
    p2.place(mousePx,mousePy,mouseRx,mouseRy);
    mousePx=0;
    mousePy=0;
    mouseRx=0;
    mouseRy=0;
  }
  if(count==2){
    p3.place(mousePx,mousePy,mouseRx,mouseRy);
    mousePx=0;
    mousePy=0;
    mouseRx=0;
    mouseRy=0;
    count=-1;
  }
  count++;
}


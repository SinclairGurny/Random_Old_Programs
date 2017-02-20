PImage img;
PFont font;
int qwerty=0;
void level_over(){
  background(0);
  translate(240,160);
  scale(2.5);
  fill(color(180,9,0));
  textAlign(CENTER);
  text("YOU WIN", 0, 0);
  text("Your time: "+time+"s",5, 20);
  qwerty++;
}
  

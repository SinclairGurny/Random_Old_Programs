//Genetic Algorithm 2.0
int frames=240;
int n=300;

ArrayList<Bot> botList = new ArrayList <Bot>();
Bot prevMax;
int prevCount=-1;
int count=0;
int generation=1;

long avg=0;
int highest=0;
int record=-99999;
boolean pause=false;
boolean replay=false;
boolean done=false;
//
void setup(){
  size(600,200);
  smooth();
  stroke(0);
  frameRate(frames);//
  for (int i=0; i<n; i++){
    botList.add(new Bot());
  }
  prevMax=new Bot();
  //finish screen color background(color(37,170,17));
}

void draw(){
  if (!pause && !replay){
    background(color(142,190,247));
    fill(color(255,20,20));
    rect(0,0,20,200);
    fill(0);
    rect(580,0,20,200);
    //
    for (Bot b : botList){
      fill(b.getColor());
      ellipse(b.x,b.y,20,20);
    }
    //
    if (count<400){//in simulation mode
      for (Bot b : botList){
        b.move(count);
      }
      count++;
    } else {//in reset mode
      int[] fits=new int[botList.size()];
      for (int i=0; i<botList.size(); i++){
        fits[i]=botList.get(i).getFitness();
      }
      highest=botList.get(listMax(fits)).getFitness();
      if (highest > record){
        prevMax.set(botList.get(listMax(fits)));
        println("New Record!");
      }
      cross(botList, listMax(fits));
      for (Bot b : botList){
        b.reset();
      }
      
      avg+=highest;
      record=max(highest,record);
      
      print("Gen: "+generation+" ");
      print("Record: "+record+" ");
      print("Gen Max: "+highest+" ");
      println("Avg: "+(avg/generation));
      
      generation++;
      count=0;
    }
  } else if (!pause && replay) {
    if (count < 400){
      background(color(142,190,247));
      fill(color(255,20,20));
      rect(0,0,20,200);
      fill(0);
      rect(580,0,20,200);
      fill(prevMax.getColor());
      ellipse(prevMax.x,prevMax.y,20,20);
      prevMax.move(count);
      count++;
    } else {
      prevMax.reset();
      count=0;
    }
  }
}

void keyPressed(){
  if (key==' ' || key=='p'){
    pause=!pause;
    //println("paused/unpaused");
  } else if (key=='r' && generation > 1){
    if (replay){
      count=prevCount;
    } else {
      prevCount=count;
      count=0;
    }
    prevMax.reset();
    replay=!replay;
  }
}

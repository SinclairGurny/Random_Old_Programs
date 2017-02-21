//Genetic Algorithm
Bot bot1=new Bot();
Bot bot2=new Bot();
Bot bot3=new Bot();
int count=0;
int generation=0;
int done=0;
//------------
long avg=0; long tick=0;
int highest=0;
int record=0;
void setup(){
  size(600,200);
  smooth();
  stroke(0);
  frameRate(200);
  println("n bot1 bot2 bot3 curMax avg max"); 
}
void draw(){
  background(color(142,190,247));
  fill(color(255,20,20));
  rect(0,0,20,200);
  fill(0);
  rect(580,0,20,200);
  fill(color(0,0,255));
  ellipse(bot1.x,bot1.y,20,20);
  fill(color(0,255,0));
  ellipse(bot2.x,bot2.y,20,20);
  fill(100);
  ellipse(bot3.x,bot3.y,20,20);
  if(count<400){//TODO replace with loop
    if(bot1.dna[count]==1){
      bot1.x+=4;
      if(bot1.x+20>=800){bot1.x+=-4;}
    }else if(bot1.dna[count]==2){
      bot1.y+=4;
      if(bot1.y+20>=200){bot1.y+=-4;}
    }else if(bot1.dna[count]==3){
      bot1.x+=-4;
      if(bot1.x-20<=0){bot1.x+=4;}
    }else if(bot1.dna[count]==4){
      bot1.x+=-4;
      if(bot1.x-20<=0){bot1.x+=4;}
    }
    if(bot2.dna[count]==1){
      bot2.x+=4;
      if(bot2.x+20>=800){bot2.x+=-4;}
    }else if(bot2.dna[count]==2){
      bot2.y+=4;
      if(bot2.y+20>=200){bot2.y+=-4;}
    }else if(bot2.dna[count]==3){
      bot2.x+=-4;
      if(bot2.x-20<=0){bot2.x+=4;}
    }else if(bot2.dna[count]==4){
      bot2.y+=-4;
      if(bot2.y-20<=0){bot2.y+=4;}
    }
    if(bot3.dna[count]==1){
      bot3.x+=4;
      if(bot3.x+20>=800){bot3.x+=-4;}
    }else if(bot3.dna[count]==2){
      bot3.y+=4;
      if(bot3.y+20>=200){bot3.y+=-4;}
    }else if(bot3.dna[count]==3){
      bot3.x+=-4;
      if(bot3.x-20<=0){bot3.x+=4;}
    }else if(bot3.dna[count]==4){
      bot3.y+=-4;
      if(bot3.y-20<=0){bot3.y+=4;}
    }
  }
  if(count==400){//end of simulation step
    bot1.fitness=bot1.x;
    bot2.fitness=bot2.x;
    bot3.fitness=bot3.x;
    highest=maxG(bot1.fitness,bot2.fitness,bot3.fitness);
    cross(bot1,bot3,bot3,highest);
    if (highest==1){
      highest=bot1.fitness;
    } else if (highest==2){
      highest=bot2.fitness;
    } else {
      highest=bot3.fitness;
    }
    tick++;
    avg+=highest;
    record=max(record,highest);
    print(tick+" "+bot1.fitness+", "+bot2.fitness+", "+bot3.fitness);
    println("--"+highest+"--"+avg/tick+"--"+record);
    if(highest>400){done=1;}
    count=-1;
    generation++;
    bot1.reset();
    bot2.reset();
    bot3.reset();
  }
  if(done==1){
    background(color(37,170,17));
    println("-----------done----------------");
    count=1000;
  }
  count++;
}


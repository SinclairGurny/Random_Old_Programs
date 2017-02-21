class Bot{
  public int[] dna=new int[400];
  private int fitness, horz;
  private int x, y;
  private final color c;
  
  Bot(){
    for(int j=0; j<400; j++){
      int r=(int)random(1,5);
      dna[j]=r;
    }
    x=20; y=100;
    fitness=-1; horz=-1;
    c=color(random(255),random(255),random(255));
  }
  
  color getColor(){ return c; }
  
  int getFitness(){
    return x;
    //return x-horz+200;
  }
  
  void reset(){
    x=20; y=100; fitness=-1; horz=-1;
  }
  
  void move(int n){
    int temp=dna[n];
    if (temp==1){
      x+=4;
      if(x+20>=800){x+=-4;}
    } else if (temp==2){
      y+=4;
      if(y+20>=200){y+=-4;}
      horz+=1;
    } else if (temp==3){
      x+=-4;
      if(x-20<=0){x+=4;}
    } else {
      y+=-4;
      if(y-20<=0){y+=4;}
      horz+=1;
    }
  }
  
  //only for prevMax
  void set(Bot b){
    for (int i=0; i<400; i++){
      this.dna[i]=b.dna[i];
    }
    reset();
  }
}


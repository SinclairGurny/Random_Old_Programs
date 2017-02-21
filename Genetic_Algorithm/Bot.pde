class Bot{
  int[] dna=new int[400];
  int fitness;
  int x;
  int y;
  Bot(){
    for(int j=0; j<400; j++){
      int r=(int)random(1,5);
      //r=constrain(r,1,4);
      dna[j]=r;
    }
    x=20;
    y=100;
  }
  void reset(){
    x=20;
    y=100;
  }
}


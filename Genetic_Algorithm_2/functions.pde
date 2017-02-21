void cross(ArrayList<Bot> bl, int index){
  //asexual repro of max w/ genetic variation
  Bot bmax=bl.get(index);
  for(int t=0; t<400; t++){
    /*
    if (t%5>1){
      for (Bot b : bl){
        b.dna[t]=bmax.dna[t];
      }
    }
    if (t%(int)random(1,20)==1){
      for (Bot b : bl){
        b.dna[t]=bmax.dna[t];
      }
    }
    */
    
    for (Bot b : bl){
        b.dna[t]=bmax.dna[t];
    }
    
    if ((int)random(0,10)==(int)random(0,10)){
      for (Bot b : bl){
        b.dna[t]=(int)random(1,5);
      }
    }
  }
}

int listMax(int[] a){//return index of max value
  int index=0; int max=a[0];
  for (int i=1; i<a.length; i++){
    if (a[i]>max){
      index=i;
      max=a[i];
    }
  }
  return index;
}

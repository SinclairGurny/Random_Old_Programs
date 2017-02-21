void cross(Bot b1, Bot b2, Bot b3, int m){
  Bot bmax;
  if (m==1){
    bmax=b1;
  } else if (m==2){
    bmax=b2;
  } else {
    bmax=b3;
  }
  for(int t=0; t<400; t++){
    if (t%2==0){
      b1.dna[t]=bmax.dna[t];
      b2.dna[t]=bmax.dna[t];
      b3.dna[t]=bmax.dna[t];
    }
    if (t%6==1){
      b1.dna[t]=bmax.dna[t];
      b2.dna[t]=bmax.dna[t];
      b3.dna[t]=bmax.dna[t];
    }
    if ((int)random(0,40)==(int)random(0,40)){
      b1.dna[t]=(int)random(1,5);
      b2.dna[t]=(int)random(1,5);
      b3.dna[t]=(int)random(1,5);
    }
  }
}

int maxG(int b1, int b2, int b3){
  int n=max(b1,b2,b3);
  if (n==b1){
    return 1;
  } else if (n==b2){
    return 2;
  } else {
    return 3;
  }
}


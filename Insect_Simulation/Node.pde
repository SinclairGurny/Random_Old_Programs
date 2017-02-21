class Node {
  private int p_level;      //stores pheromone level of this location
  private int food_level;   //stores food level of node - if type is food or colony
  private int value;        //stores type of node - 1 - nothing, 2 - colony, 3 - food, 4 - wall
  private int overlap;      //stores max number of ants that can be in this location
  private ArrayList<Ant> ants;      //stores all ants in this location
//=============================================
  //constructor
  public Node() {
    p_level = food_level = 0;
    value = 1;
    overlap = MAX_OVERLAP;
    ants=new ArrayList<Ant>();
  }
  //copy constructor
  public Node(Node n) {
    p_level = n.p_level;
    food_level = n.food_level;
    if (value == 3 && food_level <= 100) { value = 1; }
    value = n.value;
    overlap = n.overlap;
    ants = new ArrayList<Ant>();
    for (int i=0; i<n.ants.size(); ++i) {
      ants.add(n.ants.get(i));
    }
  }
//======================================================
  //accessors
  public int getType() { return value; }
  public int getFood() { return food_level; }
  public int getPLevel() { return p_level; }
  public ArrayList<Ant> getAnts() { return ants; }
  public int getAntCount() { return ants.size(); }
  public void clearAnts() {
    ants.clear();
    if (p_level > 0) { p_level-=1; }
    if (p_level < 0) { p_level+=1; }
  }
  public void clean() { p_level=0; }
  //simple functions
  public void set_type(int type) {
    //0 - nothing, 1 - ant, 2 - colony, 3 - food, 4 - wall
    value = type;
    if (value == 2) { overlap = 1000; }
    if (value == 3) { food_level = round(random(1100, 10000)); }
  }
  public void set_food(int amnt) {
    food_level = amnt;
  }
//
  void deposit(int amnt) {
    food_level+=amnt;
  }
//====================================================================
  //add functions
  public boolean addAnt(int _id) {
    if (ants.size() < overlap) {
      ants.add(new Ant(_id));
      return true;
    } else {
      return false;
    }
  }

  public boolean addAnt(Ant a) {
    if (ants.size() < overlap) {
      ants.add(new Ant(a));
      return true;
    } else {
      return false;
    }
  }

  public void addFood(int amnt) {
    value = 3;
    food_level = amnt;
  }

  public void add_p(int amnt) {
    if (ants.size() < 2) {
      p_level = constrain(p_level + amnt, -1000000, 1000000);
    } else {
      p_level = constrain(p_level + amnt/5, -1000000, 1000000);
    }
  }

  public void remAnt() {
    if (ants.size() > 0){
      ants.remove(0);
    }
  }

  public void spawn_new_ant() {
    if (value == 2 && food_level > SPAWN_THRESHOLD) {
      println("NEW ANT");
      food_level -= 10000;
      addAnt(0);
    }
  }
//=====================================================
  //helper functions
  public void print(int x, int y){
    //0 - nothing, 1 - ant, 2 - colony, 3 - food, 4 - wall
    int node_width = WIDTH/GWIDTH;
    int node_height = HEIGHT/GHEIGHT;
    if (value == 3 && food_level <= 100) { value = 1; }
    if (!show_pheromones) { fill(237, 201, 175); }
    else{
      if (p_level >= 0) {
        fill(255, 255, 255-constrain(p_level/10, 0, 255));
      } else {
        fill(255, 255-constrain(abs(p_level)/4, 0, 255), 255-constrain(abs(p_level)/4,0,255));
      }
    }

    if (value == 3) { fill(0,200,0); }
    if (ants.size() > 0) { fill(0); }
    if (value == 2) { fill(0,0,100); }
    else if (value == 4) { fill(150); }
    rect(x*node_width, y*node_height, node_width, node_height);
  }
}

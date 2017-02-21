class Grid {
  private int size_x, size_y;       // 0 -> large number
  private Node[][] grid;            // stores current world
  private Node[][] buffer;          // holds prev world while calculating next
  private int ant_count;            // 0 -> ((size_x*size_y)*MAX_OVERLAP => infinity)
  private ArrayList<Point> hives;  // stores each colony in world
//====================================
  //constructor
  public Grid(int _x, int _y) {
    size_x=_x; size_y=_y;
    ant_count=0;

    hives = new ArrayList<Point>();

    grid = new Node[size_y][size_x];
    buffer = new Node[size_y][size_x];
    for (int i=0; i<size_y; ++i) {
      for (int j=0; j<size_x; ++j) {
        grid[i][j] = new Node();
      }
    }
  }
//==========================================
  //Helper/Extra Functions
  public void print() {
    for (int i=0; i<GHEIGHT; ++i) {
      for (int j=0; j<GWIDTH; ++j) {
        grid[i][j].print(j,i);
      }
    }
    //is_paused
    if (!is_paused) {
      fill(0,255,0); rect(0,HEIGHT, 3,30);
    } else {
      fill(255,0,0); rect(0,HEIGHT, 3,30);
    }
    //stat bar
    fill(0);
    text("Ants:", 10, HEIGHT); text(ant_count, 70, HEIGHT);
    text("Colonies:", 115, HEIGHT); text(hives.size(), 220, HEIGHT);
    text("FPS: ", 240, HEIGHT); text(FPS[SIM_TICKS_PER_SEC], 300, HEIGHT);
    text("Spawn Food:", 345, HEIGHT);
    if (auto_spawn_food) { text("True", 490, HEIGHT); }
    else {                 text("False", 490, HEIGHT); }
    text("Pheromones:", 555, HEIGHT);
    if (show_pheromones) { text("True", 700, HEIGHT); }
    else {                 text("False", 700, HEIGHT); }
    //Menu bar
    text("RESET", 10, HEIGHT+30);
    text("CLEAN", 110, HEIGHT+30);
    text("<- FPS +>", 220, HEIGHT+30);
    text("Mode: ", 350, HEIGHT+30);
    if (add_or_remove) { text("add", 425, HEIGHT+30); }
    else {               text("rem", 425, HEIGHT+30); }
    if (click_mode == 0) {      text("Colony", 472, HEIGHT+30); }
    else if (click_mode == 1) { text("Ant", 472, HEIGHT+30); }
    else if (click_mode == 2) { text("Food", 472, HEIGHT+30); }
    else if (click_mode == 3) { text("Wall", 472, HEIGHT+30); }
    text("SPAWN_RAND", 555, HEIGHT+30);
    text("PRESETS: [1] [2] [3] [4]", 800, HEIGHT+30);
  }

//=========================================================================
    //Ant functions
    public void clean() {
      for (int y=0; y<size_y; y++)
        for (int x=0; x<size_x; x++)
          grid[y][x].clean();
    }
//==========================================
  //Adding and Spawning Functions
  public void add_colony(int x, int y) {
    for (int i=0; i<hives.size(); ++i) {
      if (x == hives.get(i).x && y == hives.get(i).y) {
        return;
      }
    }
    grid[y][x].set_type(2);
    hives.add(new Point(x,y));
  }

  public void add_food(int x, int y) {
    if (grid[y][x].getType() != 2) {
      grid[y][x].set_type(3);
    }
  }

  public void add_wall(int x, int y) {
    if (grid[y][x].getType() != 2) {
      grid[y][x].set_type(4);
    }
  }

  public boolean add_ant(int x, int y) {
    if (grid[y][x].addAnt(ant_count-1)) {
      ++ant_count;
      return true;
    } else {
      return false;
    }
  }

  public void rem_colony(int x, int y) {
    if (grid[y][x].getType() == 2) {
      for (int i=0; i<hives.size(); ++i) {
        if (x == hives.get(i).x && y == hives.get(i).y) {
          hives.remove(i);
          grid[y][x] = new Node();
          break;
        }
      }
    }
  }

  public void rem_food(int x, int y) {
    if (grid[y][x].getType() == 3) {
      grid[y][x].set_type(1);
    }
  }

  public void rem_wall(int x, int y) {
    if (grid[y][x].getType() == 4) {
      grid[y][x].set_type(1);
    }
  }

  public void rem_ant(int x, int y) {
    grid[y][x].remAnt();
    --ant_count;
  }

  public void add_ant_to_colony(Ant a) {
    int i = int(random(hives.size()));
    grid[hives.get(i).y][hives.get(i).x].addAnt(a);
  }

  public void spawn_colony() {
    Point c = new Point(int(random(GWIDTH)), int(random(GHEIGHT)));
    hives.add(c);
    grid[c.y][c.x].set_type(2);
  }

  public void spawn_ants(int number) {
    for (int a=0; a<number; ++a) {
      // pick colony
      int rand_colony = int(random(hives.size()));
      Point loc = hives.get(rand_colony);
      // init ant
      grid[loc.y][loc.x].addAnt(a);
    }
    ant_count += number;
  }

  public void spawn_rand() {
    int count=0;
    for (int y=0; y<size_y; y++) {
      for (int x=0; x<size_x; x++) {
        float state = random(GWIDTH*GHEIGHT);
        if (state < GWIDTH*GHEIGHT/200) {
          grid[y][x].addAnt(0);
          count++;
          if (count >= ANTS) { return; }
        }
      }
    }
    ant_count += ANTS;
  }

  public void spawn_food() {
    int dist, min_dist, chance;
    for (int y=0; y<size_y; y++) {
      for (int x=0; x<size_x; x++) {
        dist = min_dist=10000;
        for (int i=0; i<hives.size(); ++i) {
          Point h = hives.get(i);
          dist = int(sqrt((x-h.x)*(x-h.x) + (y-h.y)*(y-h.y)));
          if (dist < min_dist) { min_dist = dist; }
        }
        if (dist <= 20) { chance = 0; }
        else if (dist <= 50) { chance = 1; }
        else { chance = 3; }

        if (random(1000) < chance) {
          grid[y][x].set_type(3);
        }
      }
    }
  }

  public void spawn_walls() {
    int x,y, count = int(random(10));
    boolean is_good = true;
    for (int i=0; i<count; ) {
      is_good = true;
      if (random(100) < 50) {//vertical
        x = int(random(GWIDTH));
        y = int(random(GHEIGHT-3));
        for (int j=0; j<3; ++j) {
          if (grid[y+j][x].getType() != 1 && grid[y+j][x].getAntCount() > 0) {
            is_good = false;
          }
        }
        if (is_good) {
          for (int j=0; j<3; ++j) {
            grid[y+j][x].set_type(4);
          }
          ++i;
        }
      } else {//horizontal
        x = int(random(GWIDTH-3));
        y = int(random(GHEIGHT));
        for (int j=0; j<3; ++j) {
          if (grid[y][x+j].getType() != 1 && grid[y][x+j].getAntCount() > 0) {
            is_good = false;
          }
        }
        if (is_good) {
          for (int j=0; j<3; ++j) {
            grid[y][x+j].set_type(4);
          }
          ++i;
        }
      }
    }
  }

//===================================================================================
  //Simulation Functions
  public void tick(){
    //copy grid into buffer
    for (int y=0; y<size_y; y++) {
      for (int x=0; x<size_x; x++) {
        buffer[y][x] = new Node(grid[y][x]);
        grid[y][x].clearAnts();
      }
    }
   //store size of grid
   Point s=new Point(size_x, size_y);
   //move ants
   int temp_ant_count=0;
   for (int y=0; y<size_y; y++) {
      for (int x=0; x<size_x; x++) {
        //create point for current location
        Point c=new Point(x,y);
        //create alias for ants in current node
        ArrayList<Ant> temp = buffer[y][x].getAnts();

        for (int i=0; i<temp.size(); i++) {
          if (temp.get(i).getHealth() > 0 && temp.get(i).getAge() < 4000) {
            Ant_Interface ai = new Ant_Interface(grid, hives, c, s);
            Point n = ai.getNext(temp.get(i));
            ai.reset_food(grid);
            grid[n.y][n.x].add_p(ai.getPLevel());

            boolean success = grid[n.y][n.x].addAnt(temp.get(i));
            if (!success){
              add_ant_to_colony(temp.get(i));
            }
            ++temp_ant_count;
          } else { println("RIP"); }
        }
      }
    }
    //
    for (int h = 0; h<hives.size(); ++h) {
      Point h_loc = hives.get(0);
      while (grid[h_loc.y][h_loc.x].getFood() > SPAWN_THRESHOLD) {
        grid[h_loc.y][h_loc.x].spawn_new_ant();
      }
    }
    //DEBUG
    if (ant_count > temp_ant_count) { println("RIP: We lost some ("+(ant_count-temp_ant_count)+"): "+temp_ant_count); }
    ant_count = temp_ant_count;
  }
}

class Ant {
  private int id;                         // should be 0 -> num_ants
  private int health;                     // 0 -> 1000
  private int food_supply;                // 0 -> 100
  private long time;                      // 0 -> infinity
  private int velocity_x, velocity_y;     // -1 -> 1
  private Point home;                     //stores velocity vector to closest colony
  private int mode;                       // 0 - normal search, 1 - return food, 2 - follow/searching
  private int invert_home;                // 0 - don't invert home, 1 - invert x, 2 - invert y
//=======================================
  //constructor
  public Ant(int _id) {
    id = _id;
    health = 100;
    food_supply = 0;
    time = 0;
    home = new Point(0,0);
    mode = 0;
    //randomize velocity
    reset_velocity(false);
  }
  //copy constructor
  public Ant(Ant a) {
    id = a.id;
    health = a.health;
    food_supply = a.food_supply;
    time = a.time;
    home = a.home;
    mode = a.mode;
    velocity_x=a.velocity_x;
    velocity_y=a.velocity_y;
  }
//===============================================
  //accessors
  public long getAge() { return time; }
  public int getID() { return id; }
  public int getHealth() { return health; }
  public int getMode() { return mode; }         // DEBUG
  public int getFood() { return food_supply; }  // DEBUG
  public int getPAmnt() {
    if (mode == 0) { return 50; }
    if (mode == 1) { return 150; }
    if (mode == 2) { return 0; }
    if (mode == 3) { return -100; }
    return 0;
  }

  public void set_home(Point hm) { home = hm; }
  //Velocity Functions
  public Point set_velocity(Point p) { velocity_x = p.x; velocity_y = p.y; return p; }
  public void invert_x() { velocity_x = -velocity_x; p_invert_x(); home_invert(0); }
  public void invert_y() { velocity_y = -velocity_y; p_invert_x(); home_invert(1); }
  public void p_invert_x() { if (random(100) < 25) velocity_x = int(pow(-1, round(random(1)))); }
  public void p_invert_y() { if (random(100) < 25) velocity_y = int(pow(-1, round(random(1)))); }
  public void reset_velocity(boolean not_move) {
    velocity_x=velocity_y=0;
    while (velocity_x == 0 && velocity_y == 0) {
      velocity_x=int(random(-2,2));
      velocity_y=int(random(-2,2));
      if (not_move) { break; }
    }
  }

  public Point getVelocity(Ant_Interface ai) {
    ++time;
    if (time%30 == 0) { health -= 5; }
    Point n = look(ai);
    ai.set_p_lvl(getPAmnt());
    int dx=0, dy=0;
    if (mode == 0 && random(1000) < 50) { dx = int(random(-2, 2)); dy = int(random(-2,2)); }// unpredictablity in movement
    if (mode == 1 && random(1000) < 10) { dx = int(random(-2, 2)); dy = int(random(-2,2)); }// unpredictablity in movement
    if (mode > 1 && random(1000) < 25) { dx = int(random(-2, 2)); dy = int(random(-2,2)); }// unpredictablity in movement
    if (random(1000) < 5) { reset_velocity(false); }// change directions randomly
    return new Point(n.x + dx, n.y + dy);
  }

  public void go_home() {
    mode = 1;
    velocity_x = home.x; velocity_y = home.y;
    if (invert_home == 1 || invert_home == 2) {
      reset_velocity(false);
      mode = 0;
      food_supply = 0;
    }
  }
  public void home_invert(int x_or_y) {
     if (x_or_y == 0) {
       invert_home = 1;
     } else {
       invert_home = 2;
     }
     go_home();
  }
  //Eating Functions
  public void eat(Ant_Interface ai, int x, int y, int loc) {
    // loc: 0 - food, 1 - food_supply, 2 - colony
    int neg_health = 100-health;
    if (loc == 0) {
      //EAT, PICK_UP
      health += ai.eat(x,y,neg_health);
      food_supply += ai.pick_up(x,y, 1000-food_supply);
    } else if (loc == 1 && food_supply > 0) {
      //EAT, REDUCE
      int amnt;
      if (food_supply > neg_health) {
        amnt = neg_health;
      } else {
        amnt = food_supply;
      }
      health += amnt;
      food_supply -= amnt;
    } else if (loc == 2) {
      //EAT, REDUCE
      health += ai.eat(x,y,neg_health);
    }
  }
//==============================================
  //moving functions
  //NOTE: nbors - (type, p_level)
  //TYPES: 0 - nothing, 1 - ant(obselete), 2 - colony, 3 - food, 4 - wall
  public Point look(Ant_Interface ai) {
    int dist, home_count=0, food_count=0;
    //FOOD
    for (int y=0; y<=2*ANT_RANGE; y++) {
      for (int x=0; x<=2*ANT_RANGE; x++) {
        if (ai.nbor(x,y,0) == 3) {
          ++food_count;
          dist = floor(sqrt((x-ANT_RANGE)*(x-ANT_RANGE) + (y-ANT_RANGE)*(y-ANT_RANGE)));
          if (mode != 1) {
            if (dist < 3) { // if in range
              //eat and pick_up
              eat(ai, x,y, 0);
              go_home();
              return new Point(0,0); //stop while eating;
            } else { // if too far, move closer
              dist = max(abs(x-ANT_RANGE), abs(y-ANT_RANGE), 1);
              Point f_vec = new Point((x-ANT_RANGE)/dist, (y-ANT_RANGE)/dist);
              return set_velocity(f_vec);
            }
          }
        }
      }
    }
    //HOME
    for (int y=0; y<=2*ANT_RANGE; y++) {
      for (int x=0; x<=2*ANT_RANGE; x++) {
        if (ai.nbor(x,y,0) == 2) {
          ++home_count;
          if (mode == 0) { continue; }
          dist = floor(sqrt((x-ANT_RANGE)*(x-ANT_RANGE) + (y-ANT_RANGE)*(y-ANT_RANGE)));
          if (dist < 3) {
            if (mode == 1) {
              ai.deposit(x,y, food_supply);
              food_supply = 0;
              eat(ai, x,y, 2);
              mode = 0;
              reset_velocity(false);
              return new Point(0,0);
            } else {
              eat(ai, x,y, 2);
              mode = 0;
              reset_velocity(false);
              return new Point(0,0);
            }
          } else {
            go_home();
          }
        }
      }
    }
    //HUNGRY
    if (health <= 60) {
      if (food_supply > 0) {
        eat(ai, -1,-1, 1);
        if (food_supply > 0) {
          go_home();
        } else {
          mode = 0;
        }
        return new Point(0,0);
      } else {
        mode = 3;
      }
    } else if (health <= 20) {
      go_home();
    }

    if (mode == 1) { go_home(); }

    return new Point(velocity_x, velocity_y);
  }

  Point get_next(Ant_Interface ai) {
    home = ai.get_home();
    return getVelocity(ai);
  }
}

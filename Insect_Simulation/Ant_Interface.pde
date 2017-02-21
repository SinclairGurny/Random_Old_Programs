class Ant_Interface {
  //Locked variable
  private Point curr_loc;
  private Point grid_size;
  //Unlocked variables
  private int p_level;
  private Point home_vec;
  private int[][] nbors_type;
  private int[][] nbors_food;
  private int[][] nbors_p_lvl;
  //===========================
  public Ant_Interface(Node[][] _grid, ArrayList<Point> hvs, Point c_loc, Point g_size) {
    p_level = 0;
    curr_loc = c_loc;
    grid_size = g_size;
    home_vec = calcHome(hvs);
    //
    int nbor_size = 2*ANT_RANGE+1;
    nbors_type = new int[nbor_size][nbor_size];
    nbors_food = new int[nbor_size][nbor_size];
    nbors_p_lvl = new int[nbor_size][nbor_size];
    for (int dy = -ANT_RANGE; dy<=ANT_RANGE; ++dy) {
      for (int dx = -ANT_RANGE; dx<=ANT_RANGE; ++dx) {
        if ((curr_loc.x + dx >= 0 && curr_loc.x + dx < grid_size.x) && (curr_loc.y + dy >= 0 && curr_loc.y + dy < grid_size.y)) {
          nbors_type[ANT_RANGE+dy][ANT_RANGE+dx] = _grid[curr_loc.y+dy][curr_loc.x+dx].getType();
          nbors_food[ANT_RANGE+dy][ANT_RANGE+dx] = _grid[curr_loc.y+dy][curr_loc.x+dx].getFood();
          nbors_p_lvl[ANT_RANGE+dy][ANT_RANGE+dx] = _grid[curr_loc.y+dy][curr_loc.x+dx].getPLevel();
        } else {
          nbors_type[ANT_RANGE+dy][ANT_RANGE+dx] = -1;
          nbors_food[ANT_RANGE+dy][ANT_RANGE+dx] = -1;
          nbors_p_lvl[ANT_RANGE+dy][ANT_RANGE+dx] = -1;
        }
      }
    }
  }
  // == Helper Functions ================================
  private Point calcHome(ArrayList<Point> hives) {
    if (hives.size() == 0) { return new Point(0,0); }
    Point temp_hm, hm = new Point(hives.get(0).x - curr_loc.x, hives.get(0).y - curr_loc.y);
    int temp_dist, dist = round(sqrt(hm.x*hm.x + hm.y*hm.y));
    for (int i=1; i<hives.size(); ++i) {
      temp_hm = new Point(hives.get(i).x - curr_loc.x, hives.get(i).y - curr_loc.y);
      temp_dist = round(sqrt(temp_hm.x*temp_hm.x + temp_hm.y*temp_hm.y));
      if (temp_dist < dist) {
        dist = temp_dist;
        hm = temp_hm;
      }
    }
    //normalize vector
    if (dist > 0) { hm = new Point(round(hm.x/float(dist)), round(hm.y/float(dist))); }
    return hm;
  }
  // Ant Functions
  public int nbor(int x, int y, int type) {
    if ((x >= 0 && x <= 2*ANT_RANGE) && (x >= 0 && x <= 2*ANT_RANGE)) {
      if (type == 0) {
        return nbors_type[y][x];
      } else if (type == 1) {
        return nbors_food[y][x];
      } else if (type == 2) {
        return nbors_p_lvl[y][x];
      }
    }
    return -1;
  }

  public int eat(int x, int y, int h_amnt) {
    int ret = 0;
    if (nbors_type[y][x] == 2) {//Colony
      if (nbors_food[y][x] > h_amnt) {
        nbors_food[y][x] -= h_amnt;
        return h_amnt;
      } else {
        ret = nbors_food[y][x];
        nbors_food[y][x] = 0;
        return ret;
      }
    } else if (nbors_type[y][x] == 3) {//FOOD
      if (nbors_food[y][x] > h_amnt) {
        nbors_food[y][x] -= h_amnt;
      } else {
        ret = nbors_food[y][x];
        nbors_food[y][x] = 0;
        return ret;
      }
    }
    return 0;
  }

  public int pick_up(int x, int y, int max_pick_up) {
    if (nbors_type[y][x] == 3) {//FOOD
      if (nbors_food[y][x] > max_pick_up) {
        nbors_food[y][x] -= max_pick_up;
        return max_pick_up;
      } else {
        int ret = nbors_food[y][x];
        nbors_food[y][x] = 0;
        return ret;
      }
    }
    return 0;
  }

  public void deposit(int x, int y, int amnt) {
    if (nbors_type[y][x] == 2) {
      nbors_food[y][x] += amnt;
      //println("Deposited at colony: "+amnt);
    }
  }

  public void set_p_lvl(int amnt) {
    p_level = amnt;
  }

  public Point get_home() {
    return home_vec;
  }
  // World Functions
  public Point getNext(Ant a) {
    Point v = a.get_next(this);
    Point ret = new Point(0,0);
    if (curr_loc.x + v.x >= 0 && curr_loc.x + v.x < grid_size.x
                              && nbors_type[ANT_RANGE + v.y][ANT_RANGE + v.x] != 4) {
      ret.x = curr_loc.x + v.x;
    } else {
      ret.x = curr_loc.x - v.x;
      a.invert_x();
    }
    if (curr_loc.y + v.y >= 0 && curr_loc.y + v.y < grid_size.y
                              && nbors_type[ANT_RANGE + v.y][ANT_RANGE + v.x] != 4) {
      ret.y = curr_loc.y + v.y;
    } else {
      ret.y = curr_loc.y - v.y;
      a.invert_y();
    }
    return ret;
  }

  public int getPLevel() {
    return p_level;
  }

  public void reset_food(Node[][] _grid) {
    for (int dy = -ANT_RANGE; dy<=ANT_RANGE; ++dy) {
      for (int dx = -ANT_RANGE; dx<=ANT_RANGE; ++dx) {
        if ((curr_loc.x + dx >= 0 && curr_loc.x + dx < grid_size.x) && (curr_loc.y + dy >= 0 && curr_loc.y + dy < grid_size.y)) {
          _grid[curr_loc.y+dy][curr_loc.x+dx].set_food(nbors_food[ANT_RANGE+dy][ANT_RANGE+dx]);
        }
      }
    }
  }
}

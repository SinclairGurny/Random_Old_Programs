//system constants
int FRAME_RATE = 60;
int WIDTH = 1080;
int HEIGHT = 720;
PFont font;
//simulation constants
int[] FPS = {5, 10, 15, 30, 60, 120, 240};
int SIM_TICKS_PER_SEC = 3; // index in FPS
int ANTS = 20;
int GWIDTH = 108;
int GHEIGHT = 72;
int MAX_OVERLAP = 10;
int ANT_RANGE = 4;
int SPAWN_THRESHOLD = 50000;

//system variables
boolean is_paused = true;
long time = 0;

int click_mode = 1; //Colony, Ants, Food, Wall
boolean add_or_remove = true;
Point last_mouse_loc = new Point(-1,-1);

//simulation variables
Grid world = new Grid(GWIDTH, GHEIGHT);
boolean show_pheromones = false;
boolean auto_spawn_food = true;
int spawn_interval = 15;

void setup() {
  //Window Settings
  size(WIDTH+1, HEIGHT+60);
  frameRate(FRAME_RATE);
  //Text Settings
  font = createFont("Dialog.plain", 24);
  if (font == null) { font = createFont("Arial", 24); }
  textFont(font);
  textAlign(LEFT,TOP);
  //Basic Settings
  smooth();
  rectMode(CORNER);
  stroke(237, 155, 63);
  fill(0);
  background(0);
}

void draw() {
  background(237, 201, 175);
  world.print();

  if (FPS[SIM_TICKS_PER_SEC] <= FRAME_RATE) {
    if (!is_paused && time%(FRAME_RATE/FPS[SIM_TICKS_PER_SEC]) == 0) {
      world.tick();
      if (auto_spawn_food && time%(FRAME_RATE*spawn_interval) == 0) {
        world.spawn_food();
      }
    }
    ++time;
  } else {
    if (!is_paused) {
      for (int q=0; q<FPS[SIM_TICKS_PER_SEC]/FRAME_RATE; ++q) {
        world.tick();
        if (auto_spawn_food && time%(FRAME_RATE*spawn_interval) == 0) {
          world.spawn_food();
        }
        ++time;
      }
    }
  }
}

void keyPressed() {
  //TOGGLES
  if (key==' ') { // On/off of pause
    is_paused = !is_paused;
  }
  if (key=='p' || key == 'P') { // Toggle show_pheromones
    show_pheromones = !show_pheromones;
  }
  if (key=='f' || key=='F') { // Toggle auto_spawn_food
    auto_spawn_food = !auto_spawn_food;
  }
  if (keyCode == TAB) { // Cycle through click_mode
    ++click_mode;
    if (click_mode==4) { click_mode=0; add_or_remove = !add_or_remove; }
  }
  //CLEAR/RESET
  if (key=='r' || key == 'R') { // Reset Board
    world = new Grid(GWIDTH, GHEIGHT);
    is_paused = true;
  }
  if (key=='c' || key == 'C') { // Clear all pheromones
    world.clean();
    is_paused = true;
  }
  //ADJUST
  if (keyCode==LEFT) { // Decrease Frame rate
    if (SIM_TICKS_PER_SEC > 0) { SIM_TICKS_PER_SEC-=1; }
  }
  if (keyCode==RIGHT) { // Increase Frame rate
    if (SIM_TICKS_PER_SEC < 6) { SIM_TICKS_PER_SEC+=1; }
  }
  //OTHER
  if (key == 's' || key == 'S') {//TODO Random spawn click_mode
    if (click_mode == 0 && add_or_remove) {//Colony
      //move colonies to rand locations
      world.spawn_colony();
    } else if (click_mode == 1) {//Ant
      //spawn_random
      world.spawn_rand();
    } else if (click_mode == 2) {//Food
      //spawn_food
      world.spawn_food();
    } else if (click_mode == 3) {//Wall
      //spawn_walls
      world.spawn_walls();
    }
  }
  //PRESETS
  if (key=='1') {
    world = new Grid(GWIDTH, GHEIGHT);
    world.add_colony(54, 40);
    world.spawn_ants(ANTS);
    world.spawn_food();
    world.spawn_walls();
  }
  if (key=='2') {
    world = new Grid(GWIDTH, GHEIGHT);
    world.add_colony(0, 0);
    world.spawn_ants(ANTS);
    world.spawn_food();
    world.spawn_walls();
  }
  if (key=='3') {
    world = new Grid(GWIDTH, GHEIGHT);
    world.add_colony(0, 0);
    world.add_colony(GWIDTH-1, GHEIGHT-1);
    world.spawn_ants(ANTS);
    world.spawn_food();
    world.spawn_walls();
  }
  if (key=='4') {
    world = new Grid(GWIDTH, GHEIGHT);
    world.add_colony(int(random(GWIDTH)), int(random(GHEIGHT)));
    world.spawn_ants(ANTS);
    world.spawn_food();
    world.spawn_walls();
  }
}

void mousePressed() {
  if (mouseY < HEIGHT) {
    if (!is_paused) {
      is_paused = true;
    } else {
      int mx = (mouseX-mouseX%(WIDTH/GWIDTH))/(WIDTH/GWIDTH);
      int my = (mouseY-mouseY%(HEIGHT/GHEIGHT))/(HEIGHT/GHEIGHT);
      if (my > GHEIGHT) { return; }
      if (add_or_remove) {
        if (click_mode == 0) {//Colony
          world.add_colony(mx, my);
        } else if (click_mode == 1) {//Ant
          world.add_ant(mx, my);
        } else if (click_mode == 2) {//Food
          world.add_food(mx, my);
        } else if (click_mode == 3) {//Wall
          world.add_wall(mx, my);
        }
      } else {
        if (click_mode == 0) {//Colony
          world.rem_colony(mx, my);
        } else if (click_mode == 1) {//Ant
          world.rem_ant(mx, my);
        } else if (click_mode == 2) {//Food
          world.rem_food(mx, my);
        } else if (click_mode == 3) {//Wall
          world.rem_wall(mx, my);
        }
      }
      last_mouse_loc = new Point(mx, my);
    }
  } else {
    //RESET
    if (mouseX > 0 && mouseX < 100 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world = new Grid(GWIDTH, GHEIGHT);
      is_paused = true;
    }
    //CLEAN
    if (mouseX > 100 && mouseX < 220 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world.clean();
      is_paused = true;
    }
    //Pheromones
    if (mouseX > 555 && mouseX < 730 && mouseY > HEIGHT && mouseY < HEIGHT+30) {
      show_pheromones = !show_pheromones;
    }
    //Food
    if (mouseX > 340 && mouseX < 540 && mouseY > HEIGHT && mouseY < HEIGHT+30) {
      auto_spawn_food = !auto_spawn_food;
    }
    //click_mode
    if (mouseX > 340 && mouseX < 520 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      ++click_mode;
      if (click_mode==4) { click_mode=0; add_or_remove = !add_or_remove; }
    }
    //SPAWN_RAND
    if (mouseX > 555 && mouseX < 730 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      if (click_mode == 0 && add_or_remove) {//Colony
        world.spawn_colony();
      } else if (click_mode == 1) {//Ant
        world.spawn_rand();
      } else if (click_mode == 2) {//Food
        world.spawn_food();
      } else if (click_mode == 3) {//Wall
        world.spawn_walls();
      }
    }
    //FPS
    if (mouseX > 220 && mouseX < 240 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      if (SIM_TICKS_PER_SEC > 0) { SIM_TICKS_PER_SEC-=1; }
    } else if (mouseX > 300 && mouseX < 340 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      if (SIM_TICKS_PER_SEC < 6) { SIM_TICKS_PER_SEC+=1; }
    }
    //PRESETS
    if (mouseX > 920 && mouseX < 950 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world = new Grid(GWIDTH, GHEIGHT);
      world.add_colony(54, 40);
      world.spawn_ants(ANTS);
      world.spawn_food();
      world.spawn_walls();
    }
    if (mouseX > 950 && mouseX < 990 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world = new Grid(GWIDTH, GHEIGHT);
      world.add_colony(0, 0);
      world.spawn_ants(ANTS);
      world.spawn_food();
      world.spawn_walls();
    }
    if (mouseX > 990 && mouseX < 1020 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world = new Grid(GWIDTH, GHEIGHT);
      world.add_colony(0, 0);
      world.add_colony(GWIDTH-1, GHEIGHT-1);
      world.spawn_ants(ANTS);
      world.spawn_food();
      world.spawn_walls();
    }
    if (mouseX > 1020 && mouseX < 1050 && mouseY > HEIGHT+30 && mouseY < HEIGHT+60) {
      world = new Grid(GWIDTH, GHEIGHT);
      world.add_colony(int(random(GWIDTH)), int(random(GHEIGHT)));
      world.spawn_ants(ANTS);
      world.spawn_food();
      world.spawn_walls();
    }
    //================
  }
}

void mouseDragged() {
  int mx = (mouseX-mouseX%(WIDTH/GWIDTH))/(WIDTH/GWIDTH);
  int my = (mouseY-mouseY%(HEIGHT/GHEIGHT))/(HEIGHT/GHEIGHT);
  if (last_mouse_loc.x != mx || last_mouse_loc.y != my) {
    if (my >= GHEIGHT) { return; }
    if (add_or_remove) {
      if (click_mode == 1) {//Ant
        world.add_ant(mx, my);
      } else if (click_mode == 2) {//Food
        world.add_food(mx, my);
      } else if (click_mode == 3) {//Wall
        world.add_wall(mx, my);
      }
    } else {
      if (click_mode == 1) {//Ant
        world.rem_ant(mx, my);
      } else if (click_mode == 2) {//Food
        world.rem_food(mx, my);
      } else if (click_mode == 3) {//Wall
        world.rem_wall(mx, my);
      }
    }
  }
  last_mouse_loc = new Point(mx, my);
}

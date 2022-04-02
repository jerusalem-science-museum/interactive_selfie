class Button_Select extends Button {
  int selected = -1;
  Checkbox btns[];

  public Button_Select(int by, PImage[] images) {
    y = by;
    btns = new Checkbox[5];
    for (int i=0; i<5; i++) btns[i] = new Checkbox(293 + i*122, y, images[4-i]);
  }

  @Override
    public void show() {
    selected = -1;
    active = true;
    for (int i=0; i<5; i++) btns[i].show();
  }

  @Override
    public void hide() {
    active = false;
    for (int i=0; i<5; i++) btns[i].hide();
  }

  @Override
    public void run() {
    if (active) {
      for (int i=0; i<5; i++) btns[i].run();
    }
  }

  @Override
    public boolean touched(int mx, int my) {
    if (active) {
      for (int i=0; i<5; i++) {
        if (btns[i].touched(mx, my)) {
          selected = i;
          for (int j=0; j<5; j++) btns[j].off();
          btns[i].on();
          return true;
        }
      }
    }
    return false;
  }

  public boolean getState() {
    return (selected > -1);
  }
  
  public int getSelected() {
    return selected;
  }
}

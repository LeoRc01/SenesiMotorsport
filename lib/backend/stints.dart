class Stint {
  int index;
  double lap;
  double minute;
  double margin;

  Stint(this.index, this.lap, this.minute, this.margin);

  void setMinute(double min) {
    this.minute = min;
  }
}

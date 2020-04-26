class Recipe {
  String name;
  int coffee;
  int water;

  String get ratio {
    String ratio = '0.0';
    if (coffee != null && water != null) {
      ratio = (water.toDouble() / coffee).toStringAsFixed(1);
    }
    return '1:$ratio';
  }
}

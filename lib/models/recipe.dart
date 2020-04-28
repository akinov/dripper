import 'package:dripper/sharedPref.dart';

class Recipe {
  String name;
  int coffee;
  int water;

  Recipe();

  String get ratio {
    String ratio = '0.0';
    if (coffee != null && water != null) {
      ratio = (water.toDouble() / coffee).toStringAsFixed(1);
    }
    return '1:$ratio';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'coffee': coffee,
        'water': water,
      };

  Recipe.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        coffee = json['coffee'],
        water = json['water'];

  static Future<List<Recipe>> all() async {
    SharedPref sharedPref = SharedPref();
    List list = await sharedPref.read('stringValue') ?? new List();
    return list.map((json) => Recipe.fromJson(json)).toList();
  }
}

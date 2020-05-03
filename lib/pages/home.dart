import 'package:dripper/models/recipe.dart';
import 'package:dripper/pages/recipe/new.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() async {
    print('loadRecipes');
    // RecipeProvider recipeProvider = RecipeProvider();
    // List<Recipe> recipes = await recipeProvider.all();
    Recipe recipe = Recipe();
    recipe.name = 'aaa';
    List<Recipe> recipes = [recipe, recipe, recipe];
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(
                _recipes[index].name,
              ),
            ),
          );
        },
        itemCount: _recipes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return RecipeNew();
            },
          ));
          print(result);
          loadRecipes();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

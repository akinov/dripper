import 'package:dripper/models/process.dart';
import 'package:dripper/models/recipe.dart';
import 'package:dripper/pages/recipe/new.dart';
import 'package:dripper/pages/recipe/show.dart';
import 'package:dripper/wigets/customAppBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RecipeProvider _recipeProvider = RecipeProvider();
  ProcessProvider _processProvider = ProcessProvider();
  List<Recipe> _recipes = [];
  int _titleTapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    List<Recipe> recipes = await _recipeProvider.all();
    setState(() => _recipes = recipes);
  }

  void _tapTitle() {
    _titleTapCount += 1;
    if (_titleTapCount >= 7) {
      _titleTapCount = 0;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("登録データの一括削除"),
            content: Text("データを削除してもよろしいですか？"),
            actions: <Widget>[
              // ボタン領域
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () async {
                  await _recipeProvider.reCreateTable();
                  await _processProvider.reCreateTable();
                  _loadRecipes();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onTap: _tapTitle,
          appBar: AppBar(
            title: Text('dripper'),
          )),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Recipe recipe = _recipes[index];
          return Card(
            child: ListTile(
              title: Text(
                recipe.name,
              ),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RecipeShow(recipe);
                  },
                ));
              },
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
          _loadRecipes();
        },
        tooltip: 'Add Recipe',
        child: Icon(Icons.add),
      ),
    );
  }
}

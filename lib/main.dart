import 'package:dripper/models/recipe.dart';
import 'package:flutter/material.dart';
import 'new.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    setRecipes();
  }

  void setRecipes() async {
    List<Recipe> recipes = await Recipe.all();
    print(recipes);
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              child: Text(
                _recipes[index].name,
                style: TextStyle(fontSize: 22.0),
              ),
              padding: EdgeInsets.all(20.0),
            ),
          );
        },
        itemCount: _recipes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return New();
            },
          ))
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:dripper/models/process.dart';
import 'package:dripper/models/recipe.dart';
import 'package:dripper/pages/recipe/timer.dart';
import 'package:flutter/material.dart';

class RecipeShow extends StatefulWidget {
  RecipeShow(this.recipe);
  Recipe recipe;

  @override
  _RecipeShowState createState() => _RecipeShowState();
}

class _RecipeShowState extends State<RecipeShow> {
  List<Process> _processes = [];

  @override
  void initState() {
    loadProcesses();
    super.initState();
  }

  void loadProcesses() async {
    print('loadRecipes');

    List<Process> processes =
        await ProcessProvider().recipedBy(widget.recipe.id);
    setState(() {
      _processes = processes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        'Coffee',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Text(widget.recipe.coffee.toString() + 'g'),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        'Water',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Text(widget.recipe.water.toString() + 'ml'),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        'Process',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Column(children: processesListCards()),
                ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return RecipeTimer(widget.recipe, _processes);
            },
          ));
        },
        tooltip: 'Timer Start',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  List<Card> processesListCards() {
    return _processes.map((process) {
      return Card(
        child: ListTile(
          title: Text(
            process.typeText,
          ),
          // subtitle: Text('hoghoge'),
          leading: Text(process.step.toString()),
          subtitle: Text(process.title),
        ),
      );
    }).toList();
  }
}

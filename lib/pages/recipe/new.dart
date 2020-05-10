import 'package:dripper/models/process.dart';
import 'package:dripper/models/recipe.dart';
import 'package:dripper/pages/process/new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeNew extends StatefulWidget {
  RecipeNew({Key key}) : super(key: key);

  @override
  _RecipeNewState createState() => _RecipeNewState();
}

class _RecipeNewState extends State<RecipeNew> {
  final _formKey = GlobalKey<FormState>();
  Recipe _recipe = new Recipe();
  List<Process> _processes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Recipe"),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());

                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  RecipeProvider recipeProvider = RecipeProvider();
                  _recipe = await recipeProvider.save(_recipe);
                  ProcessProvider processProvider = ProcessProvider();
                  _processes.forEach((process) {
                    process.recipeId = _recipe.id;
                    processProvider.save(process);
                  });
                  Navigator.of(context).pop(_recipe);
                } else {
                  // 何かしらのアラート出す？
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Recipe Name",
                      ),
                      autovalidate: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() => _recipe.name = value);
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: "Coffee",
                      ),
                      autovalidate: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some digist';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() => _recipe.coffee = int.parse(value));
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: "Water",
                      ),
                      autovalidate: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some digist';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() => _recipe.water = int.parse(value));
                      },
                    ),
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
                    Card(
                      child: ListTile(
                          onTap: _addProcess,
                          title: Text(
                            'Add process',
                          ),
                          leading: Icon(Icons.add)),
                    )
                  ])),
        )));
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
          trailing: Icon(Icons.more_vert),
          subtitle: Text(process.titleForList),
        ),
      );
    }).toList();
  }

  void _addProcess() async {
    Process process = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return ProcessNew();
      },
    ));
    if (process != null) {
      setState(() {
        process.step = _processes.length + 1;
        _processes.add(process);
      });
    }
  }
}

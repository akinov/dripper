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
  double ratio = 0.0;

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
                  recipeProvider.save(_recipe);
                  Navigator.of(context).pop(_recipe);
                } else {
                  // 何かしらのアラート出す？
                }
              },
              child: Icon(Icons.check),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
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
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              _processes[index].typeText,
                            ),
                            subtitle: Text('hoghoge'),
                            leading: Text('aa'),
                            trailing: Text('bb'),
                          ),
                        );
                      },
                      itemCount: _processes.length,
                    )),
                    Card(
                      child: ListTile(
                          onTap: () async {
                            Process process = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ProcessNew();
                              },
                            ));
                            if (process != null) {
                              setState(() => _processes.add(process));
                            }
                          },
                          title: Text(
                            'Add process',
                          ),
                          leading: Icon(Icons.add)),
                    )
                  ])),
        ));
  }
}

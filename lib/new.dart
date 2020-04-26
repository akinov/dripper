import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/recipe.dart';

class New extends StatefulWidget {
  New({Key key}) : super(key: key);

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  final _formKey = GlobalKey<FormState>();
  Recipe recipe = new Recipe();
  double ratio = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());

              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
              }
            },
            child: Icon(Icons.check),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
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
                setState(() => recipe.name = value);
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
                setState(() => recipe.coffee = int.parse(value));
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
                setState(() => recipe.water = int.parse(value));
              },
            ),
            Text(recipe.ratio),
          ])),
    );
  }
}

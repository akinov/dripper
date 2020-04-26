import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class New extends StatefulWidget {
  New({Key key}) : super(key: key);

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  final _formKey = GlobalKey<FormState>();
  int _a = 0;
  int _b = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              print(_formKey.currentState.validate());
              _formKey.currentState.save();
              FocusScope.of(context).requestFocus(FocusNode());
              print(_a);
              print(_b);
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
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Email address form",
                hintText: 'Enter your email',
              ),
              autovalidate: false,
              validator: (value) {
                // _formKey.currentState.validate()でコールされる
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                setState(() => _a = int.parse(value));
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Email address form",
                hintText: 'Enter your email',
              ),
              autovalidate: false,
              validator: (value) {
                // _formKey.currentState.validate()でコールされる
                if (value.isEmpty) {
                  return 'Please enter some text';
                } else if (false) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                setState(() => _b = int.parse(value));
              },
            ),
          ])),
    );
  }
}

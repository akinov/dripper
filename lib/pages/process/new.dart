import 'package:dripper/models/process.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProcessNew extends StatefulWidget {
  ProcessNew({Key key}) : super(key: key);

  @override
  _ProcessNewState createState() => _ProcessNewState();
}

class _ProcessNewState extends State<ProcessNew> {
  final _formKey = GlobalKey<FormState>();
  Process process = new Process();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Process"),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());

                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.of(context).pop(process);
                } else {
                  // 何かしらのアラート出す？
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                DropdownButton<int>(
                  value: process.type,
                  isExpanded: true,
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (int newValue) {
                    setState(() {
                      process.type = newValue;
                    });
                  },
                  items: typeList(),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Duration(s)",
                  ),
                  autovalidate: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some digist';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() => process.duration = int.parse(value));
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Water(ml)",
                  ),
                  autovalidate: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some digist';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() => process.water = int.parse(value));
                  },
                ),
              ])),
        ));
  }

  List<DropdownMenuItem<int>> typeList() {
    return ProcessType.values.map((value) {
      return DropdownMenuItem(
        child: new Text(value.toString().split('.')[1]),
        value: value.index,
      );
    }).toList();
  }
}

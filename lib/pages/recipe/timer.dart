import 'dart:async';
import 'package:dripper/models/process.dart';
import 'package:dripper/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeTimer extends StatefulWidget {
  RecipeTimer(this.recipe, this.processes);
  final Recipe recipe;
  final List<Process> processes;

  @override
  _RecipeTimerState createState() => _RecipeTimerState();
}

class _RecipeTimerState extends State<RecipeTimer> {
  Timer _timer;
  DateTime _start;
  DateTime _now;
  Duration _tmpDuration = Duration();
  bool _doing = true;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _onTimer(Timer timer) {
    setState(() => _now = DateTime.now());
  }

  Duration _duration() {
    if (_start != null && _now != null) {
      return _tmpDuration + _now.difference(_start);
    } else {
      return _tmpDuration;
    }
  }

  void _toggleTimer() {
    if (_doing) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _doing = true;
      _start = DateTime.now();
      _now = DateTime.now();
      _timer = Timer.periodic(
        Duration(milliseconds: 100),
        _onTimer,
      );
    });
  }

  void _stopTimer() {
    _timer.cancel();
    Duration duration = _duration();
    setState(() {
      _doing = false;
      _start = null;
      _now = null;
      _tmpDuration = duration;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0), child: Text(_duration().toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTimer,
        tooltip: 'Stop Timer',
        child: Icon((_doing) ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

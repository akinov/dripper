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
  List<Process> _processes;
  double _currentWater = 0;

  @override
  void initState() {
    _setupProcsses();
    _startTimer();
    super.initState();
  }

  void _setupProcsses() {
    List<Process> result = [];
    int time = 0;
    int water = 0;
    widget.processes.forEach((process) {
      time += process.duration;
      process.inSeconds = time;
      if (process.water != null) {
        water += process.water;
      }
      process.totalWater = water;
      result.add(process);
    });
    setState(() => _processes = result);
  }

  void _onTimer(Timer timer) {
    Process process = _currentProcess();
    int seconds = _duration().inSeconds;
    if (_processes.length > 0) {
      if (process.inSeconds <= seconds) {
        _processes.removeAt(0);
      }
    } else {
      _stopTimer();
    }

    if (process.water != null || process.water != 0) {
      double a = (process.inSeconds -
              process.duration -
              (_duration().inMilliseconds / 1000)) *
          -1;
      double b = a.toDouble() / process.duration.toDouble();
      _currentWater = b * process.water;
    }

    setState(() {
      _now = DateTime.now();
      _processes = _processes;
      _currentWater = _currentWater;
    });
  }

  Process _currentProcess() {
    if (_processes.length == 0) {
      return null;
    } else {
      return _processes.first;
    }
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
        Duration(milliseconds: 25),
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

  String _durationString() {
    List times = _duration().toString().split('.');
    return times[0] + '.' + times[1].substring(0, 2);
  }

  String _title() {
    if (_currentProcess() != null) {
      return _currentProcess().typeText;
    }
    {
      return 'Complete!';
    }
  }

  String _text() {
    if (_currentProcess() != null) {
      return _currentProcess().textForTimer;
    } else {
      return ' ';
    }
  }

  String _waterText() {
    Process process = _currentProcess();
    if (process == null) {
      return '';
    }
    int prevWater = process.totalWater - process.water;
    return (prevWater + _currentWater).toStringAsFixed(1) +
        '/' +
        process.totalWater.toStringAsFixed(1) +
        ' g';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              _title(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            )),
        Text(
          _waterText(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
        Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              _durationString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            )),
        Text(
          _text(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTimer,
        tooltip: 'Stop Timer',
        child: Icon((_doing) ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'dripper',
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme:
              GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme)),
    );
  }
}

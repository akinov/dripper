import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

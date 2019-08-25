import 'package:agin_gaz/home_screen.dart';
import 'package:agin_gaz/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agile Gas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home' : (context) => HomeScreen(),
        '/' : (context) => SplashScreen(),
      },
      initialRoute: '/',
    );
  }
}

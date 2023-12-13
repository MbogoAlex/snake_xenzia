import 'package:flutter/material.dart';
import 'package:snake/homepage.dart';
import 'package:snake/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}

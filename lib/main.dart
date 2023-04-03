// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_demo_app/pages/getData.dart';
import 'package:flutter_demo_app/pages/profile.dart';
import 'package:flutter_demo_app/utils/routes.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'pages/screen1.dart';

// import 'pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: HomePage(),
      themeMode: ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(), // HomePage
        // "/scrren1": (context) => const Screen1(),
        // "/home": (context) => const HomePage(),

        // "/": (context) => getData(),
        // LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => Profile(),
        MyRoutes.loginRoute: (context) => Screen1(),
      },
    );
  }
}

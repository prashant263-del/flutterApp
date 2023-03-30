// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "Prashant";
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Flutter App"),
        // backgroundColor: Colors.amber,
      ),
      body: Center(
          child: Container(
        child: Text(
          "Welcome $name",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      )),
      drawer: const MyDrawer(),
    );
    // Text("This is the home page"),
    // Image.network("https://picsum.photos/200/300"),
    // Image.network("https://picsum.photos/200/300")

    // using childern by columns
  }
}

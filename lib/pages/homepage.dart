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
        child: SingleChildScrollView(
          child: Text(
            "Welcome $name Hru Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
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

// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/drawer.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Info Screen"),
    //     // backgroundColor: Colors.amber,
    //   ),
    //   body: Center(
    //     child: Container(
    //       child: const Text(
    //         "Welcome to the Info Screen ",
    //         style: TextStyle(
    //           fontSize: 30,
    //           fontWeight: FontWeight.bold,
    //           color: Colors.deepOrangeAccent,
    //         ),
    //       ),
    //     ),
    //   ),
    //   drawer: const MyDrawer(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Screen"),
        // backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 768) {
            return Column(
              children: [
                buildBannerSlider(),
                buildIntroText(),
              ],
            );
          } else {
            return Row(
              children: [
                buildBannerSlider(),
                buildIntroText(),
              ],
            );
          }
        }),
      ),
      drawer: const MyDrawer(),
    );
  }

  Text buildIntroText() {
    return Text(
      "Hey there, \n\n Welcome to the Flutter Application",
      style: TextStyle(fontSize: 22),
    );
  }

  Container buildBannerSlider() {
    return Container(
      width: 320,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.pink],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

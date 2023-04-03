import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/drawer.dart';
// test commit

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const header = 'Profile';
  // commonDialog dialog = new commonDialog();
  List _loadedPhotos = [];

  Future<void> _fetchData() async {
    const apiUrl =
        'https://hclwdc701d.execute-api.ap-south-1.amazonaws.com/Development/fluttertest';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode("[" + response.body + "]");
    print(data[0]['body']['header']);
    setState(() {
      _loadedPhotos = data[0]['body']['header'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: const Text(header),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
            child: _loadedPhotos.isEmpty
                ? Center(
                    child: ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text('Load Data'),
                    ),
                  )
                // The ListView that displays photos
                : ListView.builder(
                    itemCount: _loadedPhotos.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return ListTile(
                        title: Text(_loadedPhotos[index]['Title']),
                      );
                    },
                  )));
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/drawer.dart';
// test commit

class GetData extends StatefulWidget {
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  static const header = 'Profile';
  // commonDialog dialog = new commonDialog();
  List _loadedData = [];

  Future<void> _fetchData() async {
    const apiUrl = 'http://127.0.0.1:5000';

    // final response = await http.get(Uri.parse(apiUrl));

    final response = await http.get(
      Uri.parse(apiUrl),
      // Send authorization headers to the backend.
      headers: {
        'paramsfor': '{"opnfor":"100000", "act":"A-V"}',
      },
    );
    print(jsonDecode(response.body));
    final data = json.decode("[" + response.body + "]");
    print(data[0]['body']['header']);
    setState(() {
      _loadedData = data[0]['body']['header'];
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
        child: _loadedData.isEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: _fetchData,
                  child: const Text('Load Data'),
                ),
              )
            // The ListView that displays photos
            :
            // ListView.builder(
            //     itemCount: _loadedData.length,
            //     itemBuilder: (BuildContext ctx, index) {
            //       return Column(children: [
            //         ListTile(
            //           title: Text(_loadedData[index]['Fname']),
            //         ),
            //         ListTile(
            //           title: Text(_loadedData[index]['Lname']),
            //         ),
            //         ListTile(
            //           title: Text(_loadedData[index]['Title']),
            //         ),
            //         ListTile(
            //           title: Text(_loadedData[index]['Ryear']),
            //         ),
            //         ListTile(
            //           title: Text(_loadedData[index]['Description']),
            //         )
            //       ]);
            //     },
            //   )
            Container(
                padding: EdgeInsets.all(20.0),
                child: DataTable(
                    border: TableBorder.all(color: Colors.black),
                    // ignore: prefer_const_literals_to_create_immutables
                    columns: [
                      DataColumn(
                        label: Text(
                          'SDG ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'SDG Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                    rows: [
                      for (var rdata in _loadedData)
                        DataRow(cells: [
                          DataCell(Text(rdata['SDG ID'].toString())),
                          DataCell(Text(rdata['SDG Name'].toString())),
                        ])
                    ]),
              ),
      ),
    );
  }
}

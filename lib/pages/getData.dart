import 'dart:convert';

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
    const apiUrl =
        'https://hclwdc701d.execute-api.ap-south-1.amazonaws.com/Development/fluttertest';

    final response = await http.get(Uri.parse(apiUrl));
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
                              'First Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Last Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Title',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Release Year',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                        rows: [
                          for (var rdata in _loadedData)
                            DataRow(cells: [
                              DataCell(Text(rdata['Fname'].toString())),
                              DataCell(Text(rdata['Lname'].toString())),
                              DataCell(Text((rdata['Title'].toString()))),
                              DataCell(Text((rdata['Ryear'].toString()))),
                              DataCell(Text((rdata['Description'].toString()))),
                            ])
                        ]))));
  }
}

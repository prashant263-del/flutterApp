// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo_app/pages/homepage.dart';
import 'package:http/http.dart' as http;

import '../../widgets/drawer.dart';
import '../../widgets/drawer.dart';
import 'createNewAudit_old.dart';
// test commit

class RecentAudits extends StatefulWidget {
  @override
  _RecentAudits createState() => _RecentAudits();
}

class _RecentAudits extends State<RecentAudits> {
  static const header = 'Recent Audits';
  // commonDialog dialog = new commonDialog();
  List _loadedData = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    const apiUrl =
        'https://hclwdc701d.execute-api.ap-south-1.amazonaws.com/Development/fluttertest';

    final response = await http.get(Uri.parse(apiUrl));
    print(json.decode(response.body));
    final data = json.decode("[" + response.body + "]");
    // print(data[0]['body']['header']);
    setState(() {
      _loadedData = data[0]['body']['header'];
    });
  }

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(255, 211, 211, 211);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(header),
        centerTitle: true,
        // backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: (Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NewAudit()));
                },
                icon: Icon(Icons.add),
                label: Text("Create New Audit"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: DataTable(
                border: TableBorder.all(color: Colors.black),
                // ignore: prefer_const_literals_to_create_immutables
                columns: [
                  DataColumn(
                    label: Text(
                      'First Name',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Last Name',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Title',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Release Year',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
                // rows: [
                //   for (var item in _loadedData)
                //     DataRow(cells: [
                rows: List.generate(_loadedData.length, (index) {
                  final item = _loadedData[index];
                  return DataRow(
                    color: index % 2 == 0
                        ? MaterialStateProperty.resolveWith(getColor)
                        : null,
                    cells: [
                      DataCell(Text(item['Fname'].toString())),
                      DataCell(Text(item['Lname'].toString())),
                      DataCell(Text((item['Title'].toString()))),
                      DataCell(Text((item['Ryear'].toString()))),
                      DataCell(Text((item['Description'].toString()))),
                    ],
                  );
                }),
              ),
            )
          ],
        )),
      ),
    );
  }
}

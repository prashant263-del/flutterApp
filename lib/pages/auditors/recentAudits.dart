// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/pages/homepage.dart';
import 'package:http/http.dart' as http;

import '../../widgets/drawer.dart';
import '../../widgets/drawer.dart';
import 'createNewAudit_1.dart';
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

  // Future<void> _fetchData() async {
  //   const apiUrl =
  //       'https://hclwdc701d.execute-api.ap-south-1.amazonaws.com/Development/fluttertest';

  //   final response = await http.get(Uri.parse(apiUrl));
  //   print(json.decode(response.body));
  //   final data = json.decode("[" + response.body + "]");
  //   // print(data[0]['body']['header']);
  //   setState(() {
  //     _loadedData = data[0]['body']['header'];
  //   });
  // }

  Future<void> _fetchData() async {
    const apiUrl = 'http://127.0.0.1:5000';

    // final response = await http.get(Uri.parse(apiUrl));

    final response = await http.get(
      Uri.parse(apiUrl),
      // Send authorization headers to the backend.
      headers: {
        'paramsfor': '{"opnfor":"100000", "act":"A-01"}',
      },
    );
    // print(jsonDecode(response.body));
    final data = json.decode("[" + response.body + "]");
    // print(data[0]['body']['header']);
    setState(() {
      _loadedData = data[0]['body']['header'];
      // print(_loadedData);
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: DataTable(
                columnSpacing: 16.00,
                // minWidth: 600,
                // border: TableBorder.all(color: Colors.black),
                // ignore: prefer_const_literals_to_create_immutables
                columns: [
                  DataColumn(
                    label: Text("Audit Date"),
                  ),
                  DataColumn(
                    label: Text("Company Name"),
                  ),
                  DataColumn(
                    label: Text("Internal Auditor"),
                  ),
                  DataColumn(
                    label: Text("External Auditor"),
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
                      DataCell(Text(item['Audit Date'].toString())),
                      DataCell(Text(item['Company Name'].toString())),
                      DataCell(Text(item['Internal Auditor'].toString())),
                      DataCell(Text(item['External Auditor'].toString())),
                    ],
                  );
                }),
                // decoration: 3.0,
              ),
            )
          ],
        )),
      ),
    );
  }
}
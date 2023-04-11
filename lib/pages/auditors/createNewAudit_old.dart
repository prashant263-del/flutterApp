import "package:flutter/material.dart";

import "../../widgets/drawer.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class NewAudit extends StatefulWidget {
  const NewAudit({super.key});

  @override
  State<NewAudit> createState() => _NewAuditState();
}

class _NewAuditState extends State<NewAudit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  List _loadedData = [];
  static const header = 'Create New Audit';
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
    print(jsonDecode(response.body));
    final data = json.decode("[" + response.body + "]");
    print(data[0]['body']['header']);
    setState(() {
      _loadedData = data[0]['body']['header'];
      // print(_loadedData);
    });
  }

  List dropDownListData = [
    {"title": "BCA", "value": "1"},
    {"title": "MCA", "value": "2"},
    {"title": "B.Tech", "value": "3"},
    {"title": "M.Tech", "value": "4"},
  ];

  String defaultValue = "";
  String secondDropDown = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("DropDown Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(children: [
          const SizedBox(
            height: 20,
          ),
          InputDecorator(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              contentPadding: const EdgeInsets.all(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  isDense: true,
                  value: defaultValue,
                  isExpanded: true,
                  menuMaxHeight: 350,
                  items: [
                    const DropdownMenuItem(
                        child: Text(
                          "Select Course",
                        ),
                        value: ""),
                    ...dropDownListData.map<DropdownMenuItem<String>>((data) {
                      return DropdownMenuItem(
                          child: Text(data['title']), value: data['value']);
                    }).toList(),
                  ],
                  onChanged: (value) {
                    print("selected Value $value");
                    setState(() {
                      defaultValue = value!;
                    });
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InputDecorator(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              contentPadding: const EdgeInsets.all(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  isDense: true,
                  value: secondDropDown,
                  isExpanded: true,
                  menuMaxHeight: 350,
                  items: [
                    const DropdownMenuItem(
                        child: Text(
                          "Select Course",
                        ),
                        value: ""),
                    ...dropDownListData.map<DropdownMenuItem<String>>((data) {
                      return DropdownMenuItem(
                          child: Text(data['title']), value: data['value']);
                    }).toList(),
                  ],
                  onChanged: (value) {
                    print("selected Value $value");
                    setState(() {
                      secondDropDown = value!;
                    });
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (secondDropDown == "") {
                  print("Please select a course");
                } else {
                  print("user selected course $defaultValue");
                }
              },
              child: const Text("Submit"))
        ],
        
        ),
      ),
    );
  }
}

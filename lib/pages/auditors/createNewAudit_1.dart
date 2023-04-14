import 'package:data_table_2/data_table_2.dart';
import "package:flutter/material.dart";
import 'package:flutter_demo_app/widgets/drawer.dart';

// import "../../widgets/drawer.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../../../constants.dart';
import '../../../../main.dart';
// import '../../../../utils/multiSelectDropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../utils/constants.dart';

class NewAudit extends StatefulWidget {

  @override
  State<NewAudit> createState() => _NewAuditState();
}

class _NewAuditState extends State<NewAudit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  bool _isButtonEnabled = false;
  List<dynamic> _multiSelectedItems = [];
  final _multiSelectKey = GlobalKey<FormFieldState<List<String>>>();

  List<dynamic> _loadedData = [];
  List<dynamic> _loadedIndustryList = [];
  static const header = 'Create New Audit';

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(255, 211, 211, 211);
  }

  Future<void> _fetchData() async {
    const apiUrl = 'http://127.0.0.1:5000';

    // final response = await http.get(Uri.parse(apiUrl));

    final response = await http.get(
      Uri.parse(apiUrl),
      // Send authorization headers to the backend.
      headers: {
        'paramsfor': '{"opnfor":"100000", "act":"A-02"}',
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

  Future<void> getIndustryList(cID) async {
    dynamic companyID = cID;
    const apiUrl = 'http://127.0.0.1:5000';

    // final response = await http.get(Uri.parse(apiUrl));

    final response = await http.get(
      Uri.parse(apiUrl),
      // Send authorization headers to the backend.
      headers: {
        'paramsfor':
            '{"opnfor":"100000", "act":"A-03","companyID":"$companyID"}',
      },
    );
    final data = json.decode("[" + response.body + "]");
    print(data[0]['body']['header']);
    setState(() {
      _loadedIndustryList = data[0]['body']['header'];
      print('industryList $_loadedIndustryList');
    });
  }

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
        title: const Text("Create New Audit"),
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // padding:Padding.EdgeInsets.all(20.00),
              children: [
                DropdownButton<String>(
                    // isDense: true,
                    value: defaultValue,
                    // isExpanded: false,
                    // menuMaxHeight: 50,
                    items: [
                      const DropdownMenuItem(
                          child: Text(
                            "Select Company",
                          ),
                          value: ""),
                      ..._loadedData.map<DropdownMenuItem<String>>((data) {
                        return DropdownMenuItem(
                            child: Text(data['Company Name']),
                            value: data['Company ID']);
                      }).toList(),
                    ],
                    onChanged: (value) {
                      print("selected Value $value");
                      getIndustryList(value);
                      setState(() {
                        defaultValue = value!;
                        secondDropDown = '';
                      });
                    }),
                Row(
                  children: [
                    MultiSelectDialogField(
                      dialogHeight: 180,
                      dialogWidth: 12,
                      key: _multiSelectKey,
                      title: Text('Select Industry'),
                      buttonText: Text('Select Industry'),
                      items: _loadedIndustryList.map((item) {
                        return MultiSelectItem<dynamic>(
                            item['IndustryVerticalID'],
                            item['IndustryVerticalName']);
                      }).toList(),
                      initialValue: _multiSelectedItems,
                      onConfirm: (values) {
                        setState(() {
                          _multiSelectedItems = values!;
                          // _isButtonEnabled = !_isButtonEnabled;
                        });

                        // the list is not null and not empty, do something with it
                        if (_multiSelectedItems != null &&
                            _multiSelectedItems.isNotEmpty) {
                          _isButtonEnabled = !_isButtonEnabled;
                        } else {
                          _isButtonEnabled = !_isButtonEnabled;
                          // the list is null or empty, handle the case
                        }
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    if (secondDropDown == "") {
                      print("Please select a course");
                    } else {
                      print("user selected course $defaultValue");
                    }
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyApp()));
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: _isButtonEnabled
                      ? () {
                          //  onPressed: _isButtonEnabled
                          //       ? () {
                          // Button is enabled, perform action here
                        }
                      : null, // Button is disabled
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

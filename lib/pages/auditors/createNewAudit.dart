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

// import '../../utils/multiSelectDropdown.dart';
// import '../../../../utils/multiselect.dart';
// import '../../../dashboard/dashboard_screen.dart';
// import '../../../homePage.dart';
// import '../../components/side_menu.dart';

class NewAudit extends StatefulWidget {
  // const NewAudit({super.key});l

  @override
  State<NewAudit> createState() => _NewAuditState();
}

class _NewAuditState extends State<NewAudit> {
  int _selectedIndex = -1;
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
    // print(jsonDecode(response.body));
    final data = json.decode("[" + response.body + "]");
    print(data[0]['body']['header']);
    setState(() {
      _loadedIndustryList = data[0]['body']['header'];
      // _loadedIndustryList = data[0]['body']['header'];
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Please select company & SDG'),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: DropdownButton<String>(
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
                        _selectedIndex = -1;
                      });
                    }),
              ),
              Container(
                height: 300,
                width: 250,
                // mainAxisAlignment:MainAxisAlignment.start,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                  // child: ListView.builder(
                  //   itemCount: _loadedIndustryList.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return Padding(
                  //       padding: const EdgeInsets.all(10.0),
                  //       child: Container(
                  //         height: 100,
                  //         width: 200,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey),
                  //           color: Colors.grey[200],
                  //         ),
                  //         child: ListTile(
                  //           title: Text(_loadedIndustryList[index]['SDG Name']),
                  //           trailing: Text('Status: In Progress'),
                  //           subtitle: Text('10% Complete'),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  child: ListView.builder(
                    itemCount: _loadedIndustryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color:
                            _selectedIndex == index ? Colors.green[50] : null,
                        child: ListTile(
                          hoverColor: Colors.green[50],
                          title: Text(_loadedIndustryList[index]['SDG Name']),
                          subtitle: Text('10% Complete'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Status: In Progress'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                          // Icon(Icons.arrow_forward),
                          onTap: () {
                            // Do something when the user taps on the ListTile
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

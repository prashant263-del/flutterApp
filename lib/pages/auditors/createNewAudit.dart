import 'package:data_table_2/data_table_2.dart';
import "package:flutter/material.dart";
import 'package:flutter_demo_app/pages/auditors/recentAudits.dart';
import 'package:flutter_demo_app/widgets/drawer.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../../../constants.dart';
import '../../../../main.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../utils/constants.dart' as constants;

class NewAudit extends StatefulWidget {
  // const NewAudit({super.key});l

  @override
  State<NewAudit> createState() => _NewAuditState();
}

class _NewAuditState extends State<NewAudit> {
  int _selectedIndex = -1;

  int _selectedValue = 1;

  bool _selectedGrp1 = true;
  String grpVal = 'grpValue';
  String uniqGrpID = '';
  int inc = 1;

  int _selectedSDG = 0;

  bool _isIndustry_Selected = false;
  bool _isCompanySelected = false;
  bool _isSDG_Selected = false;
  String _imgPath = "assets/images/{}.png";

  var _selectedSDGName;
  var _selectedSDGID;
  var _selectedSDGWeightage;

  var grpvalue;
  // ignore: prefer_final_fields
  // List<int> _selectedOptions = List.filled(3, 0);

  String defaultValue = "";
  String _slectedCompanyID = "";
  String secondDropDown = "";

  String _selectedIndustryID = "";

  @override
  void initState() {
    super.initState();
    _isCompanySelected = false;
    _isIndustry_Selected = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  bool _isButtonEnabled = false;
  List<dynamic> _multiSelectedItems = [];
  final _multiSelectKey = GlobalKey<FormFieldState<List<String>>>();

  List<dynamic> _loadedData = [];
  List<dynamic> _loadedIndustryList = [];
  List<dynamic> _loadedSDGList = [];
  List<dynamic> _loadedAuditTemplatelist = [];
  List<dynamic> _selectedGrpValue = [];

  static const header = 'Create New Audit';

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(255, 211, 211, 211);
  }

  Future<void> _fetchData() async {
    const apiUrl = 'http://127.0.0.1:5000';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor': '{"opnfor":"100000", "act":"A-02"}',
      },
    );

    final data = json.decode("[" + response.body + "]");

    setState(() {
      _loadedData = data[0]['body']['header'];
    });
  }

// Get IndustryList of the selected Company
  Future<void> getIndustryList(cID) async {
    dynamic companyID = cID;
    const apiUrl = 'http://127.0.0.1:5000';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor':
            '{"opnfor":"100000", "act":"A-03","CompanyID":"$companyID"}',
      },
    );
    final data = await json.decode("[" + response.body + "]");

    setState(() {
      _loadedIndustryList = data[0]['body']['header'];

      if (_loadedIndustryList != null && _loadedIndustryList.isNotEmpty) {
        _isCompanySelected = true;
      } else {}
    });
  }

// Get SDG List for the selected Industry
  Future<void> getSDGListForIndusry(p_IndustryID, p_slectedCompanyID) async {
    dynamic IndustryID = p_IndustryID;
    dynamic CompanyID = p_slectedCompanyID;
    const apiUrl = 'http://127.0.0.1:5000';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor':
            '{"opnfor":"100000", "act":"A-04","CompanyID":"$CompanyID","IndustryID":"$IndustryID"}',
      },
    );
    final data = await json.decode("[" + response.body + "]");
    setState(() {
      _loadedSDGList = data[0]['body']['header'];
      if (_loadedSDGList != null && _loadedSDGList.isNotEmpty) {
        _isIndustry_Selected = true;
      } else {}
    });
  }

  Future<void> getAuditTemplate(
      p_selectedIndustryID, p_slectedCompanyID, p_sdgID) async {
    // dynamic sdgID = p_sdgID;
    // print('sdgID $sdgID');
    String UserID = constants.UserID;
    const apiUrl = 'http://127.0.0.1:5000';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor':
            '{"opnfor":"100000", "act":"A-06","IndustryID":"$p_selectedIndustryID","CompanyID":"$p_slectedCompanyID","sdgID":"$p_sdgID", "UserID":"$UserID"}',
      },
    );
    final data = await json.decode("[" + response.body + "]");
    setState(() {
      _loadedAuditTemplatelist = data[0]['body']['lineitems'];
      if (_loadedAuditTemplatelist != null &&
          _loadedAuditTemplatelist.isNotEmpty) {
        _isSDG_Selected = true;
        for (int i = 0; i < _loadedAuditTemplatelist.length; i++) {
          _selectedGrpValue.add({"id": i, "grpValue": ""});
        }
      } else {}
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    int selectedGrpVal;
    int qNo = 1;
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create New Audit"),
        backgroundColor: Colors.blue,
        //  appBarColor,
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text(
                    //   // 'Please select company & SDG',
                    //   style: TextStyle(fontSize: 15),
                    // ),
                    SizedBox(
                      width: 250,
                      child: DropdownButton<String>(
                          value: defaultValue,
                          items: [
                            const DropdownMenuItem(
                                child: Text(
                                  "Select Company",
                                ),
                                value: ""),
                            ..._loadedData
                                .map<DropdownMenuItem<String>>((data) {
                              return DropdownMenuItem(
                                  child: Text(data['Company Name']),
                                  value: data['Company ID']);
                            }).toList(),
                          ],
                          onChanged: (value) {
                            getIndustryList(value);
                            setState(() {
                              defaultValue = value!;
                              _slectedCompanyID = defaultValue;
                              _selectedIndustryID = '';
                              // secondDropDown = '';
                              _selectedIndex = -1;
                            });
                          }),
                    ),

                    // Dropdown for Industries
                    _isCompanySelected
                        ? SizedBox(
                            width: 250,
                            child: DropdownButton<String>(
                                value: _selectedIndustryID,
                                items: [
                                  const DropdownMenuItem(
                                      child: Text(
                                        "Select Industry",
                                      ),
                                      value: ""),
                                  ..._loadedIndustryList
                                      .map<DropdownMenuItem<String>>((data) {
                                    return DropdownMenuItem(
                                        child:
                                            Text(data['IndustryVerticalName']),
                                        value: data['IndustryVerticalID']);
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  // getIndustryList(value);
                                  setState(() {
                                    _selectedIndustryID = value!;
                                    // secondDropDown = value!;
                                    // secondDropDown = '';
                                    _selectedIndex = -1;
                                  });
                                  getSDGListForIndusry(
                                      _selectedIndustryID, _slectedCompanyID);
                                }),
                          )
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                    // cards for the SDGs of selected Industry

                    Container(
                      height: 550,
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                        child: ListView.builder(
                          itemCount: _loadedSDGList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 130,
                              width: 150,
                              child: Card(
                                elevation: 8,
                                color: _selectedIndex == index
                                    ? Colors.green[50]
                                    : null,
                                child: ListTile(
                                  hoverColor: Colors.green[50],
                                  // leading: Image.asset(
                                  //     "assets/images/$_loadedIndustryList[index]['SDG ID'].png"),
                                  title:
                                      Text(_loadedSDGList[index]['SDG Name']),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('10% Complete'),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Score: '),
                                            ],
                                          ),
                                        ),
                                        // SizedBox(width: 16),
                                        // SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  // Text('10% Complete'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Status: In Progress'),
                                      SizedBox(width: 5),
                                      // Icon(Icons.arrow_forward),
                                    ],
                                  ),
                                  // Icon(Icons.arrow_forward),
                                  onTap: () {
                                    // Do something when the user taps on the ListTile
                                    setState(() {
                                      _selectedSDG =
                                          _loadedSDGList[index]['SDG ID'];
                                      _selectedIndex = index;
                                      _selectedSDGID =
                                          _loadedSDGList[index]['SDG ID'];
                                      _selectedSDGName =
                                          _loadedSDGList[index]['SDG Name'];
                                      _selectedSDGWeightage =
                                          _loadedSDGList[index]
                                              ['weightage_slab'];
                                      getAuditTemplate(_selectedIndustryID,
                                          _slectedCompanyID, _selectedSDG);
                                    });
                                  },
                                ),
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
          ),

          // get questionaire for the selected SDG
          SizedBox(
            width: 1160,
            height: 690,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: _isSDG_Selected
                  // ? getTemplateForSDG(context)
                  ? Container(
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 1150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // colors: [Colors.purple, Colors.pink],
                                colors: [Colors.black, Colors.black87],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'SDG: $_selectedSDGID       Name: $_selectedSDGName       Weightage: $_selectedSDGWeightage',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 550,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  // height: 400,
                                  child: Column(
                                    children: [
                                      for (int x = 0;
                                          // x < 5;
                                          x < _loadedAuditTemplatelist.length;
                                          x++) ...[
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // qNo = x+qNo,
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            child: getQno(x),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        child: Text(
                                                            _loadedAuditTemplatelist[
                                                                    x]
                                                                ['Questions']),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Expanded(
                                                //   flex: 3, // 20%
                                                //   child: Container(
                                                //     child: Text(
                                                //         _loadedAuditTemplatelist[x]
                                                //             ['ans_type_id']),
                                                //   ),
                                                // ),

                                                if ((_loadedAuditTemplatelist[x]
                                                        ['ans_type_id']) ==
                                                    '1') ...[
                                                  // ansType1(),
                                                  ListTile(
                                                    title: const Text('Yes'),
                                                    leading: Radio(
                                                      value: '1',
                                                      groupValue:
                                                          _selectedGrpValue[x]
                                                              ['grpValue'],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedGrpValue[x]
                                                                  ['grpValue'] =
                                                              value.toString();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: const Text('No'),
                                                    leading: Radio(
                                                      value: '0',
                                                      groupValue:
                                                          _selectedGrpValue[x]
                                                              ['grpValue'],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedGrpValue[x]
                                                                  ['grpValue'] =
                                                              value.toString();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          // width: 300,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Enter comment here',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ] else if ((_loadedAuditTemplatelist[
                                                        x]['ans_type_id']) ==
                                                    '2') ...[
                                                  for (int y = 0;
                                                      y <
                                                          (_loadedAuditTemplatelist[
                                                                  x]['Answer']
                                                              .length);
                                                      y++) ...[
                                                    Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                              _loadedAuditTemplatelist[
                                                                          x]
                                                                      ['Answer']
                                                                  [
                                                                  y]['Option']),
                                                          leading: Radio(
                                                            value: y.toString(),
                                                            groupValue:
                                                                _selectedGrpValue[
                                                                        x][
                                                                    'grpValue'],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedGrpValue[
                                                                            x][
                                                                        'grpValue'] =
                                                                    value
                                                                        .toString();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      // width: 300,
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter comment here',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                                //else if ((_loadedAuditTemplatelist[
                                                //         x]['ans_type_id']) ==
                                                //     '3') ...[
                                                //   // ansType1(),
                                                //   Radio(
                                                //     value: '0',
                                                //     groupValue:
                                                //         _selectedGrpValue[x]
                                                //             ['grpValue'],
                                                //     onChanged: (value) {
                                                //       setState(() {
                                                //         _selectedGrpValue[x]
                                                //                 ['grpValue'] =
                                                //             value.toString();
                                                //       });
                                                //     },
                                                //   ),
                                                //   Text('YES'),
                                                //   Radio(
                                                //     value: '1',
                                                //     groupValue:
                                                //         _selectedGrpValue[x]
                                                //             ['grpValue'],
                                                //     onChanged: (value) {
                                                //       setState(() {
                                                //         _selectedGrpValue[x]
                                                //                 ['grpValue'] =
                                                //             value.toString();
                                                //       });
                                                //     },
                                                //   ),
                                                //   Text('NO'),
                                                // ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 210,
                          // ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(width: 1, color: Colors.black),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(80, 5, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RecentAudits()));
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {},
                                      child: const Text("Submit"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    )
                  : Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Please Select Company & SDG for Audit Questionire!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          )
          // End of Questionaire
        ],
      ),
    );
  }

  ansType1() {
    int? _selectedValue = 1;

    Column(
      children: [
        Radio(
          value: 1,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
        ),
        Radio(
          value: 2,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
        ),
      ],
    );
  }

  getQno(int x) {
    x = x + 1;
    return Text('Que: $x');
  }

  // Column getTemplateForSDG(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Text('CSR Questions for: $_selectedSDGName'),
  //       SizedBox(
  //         height: 100,
  //         width: 200,
  //         child: SingleChildScrollView(
  //           child: ListView.builder(
  //             itemCount: _loadedAuditTemplatelist.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ListTile(
  //                 title: Text(_loadedAuditTemplatelist[index]['Questions']),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
  //         onPressed: () {
  //           Navigator.pop(context);
  //           Navigator.of(context).push(
  //               MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  //         },
  //         child: const Text("Cancel"),
  //       ),
  //     ],
  //   );
  // }

  // Widget showAuditQues() {
  //   return Row(
  //     children: [
  //       Text('test'),
  //     ],
  //   );
  // }
}

addGrpVal(int x) {
  int grpValue = x;
  return grpValue;
}

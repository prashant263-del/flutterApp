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
import 'package:flutter_demo_app/utils/common.dart';

import '../../utils/constants.dart' as constants;

class NewAudit extends StatefulWidget {
  // const NewAudit({super.key});l

  @override
  State<NewAudit> createState() => _NewAuditState();
}

class _NewAuditState extends State<NewAudit> {
  String payload = "";
  commonFunctions cFun = new commonFunctions();

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
  List<dynamic> _selectedGrpValue = []; // Internal
  List<dynamic> _selectedGrpValueExt = []; // External
  List<dynamic> _checkedItem = []; // Internal
  List<dynamic> _checkedItemExt = []; // External
  List<dynamic> _selectedCheckBoxValues = [];

  dynamic _selectedAuditID;

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
      _selectedGrpValue = [];
      _selectedGrpValueExt = [];
      // _checkedItem = [];
      _loadedAuditTemplatelist = data[0]['body']['lineitems'];
      _selectedAuditID = data[0]['body']['header'];
      if (_loadedAuditTemplatelist != null &&
          _loadedAuditTemplatelist.isNotEmpty) {
        _isSDG_Selected = true;
        for (int i = 0; i < _loadedAuditTemplatelist.length; i++) {
          _selectedGrpValue.add({
            "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
            "grpValue": ""
          });
          _selectedGrpValueExt.add({
            "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
            "grpValue": ""
          });

          if (_loadedAuditTemplatelist[i]['ans_type_id'] == "3" &&
              _loadedAuditTemplatelist[i]['InternalSelectedAns'] == "-") {
            _checkedItem.add({
              "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
              "checkedValues": []
            });
          } else if (_loadedAuditTemplatelist[i]['ans_type_id'] == "3" &&
              _loadedAuditTemplatelist[i]['InternalSelectedAns'] != "-") {
            _checkedItem.add({
              "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
              "checkedValues": [
                _loadedAuditTemplatelist[i]["InternalSelectedAns"]
              ]
            });
          }
          // external multi select:
          if (_loadedAuditTemplatelist[i]['ans_type_id'] == "3" &&
              _loadedAuditTemplatelist[i]['ExternalSelectedAns'] == "-") {
            _checkedItemExt.add({
              "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
              "checkedValues": []
            });
          } else if (_loadedAuditTemplatelist[i]['ans_type_id'] == "3" &&
              _loadedAuditTemplatelist[i]['ExternalSelectedAns'] != "-") {
            _checkedItemExt.add({
              "id": _loadedAuditTemplatelist[i]["AuditTemplateID"],
              "checkedValues": [
                _loadedAuditTemplatelist[i]["ExternalSelectedAns"]
              ]
            });
          }
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
                                              Text('100')
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
                                      Text('In Progress'),
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
                                      // _selectedGrpValue = [];
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
                                colors: [Colors.blue, Colors.purple],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '         SDG: $_selectedSDGID                                       $_selectedSDGName                                        Weightage: $_selectedSDGWeightage',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 1150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // colors: [Colors.purple, Colors.pink],
                                colors: [Colors.blue, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '             Que                                                                                                                  Internal Audit                                                                                 External Audit',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            child: getQno(x),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 310,
                                                        child: Text(
                                                            _loadedAuditTemplatelist[
                                                                    x]
                                                                ['Questions']),
                                                      ),
                                                      //   ],
                                                      // ),
                                                      if ((_loadedAuditTemplatelist[
                                                                  x][
                                                              'ans_type_id']) ==
                                                          '1') ...[
                                                        // ansType1(),
                                                        internalAnsType_01(x),
                                                        externalAnsType_01(x),
                                                      ]
                                                      // answer type 2
                                                      else if ((_loadedAuditTemplatelist[
                                                                  x][
                                                              'ans_type_id']) ==
                                                          '2') ...[
                                                        internalAnsType_02(x),
                                                        externalAnsType_02(x)
                                                      ] else if ((_loadedAuditTemplatelist[
                                                                      x][
                                                                  'ans_type_id']) ==
                                                              '3' &&
                                                          (_loadedAuditTemplatelist[
                                                                      x][
                                                                  'InternalExternal']) ==
                                                              '-') ...[
                                                        internalAnsType_03(x),

                                                        // external
                                                        externalAnsType_03(x),
                                                        // end of external auditor
                                                      ] // if else condition
                                                    ]),
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

  Padding externalAnsType_03(int x) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 2))),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 300,
              child: ListView.builder(
                itemCount: _loadedAuditTemplatelist[x]['Answer'].length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    // title: Text(
                    //     _loadedAuditTemplatelist[x]['Answer'][index]['Option']),
                    // value: _checkedItemExt[x]['checkedValues'].contains(
                    //     _loadedAuditTemplatelist[x]['Answer'][index]
                    //         ['ansID']), // _selectedOption:20, value: true
                    title: Text(
                        _loadedAuditTemplatelist[x]['Answer'][index]['Option']),
                    value: _loadedAuditTemplatelist[x]['ExternalSelectedAns'] ==
                            '-'
                        ? _checkedItemExt[x]['checkedValues'].contains(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                ['ansID'])
                        : checkForCheckedValues(
                            _loadedAuditTemplatelist[x]['ExternalSelectedAns'],
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                ['ansID'],
                          ),
                    onChanged: (value) {
                      setState(() {
                        if (_checkedItemExt[x]['checkedValues'].contains(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                ['ansID'])) {
                          _checkedItemExt[x]['checkedValues'].remove(
                              _loadedAuditTemplatelist[x]['Answer'][index]
                                      ['ansID']
                                  .toString());
                        } else {
                          _checkedItemExt[x]['checkedValues'].add(
                              _loadedAuditTemplatelist[x]['Answer'][index]
                                      ['ansID']
                                  .toString());
                        }
                      });

                      payload =
                          // ignore: prefer_interpolation_to_compose_strings
                          '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                              _selectedAuditID[0]['AuditID'] +
                              '","QueNo":"' +
                              _selectedGrpValue[x]['id'].toString() +
                              '", "AnsSelected":"' +
                              _checkedItemExt[x]['checkedValues'].toString() +
                              '", "AnsType":"3","AnsFor":"Ext"}';
                      cFun.callAPI(payload).then((data) {
                        setState(() {
                          getAuditTemplate(_selectedIndustryID,
                              _slectedCompanyID, _selectedSDG);
                        });
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // puts checkbox before the text
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter comment here',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container internalAnsType_03(int x) {
    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 2))),
      child: Column(
        children: [
          Container(
            height: 200,
            width: 300,
            child: ListView.builder(
              itemCount: _loadedAuditTemplatelist[x]['Answer'].length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                      _loadedAuditTemplatelist[x]['Answer'][index]['Option']),
                  value: _loadedAuditTemplatelist[x]['InternalSelectedAns'] ==
                          '-'
                      ? _checkedItem[x]['checkedValues'].contains(
                          _loadedAuditTemplatelist[x]['Answer'][index]['ansID'])
                      : checkForCheckedValues(
                          _loadedAuditTemplatelist[x]['InternalSelectedAns'],
                          _loadedAuditTemplatelist[x]['Answer'][index]['ansID'],
                        ),
                  onChanged: (value) {
                    setState(() {
                      if (_checkedItem[x]['checkedValues'].contains(
                          _loadedAuditTemplatelist[x]['Answer'][index]
                              ['ansID'])) {
                        _checkedItem[x]['checkedValues'].remove(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                    ['ansID']
                                .toString());
                      } else {
                        _checkedItem[x]['checkedValues'].add(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                    ['ansID']
                                .toString());
                      }
                    });

                    payload = '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                        _selectedAuditID[0]['AuditID'] +
                        '","QueNo":"' +
                        _selectedGrpValue[x]['id'].toString() +
                        '", "AnsSelected":"' +
                        _checkedItem[x]['checkedValues'].toString() +
                        '", "AnsType":"3","AnsFor":"Int"}';
                    cFun.callAPI(payload).then((data) {
                      setState(() {
                        getAuditTemplate(_selectedIndustryID, _slectedCompanyID,
                            _selectedSDG);
                      });
                    });
                  },
                  controlAffinity: ListTileControlAffinity
                      .leading, // puts checkbox before the text
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter comment here',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container internalAnsType_02(int x) {
    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 2))),
      child: Column(
        children: [
          for (int y = 0;
              y < (_loadedAuditTemplatelist[x]['Answer'].length);
              y++) ...[
            Container(
              width: 300,
              child: ListTile(
                title: Text(_loadedAuditTemplatelist[x]['Answer'][y]['Option']),
                leading: Radio(
                  value: _loadedAuditTemplatelist[x]['Answer'][y]['ansID'],
                  groupValue: _loadedAuditTemplatelist[x]
                              ['InternalSelectedAns'] ==
                          '-'
                      ? _selectedGrpValue[x]['grpValue']
                      : _selectedGrpValue[x]['grpValue'] =
                          _loadedAuditTemplatelist[x]['InternalSelectedAns'],
                  onChanged: (value) {
                    setState(() {
                      _selectedGrpValue[x]['grpValue'] = value.toString();
                    });
                    payload = '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                        _selectedAuditID[0]['AuditID'] +
                        '","QueNo":"' +
                        _selectedGrpValue[x]['id'].toString() +
                        '", "AnsSelected":"' +
                        _selectedGrpValue[x]['grpValue'].toString() +
                        '", "AnsType":"2","AnsFor":"Int"}';
                    cFun.callAPI(payload).then((data) {
                      setState(() {
                        getAuditTemplate(_selectedIndustryID, _slectedCompanyID,
                            _selectedSDG);
                      });
                    });
                  },
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter comment here',
                ),
              ),
            ),
          )
        ], // children
      ),
    );
  }

  Padding externalAnsType_02(int x) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 2))),
        child: Column(
          children: [
            for (int y = 0;
                y < (_loadedAuditTemplatelist[x]['Answer'].length);
                y++) ...[
              Container(
                width: 300,
                child: ListTile(
                  title:
                      Text(_loadedAuditTemplatelist[x]['Answer'][y]['Option']),
                  leading: Radio(
                    value: _loadedAuditTemplatelist[x]['Answer'][y]['ansID'],
                    groupValue: _loadedAuditTemplatelist[x]
                                ['ExternalSelectedAns'] ==
                            '-'
                        ? _selectedGrpValueExt[x]['grpValue']
                        : _selectedGrpValueExt[x]['grpValue'] =
                            _loadedAuditTemplatelist[x]['ExternalSelectedAns'],
                    onChanged: (value) {
                      setState(() {
                        _selectedGrpValueExt[x]['grpValue'] = value.toString();
                      });
                      payload =
                          '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                              _selectedAuditID[0]['AuditID'] +
                              '","QueNo":"' +
                              _selectedGrpValueExt[x]['id'].toString() +
                              '", "AnsSelected":"' +
                              _selectedGrpValueExt[x]['grpValue'].toString() +
                              '", "AnsType":"2","AnsFor":"Ext"}';
                      cFun.callAPI(payload).then((data) {
                        setState(() {
                          getAuditTemplate(_selectedIndustryID,
                              _slectedCompanyID, _selectedSDG);
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter comment here',
                  ),
                ),
              ),
            )
          ], // children
        ),
      ),
    );
  }

  Container internalAnsType_01(int x) {
    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 2))),
      width: 300,
      child: Column(
        children: [
          ListTile(
            title: const Text('Yes'),
            leading: Radio(
              value: '1',
              groupValue:
                  _loadedAuditTemplatelist[x]['InternalSelectedAns'] == '-'
                      ? _selectedGrpValue[x]['grpValue']
                      : _selectedGrpValue[x]['grpValue'] =
                          _loadedAuditTemplatelist[x]['InternalSelectedAns'],
              onChanged: (value) {
                setState(() {
                  _selectedGrpValue[x]['grpValue'] = value.toString();
                });
                payload =
                    // '{"opnfor":"100000", "act":"A-7", "" }';
                    '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                        _selectedAuditID[0]['AuditID'] +
                        '","QueNo":"' +
                        _selectedGrpValue[x]['id'].toString() +
                        '", "AnsSelected":"' +
                        _selectedGrpValue[x]['grpValue'].toString() +
                        '", "AnsType":"1","AnsFor":"Int"}';
                print(payload);
                cFun.callAPI(payload).then((data) {
                  setState(() {
                    getAuditTemplate(
                        _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                    // _loadedData =
                    //     data[
                    //         'header'];
                    print('call success');
                  });
                });
              },
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio(
              value: '0',
              groupValue:
                  _loadedAuditTemplatelist[x]['InternalSelectedAns'] == '-'
                      ? _selectedGrpValue[x]['grpValue']
                      : _selectedGrpValue[x]['grpValue'] =
                          _loadedAuditTemplatelist[x]['InternalSelectedAns'],
              // _selectedGrpValue[x]
              //     ['grpValue'],
              onChanged: (value) {
                setState(() {
                  _selectedGrpValue[x]['grpValue'] = value.toString();
                });

                payload =
                    // '{"opnfor":"100000", "act":"A-7", "" }';
                    '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                        _selectedAuditID[0]['AuditID'] +
                        '","QueNo":"' +
                        _selectedGrpValue[x]['id'].toString() +
                        '", "AnsSelected":"' +
                        _selectedGrpValue[x]['grpValue'].toString() +
                        '", "AnsType":"1","AnsFor":"Int"}';
                print(payload);
                cFun.callAPI(payload).then((data) {
                  setState(() {
                    getAuditTemplate(
                        _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                  });
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter comment here',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding externalAnsType_01(int x) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 2))),
        width: 300,
        child: Column(
          children: [
            ListTile(
              title: const Text('Yes'),
              leading: Radio(
                value: '1',
                groupValue:
                    _loadedAuditTemplatelist[x]['ExternalSelectedAns'] == '-'
                        ? _selectedGrpValueExt[x]['grpValue']
                        : _selectedGrpValueExt[x]['grpValue'] =
                            _loadedAuditTemplatelist[x]['ExternalSelectedAns'],
                onChanged: (value) {
                  setState(() {
                    _selectedGrpValueExt[x]['grpValue'] = value.toString();
                  });
                  payload =
                      // ignore: prefer_interpolation_to_compose_strings
                      '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                          _selectedAuditID[0]['AuditID'] +
                          '","QueNo":"' +
                          _selectedGrpValueExt[x]['id'].toString() +
                          '", "AnsSelected":"' +
                          _selectedGrpValueExt[x]['grpValue'].toString() +
                          '", "AnsType":"1","AnsFor":"Ext"}';
                  cFun.callAPI(payload).then((data) {
                    setState(() {
                      getAuditTemplate(
                          _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                    });
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio(
                value: '0',
                groupValue:
                    _loadedAuditTemplatelist[x]['ExternalSelectedAns'] == '-'
                        ? _selectedGrpValueExt[x]['grpValue']
                        : _selectedGrpValueExt[x]['grpValue'] =
                            _loadedAuditTemplatelist[x]['ExternalSelectedAns'],
                // _selectedGrpValue[x]
                //     ['grpValue'],
                onChanged: (value) {
                  setState(() {
                    _selectedGrpValueExt[x]['grpValue'] = value.toString();
                  });

                  payload = '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                      _selectedAuditID[0]['AuditID'] +
                      '","QueNo":"' +
                      _selectedGrpValueExt[x]['id'].toString() +
                      '", "AnsSelected":"' +
                      _selectedGrpValueExt[x]['grpValue'].toString() +
                      '", "AnsType":"1","AnsFor":"Ext"}';
                  print(payload);
                  cFun.callAPI(payload).then((data) {
                    setState(() {
                      getAuditTemplate(
                          _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter comment here',
                  ),
                ),
              ),
            ),
          ],
        ),
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

  checkForCheckedValues(selectedAns, ansFromList) {
    // selected from DB
    print(selectedAns);
    if (selectedAns.contains(ansFromList)) {
      return true;
    } else {
      return false;
    }
    // return true;
  }
}

addGrpVal(int x) {
  int grpValue = x;
  return grpValue;
}

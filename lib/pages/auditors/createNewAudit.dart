// ignore_for_file: prefer_interpolation_to_compose_strings

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
  const NewAudit({super.key, required this.userID});
  final String userID;

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
  bool _buttonDisabled = true;
  String _imgPath = "assets/images/{}.png";

  var _selectedSDGName;
  var _selectedSDGID;
  var _selectedSDGWeightage;

  var grpvalue;

  String defaultValue = "";
  String _slectedCompanyID = "";
  String secondDropDown = "";

  String _selectedIndustryID = "";

  @override
  void initState() {
    super.initState();

    _isCompanySelected = false;
    _isIndustry_Selected = false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchData(widget.userID));
  }

  bool _isButtonEnabled = false;
  List<dynamic> _multiSelectedItems = [];
  final _multiSelectKey = GlobalKey<FormFieldState<List<String>>>();

  List<dynamic> _loadedData = [];
  List<dynamic> _loadedCompanyList = [];
  List<dynamic> _loadedSDGList = [];
  List<dynamic> _loadedAuditTemplatelist = [];
  List<dynamic> _selectedGrpValue = []; // Internal
  List<dynamic> _selectedGrpValueExt = []; // External
  List<dynamic> _checkedItem = []; // Internal
  List<dynamic> _checkedItemExt = []; // External
  List<dynamic> _selectedCheckBoxValues = [];

  dynamic _selectedAuditID;
  dynamic _internalScore;
  dynamic _externalScore;

  static const header = 'Create New Audit';

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(255, 211, 211, 211);
  }

  // Future<void> _fetchData() async {
  //   const apiUrl = 'http://127.0.0.1:5000';

  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'paramsfor': '{"opnfor":"100000", "act":"A-02"}',
  //     },
  //   );

  //   final data = json.decode("[" + response.body + "]");

  //   setState(() {
  //     _loadedData = data[0]['body']['header'];
  //   });
  // }

  _fetchData(userID) {
    setState(() {});
    payload = '{"opnfor":"100000", "act":"A-02", "userID": "' + userID + '"}';
    cFun.callAPI(payload).then((data) {
      setState(() {
        _loadedData = data['header'];
      });
    });
  }

  getCompanyList(industryID) {
    payload = '{"opnfor":"100000", "act":"A-03","industryID":"$industryID"}';
    cFun.callAPI(payload).then((data) {
      setState(() {
        _loadedCompanyList = data['header'];
        if (_loadedCompanyList != null && _loadedCompanyList.isNotEmpty) {
          // _isCompanySelected = true;
          _isIndustry_Selected = true;
        } else {}
      });
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
        _isCompanySelected = true;
      } else {}
    });
  }

  Future<void> getAuditTemplate(
      p_selectedIndustryID, p_slectedCompanyID, p_sdgID) async {
    String UserID = constants.UserID;
    const apiUrl = 'http://127.0.0.1:5000';
    payload =
        '{"opnfor":"100000", "act":"A-06","IndustryID":"$p_selectedIndustryID","CompanyID":"$p_slectedCompanyID","sdgID":"$p_sdgID", "UserID":"$UserID"}';
    print(payload);
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor':
            '{"opnfor":"100000", "act":"A-06","IndustryID":"$p_selectedIndustryID","CompanyID":"$p_slectedCompanyID","sdgID":"$p_sdgID", "UserID":"$UserID"}',
      },
    );
    final data = await json.decode("[" + response.body + "]");
    // _checkedItem = [];
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
                _loadedAuditTemplatelist[i]["ExternalSelectedAns"].toString()
              ]
            });
          }
        }
      } else {}
    });
  }

  getScore(_p_audit_id, _p_sdg_id) {
    setState(() {});
    payload = '{"opnfor":"100000", "act":"A-08", "AuditID":"' +
        _p_audit_id +
        '","SdgID":"' +
        _p_sdg_id +
        '"}';
    cFun.callAPI(payload).then((data) {
      setState(() {
        getAuditTemplate(_selectedIndustryID, _slectedCompanyID, _selectedSDG);
      });
    });
  }

  void lockTheSdg(selectedAuditID, selectedSDG) {
    setState(() {});
    payload = '{"opnfor":"100000", "act":"A-08", "audit_id":"' +
        selectedAuditID +
        '","sdg_id":"' +
        selectedSDG +
        '"}';
    cFun.callAPI(payload).then((data) {
      setState(() {
        print('updates successfultty');
      });
    });
  }

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
        actions: <Widget>[
          cFun.getProfileMenu(context),
        ],
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(10),
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
                                  "Select Industry",
                                ),
                                value: ""),
                            ..._loadedData
                                .map<DropdownMenuItem<String>>((data) {
                              return DropdownMenuItem(
                                  child: Text(data['IndustryVerticalName']),
                                  value: data['IndustryVerticalID']);
                            }).toList(),
                          ],
                          onChanged: (value) {
                            getCompanyList(value);
                            // getIndustryList(value);
                            setState(() {
                              defaultValue = value!;
                              // _slectedCompanyID = defaultValue;
                              _selectedIndustryID = defaultValue;
                              // _selectedIndustryID = '';
                              _slectedCompanyID = '';
                              _selectedIndex = -1;
                              _isIndustry_Selected = false;
                              _isCompanySelected = false;
                              _isSDG_Selected = false;
                            });
                          }),
                    ),

                    // Dropdown for Industries
                    // _isCompanySelected
                    _isIndustry_Selected
                        ? SizedBox(
                            width: 250,
                            child: DropdownButton<String>(
                                value: _slectedCompanyID,
                                items: [
                                  const DropdownMenuItem(
                                      child: Text(
                                        "Select Company",
                                      ),
                                      value: ""),
                                  ..._loadedCompanyList
                                      .map<DropdownMenuItem<String>>((data) {
                                    return DropdownMenuItem(
                                        child: Text(data['CompanyName']),
                                        value: data['CompanyID']);
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _slectedCompanyID = value!;
                                    _selectedIndex = -1;
                                    _isCompanySelected = false;
                                    _isSDG_Selected = false;
                                    // if (_slectedCompanyID == '') {
                                    //   _isCompanySelected = false;
                                    // }
                                    // else {
                                    //   _isCompanySelected = true;
                                    // }
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

                    _isCompanySelected
                        ? (_loadedSDGList != null && _loadedSDGList.isNotEmpty)
                            ? Container(
                                height: 550,
                                width: 350,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 2, 10),
                                  child: ListView.builder(
                                    itemCount: _loadedSDGList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Card(
                                          elevation: 8,
                                          color: _selectedIndex == index
                                              ? Colors.blue[50]
                                              : null,
                                          child: ListTile(
                                            hoverColor: Colors.grey[100],
                                            // leading: Image.asset(
                                            //     "assets/images/$_loadedCompanyList[index]['SDG ID'].png"),
                                            title: SizedBox(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        // Text(
                                                        //   'SDG ',
                                                        //   style: cFun
                                                        //       .getStyleForSDGLabel(),
                                                        // ),
                                                        if (_loadedSDGList[
                                                                    index]
                                                                ['SDG ID'] <
                                                            10) ...[
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "SDG 0${_loadedSDGList[index]['SDG ID'].toString()} ",
                                                                style: cFun
                                                                    .getStyleForSDGLabel(),
                                                              ),
                                                              getSDG_Name(
                                                                  index),
                                                            ],
                                                          ),
                                                        ] else ...[
                                                          Text(
                                                            _loadedSDGList[
                                                                        index]
                                                                    ['SDG ID']
                                                                .toString(),
                                                            style: cFun
                                                                .getStyleForSDGLabel(),
                                                          ),
                                                        ],
                                                        // Text(
                                                        //   ':  ',
                                                        //   style: cFun
                                                        //       .getStyleForSDGLabel(),
                                                        // ),
                                                        // getSDG_Name(index),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 20, 0, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Column(children: [
                                                          Text('Score:',
                                                              style: cFun
                                                                  .getStyleForScore())
                                                        ]),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                  'Internal:'),
                                                              Text(
                                                                  _loadedSDGList[
                                                                          index]
                                                                      [
                                                                      'internal_score'],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20.0)),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                      'External:'),
                                                                  Text(
                                                                      _loadedSDGList[
                                                                              index]
                                                                          [
                                                                          'external_score'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20.0)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Text('10% Complete'),
                                            trailing: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'In Progress',
                                                  style: TextStyle(
                                                      color: Colors.amber,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(width: 5),
                                                // Icon(Icons.arrow_forward),
                                              ],
                                            ),
                                            // Icon(Icons.arrow_forward),
                                            onTap: () {
                                              // Do something when the user taps on the ListTile
                                              setState(() {
                                                _selectedSDG =
                                                    _loadedSDGList[index]
                                                        ['SDG ID'];
                                                _selectedIndex = index;
                                                _selectedSDGID =
                                                    _loadedSDGList[index]
                                                        ['SDG ID'];
                                                _selectedSDGName =
                                                    _loadedSDGList[index]
                                                        ['SDG Name'];
                                                _selectedSDGWeightage =
                                                    _loadedSDGList[index]
                                                        ['weightage_slab'];
                                                getAuditTemplate(
                                                    _selectedIndustryID,
                                                    _slectedCompanyID,
                                                    _selectedSDG);
                                                // _selectedGrpValue = [];
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Text('SDG not available')
                        : Text('')
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
                // borderRadius: BorderRadius.circular(10),
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
                            color: Colors.black,
                            width: 1150,
                            // decoration: BoxDecoration(

                            //     // gradient: LinearGradient(
                            //     //   // colors: [Colors.purple, Colors.pink],
                            //     //   colors: [Colors.blue, Colors.purple],
                            //     // ),
                            //     // borderRadius: BorderRadius.circular(12),
                            //     ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    if (_selectedSDGID < 10) ...[
                                      Text(
                                        "   SDG 0$_selectedSDGID : $_selectedSDGName",
                                        textAlign: TextAlign.start,
                                        style: cFun.getStyleForQueHead(),
                                      ),
                                    ] else ...[
                                      Text(
                                        '   SDG $_selectedSDGID : $_selectedSDGName',
                                        textAlign: TextAlign.start,
                                        style: cFun.getStyleForQueHead(),
                                      ),
                                    ],
                                    // Text(
                                    //   '   SDG $_selectedSDGID : $_selectedSDGName',
                                    //   textAlign: TextAlign.start,
                                    //   style: TextStyle(
                                    //       fontSize: 24,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.white),
                                    // ),
                                    SizedBox(
                                      width: 500,
                                    ),
                                    Text(
                                      ' Weightage: $_selectedSDGWeightage',
                                      textAlign: TextAlign.end,
                                      style: cFun.getStyleForQueHead(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: 100,
                                      ),
                                    ),
                                    Text(
                                      ' Year: 2023',
                                      textAlign: TextAlign.end,
                                      style: cFun.getStyleForQueHead(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                        color: Colors.grey,
                                      ),
                                      width: 1150,
                                      child: Row(
                                        children: [
                                          const Text(
                                            '            Audit Question                                                                                        Internal Audit                                                                                     External Audit',
                                            textAlign: TextAlign.start,
                                          ),
                                          // const Text(
                                          //   '            Audit Question                                                                                                                  Internal Audit                                                                                 External Audit',
                                          //   textAlign: TextAlign.start,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          (_loadedAuditTemplatelist != null ||
                                  _loadedAuditTemplatelist.isNotEmpty)
                              ? Container(
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
                                                x <
                                                    _loadedAuditTemplatelist
                                                        .length;
                                                x++) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5,
                                                    ),
                                                    // borderRadius: BorderRadius.all(
                                                    //   Radius.circular(5.0),
                                                    // ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: getQno(x),
                                                              // Padding(
                                                              //   padding:
                                                              //       const EdgeInsets
                                                              //               .fromLTRB(
                                                              //           0, 0, 0, 100),
                                                              //   child: Column(
                                                              //     mainAxisAlignment:
                                                              //         MainAxisAlignment
                                                              //             .start,
                                                              //     children: [
                                                              //       Container(
                                                              //         width: 50,
                                                              //         child:
                                                              //             getQno(x),
                                                              //       ),
                                                              //     ],
                                                              //   ),
                                                              // ),
                                                            ),
                                                            Container(
                                                              width: 310,
                                                              child: Text(
                                                                  _loadedAuditTemplatelist[
                                                                          x][
                                                                      'Questions']),
                                                            ),
                                                            //   ],
                                                            // ),
                                                            if ((_loadedAuditTemplatelist[
                                                                        x][
                                                                    'ans_type_id']) ==
                                                                '1') ...[
                                                              // ansType1(),
                                                              internalAnsType_01(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length),
                                                              externalAnsType_01(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length),
                                                            ]
                                                            // answer type 2
                                                            else if ((_loadedAuditTemplatelist[
                                                                        x][
                                                                    'ans_type_id']) ==
                                                                '2') ...[
                                                              internalAnsType_02(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length),
                                                              externalAnsType_02(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length)
                                                            ] else if ((_loadedAuditTemplatelist[
                                                                            x][
                                                                        'ans_type_id']) ==
                                                                    '3' &&
                                                                (_loadedAuditTemplatelist[
                                                                            x][
                                                                        'InternalExternal']) ==
                                                                    '-') ...[
                                                              internalAnsType_03(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length),

                                                              // external
                                                              externalAnsType_03(
                                                                  x,
                                                                  _loadedAuditTemplatelist
                                                                      .length),
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
                                )
                              : Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Questionnaire not available',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
                              padding:
                                  const EdgeInsets.fromLTRB(80, 15, 20, 10),
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
                                                  RecentAudits(userID: '1')));
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
                                      onPressed: () {
                                        lockTheSdg(
                                            _selectedAuditID[0]['AuditID'],
                                            _selectedSDG.toString());
                                        print('save this lock ythis sdg');
                                      },
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
                            'Please Select Industry, Company & SDG for Audit Questionire!',
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

  SizedBox getSDG_Name(int index) {
    return SizedBox(
      width: 150,
      child: Tooltip(
        message: _loadedSDGList[index]['SDG Name'],
        child: Text(
          _loadedSDGList[index]['SDG Name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: cFun.getStyleForSDGLabel(),
        ),
      ),
    );
  }

  Padding externalAnsType_03(int x, int no_of_ques) {
    dynamic markPerQuestionType03 = 1 / no_of_ques;
    dynamic numberOfOptions = _loadedAuditTemplatelist[x]['Answer'].length;
    dynamic markForEachOption = markPerQuestionType03 / numberOfOptions;

    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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
                        print(_checkedItemExt[x]['checkedValues'].runtimeType);
                        print(_loadedAuditTemplatelist[x]['Answer'][index]
                                ['ansID']
                            .runtimeType);
                        print(_checkedItemExt[x]['checkedValues'].contains(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                    ['ansID']
                                .toString()));
                        if (_checkedItemExt[x]['checkedValues'].contains(
                            _loadedAuditTemplatelist[x]['Answer'][index]
                                    ['ansID']
                                .toString())) {
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
                      dynamic totalMarks = markForEachOption *
                          (_checkedItemExt[x]['checkedValues'].length);
                      payload =
                          // ignore: prefer_interpolation_to_compose_strings
                          '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                              _selectedAuditID[0]['AuditID'] +
                              '","QueNo":"' +
                              _selectedGrpValue[x]['id'].toString() +
                              '", "AnsSelected":"' +
                              _checkedItemExt[x]['checkedValues'].toString() +
                              '", "AnsType":"3","AnsFor":"Ext","Company":"' +
                              _slectedCompanyID +
                              '","Industry":"' +
                              _selectedIndustryID +
                              '","SDG":"' +
                              _selectedSDG.toString() +
                              '","externalMarks":"' +
                              totalMarks.toString() +
                              '"}';
                      cFun.callAPI(payload).then((data) {
                        setState(() {
                          _loadedSDGList = data['header'];
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
            commentBox(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: 300,
            //     child: TextField(
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         hintText: 'Enter comment here',
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Container internalAnsType_03(int x, int no_of_ques) {
    dynamic markPerQuestionType03 = 1 / no_of_ques;
    dynamic numberOfOptions = _loadedAuditTemplatelist[x]['Answer'].length;
    dynamic markForEachOption = markPerQuestionType03 / numberOfOptions;

    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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
                  onChanged: _buttonDisabled
                      ? null
                      : (value) {
                          value = value;
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

                          dynamic totalMarks = markForEachOption *
                              (_checkedItem[x]['checkedValues'].length);
                          payload =
                              '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                                  _selectedAuditID[0]['AuditID'] +
                                  '","QueNo":"' +
                                  _selectedGrpValue[x]['id'].toString() +
                                  '", "AnsSelected":"' +
                                  _checkedItem[x]['checkedValues'].toString() +
                                  '", "AnsType":"3","AnsFor":"Int", "Company":"' +
                                  _slectedCompanyID +
                                  '","Industry":"' +
                                  _selectedIndustryID +
                                  '","SDG":"' +
                                  _selectedSDG.toString() +
                                  '","internalMarks":"' +
                                  totalMarks.toString() +
                                  '"}';
                          cFun.callAPI(payload).then((data) {
                            setState(() {
                              _loadedSDGList = data['header'];
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
          commentBox(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: 300,
          //     child: TextField(
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         hintText: 'Enter comment here',
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Container internalAnsType_02(int x, int no_of_ques) {
    dynamic marksForAns;
    dynamic numberOfOptions = _loadedAuditTemplatelist[x]['Answer'].length;
    dynamic markPerQuestionType02 = 1 / no_of_ques;

    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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

                    if (y == 0) {
                      marksForAns = 0;
                    } else {
                      marksForAns = (1 /
                              ((_loadedAuditTemplatelist[x]['Answer'].length) -
                                  y)) *
                          markPerQuestionType02;
                    }
                    payload = '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                        _selectedAuditID[0]['AuditID'] +
                        '","QueNo":"' +
                        _selectedGrpValue[x]['id'].toString() +
                        '", "AnsSelected":"' +
                        _selectedGrpValue[x]['grpValue'].toString() +
                        '", "AnsType":"2","AnsFor":"Int", "Company":"' +
                        _slectedCompanyID +
                        '","Industry":"' +
                        _selectedIndustryID +
                        '","SDG":"' +
                        _selectedSDG.toString() +
                        '","internalMarks":"' +
                        marksForAns.toString() +
                        '"}';
                    cFun.callAPI(payload).then((data) {
                      setState(() {
                        _loadedSDGList = data['header'];
                        getAuditTemplate(_selectedIndustryID, _slectedCompanyID,
                            _selectedSDG);
                      });
                    });
                  },
                ),
              ),
            ),
          ],

          commentBox(), // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: 300,
          //     child: TextField(
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         hintText: 'Enter comment here',
          //       ),
          //     ),
          //   ),
          // )
        ], // children
      ),
    );
  }

  Padding externalAnsType_02(int x, int no_of_ques) {
    dynamic marksForAns;
    dynamic numberOfOptions = _loadedAuditTemplatelist[x]['Answer'].length;
    dynamic markPerQuestionType02 = 1 / no_of_ques;
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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
                      if (y == 0) {
                        marksForAns = 0;
                      } else {
                        marksForAns = (1 /
                                ((_loadedAuditTemplatelist[x]['Answer']
                                        .length) -
                                    y)) *
                            markPerQuestionType02;
                      }
                      payload =
                          '{"opnfor":"100000", "act":"A-07", "AuditID":"' +
                              _selectedAuditID[0]['AuditID'] +
                              '","QueNo":"' +
                              _selectedGrpValueExt[x]['id'].toString() +
                              '", "AnsSelected":"' +
                              _selectedGrpValueExt[x]['grpValue'].toString() +
                              '", "AnsType":"2","AnsFor":"Ext", "Company":"' +
                              _slectedCompanyID +
                              '","Industry":"' +
                              _selectedIndustryID +
                              '","SDG":"' +
                              _selectedSDG.toString() +
                              '","externalMarks":"' +
                              marksForAns.toString() +
                              '"}';
                      cFun.callAPI(payload).then((data) {
                        setState(() {
                          _loadedSDGList = data['header'];
                          getAuditTemplate(_selectedIndustryID,
                              _slectedCompanyID, _selectedSDG);
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
            commentBox(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: 300,
            //     child: TextField(
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         hintText: 'Enter comment here',
            //       ),
            //     ),
            //   ),
            // )
          ], // children
        ),
      ),
    );
  }

  Container internalAnsType_01(int x, int no_of_ques) {
    dynamic markPerQuestion = 1 / no_of_ques;
    dynamic ans_yes = markPerQuestion;
    dynamic ans_no = 0;
    return Container(
      decoration: BoxDecoration(
          // color: Colors.amber,
          border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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
                        '", "AnsType":"1","AnsFor":"Int", "Company":"' +
                        _slectedCompanyID +
                        '","Industry":"' +
                        _selectedIndustryID +
                        '","SDG":"' +
                        _selectedSDG.toString() +
                        '","internalMarks":"' +
                        ans_yes.toString() +
                        '"}';
                cFun.callAPI(payload).then((data) {
                  setState(() {
                    _loadedSDGList = data['header'];
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
                        '", "AnsType":"1","AnsFor":"Int", "Company":"' +
                        _slectedCompanyID +
                        '","Industry":"' +
                        _selectedIndustryID +
                        '","SDG":"' +
                        _selectedSDG.toString() +
                        '","internalMarks":"' +
                        ans_no.toString() +
                        '"}';
                print(payload);
                cFun.callAPI(payload).then((data) {
                  setState(() {
                    _loadedSDGList = data['header'];
                    getAuditTemplate(
                        _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                  });
                });
              },
            ),
          ),
          commentBox(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: 300,
          //     child: Container(
          //       // height: 200,
          //       // decoration:
          //       // BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          //       child: TextField(
          //         decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           hintText: 'Enter comment here',
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Padding externalAnsType_01(int x, int no_of_ques) {
    dynamic markPerQuestion = 1 / no_of_ques;
    dynamic ans_yes = markPerQuestion;
    dynamic ans_no = 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey, width: 0.5))),
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
                          '", "AnsType":"1","AnsFor":"Ext", "Company":"' +
                          _slectedCompanyID +
                          '","Industry":"' +
                          _selectedIndustryID +
                          '","SDG":"' +
                          _selectedSDG.toString() +
                          '","externalMarks":"' +
                          ans_yes.toString() +
                          '"}';
                  cFun.callAPI(payload).then((data) {
                    setState(() {
                      _loadedSDGList = data['header'];
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
                      '", "AnsType":"1","AnsFor":"Ext", "Company":"' +
                      _slectedCompanyID +
                      '","Industry":"' +
                      _selectedIndustryID +
                      '","SDG":"' +
                      _selectedSDG.toString() +
                      '","externalMarks":"' +
                      ans_no.toString() +
                      '"}';
                  print(payload);
                  cFun.callAPI(payload).then((data) {
                    setState(() {
                      _loadedSDGList = data['header'];
                      getAuditTemplate(
                          _selectedIndustryID, _slectedCompanyID, _selectedSDG);
                    });
                  });
                },
              ),
            ),
            commentBox(),
          ],
        ),
      ),
    );
  }

  Padding commentBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        height: 150,
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.grey)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              // TextField(
              //   // decoration: InputDecoration(
              //   //   // border: OutlineInputBorder(),
              //   //   hintText: 'Enter comment here',
              //   // ),
              //   decoration: new InputDecoration.collapsed(
              //       hintText: 'Enter comment here'),
              // ),

              TextField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Enter comment here',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              constraints: BoxConstraints.tightFor(width: 350, height: 100),
            ),
          ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
          child: Text(' $x.', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  checkForCheckedValues(selectedAns, ansFromList) {
    // selected from DB
    // print(selectedAns.runtimeType);
    // print('selectedAns $selectedAns');
    // print('ansFromList $ansFromList');
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

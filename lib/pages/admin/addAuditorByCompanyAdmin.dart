import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../widgets/drawer.dart';
import 'package:flutter_demo_app/utils/common.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:sms_app/utilities/commonToaster.dart';

var auditorsDetails = [];

class InternalAuditorDetails extends StatefulWidget {
  const InternalAuditorDetails({super.key});

  @override
  State<InternalAuditorDetails> createState() => AuditorsDetailsState();
}

class AuditorsDetailsState extends State<InternalAuditorDetails> {
  bool detailsAccessed = true;
  String payload = "";

  String? id;

  List? _myActivities;
  late String _myActivitiesResult;

  TextEditingController name = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isAddressLine1Entered = false;
  bool isSchoolNameEntered = false;
  bool insertMessage = false;
  bool isSubmitForm = true;

  commonFunctions cFun = commonFunctions();
  // commonToaster toast = commonToaster();

  @override
  void initState() {
    super.initState();
    getAllauditorsDetails();
    _myActivities = [];
    _myActivitiesResult = '';
  }

  void getAllauditorsDetails() {
    payload = '{"opnfor": "200000", "act": "A-01"}';
    cFun.callAPI(payload).then((data) {
      setState(() {
        auditorsDetails = data['header'];
        detailsAccessed = false;
      });
    });
  }

  final List<String> columns = [
    "First Name",
    "Last Name",
    "Phone Number",
    "Email",
    "User ID",
    "Action"
  ];

  // list of columns
  List<DataColumn> getColumn(List<String> columns) {
    return columns
        .map(
          (String columnName) => DataColumn(
            label: Text(columnName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
        )
        .toList();
  }

  // list of rows
  List<DataRow> getRow(BuildContext context) {
    return auditorsDetails.map(
      (row) {
        int sr = auditorsDetails.indexOf(row) + 1;
        return DataRow(
          // color: MaterialStateColor.resolveWith((states) {
          //   return sr % 2 == 0
          //       ? Color.fromARGB(255, 239, 241, 241)
          //       : Color.fromARGB(255, 239, 241, 241);
          //   // tableRowColor;
          // }),
          color: auditorsDetails.indexOf(row) % 2 != 0
              ? MaterialStateProperty.resolveWith(cFun.getAlternateRowColor)
              : null,
          cells: [
            DataCell(Text(
              row['FirstName'].toString(),
              // style: TextStyle(fontSize: 18),
            )),
            DataCell(Text(
              row['LastName'].toString(),
              // style: TextStyle(fontSize: 18),
            )),
            DataCell(Text(
              row['MobileNo'].toString(),
              // style: TextStyle(fontSize: 18),
            )),
            DataCell(Text(
              row['EmailId'].toString(),
              // style: TextStyle(fontSize: 18),
            )),
            DataCell(Text(
              row['UserName'].toString(),
              // style: TextStyle(fontSize: 18),
            )),
            DataCell(
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // backgroundColor: talbelEdit,
                    ),
                onPressed: () {
                  setState(() {
                    id = row['UserID'].toString();
                    fname = TextEditingController(
                        text: row['FirstName'].toString());
                    lname =
                        TextEditingController(text: row['LastName'].toString());
                    email =
                        TextEditingController(text: row['EmailId'].toString());
                    phone =
                        TextEditingController(text: row['MobileNo'].toString());
                    uname =
                        TextEditingController(text: row['UserName'].toString());
                    password =
                        TextEditingController(text: row['Password'].toString());
                  });
                  commonDialogForInsertUpdate(
                      context, 'Update Auditor Details');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Company Auditor Master"),
        backgroundColor: Colors.blue,
        //  appBarColor,
        actions: <Widget>[
          cFun.getProfileMenu(context),
        ],
      ),
      drawer: const MyDrawer(),
      body: detailsAccessed
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Column(
              children: [
                auditorsDetails.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(450, 300, 50, 50),
                        child: Row(
                          children: [
                            const Text('No records available. Please click  ',
                                style: TextStyle(fontSize: 30)),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    id = null;
                                    fname.clear();
                                    lname.clear();
                                    uname.clear();
                                    email.clear();
                                    phone.clear();
                                    password.clear();

                                    // isAddressLine1Entered = false;
                                    // isSchoolNameEntered = false;
                                  });
                                  commonDialogForInsertUpdate(
                                      context, 'Add Auditor Details');
                                },
                                child: const Text('here',
                                    style: TextStyle(fontSize: 30))),
                            const Text('  to add new Auditor',
                                style: TextStyle(fontSize: 30))
                          ],
                        ),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Column(children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    // const EdgeInsets.only(left: 1350, top: 12),
                                    const EdgeInsets.fromLTRB(1280, 15, 0, 0),
                                child: getAddButton(context),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: 1400,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 100, top: 12),
                                child: Container(
                                  height: 500,
                                  width: 1200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        // blurRadius: 5,
                                        // offset: Offset(0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: DataTable(
                                    // border: TableBorder.all(
                                    //   width: 1,
                                    //   color: Colors.black,
                                    // ),
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.black),
                                    columnSpacing: 8.00,
                                    columns: getColumn(columns),
                                    rows: getRow(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
              ],
            ),
    );
  }

  ElevatedButton getAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          id = null;
          fname.clear();
          lname.clear();
          uname.clear();
          email.clear();
          phone.clear();
          password.clear();

          isAddressLine1Entered = false;
          isSchoolNameEntered = false;
        });
        commonDialogForInsertUpdate(context, 'Add Auditor Details');
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Add",
                  // style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> commonDialogForInsertUpdate(
      BuildContext context, String title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                height: 40,
                decoration: const BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              content: getSchoolFormInsertOrUpdate(),
              actions: <Widget>[
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        performSchoolOperations();
                        Navigator.pop(context);
                      } else {}
                    },
                    child:
                        id == null ? const Text('Save') : const Text('Update')),
              ],
            );
          });
        });
  }

  SizedBox getSchoolFormInsertOrUpdate() {
    return SizedBox(
      width: 900,
      height: 500,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: fname,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : "Please enter first name";
              },
              decoration: const InputDecoration(
                labelText: "First Name",
              ),
            ),
            TextFormField(
              controller: lname,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : "Please enter last name";
              },
              decoration: const InputDecoration(
                labelText: "Last Name",
              ),
            ),
            // TextFormField(
            //   controller: phone,
            //   validator: (value) {
            //     return (value != null && value.isNotEmpty)
            //         ? null
            //         : "Please enter phone name";
            //   },
            //   decoration: const InputDecoration(
            //     labelText: "Phone Number",
            //   ),
            // ),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.number,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? value.toString().length != 10
                        ? 'Phone Number should a 10 digit number'
                        : null
                    : "Please enter phone number";
              },
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),
            // TextFormField(
            //   controller: email,
            //   validator: (value) {
            //     return (value != null && value.isNotEmpty)
            //         ? null
            //         : "Please enter email id";
            //   },
            //   decoration: const InputDecoration(
            //     labelText: "Email ID",
            //   ),
            // ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? EmailValidator.validate(value)
                        ? null
                        : "Please enter a valid email"
                    : "Please enter email";
              },
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextFormField(
              controller: uname,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : "Please enter user name";
              },
              decoration: const InputDecoration(
                labelText: "User Name",
              ),
            ),
            TextFormField(
              controller: password,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : "Please enter password";
              },
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            Container(
              child: MultiSelectFormField(
                autovalidate: AutovalidateMode.disabled,
                chipBackGroundColor: Colors.black,
                chipLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.blue,
                checkBoxCheckColor: Colors.white,
                dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                hintWidget: Text(''),
                title: Text(
                  "Please select Industries",
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: [
                  {
                    "display": "Finance",
                    "value": "Finance",
                  },
                  {
                    "display": "Banking",
                    "value": "Banking",
                  },
                ],
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                // hintWidget: Text('Please choose one or more'),
                initialValue: _myActivities,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    _myActivities = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performSchoolOperations() {
    if (id == null) {
      payload =
          '{"opnfor": "200000","act": "A-I","CreatedBy": "admin","UserRole": "107","fName":"' +
              fname.text +
              '","lName":"' +
              lname.text +
              '","Email":"' +
              email.text +
              '","Phone":"' +
              phone.text +
              '","uName":"' +
              uname.text +
              '","Password":"' +
              password.text +
              '"}';

      // payload["fName"] = fname.text;
      // payload["lName"] = lname.text;
      // payload["Email"] = email.text;
      // payload["Phone"] = phone.text;
      // payload["uName"] = uname.text;
      // payload["Password"] = password.text;

      cFun.callAPI(payload).then((data) => {
            setState(
              () {
                insertMessage = true;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const InternalAuditorDetails()));
              },
            )
          });
    } else {
      // var payload = {
      //   "opnfor": "200000",
      //   "act": "A-U",
      //   "CreatedBy": "admin",
      //   "ModifiedBy": "admin"
      // };
      payload =
          '{"opnfor": "200000","act": "A-U","CreatedBy": "admin","ModifiedBy": "admin","UserRole": "107","fName":"' +
              fname.text +
              '","lName":"' +
              lname.text +
              '","Email":"' +
              email.text +
              '","Phone":"' +
              phone.text +
              '","uName":"' +
              uname.text +
              '","Password":"' +
              password.text +
              '","ID":"' +
              id.toString() +
              '"}';

      // payload["fName"] = fname.text;
      // payload["lName"] = lname.text;
      // payload["Email"] = email.text;
      // payload["Phone"] = phone.text;
      // payload["uName"] = uname.text;
      // payload["Password"] = password.text;
      // payload["ID"] = id.toString();

      cFun.callAPI(payload).then((data) => {
            setState(
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const InternalAuditorDetails()));
              },
            )
          });
    }
  }
}

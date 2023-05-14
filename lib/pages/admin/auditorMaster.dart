// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; 
// import 'package:flutter_demo_app/utils/common.dart';

// class FarmerMaster extends StatefulWidget {
//   const FarmerMaster({super.key});

//   @override
//   State<FarmerMaster> createState() => _FarmerMasterState();
// }

// class _FarmerMasterState extends State<FarmerMaster> {
//   final _formKey = GlobalKey<FormState>();
//   commonFunctions cFun = commonFunctions();
//   bool _loadingFarmers = true;
//   String payload = '';
//   List<dynamic> _loadedFarmers = [];
//     List<dynamic> _loadedAuditors = [];
//   bool passwordVisible = true;
//   String loginUserName = 'Omkar'; // Since we don't have login
//   bool isEdit = false;
//   commonDialog dialog = new commonDialog();
//   String FarmerID = '';

//   TextEditingController firstName = new TextEditingController();
//   TextEditingController lastName = new TextEditingController();
//   TextEditingController userName = new TextEditingController();
//   TextEditingController password = new TextEditingController();
//   TextEditingController phoneNumber = new TextEditingController();
//   TextEditingController email = new TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadingFarmers = true;

//     firstName.text = '';
//     lastName.text = '';
//     userName.text = '';
//     password.text = '';
//     phoneNumber.text = '';
//     email.text = '';

//     payload = '{"opnfor":"200000", "act":"A-V" }';

//     cFun.callAPI(payload).then((data) {
//       setState(() {
//         _loadedFarmers = data['header'];
//         _loadingFarmers = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: SideMenu(),
//         appBar: AppBar(
//             title: Text('Farmer Master'),
//             centerTitle: true,
//             backgroundColor: Colors.green[600],
//             actionsIconTheme: const IconThemeData(
//                 size: 30.0, color: Colors.white, opacity: 10.0),
//             actions: <Widget>[
//               cFun.getProfileMenu(context),
//             ]),
//         body: _loadingFarmers
//             ? const Center(
//                 child: CircularProgressIndicator(
//                 color: Colors.black,
//               ))
//             : Container(
//                 child: ResponsiveWidget(
//                 mobile: const Text('Phone View In-Progress'),
//                 desktop: _loadedFarmers.length == 0
//                     ? const Center(
//                         child: Text(
//                           'Add New Farmer',
//                           style: TextStyle(
//                               fontSize: 28, fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     : getFarmerMasterList(),
//                 tablet: const Text('Tablet View In-Progress'),
//               )));
//   }

//   Widget getFarmerMasterList() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           height: 40,
//           width: 1450,
//           child: Row(
//             children: [
//               Container(
//                 margin: EdgeInsets.fromLTRB(640, 0, 0, 0),
//                 alignment: Alignment.topCenter,
//                 child: const Text(
//                   'Farmer List',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.fromLTRB(510, 0, 0, 0),
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       isEdit = false;
//                     });
//                     getSaveAndUpdateFormForFarmer();
//                   },
//                   icon: const Icon(Icons.add_box_outlined),
//                   label: const Text('Add'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.green[600],
//                     shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     side: const BorderSide(
//                         color: Color.fromARGB(255, 67, 160, 71), width: 1),
//                     textStyle: TextStyle(
//                         color: Colors.green[600],
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           thickness: 2,
//           color: Colors.green[600],
//         ),
//         SizedBox(
//           height: 600,
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 67, 160, 71),
//                         border: Border.all(color: Colors.black)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'First Name',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 67, 160, 71),
//                         border: Border.all(color: Colors.black)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Last Name',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'User Name',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Password',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Phone Number',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Email',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 200,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Active',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         color: Color.fromARGB(255, 67, 160, 71)),
//                     width: 135,
//                     height: 80,
//                     child: const Center(
//                       widthFactor: 1.4,
//                       child: Text(
//                         'Actions',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 500,
//                 child: SingleChildScrollView(
//                   child: DataTable(
//                       border: TableBorder.all(
//                         width: 1,
//                       ),
//                       showCheckboxColumn: false,
//                       headingRowHeight: 0,
//                       columnSpacing: 20,
//                       horizontalMargin: 10,
//                       dataRowHeight: 50,
//                       headingRowColor: MaterialStateColor.resolveWith(
//                           (states) => Color.fromARGB(255, 67, 160, 71)),
//                       headingTextStyle: const TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       dataTextStyle: const TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                       columns: const [
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'First Name',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'Last Name',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'User Name',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'Password',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                           label: Expanded(
//                             child: SizedBox(
//                               width: 180,
//                               child: Center(
//                                 widthFactor: 1.4,
//                                 child: Text(
//                                   'Phone Number',
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           numeric: true,
//                         ),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'Email',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'Active',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                         DataColumn(
//                             label: Expanded(
//                           child: SizedBox(
//                             width: 180,
//                             child: Center(
//                               widthFactor: 1.4,
//                               child: Text(
//                                 'Actions',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         )),
//                       ],
//                       rows: <DataRow>[
//                         for (var i = 0; i < _loadedFarmers.length; i++)
//                           DataRow(
//                             color: i % 2 != 0
//                                 ? MaterialStateProperty.resolveWith(getColor)
//                                 : null,
//                             cells: <DataCell>[
//                               DataCell(Center(
//                                   widthFactor: 2,
//                                   child: Text(
//                                     _loadedFarmers[i]["FirstName"].toString(),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                               DataCell(Center(
//                                   widthFactor: 2,
//                                   child: Text(
//                                     _loadedFarmers[i]["LastName"].toString(),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                               DataCell(Center(
//                                   widthFactor: 2,
//                                   child: Text(
//                                     _loadedFarmers[i]["UserName"].toString(),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                               DataCell(Center(
//                                   widthFactor: 2,
//                                   child: Text(
//                                     _loadedFarmers[i]["Password"].toString(),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                               DataCell(Text(
//                                   _loadedFarmers[i]["PhoneNumber"].toString())),
//                               DataCell(Center(
//                                   widthFactor: 4,
//                                   child: Text(
//                                     _loadedFarmers[i]["Email"].toString(),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                               DataCell(Center(
//                                   widthFactor: 5,
//                                   child: SizedBox(
//                                     width: 100,
//                                     child: SwitchListTile(
//                                       value: _loadedFarmers[i]["ActiveFlag"] ==
//                                               'true'
//                                           ? true
//                                           : false,
//                                       activeColor: Colors.red[600],
//                                       inactiveTrackColor: Colors.grey,
//                                       onChanged: (bool value) {
//                                         String activeYandN =
//                                             value == true ? 'Y' : 'N';

//                                         String FarmerName = _loadedFarmers[i]
//                                                 ["UserName"]
//                                             .toString();

//                                         dialog.confirmDialog(
//                                             context,
//                                             activeYandN == 'N'
//                                                 ? 'Farmer Deactivation'
//                                                 : 'Farmer Activation',
//                                             activeYandN == 'N'
//                                                 ? Text(
//                                                     'Do you want to Deactivate "$FarmerName" Farmer?')
//                                                 : Text(
//                                                     'Do you want to Activate "$FarmerName" Farmer?'),
//                                             'No',
//                                             'Yes', () {
//                                           Navigator.pop(context);
//                                         }, () {
//                                           activeFarmer(
//                                               activeYandN,
//                                               _loadedFarmers[i]["UserID"]
//                                                   .toString());
//                                           Navigator.pop(context);
//                                         });
//                                       },
//                                     ),
//                                   ))),
//                               DataCell(Center(
//                                 widthFactor: 2,
//                                 child: IconButton(
//                                   icon: Icon(Icons.edit),
//                                   iconSize: 20,
//                                   tooltip: 'Edit Farmer',
//                                   onPressed: () {
//                                     setterForFarmer(
//                                         _loadedFarmers[i]["FirstName"]
//                                             .toString(),
//                                         _loadedFarmers[i]["LastName"]
//                                             .toString(),
//                                         _loadedFarmers[i]["UserName"]
//                                             .toString(),
//                                         _loadedFarmers[i]["Password"]
//                                             .toString(),
//                                         _loadedFarmers[i]["PhoneNumber"]
//                                             .toString(),
//                                         _loadedFarmers[i]["Email"].toString(),
//                                         _loadedFarmers[i]["UserID"].toString());
//                                     getSaveAndUpdateFormForFarmer();
//                                   },
//                                 ),
//                               ))
//                             ],
//                           )
//                       ]),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   activeFarmer(String value, String FarmerID) {
//     payload =
//         '{"opnfor":"200000", "act":"A-03", "ActiveFlag":"$value", "FarmerID":"$FarmerID", "IN_UserName":"$loginUserName"}';
//     setState(() {
//       _loadingFarmers = true;
//       cFun.callAPI(payload).then((data) {
//         setState(() {
//           _loadedFarmers = data['header'];

//           _loadingFarmers = false;
//         });
//       });
//     });
//   }

//   setterForFarmer(
//       String FirstName,
//       String LastName,
//       String UserName,
//       String Password,
//       String PhoneNumber,
//       String Email,
//       String UpdateFarmerID) {
//     setState(() {
//       isEdit = true;
//       FarmerID = UpdateFarmerID;
//       firstName.value = TextEditingValue(
//         text: FirstName,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: FirstName.length),
//         ),
//       );
//       lastName.value = TextEditingValue(
//         text: LastName,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: LastName.length),
//         ),
//       );
//       userName.value = TextEditingValue(
//         text: UserName,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: UserName.length),
//         ),
//       );
//       password.value = TextEditingValue(
//         text: Password,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: Password.length),
//         ),
//       );
//       phoneNumber.value = TextEditingValue(
//         text: PhoneNumber,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: PhoneNumber.length),
//         ),
//       );
//       email.value = TextEditingValue(
//         text: Email == '-' ? '' : Email,
//         selection: TextSelection.fromPosition(
//           TextPosition(offset: Email.length),
//         ),
//       );
//     });
//   }

//   Future<dynamic> getSaveAndUpdateFormForFarmer() {
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               titlePadding: const EdgeInsets.all(0),
//               title: Container(
//                 height: 40,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0)),
//                 ),
//                 child: Center(
//                   child: isEdit
//                       ? const Text('Farmer Update',
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white))
//                       : const Text('Farmer Add',
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                 ),
//               ),
//               content: getFarmerForm(setState),
//               actions: <Widget>[
//                 OutlinedButton(
//                     onPressed: () {
//                       firstName.clear();
//                       lastName.clear();
//                       userName.clear();
//                       password.clear();
//                       email.clear();
//                       phoneNumber.clear();
//                       Navigator.pop(context);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.green[600],
//                       shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       side: const BorderSide(
//                           color: Color.fromARGB(255, 67, 160, 71), width: 1),
//                       textStyle: TextStyle(
//                           color: Colors.green[600],
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     child: const Text('Cancel')),
//                 OutlinedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         saveAndUpdateFarmer();
//                         Navigator.pop(context);
//                       }
//                     },
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.green[600],
//                       shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       side: const BorderSide(
//                           color: Color.fromARGB(255, 67, 160, 71), width: 1),
//                       textStyle: TextStyle(
//                           color: Colors.green[600],
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     child: isEdit ? const Text('Update') : const Text('Save')),
//               ],
//             );
//           });
//         });
//   }

//   SizedBox getFarmerForm(StateSetter setState) {
//     return SizedBox(
//       width: 900,
//       height: 500,
//       child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: firstName,
//                 decoration: const InputDecoration(
//                   icon: const Icon(Icons.person_2_outlined),
//                   hintText: 'Enter First Name',
//                   labelText: 'First Name',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter First Name';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: lastName,
//                 decoration: const InputDecoration(
//                   icon: const Icon(Icons.person_2_outlined),
//                   hintText: 'Enter Last Name',
//                   labelText: 'Last Name',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Last Name';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: userName,
//                 decoration: const InputDecoration(
//                   icon: const Icon(Icons.verified_user_outlined),
//                   hintText: 'Enter Username',
//                   labelText: 'Username',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Username';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: password,
//                 obscureText: passwordVisible,
//                 keyboardType: TextInputType.visiblePassword,
//                 textInputAction: TextInputAction.done,
//                 decoration: InputDecoration(
//                   helperText: "Password must be at least 8 characters",
//                   helperStyle: TextStyle(color: Colors.green),
//                   suffixIcon: IconButton(
//                       icon: Icon(passwordVisible
//                           ? Icons.visibility_off
//                           : Icons.visibility),
//                       onPressed: () {
//                         setState(
//                           () {
//                             passwordVisible = !passwordVisible;
//                           },
//                         );
//                       }),
//                   icon: const Icon(Icons.password_outlined),
//                   hintText: 'Enter Password',
//                   labelText: 'Password',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Password';
//                   }
//                   if (value.length < 8) {
//                     return 'Please enter Password at least 8 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: phoneNumber,
//                 maxLength: 10,
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 decoration: const InputDecoration(
//                   icon: const Icon(Icons.phone),
//                   hintText: 'Enter Phone Number',
//                   labelText: 'Phone Number',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Phone Number';
//                   } else if (value.length < 10) {
//                     return 'Please enter 10 digit Phone Number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: email,
//                 decoration: const InputDecoration(
//                   icon: const Icon(Icons.email_outlined),
//                   hintText: 'Enter Email',
//                   labelText: 'Email',
//                 ),
//               ),
//             ],
//           )),
//     );
//   }

//   Color getColor(Set<MaterialState> states) {
//     return Colors.lightGreen.withOpacity(0.4);
//   }

//   saveAndUpdateFarmer() {
//     if (isEdit) {
//       // Update
//       String set = "UserName='${userName.text}',";
//       set += "Password='${password.text}', ";
//       set += "FirstName='${firstName.text}', ";
//       set += "LastName='${lastName.text}', ";
//       set += "PhoneNumber='${phoneNumber.text}', ";
//       email.text == null || email.text == ''
//           ? set += "Email=NULL"
//           : set += "Email='${email.text}'";

//       set += ",ModifiedBy='$loginUserName', ModifiedDate=now()";

//       String where = 'UserID=$FarmerID';

//       payload =
//           '{"opnfor":"200000", "act":"A-02", "where":"$where", "set":"$set"}';
//       setState(() {
//         _loadingFarmers = true;
//         cFun.callAPI(payload).then((data) {
//           setState(() {
//             _loadedFarmers = data['header'];

//             _loadingFarmers = false;
//           });
//         });
//       });
//       firstName.clear();
//       lastName.clear();
//       userName.clear();
//       password.clear();
//       email.clear();
//       phoneNumber.clear();
//     } else {
//       // Save
//       String columnValues = "'${userName.text}',";
//       columnValues += "'${password.text}', ";
//       columnValues += "'${firstName.text}', ";
//       columnValues += "'${lastName.text}', ";
//       columnValues += "'${phoneNumber.text}', ";
//       email.text == null || email.text == ''
//           ? columnValues += "NULL"
//           : columnValues += "'${email.text}'";

//       columnValues += ", 2, '$loginUserName'";

//       payload =
//           '{"opnfor":"200000", "act":"A-01", "columnValues":"$columnValues" }';
//       setState(() {
//         _loadingFarmers = true;
//         cFun.callAPI(payload).then((data) {
//           setState(() {
//             _loadedFarmers = data['header'];

//             _loadingFarmers = false;
//           });
//         });
//       });
//       firstName.clear();
//       lastName.clear();
//       userName.clear();
//       password.clear();
//       email.clear();
//       phoneNumber.clear();
//     }
//   }
// }

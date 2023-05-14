import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/login_page.dart';
import 'commonDialog.dart';
import 'commonToaster.dart';
import 'constants.dart';

class commonFunctions {
  commonToaster toaster = commonToaster();
  commonDialog dialog = commonDialog();
  commonToaster toast = commonToaster();
  Future<dynamic> callAPI(params) async {
    print('Params:');
    print(params);
    var payload = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'paramsFor': params.toString()
    };

    final response = await http.get(Uri.parse(API_URL), headers: payload);

    final data = json.decode("[" + response.body + "]");
    return data[0]['body'];
  }

  Color getAlternateRowColor(Set<MaterialState> states) {
    return const Color.fromARGB(255, 211, 211, 211);
  }

  TextStyle getStyleForSDGLabel() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  TextStyle getStyleForScore() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  TextStyle getStyleForQueHead() {
    return const TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
  }

  Padding getProfileMenu(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        radius: 18,
        child: PopupMenuButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.person_2_rounded,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    title: Text("Sign-Out"),
                    leading: const Icon(Icons.logout),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                dialog.confirmDialog(
                    context,
                    'Confirmation',
                    const Text('Will you like to Sign-Out?'),
                    'Cancel',
                    'Yes', () {
                  Navigator.pop(context);
                }, () {
                  UserDetails = {};
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));

                  toaster.successMessage('Signed-Out Successfully');
                });
              }
            }),
      ),
    );
  }
}

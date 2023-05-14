import 'package:flutter/material.dart';

import 'commonToaster.dart';

class commonDialog {
  commonToaster toaster = new commonToaster();

  // For information
  information(BuildContext context, String title, Widget contentWidget,
      String ButtonLableFirst, Function() ButtonLableFirstFunction) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              content: contentWidget,
              actions: <Widget>[
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      ButtonLableFirstFunction();
                    },
                    child: Text(ButtonLableFirst)),
              ],
            );
          });
        });
  }

  // Dynamic Confirm
  confirmDialog(
      BuildContext context,
      String title,
      Widget contentWidget,
      String ButtonLableFirst,
      String ButtonLableSecond,
      Function() ButtonLableFirstFunction,
      Function() ButtonLableSecondFunction) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            titlePadding: const EdgeInsets.all(0),
            title: Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            content: contentWidget,
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => ButtonLableFirstFunction(),
                  child: Text(ButtonLableFirst)),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => ButtonLableSecondFunction(),
                  child: Text(ButtonLableSecond))
            ],
          );
        });
  }

// For Error
  error(BuildContext context, String title, Widget contentWidget,
      String ButtonLableFirst, Function() ButtonLableFirstFunction) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            titlePadding: const EdgeInsets.all(0),
            title: Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            content: contentWidget,
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => ButtonLableFirstFunction(),
                  child: Text(ButtonLableFirst)),
            ],
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class commonToaster {
  successMessage(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        webPosition: 'center',
        timeInSecForIosWeb: 1,
        webBgColor:
            'linear-gradient(90deg, rgba(15,157,88,1) 31%, rgba(15,157,88,1) 64%)',
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  errorMessage(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        webPosition: 'center',
        webBgColor:
            'linear-gradient(90deg, rgba(219,68,55,1) 31%, rgba(219,68,55,1) 64%)',
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  informationMessage(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        webPosition: 'center',
        timeInSecForIosWeb: 2,
        webBgColor:
            'linear-gradient(90deg, rgba(66,133,244,1) 31%, rgba(66,133,244,1) 64%)',
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

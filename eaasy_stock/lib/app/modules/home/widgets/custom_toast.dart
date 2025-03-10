import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
    void showToast(String message) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: const Color.fromRGBO(255, 255, 255, 1),
        fontSize: 16.0,
      );
    } catch (e) {
      print("Erro ao exibir toast: $e");
    }
  }
}
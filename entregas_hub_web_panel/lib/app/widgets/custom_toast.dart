import 'package:entregas_hub_web_panel/app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  void showToast(String message, {ToastType type = ToastType.error}) {
    try {
      Color backgroundColor;
      switch (type) {
        case ToastType.success:
          backgroundColor = AppColors.successColor;
          break;
        case ToastType.error:
          backgroundColor = AppColors.errorColor;
          break;
        case ToastType.warning:
          backgroundColor = AppColors.warningColor;
          break;
        case ToastType.info:
          backgroundColor = AppColors.infoColor;
          break;
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Erro ao exibir toast: $e");
    }
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}

import 'package:entregas_hub_web_panel/app/modules/stock/controllers/stock_controller.dart';
import 'package:entregas_hub_web_panel/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  Get.put(StockController());
  runApp(
    GetMaterialApp(
      theme: AppTheme.lightTheme,
      // Aplicando o tema escuro
      darkTheme: AppTheme.darkTheme,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

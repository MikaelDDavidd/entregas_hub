import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/modules/conferency/controllers/conferency_controller.dart';
import 'package:logistics_app/app/modules/interior/controllers/interior_controller.dart';
import 'package:logistics_app/app/modules/listing/controllers/listing_controller.dart';
import 'package:logistics_app/app/modules/scanning/controllers/scanning_controller.dart';
import 'package:logistics_app/app/modules/test_api/controllers/test_api_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ListingController());
  Get.put(ScanningController());
  Get.put(InteriorController());
  Get.put(ConferencyController());
  Get.put(TestApiController());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

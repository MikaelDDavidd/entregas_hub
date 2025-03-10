import 'package:get/get.dart';

import '../controllers/scanning_controller.dart';

class ScanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanningController>(
      () => ScanningController(),
    );
  }
}

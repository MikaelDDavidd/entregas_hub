import 'package:get/get.dart';

import '../controllers/interior_controller.dart';

class InteriorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InteriorController>(
      () => InteriorController(),
    );
  }
}

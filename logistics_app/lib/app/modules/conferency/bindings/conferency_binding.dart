import 'package:get/get.dart';

import '../controllers/conferency_controller.dart';

class ConferencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConferencyController>(
      () => ConferencyController(),
    );
  }
}

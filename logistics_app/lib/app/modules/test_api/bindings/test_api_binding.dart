import 'package:get/get.dart';

import '../controllers/test_api_controller.dart';

class TestApiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestApiController>(
      () => TestApiController(),
    );
  }
}

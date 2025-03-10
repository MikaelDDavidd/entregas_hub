import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test_api_controller.dart';

class TestApiView extends GetView<TestApiController> {
  const TestApiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestApiView'),
        centerTitle: true,
      ),
      body:  Center(
        child: FloatingActionButton(
            onPressed: () {
              controller.takePhoto();
            },
            child: Icon(Icons.qr_code), // Ícone a ser exibido no botão
          ),
      ),
    );
  }
}

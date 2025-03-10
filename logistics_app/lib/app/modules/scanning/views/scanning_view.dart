import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/scanning_controller.dart';

class ScanningView extends GetView<ScanningController> {
  const ScanningView({super.key});
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Container(
            child: Center(
              child: Obx(() {
                // Verifica se o código QR foi lido
                if (controller.qrCode.value.isNotEmpty) {
                  return SizedBox(
                    height: 300,
                    child: QrImageView(
                      data: controller.qrCode.value,
                      version: QrVersions.auto,
                    ),
                  );
                } else {
                  return Text(
                    'Nenhum QR Code detectado',
                    style: TextStyle(fontSize: 20),
                  );
                }
              }),
            ),
          ),
          Spacer(),
          Obx(() {
            // Verifica se o QR Code foi lido
            if (controller.qrCode.value.isNotEmpty) {
              return Text(
                controller.qrCode.value,
                style: TextStyle(fontSize: 20),
              );
            } else {
              return Container(); // Retorna um Container vazio se nenhum QR Code for detectado
            }
          }),
          Spacer(),
          FloatingActionButton(
            onPressed: () {
              controller.startScanning();
            },
            child: Icon(Icons.qr_code), // Ícone a ser exibido no botão
          ),
          Spacer()
        ],
      ),
    );
  }
}
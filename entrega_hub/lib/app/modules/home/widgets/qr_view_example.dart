// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRViewExample extends StatelessWidget {
//   // Cria uma chave única para o QRView
//   final GlobalKey<QRViewController> qrKey = GlobalKey<QRViewController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Escanear Código')),
//       body: QRView(
//         key: qrKey,  // Adiciona a chave ao QRView
//         onQRViewCreated: (QRViewController controller) {
//           controller.scannedDataStream.listen((scanData) {
//             Get.back(result: scanData.code); // Passa o código de rastreio de volta para a tela anterior
//           });
//         },
//       ),
//     );
//   }
// }
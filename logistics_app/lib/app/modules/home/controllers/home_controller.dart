import 'package:get/get.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:audioplayers/audioplayers.dart'; // Importe a biblioteca
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final qrCode = ''.obs;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  final AudioPlayer audioPlayer = AudioPlayer(); // Instância do AudioPlayer

//   Future<void> requestStoragePermission() async {
//   // Verifica o status da permissão
//   PermissionStatus status = await Permission.storage.status;

//   if (!status.isGranted) {
//     // Se a permissão não for concedida, solicita-a
//     PermissionStatus newStatus = await Permission.storage.request();
//     if (newStatus.isGranted) {
//       print("Permissão concedida!");
//     } else {
//       print("Permissão negada!");
//     }
//   } else {
//     print("Permissão já concedida.");
//   }
// }

  void startScanning() {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: Get.context!,
      onCode: (String? code) {
        if (code != null && code != qrCode.value) {
          qrCode.value = code;
          playSound(); // Toca o som quando um novo QR Code é escaneado
        }
      },
    );
  }

  void onItemTapped(value) {
    selectedIndex.value = value;
  }

  void playSound() async {
    try {
      await audioPlayer.play(AssetSource('/beep.mp3'));
    } catch (e) {
      print("Erro ao tocar o som: $e");
    }
  }

  @override
  void onInit() {
    //requestStoragePermission();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}

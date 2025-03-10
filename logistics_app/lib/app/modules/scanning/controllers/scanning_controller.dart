import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ScanningController extends GetxController {
final qrCode = ''.obs;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  final AudioPlayer audioPlayer = AudioPlayer(); // Instância do AudioPlayer

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

  void playSound() async {
    try {
      await audioPlayer.play(AssetSource('/beep.mp3'));
    } catch (e) {
      print("Erro ao tocar o som: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}


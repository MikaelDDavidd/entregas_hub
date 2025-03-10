import 'package:audioplayers/audioplayers.dart';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:eaasy_stock/app/modules/home/services/firebase_services.dart';
import 'package:eaasy_stock/app/modules/home/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Pacote para formatação de data
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final count = 0.obs;
  final Function showToast = CustomToast().showToast;
  var qrCode = ''.obs;
  final searchController = TextEditingController();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  var deliveries = <Delivery>[].obs;
  var originalDeliveries = <Delivery>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await loadDeliveriesFromFirebase();
      searchController.addListener(() {
        try {
          filterDeliveries(searchController.text);
        } catch (e) {
          print("Erro no listener do campo de busca: $e");
        }
      });
    } catch (e) {
      print("Erro ao inicializar o controlador: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void addDelivery(Delivery delivery) {
    try {
      if (originalDeliveries
          .any((d) => d.trackingCode == delivery.trackingCode)) {
        showToast("Entrega já registrada.");
        return;
      }
      deliveries.add(delivery);
      originalDeliveries.add(delivery);
    } catch (e) {
      print("Erro ao adicionar entrega: $e");
    }
  }

  void filterDeliveries(String query) {
    try {
      if (query.isEmpty) {
        deliveries.assignAll(originalDeliveries);
      } else {
        deliveries.assignAll(
          originalDeliveries.where((delivery) => delivery.trackingCode
              .toLowerCase()
              .contains(query.toLowerCase())),
        );
      }
    } catch (e) {
      print("Erro ao filtrar entregas: $e");
    }
  }

  Future<void> loadDeliveriesFromFirebase() async {
    try {
      FirebaseServices firebaseServices = FirebaseServices();
      List<Delivery> loadedDeliveries =
          await firebaseServices.fetchDeliveriesFromFirebase();
      deliveries.assignAll(loadedDeliveries);
      originalDeliveries.assignAll(loadedDeliveries);
    } catch (e) {
      print("Erro ao carregar entregas do Firebase: $e");
      showToast("Erro ao carregar entregas do Firebase.");
    }
  }

  void startScanning() {
    try {
      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: Get.context!,
        onCode: (String? code) async {
          if (code != null && code != qrCode.value) {
            qrCode.value = code;

            // Regras de validação
            if (code == "56380000" || code == "56380-000") {
              showToast("Código inválido.");
              return;
            }

            // Verificar se já existe
            final alreadyExists =
                originalDeliveries.any((d) => d.trackingCode == code);
            if (alreadyExists) {
              showToast("Entrega já registrada.");
              return;
            }

            // Criar objeto Delivery
            final delivery = Delivery(
              trackingCode: code,
              registerDate:
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            );

            // Enviar para o Firebase
            try {
              await FirebaseServices().sendDeliveryToFirebase(delivery);
              showToast("Entrega registrada com sucesso!");

              // Adicionar à lista local e atualizar
              addDelivery(delivery);
            } catch (e) {
              showToast("Erro ao registrar entrega: $e");
            }
          }
        },
      );
    } catch (e) {
      print("Erro ao iniciar a leitura do QR Code: $e");
      showToast("Erro ao iniciar a leitura do QR Code.");
    }
  }

  void addManualDelivery(String code) async {
  try {
    // Verifica se o código é inválido
    if (code == "56380000" || code == "56380-000") {
      showToast("Código inválido.");
      return;
    }

    // Verifica se já existe
    final alreadyExists = originalDeliveries.any((d) => d.trackingCode == code);
    if (alreadyExists) {
      showToast("Entrega já registrada.");
      return;
    }

    // Cria o objeto Delivery
    final delivery = Delivery(
      trackingCode: code,
      registerDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );

    // Envia para o Firebase
    try {
      await FirebaseServices().sendDeliveryToFirebase(delivery);
      showToast("Entrega registrada com sucesso!");

      // Adiciona à lista local e recarrega
      addDelivery(delivery);
    } catch (e) {
      showToast("Erro ao registrar entrega: $e");
    }
  } catch (e) {
    print("Erro ao processar código manual: $e");
  }
}

  void playSound() async {
    try {
      await audioPlayer.play(AssetSource('/beep.mp3'));
    } catch (e) {
      print("Erro ao tocar o som: $e");
    }
  }
}

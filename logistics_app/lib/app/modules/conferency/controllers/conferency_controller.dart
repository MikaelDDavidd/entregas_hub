import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ConferencyController extends GetxController {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  final AudioPlayer audioPlayer = AudioPlayer();

  var qrCode = ''.obs;
  var deliveries = <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();
  List<Map<String, dynamic>> originalDeliveries = [];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      filterDeliveries(searchController.text);
    });
    loadDeliveries();
  }

  Future<void> clearDeliveriesLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('deliveries');
      deliveries.clear();
      originalDeliveries.clear();
      showToast("Lista de entregas limpa com sucesso.");
    } catch (e) {
      showToast("Erro ao limpar as entregas: $e");
    }
  }

  void startRegistering() {
    qrCode.value = '';
    startScanning();
  }

  void startScanning() {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: Get.context!,
      onCode: (String? code) {
        if (code != null && code != qrCode.value) {
          qrCode.value = code;
          playSound();
          _registerDeliveryLocally();
        }
      },
    );
  }

  void startRegisteringManually() {
    qrCode.value = '';
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Inserir Código de Rastreamento'),
          content: TextField(
            onChanged: (text) => qrCode.value = text,
            decoration: InputDecoration(hintText: 'Código de Rastreamento'),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (qrCode.value.isNotEmpty) {
                  playSound();
                  _registerDeliveryLocally();
                } else {
                  showToast("Por favor, insira um código de rastreamento.");
                }
              },
              child: Text('Registrar'),
            ),
          ],
        );
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

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> deliverPackage(String trackingCode) async {
    try {
      // Captura a foto usando a câmera
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo == null) {
        showToast("Foto não capturada.");
        return;
      }
      String randomFileName() {
        var uuid = Uuid();
        return 'photo_${uuid.v4()}.png'; // Gera um nome único
      }

      // Salva a foto na galeria
      SaverGallery.saveFile(
        filePath: photo.path,
        fileName: randomFileName(),
        skipIfExists: true,
      );

      final String? galleryPath = await getGalleryPath(photo.path);
      if (galleryPath == null) {
        showToast("Erro ao obter o caminho da foto na galeria.");
        return;
      }

      showToast("Foto salva na galeria com sucesso!");

      // Associa a foto à encomenda local
      final index = deliveries.indexWhere(
        (delivery) => delivery['trackingCode'] == trackingCode,
      );

      if (index != -1) {
        deliveries[index]['photoPath'] = photo.path; // Salva o caminho da foto
        deliveries[index]['delivered'] = true; // Marca como entregue
        deliveries.refresh();

        // Salva as mudanças no armazenamento local
        await saveDeliveries();
        showToast("Encomenda marcada como entregue!");
      } else {
        showToast("Encomenda não encontrada.");
      }
    } catch (e) {
      showToast("Erro ao processar a entrega: $e");
    }
  }

  Future<String?> getGalleryPath(String originalPath) async {
    try {
      final fileName = originalPath.split('/').last;

      final List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList();

      for (var album in albums) {
        // Corrigindo a chamada do método getAssetListPaged:
        final List<AssetEntity> photos =
            await album.getAssetListPaged(page: 0, size: 10000);
        for (var photo in photos) {
          if (photo.title == fileName) {
            return (await photo.file)?.path;
          }
        }
      }
    } catch (e) {
      print("Erro ao obter o caminho da galeria: $e");
    }
    return null;
  }

  void filterDeliveries(String query) {
    if (query.isEmpty) {
      deliveries.assignAll(originalDeliveries);
    } else {
      deliveries.assignAll(
        originalDeliveries
            .where((delivery) =>
                delivery['trackingCode'] != null &&
                delivery['trackingCode']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<void> _registerDeliveryLocally() async {
    try {
      bool isDuplicate = deliveries
          .any((delivery) => delivery['trackingCode'] == qrCode.value);
      if (isDuplicate) {
        showToast("Esta encomenda já foi registrada!");
        return;
      }

      if (qrCode.value.isNotEmpty) {
        final trackingCode = qrCode.value;
        final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
        final registerDate = dateFormat.format(DateTime.now());

        Map<String, dynamic> newDelivery = {
          'trackingCode': trackingCode,
          'registerDate': registerDate,
          'delivered': false,
        };

        deliveries.add(newDelivery);
        originalDeliveries.add(newDelivery);

        await saveDeliveries();
        showToast("Encomenda registrada com sucesso!");
      }
    } catch (e) {
      showToast("Erro ao registrar entrega: $e");
    }
  }

  Future<void> saveDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = jsonEncode(deliveries);
      await prefs.setString('deliveries', deliveriesJson);
    } catch (e) {
      print("Erro ao salvar entregas: $e");
    }
  }

  Future<void> loadDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = prefs.getString('deliveries');

      if (deliveriesJson != null) {
        final List<dynamic> decodedList = jsonDecode(deliveriesJson);
        originalDeliveries = decodedList.cast<Map<String, dynamic>>();
        deliveries.assignAll(originalDeliveries);
      } else {
        deliveries.clear();
      }
    } catch (e) {
      print("Erro ao carregar entregas: $e");
    }
  }

  Future<void> generateExcel() async {
    var excel = Excel.createExcel(); // Cria um novo arquivo Excel
    Sheet sheet = excel['Sheet1']; // Cria a primeira planilha

    // Adiciona cabeçalhos de colunas
    sheet.appendRow([
      TextCellValue('Tracking Code'),
      TextCellValue('Data'),
    ]);

    // Preenche as linhas com os dados das entregas
    for (var delivery in deliveries) {
      var trackingCode = delivery['trackingCode'] ?? '';
      var registerDate =
          DateFormat('dd/MM/yyyy HH:mm').parse(delivery['registerDate'] ?? '');

      var formattedDate = DateFormat('dd/MM/yyyy')
          .format(registerDate); // Formata apenas a data (sem hora)

      sheet.appendRow([
        TextCellValue(trackingCode),
        TextCellValue(formattedDate),
      ]);
    }

    // Gera o nome do arquivo com base na data atual
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String fileName = 'entregas_$currentDate.xlsx';

    // Converte o arquivo para bytes
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      // Obtém o diretório temporário para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();
      String outputPath = "${directory.path}/$fileName";

      // Cria e escreve o arquivo Excel
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // Compartilha o arquivo diretamente no WhatsApp ou outros aplicativos
      await Share.shareXFiles(
        [XFile(outputPath)],
        text: "Confira a tabela de entregas gerada pelo app!",
      );
    } else {
      print("Erro ao gerar o arquivo Excel.");
    }
  }
}

// Atualização no InteriorController
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/modules/interior/views/deliver_dialog.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Necessário para JSON
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class InteriorController extends GetxController {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  final AudioPlayer audioPlayer = AudioPlayer();

  var qrCode = ''.obs;
  var photoPath = "".obs;
  var deliveriesInterior = <Map<String, dynamic>>[].obs;
  final searchController =
      TextEditingController(); // Controlador do campo de busca
  List<Map<String, dynamic>> originalDeliveries = [];

  final String firebaseUrl =
      'https://entrega-hub-default-rtdb.firebaseio.com/.json';

  @override
  void onInit() {
    super.onInit();
    //clearDeliveriesLocally();
    searchController.addListener(() {
      filterDeliveries(searchController.text);
    });
    loadDeliveries(); // Carrega as entregas salvas ao iniciar o app
  }

  Future<void> clearDeliveriesLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(
          'deliveriesInterior'); // Remove o item 'deliveries' do SharedPreferences
      deliveriesInterior.clear(); // Limpa a lista observável de encomendas
      originalDeliveries.clear(); // Limpa a lista original
      showToast("Lista de entregas localmente limpa com sucesso.");
    } catch (e) {
      showToast("Erro ao limpar as entregas localmente: $e");
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
          _takePhoto(qrCode.value);
          // Exibe o diálogo após o scan
        }
      },
    );
  }

  Future<void> _takePhoto(String trackingCode) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        final photoFile = File(photo.path);
        final directory = await getApplicationDocumentsDirectory();
        final randomFileName = '${Uuid().v4()}.jpg';
        final newPath = '${directory.path}/$randomFileName';

        // Salva a foto localmente
        await photoFile.copy(newPath);
        photoPath.value = newPath;
        _showDeliveryDialog(trackingCode, photoPath.value);

        bool saved = await _saveToGallery(photoFile);
        if (saved) {
          showToast("Imagem salva na galeria com sucesso.");
        } else {
          showToast("Falha ao salvar imagem na galeria.");
        }
      }
    } catch (e) {
      showToast("Erro ao tirar foto: $e");
    }
  }

  Future<bool> _saveToGallery(File photoFile) async {
    try {
      // Solicita permissão extendida para acesso à galeria
      final PermissionState ps = await PhotoManager.requestPermissionExtend();

      if (ps.isAuth || ps.hasAccess) {
        // Lê os bytes do arquivo de imagem
        final bytes = await photoFile.readAsBytes();

        // Salva a imagem na galeria
        final assetEntity = await PhotoManager.editor.saveImage(
          bytes,
          filename: '${Uuid().v4()}.jpg',
        );

        if (assetEntity != null) {
          showToast("Imagem salva na galeria com sucesso.");
          return true;
        } else {
          showToast("Falha ao salvar imagem na galeria.");
          return false;
        }
      } else {
        showToast("Permissão negada para acessar a galeria.");
        return false;
      }
    } catch (e) {
      showToast("Erro ao salvar na galeria: $e");
      return false;
    }
  }

  void playSound() async {
    try {
      await audioPlayer.play(AssetSource('/beep.mp3'));
    } catch (e) {
      print("Erro ao tocar o som: $e");
    }
  }

  void showToast(String message) {
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: const Color.fromRGBO(255, 255, 255, 1),
        fontSize: 16.0,
      );
    } catch (e) {
      print(e);
    }
  }

  void filterDeliveries(String query) {
    if (query.isEmpty) {
      deliveriesInterior
          .assignAll(originalDeliveries); // Restaura a lista completa
    } else {
      deliveriesInterior.assignAll(
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

  // Função para filtrar entregas por intervalo de datas
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    deliveriesInterior.assignAll(originalDeliveries.where((delivery) {
      DateTime registerDate =
          DateFormat('dd/MM/yyyy HH:mm').parse(delivery['registerDate']);
      return registerDate.isAfter(startDate) && registerDate.isBefore(endDate);
    }).toList());
  }

  void _showDeliveryDialog(String trackingCode, String onTakePhoto) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return DeliveryDialog(
          trackingCode: trackingCode,
          onTakePhoto: onTakePhoto, // Passa a função para o diálogo
        );
      },
    );
  }

  // Função para salvar a lista de entregas no SharedPreferences
  Future<void> saveDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = jsonEncode(deliveriesInterior);
      await prefs.setString('deliveriesInterior', deliveriesJson);

      // Atualiza a lista original após salvar as entregas
      originalDeliveries.assignAll(deliveriesInterior);
    } catch (e) {
      print("Erro ao salvar entregas: $e");
    }
  }

  // Função para carregar as entregas salvas do SharedPreferences
  Future<void> loadDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = prefs.getString('deliveriesInterior');

      if (deliveriesJson != null) {
        final List<dynamic> decodedList = jsonDecode(deliveriesJson);
        originalDeliveries = decodedList
            .cast<Map<String, dynamic>>(); // Armazena a lista original
        deliveriesInterior.assignAll(
            originalDeliveries); // Preenche deliveries com a lista original
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
    for (var delivery in deliveriesInterior) {
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

  final count = 0.obs;
  void increment() => count.value++;
}

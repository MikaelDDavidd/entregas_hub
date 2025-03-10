import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/app/data/http/custom_http_client.dart';
import 'package:logistics_app/app/data/models/package_model.dart';
import 'package:logistics_app/app/data/repositories/package_repositoriy.dart';
import 'package:logistics_app/app/data/stores/pacakge_store.dart';
import 'package:logistics_app/app/modules/listing/controllers/upload_controller.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:photo_manager/photo_manager.dart'; // Para salvar na galeria
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ListingController extends GetxController {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  // Listas observáveis
  final pendingPackages = <Map<String, dynamic>>[].obs;
// Corrigir para uma RxList para que o GetX possa observar e atualizar
  RxList<Package> deliveredPackages = <Package>[].obs;
  final searchController = TextEditingController();

  // Variável para entrada manual
  final manualCode = ''.obs;

  // Variáveis para imagem e localização
  File? imageFile;
  String location = 'Estante'; // Localização default

  final PackageStore store = PackageStore(
    repository: PackageRepository(
      client: CustomHttpClient(),
    ),
  );

  @override
  void onInit() {
    super.onInit();
    loadPackages(); // Carrega as listas do SharedPreferences, se existirem
    store.getPackages().then((_) {
      // Agora que os pacotes foram carregados, podemos atualizar a lista
      deliveredPackages.value = store.state.value;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Função para iniciar o escaneamento do QR Code
  void startScanning() {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: Get.context!,
      onCode: (String? code) {
        if (code != null) {
          // Chama a captura de imagem após o QR scan
          _captureImageAfterScanning(code);
        }
      },
    );
  }

  // Função para adicionar um pacote manualmente
  void addManualPackage() {
    if (manualCode.value.isNotEmpty) {
      // Chama a captura de imagem após o código manual
      _captureImageAfterScanning(manualCode.value);
      manualCode.value = '';
    }
  }

  // Função para capturar a imagem após o escaneamento
  void _captureImageAfterScanning(String trackingCode) async {
    try {
      final capturedFile = await _captureImage();
      if (capturedFile != null) {
        imageFile = capturedFile;
        _showPackageDialog(trackingCode);
      } else {
        print('Erro: Imagem não foi capturada.');
      }
    } catch (e, stackTrace) {
      print('Erro ao capturar imagem ou exibir diálogo: $e');
      print(stackTrace);
    }
  }

// Função para capturar imagem usando a câmera
  Future<File?> _captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        try {
          final photoFile = File(photo.path);
          final randomFileName = '${Uuid().v4()}.jpg';
          final photoPathToSave =
              '${Directory.systemTemp.path}/$randomFileName';
          await photoFile.copy(photoPathToSave);

          return photoFile;
        } catch (e, stackTrace) {
          print('Erro ao salvar ou manipular imagem: $e');
          print(stackTrace);
          return null;
        }
      } else {
        print('Erro: Nenhuma imagem foi capturada.');
        return null;
      }
    } catch (e, stackTrace) {
      print('Erro ao acessar a câmera: $e');
      print(stackTrace);
      return null;
    }
  }

// Função para exibir o diálogo de informações do pacote
  void _showPackageDialog(String trackingCode) {
    try {
      String ownerName = '';
      Get.dialog(
        AlertDialog(
          title: Text('Informações do Pacote'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Nome do Proprietário'),
                  onChanged: (value) {
                    try {
                      ownerName = value;
                    } catch (e, stackTrace) {
                      print('Erro ao capturar o nome do proprietário: $e');
                      print(stackTrace);
                    }
                  },
                ),
                SizedBox(height: 10),
                Text('Localização'),
                DropdownButton<String>(
                  value: location,
                  onChanged: (newValue) {
                    try {
                      location = newValue!;
                    } catch (e, stackTrace) {
                      print('Erro ao selecionar localização: $e');
                      print(stackTrace);
                    }
                  },
                  items: <String>['Estante', 'Depósito']
                      .map<DropdownMenuItem<String>>((String value) {
                    try {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    } catch (e, stackTrace) {
                      print('Erro ao mapear itens do dropdown: $e');
                      print(stackTrace);
                      return DropdownMenuItem<String>(
                        value: '',
                        child: Text('Erro'),
                      );
                    }
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  Get.back(); // Fecha o diálogo sem salvar
                } catch (e, stackTrace) {
                  print('Erro ao fechar o diálogo: $e');
                  print(stackTrace);
                }
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  if (ownerName.isNotEmpty) {
                    _addPackage(trackingCode, ownerName, imageFile, location);
                  } else {
                    print('Erro: Nome do proprietário é obrigatório!');
                  }
                } catch (e, stackTrace) {
                  print('Erro ao salvar o pacote: $e');
                  print(stackTrace);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('Erro ao exibir o diálogo de informações do pacote: $e');
      print(stackTrace);
    }
  }

  // Função para adicionar um pacote com informações completas
  // Função para adicionar um pacote com informações completas
  void _addPackage(
      String trackingCode, String ownerName, File? imageFile, String location) {
    final newPackage = {
      'trackingCode': trackingCode,
      'ownerName': ownerName,
      'location': location, // Inclui a localização
      'synced': false,
      'imagePath': imageFile?.path,
    };

    // Adiciona o pacote à lista de pendentes
    pendingPackages.add(newPackage);
    _savePackages();

    // Realizar o upload com a imagem
    if (imageFile != null) {
      PackageUploader()
          .uploadPackageWithImage(imageFile, newPackage)
          .then((success) {
        if (success) {
          Get.snackbar('Sucesso', 'Pacote enviado com sucesso!');
          store.getPackages().then((_) {
            // Agora que os pacotes foram carregados, podemos atualizar a lista
            deliveredPackages.value = store.state.value;
          });

          // Remove o pacote da lista de pendentes após o envio com sucesso
          pendingPackages.removeWhere(
              (package) => package['trackingCode'] == trackingCode);

          // Salvar as listas atualizadas
          _savePackages();

          // Recarregar a tela para refletir as mudanças
          loadPackages();
        } else {
          Get.snackbar('Erro', 'Falha ao enviar o pacote!');
        }
      });
    }

    Get.back(); // Fecha o diálogo após adicionar
  }

  // Função para salvar as listas localmente
  Future<void> _savePackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pendingPackages', jsonEncode(pendingPackages));
    await prefs.setString('deliveredPackages', jsonEncode(deliveredPackages));
  }

  // Função para carregar as listas do armazenamento local
  Future<void> loadPackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString('pendingPackages');

    if (pendingJson != null) {
      pendingPackages.value = (jsonDecode(pendingJson) as List)
          .map((e) => Map<String, dynamic>.from(e))
          .where((element) => _isValidPackage(element))
          .toList();
    }
  }

  // Valida se o pacote contém todos os campos necessários
  bool _isValidPackage(Map<String, dynamic> package) {
    return package['trackingCode'] != null &&
        package['ownerName'] != null &&
        package['location'] != null;
  }
}

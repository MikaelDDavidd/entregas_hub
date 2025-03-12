import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:entrega_hub/app/models/package_model.dart';
import 'package:entrega_hub/app/modules/home/controllers/upload_controller.dart';
import 'package:entrega_hub/app/modules/home/widgets/delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as https;

class HomeController extends GetxController {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  final pendingPackages = <Map<String, dynamic>>[].obs;
  var packages = <PackageModel>[].obs;
  var isLoading = false.obs;
  var fetchError = false.obs;
  final searchController = TextEditingController();
  final qrCode = ''.obs;
  File? imageFile;
  String location = 'Estante';

Future<void> fetchData() async {
    isLoading(true);
    fetchError(false);
    try {
      final response = await https
          .get(Uri.parse('http://mikaeldavid.online/api/packages'))
          .timeout(Duration(seconds: 10)); // Timeout de 10 segundos

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Processa os dados normalmente
        packages.assignAll(data.map<PackageModel>((json) => PackageModel.fromJson(json)).toList());
      } else {
        fetchError(true);
        throw Exception('Falha ao carregar pacotes: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      fetchError(true);
      print('Tempo de conexão expirou: $e');
    } on SocketException catch (e) {
      fetchError(true);
      print('Erro de rede: $e');
    } catch (e) {
      fetchError(true);
      print('Erro geral: $e');
    } finally {
      isLoading(false); // Finaliza o carregamento
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    try {
      loadPackages();
      requestPermissions();
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestPermissions() async {
    // Verifica se a permissão para a câmera já foi concedida
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      // Se não foi concedida, solicita a permissão
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        print('Permissão para a câmera não concedida');
        // Você pode informar ao usuário para conceder a permissão
      }
    }

    // Verifica se a permissão para o microfone já foi concedida
    PermissionStatus microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      // Se não foi concedida, solicita a permissão
      microphoneStatus = await Permission.microphone.request();
      if (!microphoneStatus.isGranted) {
        print('Permissão para o microfone não concedida');
        // Similar à câmera, você pode pedir para o usuário conceder a permissão
      }
    }

    // Verifica se a permissão para a galeria já foi concedida
    PermissionStatus galleryStatus = await Permission.photos.status;
    if (!galleryStatus.isGranted) {
      // Se não foi concedida, solicita a permissão
      galleryStatus = await Permission.photos.request();
      if (!galleryStatus.isGranted) {
        print('Permissão para a galeria não concedida');
        // Você pode informar ao usuário para conceder a permissão
      }
    }
  }

  void startScanning() {
    try {
      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: Get.context!,
        onCode: (String? code) {
          if (code != null) {
            qrCode.value = code;
            _captureImageAfterScanning(code);
          }
        },
      );
    } catch (e) {
      print('Erro ao iniciar a leitura do QR Code: $e');
    }
  }

  void addManualPackage() {
    try {
      if (qrCode.value.isNotEmpty) {
        _captureImageAfterScanning(qrCode.value);
        qrCode.value = '';
      }
    } catch (e) {
      print('Erro ao adicionar pacote manualmente: $e');
    }
  }

  void _captureImageAfterScanning(String trackingCode) async {
    try {
      final capturedFile = await _captureImage();
      if (capturedFile != null) {
        imageFile = capturedFile; // Armazena a imagem capturada
        _navigateToDeliveryScreen(trackingCode);
      } else {
        print('Erro: Imagem não foi capturada.');
      }
    } catch (e) {
      print('Erro ao capturar imagem: $e');
    }
  }

  Future<File?> _captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final photoFile = File(photo.path);

        // Gerar um nome de arquivo único
        final randomFileName = '${Uuid().v4()}.jpg';

        // Obter diretório de documentos para armazenamento permanente
        final appDocDir = await getApplicationDocumentsDirectory();
        final photoPathToSave = '${appDocDir.path}/$randomFileName';

        // Copiar o arquivo da imagem para o local permanente
        await photoFile.copy(photoPathToSave);

        print('Imagem salva em: $photoPathToSave');
        return File(photoPathToSave); // Retorna o caminho da imagem salva
      } else {
        print('Erro: Nenhuma imagem capturada.');
        return null;
      }
    } catch (e) {
      print('Erro ao acessar a câmera: $e');
      return null;
    }
  }

  void _navigateToDeliveryScreen(String trackingCode) {
    try {
      // Certifique-se de que a imagem foi salva corretamente antes de navegar
      if (imageFile != null) {
        Get.to(() => DeliveryScreen(), arguments: {
          'trackingCode': trackingCode,
          'imageFile': imageFile,
          'location': location,
        });
      } else {
        print('Erro: Imagem não foi salva corretamente. Navegação abortada.');
      }
    } catch (e) {
      print('Erro ao navegar para a tela de entrega: $e');
    }
  }

  addPackage(
      String ownerName, String relation, String? subRelation, String cpf) {
    try {
      final newPackage = {
        'trackingCode': qrCode.value,
        'ownerName': ownerName,
        'relation': relation,
        'subRelation': subRelation ?? "none",
        'cpf': cpf,
        'location': location,
        'synced': false,
        'imagePath': imageFile?.path,
      };

      pendingPackages.add(newPackage);
      _savePackages();

      if (imageFile != null) {
        PackageUploader().uploadPackageWithImage(imageFile!, newPackage);
      }
      return true;
    } catch (e) {
      print('Erro ao adicionar pacote: $e');
    }
  }

  Future<void> _savePackages() async {
    try {
      print('Salvando pacotes'); // <-- Verifica o conteúdo
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pendingPackages', jsonEncode(pendingPackages));
      print('Pacotes salvos com sucesso!');
    } catch (e, stacktrace) {
      print('Erro ao salvar pacotes: $e');
      print(stacktrace); // <-- Mostra detalhes do erro
    }
  }

  Future<void> loadPackages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getString('pendingPackages');
      if (pendingJson != null) {
        pendingPackages.value = (jsonDecode(pendingJson) as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (e) {
      print('Erro ao carregar pacotes: $e');
    }
  }
}

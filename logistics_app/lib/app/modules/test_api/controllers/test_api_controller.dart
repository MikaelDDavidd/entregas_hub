import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class TestApiController extends GetxController {

  var photoPath = "".obs;

    Future<void> takePhoto() async {
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

        bool saved = await _saveToGallery(photoFile);
        if (saved) {
          showToast("Imagem salva na galeria com sucesso.");
          // Envia a imagem após salvar na galeria
          await enviarImagem(newPath); 
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

        if (assetEntity == true) {
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

    // Função para enviar a imagem (adaptada para usar newPath)
  Future<void> enviarImagem(String newPath) async {
    // Decodifica a imagem original
    var originalImage = img.decodeImage(File(newPath).readAsBytesSync());

    // Converte para PNG com qualidade máxima
    var pngImage = img.encodePng(originalImage!, level: 9);

    // Salva a imagem PNG em um arquivo temporário
    var tempFile = File.fromUri(Uri.parse(newPath + '.png'));
    tempFile.writeAsBytesSync(pngImage);

    var request = http.MultipartRequest('POST', Uri.parse('https://instalike-back-336552304292.southamerica-east1.run.app/upload')); 
    request.files.add(await http.MultipartFile.fromPath('imagem', tempFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Imagem enviada com sucesso!');
      showToast("Imagem enviada com sucesso!");
    } else {
      print('Falha ao enviar imagem: ${response.statusCode}');
      showToast("Falha ao enviar imagem.");
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

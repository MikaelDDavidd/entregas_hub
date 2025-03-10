import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:logistics_app/app/data/api_service.dart';

class PackageUploader {
  final ApiService _apiService = ApiService();

  /// Função para redimensionar a imagem e converter para PNG
  Future<File> _resizeAndCompressImage(File imageFile) async {
    // Decodifica a imagem original
    final originalImage = img.decodeImage(await imageFile.readAsBytes());
    if (originalImage == null) {
      throw "Não foi possível redimensionar a imagem.";
    }

    // Redimensiona a imagem (ajuste o tamanho conforme necessário)
    final resizedImage = img.copyResize(originalImage, width: 800);

    // Converte a imagem para o formato PNG
    final pngBytes = img.encodePng(resizedImage);

    // Cria um arquivo temporário para armazenar a imagem redimensionada e comprimida
    final tempDir = Directory.systemTemp;
    final compressedFile = File('${tempDir.path}/resized_${imageFile.path.split('/').last.split('.').first}.png')
      ..writeAsBytesSync(pngBytes);

    return compressedFile;
  }

  /// Função para enviar um pacote com a imagem
  Future<bool> uploadPackageWithImage(File imageFile, Map<String, dynamic> packageData) async {
    try {
      // 1. Redimensionar e comprimir a imagem para PNG
      final resizedImageFile = await _resizeAndCompressImage(imageFile);

      // 2. Fazer o upload da imagem e obter a URL
      final imageUrl = await _apiService.uploadImage(resizedImageFile);
      if (imageUrl == null) {
        print("Falha ao fazer upload da imagem.");
        return false;
      }

      // 3. Adicionar a URL da imagem ao pacote
      packageData['imageUrl'] = imageUrl;

      // 4. Enviar o pacote para a API
      final success = await _apiService.sendPackage(packageData);
      return success;
    } catch (e) {
      print("Erro ao enviar pacote com imagem: $e");
      return false;
    }
  }
}
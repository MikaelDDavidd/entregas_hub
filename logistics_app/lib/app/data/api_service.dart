import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://191.252.202.88:3000/api';

  // Upload da imagem para o endpoint /upload
  Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await imageFile.readAsBytes(),
          filename: imageFile.path.split('/').last,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print("Response body: $responseData"); // Verifique a resposta
        return responseData; // Retorne a URL diretamente
      } else {
        print("Erro ao fazer upload da imagem: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erro ao conectar com o endpoint /upload: $e");
      return null;
    }
  }

  // Envio dos pacotes para o endpoint /packages
  Future<bool> sendPackage(Map<String, dynamic> packageData) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/packages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(packageData),
      );

      if (response.statusCode == 200) {
        print("Pacote enviado com sucesso!");
        return true;
      } else {
        print("Erro ao enviar pacote: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro ao conectar com o endpoint /packages: $e");
      return false;
    }
  }

  // Recuperação de pacotes do endpoint /packages
  Future<List<Map<String, dynamic>>?> getPackages() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/packages'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print("Erro ao buscar pacotes: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erro ao conectar com o endpoint /packages: $e");
      return null;
    }
  }
}
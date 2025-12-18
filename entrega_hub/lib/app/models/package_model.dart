import 'dart:convert';
import '../config/api_config.dart';

class PackageModel {
  final String id;
  final String trackingCode;
  final String ownerName;
  final String relation;
  final String subRelation;
  final String cpf;
  final String location;
  final String? deliveryMan;
  final bool synced;
  final String imagePath;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PackageModel({
    required this.id,
    required this.trackingCode,
    required this.ownerName,
    required this.relation,
    required this.subRelation,
    required this.cpf,
    required this.location,
    this.deliveryMan,
    required this.synced,
    required this.imagePath,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Método para criar um objeto PackageModel a partir do JSON
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    // Tratamento para pegar a URL da imagem
    String imageUrl = '';
    if (json['imageUrl'] != null) {
      try {
        // Se for uma string simples (URL direta), usa diretamente
        if (json['imageUrl'] is String) {
          String urlString = json['imageUrl'] as String;
          // Tenta decodificar se for JSON
          try {
            var decodedUrl = jsonDecode(urlString);
            if (decodedUrl is Map && decodedUrl.containsKey('url')) {
              imageUrl = decodedUrl['url'];
            } else {
              imageUrl = urlString; // Se não tiver 'url', usa a string direta
            }
          } catch (_) {
            // Se não for JSON, é uma URL simples
            imageUrl = urlString;
          }
        } else if (json['imageUrl'] is Map && json['imageUrl'].containsKey('url')) {
          // Se já for um Map, pega a URL diretamente
          imageUrl = json['imageUrl']['url'];
        }
      } catch (e) {
        print('Erro ao decodificar a URL: $e');
        imageUrl = '';
      }
    }

    // Parse das datas
    DateTime? createdAt;
    DateTime? updatedAt;

    try {
      if (json['createdAt'] != null) {
        if (json['createdAt'] is String) {
          createdAt = DateTime.parse(json['createdAt']);
        } else if (json['createdAt'] is Map && json['createdAt'].containsKey('\$date')) {
          createdAt = DateTime.parse(json['createdAt']['\$date']);
        }
      }

      if (json['updatedAt'] != null) {
        if (json['updatedAt'] is String) {
          updatedAt = DateTime.parse(json['updatedAt']);
        } else if (json['updatedAt'] is Map && json['updatedAt'].containsKey('\$date')) {
          updatedAt = DateTime.parse(json['updatedAt']['\$date']);
        }
      }
    } catch (e) {
      print('Erro ao parsear datas: $e');
    }

    return PackageModel(
      id: json['_id'] ?? '',
      trackingCode: json['trackingCode'] ?? '',
      ownerName: json['ownerName'] ?? '',
      relation: json['relation'] ?? '',
      subRelation: json['subRelation'] ?? 'none',
      cpf: json['cpf'] ?? '',
      location: json['location'] ?? '',
      deliveryMan: json['deliveryMan'],
      synced: json['synced'] ?? false,
      imagePath: json['imagePath'] ?? '',
      imageUrl: _normalizeImageUrl(imageUrl),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String _normalizeImageUrl(String url) {
    if (url.isEmpty) return url;
    final regex = RegExp(r'http://[\d.]+:3000');
    return url.replaceFirst(regex, ApiConfig.uploadsUrl);
  }
}
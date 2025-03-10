import 'dart:convert'; // Necessário para o jsonDecode

class PackageModel {
  final String id;
  final String trackingCode;
  final String ownerName;
  final String relation;
  final String subRelation;
  final String cpf;
  final String location;
  final bool synced;
  final String imagePath;
  final String imageUrl;

  PackageModel({
    required this.id,
    required this.trackingCode,
    required this.ownerName,
    required this.relation,
    required this.subRelation,
    required this.cpf,
    required this.location,
    required this.synced,
    required this.imagePath,
    required this.imageUrl,
  });

  // Método para criar um objeto PackageModel a partir do JSON
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    // Tratamento para pegar a URL de dentro da string JSON
    String imageUrl = '';
    if (json['imageUrl'] != null) {
      try {
        // Se a string for uma representação JSON válida, converta-a
        var decodedUrl = jsonDecode(json['imageUrl']);
        // Verifique se a chave 'url' existe
        if (decodedUrl is Map && decodedUrl.containsKey('url')) {
          imageUrl = decodedUrl['url'];
        }
      } catch (e) {
        // Caso a string não seja um JSON válido, ou outra exceção ocorra, retorna uma string vazia
        print('Erro ao decodificar a URL: $e');
      }
    }

    return PackageModel(
      id: json['_id'],
      trackingCode: json['trackingCode'],
      ownerName: json['ownerName'],
      relation: json['relation'],
      subRelation: json['subRelation'],
      cpf: json['cpf'],
      location: json['location'],
      synced: json['synced'],
      imagePath: json['imagePath'],
      imageUrl: imageUrl, // A URL já está tratada
    );
  }
}
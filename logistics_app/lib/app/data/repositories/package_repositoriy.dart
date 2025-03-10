import 'dart:convert';

import 'package:logistics_app/app/data/http/exceptions.dart';
import 'package:logistics_app/app/data/http/custom_http_client.dart';
import 'package:logistics_app/app/data/models/package_model.dart';

abstract class iPackageRepository {
  Future<List<Package>> getPackages();
}

class PackageRepository implements iPackageRepository {
  final IHttpClient client;

  PackageRepository({required this.client});

  @override
  Future<List<Package>> getPackages() async {
    final response =
        await client.get(url: "http://mikaeldavid.online/api/packages");

    if (response.statusCode == 200) {
      final List<Package> packages = [];
      final body = jsonDecode(response.body);

      // Garantir que o campo 'data' existe e é uma lista
      if (body['data'] is List) {
        body['data'].forEach((item) {
          // Aqui, você pode desserializar o campo 'imageUrl' corretamente
          var imageUrl = jsonDecode(item['imageUrl']);
          item['imageUrl'] =
              imageUrl['url']; // Agora 'imageUrl' contém a URL correta

          final Package package = Package.fromJson(item);
          packages.add(package);
        });
      } else {
        print('Campo "data" não é uma lista');
      }

      print('Packages Loaded: $packages');
      return packages;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar os produtos');
    }
  }
}

import 'dart:convert';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  final String firebaseUrl =
      'https://entrega-hub-default-rtdb.firebaseio.com/.json';

  Future<List<Delivery>> fetchDeliveriesFromFirebase() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        List<Delivery> fetchedDeliveries = [];

        data.forEach((key, delivery) {
          try {
            fetchedDeliveries.add(
              Delivery(
                trackingCode: delivery['trackingCode'] ?? '',
                registerDate: delivery['registerDate'] ?? '',
              ),
            );
          } catch (e) {
            print("Erro ao formatar entrega: $e");
          }
        });

        return fetchedDeliveries;
      } else {
        print("Erro ao buscar entregas do Firebase: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro ao buscar entregas do Firebase: $e");
      return [];
    }
  }

  Future<void> sendDeliveryToFirebase(Delivery delivery) async {
    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(delivery.toJson()),
      );

      if (response.statusCode != 200) {
        print("Erro ao enviar entrega para o Firebase: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao enviar entrega para o Firebase: $e");
      rethrow;
    }
  }
}

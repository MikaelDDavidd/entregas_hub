import 'dart:convert';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:eaasy_stock/app/modules/home/controllers/home_controller.dart';
import 'package:eaasy_stock/app/modules/home/widgets/custom_toast.dart';

class FirebaseServices {
  final String firebaseUrl =
      'https://entrega-hub-default-rtdb.firebaseio.com/.json';
  final Function showToast = CustomToast().showToast;

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

        showToast("Entregas carregadas com sucesso!");
        return fetchedDeliveries;
      } else {
        showToast("Erro ao buscar entregas: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      showToast("Erro ao buscar entregas: $e");
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

      if (response.statusCode == 200) {
        showToast("Entrega enviada com sucesso!");
      } else {
        showToast("Erro ao enviar entrega.");
      }
    } catch (e) {
      showToast("Erro ao enviar entrega: $e");
    }
  }
}  final String firebaseUrl =
      'https://entrega-hub-default-rtdb.firebaseio.com/.json';
  final Function showToast = CustomToast().showToast;

  final HomeController homeController = Get.find<HomeController>();

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

      showToast("Entregas carregadas com sucesso do Firebase!");
      return fetchedDeliveries;
    } else {
      showToast("Erro ao buscar entregas do Firebase: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    showToast("Erro ao buscar entregas do Firebase: $e");
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

      if (response.statusCode == 200) {
        showToast("Entrega enviada para o Firebase com sucesso!");
      } else {
        showToast("Erro ao enviar entrega para o Firebase.");
      }
    } catch (e) {
      showToast("Erro ao enviar entrega para o Firebase: $e");
    }
  }
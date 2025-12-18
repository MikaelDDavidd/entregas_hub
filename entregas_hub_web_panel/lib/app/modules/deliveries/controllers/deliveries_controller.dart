import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeliveriesController extends GetxController {
  final String baseUrl = 'http://localhost:3000/api';

  var isLoading = false.obs;
  var deliveryMen = <Map<String, dynamic>>[].obs;
  var selectedDeliveryMan = Rxn<String>();
  var deliveriesForSelectedMan = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryMen();
  }

  Future<void> fetchDeliveryMen() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('$baseUrl/deliverymen'));

      // Delay mínimo para mostrar skeleton
      await Future.delayed(const Duration(milliseconds: 300));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        deliveryMen.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('Erro ao carregar entregadores: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar entregadores: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectDeliveryMan(String name) async {
    try {
      selectedDeliveryMan.value = name;
      isLoading(true);

      final response = await http.get(
        Uri.parse('$baseUrl/packages?deliveryMan=${name.toLowerCase()}'),
      );

      // Delay mínimo para mostrar skeleton
      await Future.delayed(const Duration(milliseconds: 300));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        deliveriesForSelectedMan.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('Erro ao carregar entregas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar entregas: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteDelivery(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/packages/$id'),
      );

      if (response.statusCode == 200) {
        print('Entrega deletada com sucesso');

        // Recarrega a lista
        if (selectedDeliveryMan.value != null) {
          await selectDeliveryMan(selectedDeliveryMan.value!);
        }
        await fetchDeliveryMen();
      } else {
        print('Falha ao deletar entrega: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao deletar entrega: $e');
    }
  }

  Future<void> deleteAllDeliveriesForMan(String deliveryMan) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/packages/deliveryman/${deliveryMan.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Sucesso: ${data['message']}');

        selectedDeliveryMan.value = null;
        deliveriesForSelectedMan.clear();
        await fetchDeliveryMen();
      } else {
        print('Falha ao deletar entregas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao deletar entregas: $e');
    }
  }

  void clearSelection() {
    selectedDeliveryMan.value = null;
    deliveriesForSelectedMan.clear();
  }
}

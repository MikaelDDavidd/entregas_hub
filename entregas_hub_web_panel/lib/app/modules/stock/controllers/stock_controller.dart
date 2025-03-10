import 'package:entregas_hub_web_panel/app/services/firebase_service.dart';
import 'package:get/get.dart';
import 'package:entregas_hub_web_panel/app/models/delivery_model.dart';

class StockController extends GetxController {
  final FirebaseServices firebaseServices = FirebaseServices();

  // Pacotes organizados por data
  final packagesByDate = <String, List<Delivery>>{}.obs;

  // Flag para indicar carregamento
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages(); // Busca inicial dos pacotes
  }

  // Função de busca de pacotes por código de rastreio
  void searchPackages(String query) {
    if (query.isEmpty) {
      refreshPackages(); // Restaura a lista original
      return;
    }

    final filteredPackages = <String, List<Delivery>>{};

    packagesByDate.forEach((date, deliveries) {
      // Filtra pacotes pelo trackingCode
      final filteredDeliveries = deliveries
          .where((delivery) =>
              delivery.trackingCode.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (filteredDeliveries.isNotEmpty) {
        filteredPackages[date] = filteredDeliveries;
      }
    });

    packagesByDate.value = filteredPackages; // Atualiza a lista filtrada
  }

  // Função para buscar pacotes do Firebase
  Future<void> fetchPackages() async {
    isLoading.value = true;
    try {
      // Busca pacotes do Firebase
      List<Delivery> fetchedDeliveries =
          await firebaseServices.fetchDeliveriesFromFirebase();

      if (fetchedDeliveries.isNotEmpty) {
        // Organiza os pacotes por data
        organizePackagesByDate(fetchedDeliveries);
      } else {
        print("Nenhum pacote encontrado no Firebase.");
      }
    } catch (e, stackTrace) {
      print("Erro ao recuperar pacotes do Firebase: $e");
      print("StackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

// Função para normalizar datas no formato yyyy-MM-dd
  String normalizeDate(String date) {
    try {
      // Verifica se já está no formato yyyy-MM-dd
      if (date.contains('-')) {
        return date;
      }

      // Converte formato dd/MM/yyyy para yyyy-MM-dd
      final parts = date.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}'; // yyyy-MM-dd
      }
    } catch (e) {
      print("Erro ao normalizar a data: $date");
    }
    return ''; // Retorna uma string vazia se a conversão falhar
  }

// Organiza pacotes por data de registro em ordem decrescente
  void organizePackagesByDate(List<Delivery> deliveries) {
    final Map<String, List<Delivery>> grouped = {};

    for (var delivery in deliveries) {
      // Normaliza a data antes de usar
      final date = normalizeDate(delivery.registerDate.split(' ').first);

      if (date.isEmpty) {
        print("Data inválida ignorada: ${delivery.registerDate}");
        continue;
      }

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(delivery);
    }

    // Ordena as chaves (datas) em ordem decrescente
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          return DateTime.parse(b).compareTo(DateTime.parse(a));
        } catch (e) {
          print("Erro ao converter data: $a ou $b");
          return 0; // Caso ocorra um erro, não altera a ordem
        }
      });

    // Cria um novo mapa com as chaves ordenadas
    final sortedGrouped = {
      for (var key in sortedKeys) key: grouped[key]!,
    };

    // Atualiza os dados agrupados no Observable
    packagesByDate.value = sortedGrouped;
  }

  // Atualiza manualmente os pacotes
  Future<void> refreshPackages() async {
    await fetchPackages();
  }
}

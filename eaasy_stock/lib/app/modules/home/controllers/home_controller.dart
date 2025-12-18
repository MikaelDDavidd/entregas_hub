import 'dart:async';
import 'dart:developer' as dev;
import 'package:audioplayers/audioplayers.dart';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:eaasy_stock/app/modules/home/services/excel_services.dart';
import 'package:eaasy_stock/app/modules/home/services/firebase_services.dart';
import 'package:eaasy_stock/app/modules/home/widgets/custom_toast.dart';
import 'package:eaasy_stock/app/utils/delivery_processor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class HomeController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final count = 0.obs;
  final Function showToast = CustomToast().showToast;
  var qrCode = ''.obs;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  var deliveries = <Delivery>[].obs;
  var displayedDeliveries = <Delivery>[].obs;
  var originalDeliveries = <Delivery>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isFiltered = false.obs;
  RxBool hasMore = true.obs;
  RxBool isScanning = false.obs;
  Timer? _debounce;
  final int pageSize = 20;
  int currentPage = 0;

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await loadDeliveriesFromFirebase();
      searchController.addListener(_onSearchChanged);
      scrollController.addListener(_onScroll);
      _loadMoreItems();
    } catch (e) {
      print("Erro ao inicializar o controlador: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.removeListener(_onScroll);
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        hasMore.value) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    final startIndex = currentPage * pageSize;
    final endIndex = (currentPage + 1) * pageSize;

    dev.log('📄 [HomeController] Loading page $currentPage: $startIndex-$endIndex');

    if (startIndex >= deliveries.length) {
      hasMore.value = false;
      isLoadingMore.value = false;
      return;
    }

    await Future.delayed(Duration(milliseconds: 200));

    final nextItems = deliveries.sublist(
      startIndex,
      endIndex > deliveries.length ? deliveries.length : endIndex,
    );

    displayedDeliveries.addAll(nextItems);
    currentPage++;

    if (displayedDeliveries.length >= deliveries.length) {
      hasMore.value = false;
    }

    dev.log('📊 [HomeController] Displayed: ${displayedDeliveries.length} / ${deliveries.length}');
    isLoadingMore.value = false;
  }

  Future<void> _resetPagination() async {
    dev.log('🔄 [HomeController] Reset pagination - Total: ${deliveries.length}');
    currentPage = 0;
    displayedDeliveries.clear();
    hasMore.value = true;
    await _loadMoreItems();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterDeliveries(searchController.text);
    });
  }

  void addDelivery(Delivery delivery) {
    try {
      if (originalDeliveries
          .any((d) => d.trackingCode == delivery.trackingCode)) {
        showToast("Entrega já registrada.");
        return;
      }
      deliveries.insert(0, delivery);
      originalDeliveries.insert(0, delivery);
      displayedDeliveries.insert(0, delivery);
    } catch (e) {
      print("Erro ao adicionar entrega: $e");
    }
  }

  Future<void> filterDeliveries(String query) async {
    try {
      final filtered = DeliveryProcessor.filterByText(originalDeliveries, query);
      deliveries.assignAll(filtered);
      await _resetPagination();
    } catch (e) {
      print("Erro ao filtrar entregas: $e");
    }
  }

  Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      dev.log('📅 [HomeController] Filter: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}');

      displayedDeliveries.clear();
      isLoading.value = true;
      isFiltered.value = true;

      final filtered = await DeliveryProcessor.filterByDateRange(
        originalDeliveries,
        startDate,
        endDate,
      );

      deliveries.assignAll(filtered);
      await _resetPagination();

      dev.log('✅ [HomeController] Filter complete: ${displayedDeliveries.length} displayed');
      showToast("Filtro aplicado: ${deliveries.length} entregas encontradas");
    } catch (e) {
      dev.log('❌ [HomeController] Filter error: $e');
      showToast("Erro ao aplicar filtro");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearFilter() async {
    try {
      dev.log('🗑️ [HomeController] Clear filter');
      displayedDeliveries.clear();
      isLoading.value = true;
      isFiltered.value = false;
      deliveries.assignAll(originalDeliveries);
      await _resetPagination();
      showToast("Filtro removido");
    } catch (e) {
      dev.log('❌ [HomeController] Clear filter error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDeliveriesFromFirebase() async {
    try {
      isLoading.value = true;
      FirebaseServices firebaseServices = FirebaseServices();
      List<Delivery> loadedDeliveries =
          await firebaseServices.fetchDeliveriesFromFirebase();
      deliveries.assignAll(loadedDeliveries);
      originalDeliveries.assignAll(loadedDeliveries);
      await _resetPagination();
    } catch (e) {
      print("Erro ao carregar entregas do Firebase: $e");
      showToast("Erro ao carregar entregas do Firebase.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncWithFirebase() async {
    try {
      isLoading.value = true;
      showToast("Sincronizando com Firebase...");
      await loadDeliveriesFromFirebase();
      showToast("Sincronização concluída!");
    } catch (e) {
      print("Erro ao sincronizar: $e");
      showToast("Erro ao sincronizar com Firebase");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportToExcel() async {
    try {
      if (deliveries.isEmpty) {
        showToast("Nenhuma entrega para exportar");
        return;
      }

      showToast("Gerando planilha Excel...");
      ExcelServices excelServices = ExcelServices();
      await excelServices.generateExcel(deliveries);
      showToast("Planilha Excel gerada com sucesso!");
    } catch (e) {
      print("Erro ao exportar para Excel: $e");
      showToast("Erro ao gerar planilha Excel");
    }
  }

  void startScanning() {
    if (isScanning.value) {
      print('Scanner já está ativo');
      return;
    }

    try {
      isScanning.value = true;

      Future.delayed(Duration(seconds: 30), () {
        if (isScanning.value) {
          isScanning.value = false;
          print('Scanner timeout - resetando estado');
        }
      });

      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: Get.context!,
        onCode: (String? code) async {
          if (!isScanning.value) return;

          isScanning.value = false;
          if (code != null && code.isNotEmpty && code != qrCode.value) {
            qrCode.value = code;

            if (code == "56380000" || code == "56380-000") {
              showToast("Código inválido.");
              return;
            }

            final alreadyExists =
                originalDeliveries.any((d) => d.trackingCode == code);
            if (alreadyExists) {
              showToast("Entrega já registrada.");
              return;
            }

            final delivery = Delivery(
              trackingCode: code,
              registerDate:
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            );

            try {
              await FirebaseServices().sendDeliveryToFirebase(delivery);
              showToast("Entrega registrada com sucesso!");
              addDelivery(delivery);
            } catch (e) {
              showToast("Erro ao registrar entrega: $e");
            }
          } else {
            print("Scanner cancelado ou código vazio");
          }
        },
      );
    } catch (e) {
      isScanning.value = false;
      print("Erro ao iniciar a leitura do QR Code: $e");
      showToast("Erro ao iniciar a leitura do QR Code.");
    }
  }

  void addManualDelivery(String code) async {
    try {
      if (code == "56380000" || code == "56380-000") {
        showToast("Código inválido.");
        return;
      }

      final alreadyExists =
          originalDeliveries.any((d) => d.trackingCode == code);
      if (alreadyExists) {
        showToast("Entrega já registrada.");
        return;
      }

      final delivery = Delivery(
        trackingCode: code,
        registerDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      try {
        await FirebaseServices().sendDeliveryToFirebase(delivery);
        showToast("Entrega registrada com sucesso!");
        addDelivery(delivery);
      } catch (e) {
        showToast("Erro ao registrar entrega: $e");
      }
    } catch (e) {
      print("Erro ao processar código manual: $e");
    }
  }

  void playSound() async {
    try {
      await audioPlayer.play(AssetSource('/beep.mp3'));
    } catch (e) {
      print("Erro ao tocar o som: $e");
    }
  }
}

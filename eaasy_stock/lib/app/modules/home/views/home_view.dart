import 'package:eaasy_stock/app/modules/home/widgets/filter_dialog.dart';
import 'package:eaasy_stock/app/modules/home/widgets/manual_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eaasy Stock".tr),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        actions: [
          PopupMenuButton<String>(
            color: Colors.grey[100],
            onSelected: (value) {
              // Ação para cada opção selecionada no menu
              print('Você escolheu: $value');
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Export',
                  child: Row(
                    children: [
                      Icon(Icons.upload),
                      Text('Export'.tr),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Sync',
                  child: Row(
                    children: [
                      Icon(Icons.sync),
                      Text('Sync'.tr),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Botão de Escaneamento (Scan)
                      Expanded(
                        flex: 2, // Botão ocupa mais espaço
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(0,
                                60), // Altura definida, largura ajusta-se ao espaço
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 5,
                          ),
                          label: Text(
                            'Scan'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(
                            Icons
                                .qr_code_scanner, // Ícone específico para scanner
                            size: 24,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.startScanning();
                          },
                        ),
                      ),
                      const SizedBox(width: 10), // Espaço entre os botões

                      // Botão de Inserção Manual
                      Expanded(
                        flex: 1, // Botão ocupa menos espaço
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .green, // Cor diferente para diferenciá-lo
                            minimumSize: const Size(0,
                                60), // Altura definida, largura ajusta-se ao espaço
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 5,
                          ),
                          label: Text(
                            '', // Texto diferenciado
                            style: const TextStyle(
                              fontSize: 16, // Fonte menor
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(
                            Icons
                                .edit_note, // Ícone que representa entrada manual
                            size: 22,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => ManualCodeDialog(
                                onSubmit: (String code) {
                                  final homeController =
                                      Get.find<HomeController>();
                                  homeController.addManualDelivery(code);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search".tr,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'Scanned'.tr}: ${controller.deliveries.length}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          //   FilterDialog().showDateFilterDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.deliveries.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No deliveries found.'.tr,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final delivery = controller.deliveries[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.local_shipping,
                              color: Colors.blueAccent),
                          title: Text(
                            'Código: ${delivery.trackingCode ?? "N/A"}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Data: ${delivery.registerDate ?? "N/A"}',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            print('Selecionou ${delivery.trackingCode}');
                          },
                        ),
                      );
                    },
                    childCount: controller.deliveries.length,
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}

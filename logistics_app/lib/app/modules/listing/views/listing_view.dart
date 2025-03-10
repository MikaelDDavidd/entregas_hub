import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/widgets/package_container.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import '../controllers/listing_controller.dart';

class ListingView extends GetView<ListingController> {
  const ListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                ),
                label: const Text(
                  "Scan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(Icons.qr_code, size: 24, color: Colors.white),
                onPressed: () {},
                //    onPressed: () => controller.searchScanning(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          // Barra de pesquisa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Pesquisar Encomendas",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
          ),
          // Contador de encomendas entregues
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Obx(() {
                return Text(
                    'Entregues: ${controller.deliveredPackages.length}');
              }),
            ),
          ),
          // Lista de encomendas entregues
          Obx(() {
            final deliveredPackages = controller.deliveredPackages;
            return deliveredPackages.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                        child: Text('Nenhuma encomenda entregue encontrada')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final package = deliveredPackages[index];
                        final isDelivered = true;
                        final photoPath = package.imageUrl;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: PackageContainer(
                            trackingCode: package.trackingCode,
                            ownerName: package.ownerName,
                            isDelivered: isDelivered,
                            imageUrl: photoPath, // Passando a URL para imagem
                            onTap: () {
                              // Ação ao clicar no item
                            },
                          ),
                        );
                      },
                      childCount: deliveredPackages.length,
                    ),
                  );
          }),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Obx(() {
                return Text('Pendentes: ${controller.pendingPackages.length}');
              }),
            ),
          ),
          // Lista de encomendas pendentes
          Obx(() {
            final filteredPackages = controller.pendingPackages;
            return filteredPackages.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                        child: Text('Nenhuma encomenda pendente encontrada')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final package = filteredPackages[index];
                        final isDelivered = package['delivered'] == true;
                        final photoPath = package['imagePath'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: PackageContainer(
                            trackingCode: package['trackingCode'] ??
                                'Código desconhecido',
                            ownerName: package['ownerName'] ?? 'Sem nome',
                            isDelivered: isDelivered,
                            photoPath: photoPath,
                            onTap: () {
                              // Ação ao clicar no item
                            },
                          ),
                        );
                      },
                      childCount: filteredPackages.length,
                    ),
                  );
          }),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.add),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: 'Escanear QR Code',
            onPressed: () => controller.startScanning(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Inserir Manualmente',
            onPressed: () => _showManualEntryDialog(context),
          ),
        ],
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: const Text('Inserir Código Manualmente'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Código',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.manualCode.value = textController.text;
                controller.addManualPackage();
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}

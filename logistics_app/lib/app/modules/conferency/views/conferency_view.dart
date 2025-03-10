import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/modules/conferency/views/tracking_dialog.dart';
import '../controllers/conferency_controller.dart';

class ConferencyView extends GetView<ConferencyController> {
  const ConferencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                  elevation: 5,
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
                onPressed: () => controller.startRegistering(),
                onLongPress: () => controller.clearDeliveriesLocally(),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                  elevation: 5,
                ),
                label: const Text(
                  "Inserir Manualmente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(Icons.edit, size: 24, color: Colors.white),
                onPressed: () => controller.startRegisteringManually(),
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
                onChanged: (value) => controller.filterDeliveries(value),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return Text(
                  'Encomendas Entregues (${controller.deliveries.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          Obx(() {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final encomenda = controller.deliveries[index];
                  final isDelivered = encomenda['delivered'] == true;
                  final photoPath = encomenda['photoPath'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Colors.white,
                      child: ListTile(
                        leading: photoPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(photoPath),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.local_shipping,
                                color: isDelivered
                                    ? Colors.green
                                    : Colors.blueAccent,
                                size: 40,
                              ),
                        title: Text(
                          'Código: ${encomenda["trackingCode"] ?? "Não disponível"}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        subtitle: Text(
                          isDelivered ? 'Entregue' : 'Pendente',
                          style: TextStyle(
                            color: isDelivered ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        onTap: () {
                          if (isDelivered) {
                            showDialog(
                              context: context,
                              builder: (context) => TrackingDialog(
                                trackingCode: encomenda["trackingCode"],
                                imagePath: photoPath,
                              ),
                            );
                          } else {
                            controller.deliverPackage(encomenda["trackingCode"]);
                          }
                        },
                      ),
                    ),
                  );
                },
                childCount: controller.deliveries.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
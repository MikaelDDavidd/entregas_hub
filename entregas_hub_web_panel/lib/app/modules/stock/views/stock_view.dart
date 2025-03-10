import 'package:entregas_hub_web_panel/app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/stock_controller.dart';

class StockView extends GetView<StockController> {
  const StockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacotes por Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshPackages,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.searchPackages(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Pesquisar por código de rastreio...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() {
              int totalPackages = 0;
              controller.packagesByDate.forEach((key, value) {
                totalPackages += value.length;
              });

              return Text(
                'Total de Pacotes: $totalPackages',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.packagesByDate.isEmpty) {
                return const Center(child: Text('Nenhum pacote encontrado.'));
              }

              return ListView(
                children: controller.packagesByDate.entries.map((entry) {
                  final date = entry.key;
                  final deliveries = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Apuração: $date',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              '${deliveries.length} Pacotes',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: deliveries.map((delivery) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  title: Text(
                                    'Código: ${delivery.trackingCode}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Registrado em: ${delivery.registerDate}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () => _showQRCodeDialog(
                                    context,
                                    delivery.trackingCode,
                                  ),
                                ),
                                if (delivery != deliveries.last)
                                  const Divider(),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context, String trackingCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('QR Code do Pacote'),
          content: SizedBox(
            width: 200.0,
            height: 300.0,
            child: Column(
              children: [
                QrImageView(
                  data: trackingCode,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                Text(trackingCode, style: AppTextStyles.bodyLarge,),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

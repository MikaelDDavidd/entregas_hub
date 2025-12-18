import 'package:entregas_hub_web_panel/app/modules/stock/widgets/delivery_group_widget.dart';
import 'package:entregas_hub_web_panel/app/modules/stock/widgets/qr_code_dialog.dart';
import 'package:entregas_hub_web_panel/app/modules/stock/widgets/search_bar_widget.dart';
import 'package:entregas_hub_web_panel/app/modules/stock/widgets/stock_header_widget.dart';
import 'package:entregas_hub_web_panel/app/theme/colors.dart';
import 'package:entregas_hub_web_panel/app/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/stock_controller.dart';

class StockView extends GetView<StockController> {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondaryColor,
                    AppColors.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                PhosphorIcons.package(PhosphorIconsStyle.duotone),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Estoque de Pacotes'),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.arrowsClockwise()),
            tooltip: 'Atualizar',
            onPressed: controller.refreshPackages,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SearchBarWidget(
            controller: searchController,
            onChanged: controller.searchPackages,
          ),
          Obx(() {
            int totalPackages = 0;
            controller.packagesByDate.forEach((key, value) {
              totalPackages += value.length;
            });
            return StockHeaderWidget(totalPackages: totalPackages);
          }),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SingleChildScrollView(
                  child: DeliveriesListSkeleton(
                    itemCount: 8,
                    showDateHeader: true,
                  ),
                );
              }

              if (controller.packagesByDate.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.iconColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          PhosphorIcons.package(PhosphorIconsStyle.duotone),
                          size: 64,
                          color: AppColors.iconColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Nenhum pacote encontrado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Os pacotes aparecerão aqui assim que forem registrados',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                children: controller.packagesByDate.entries.map((entry) {
                  return DeliveryGroupWidget(
                    date: entry.key,
                    deliveries: entry.value,
                    onDeliveryTap: (trackingCode) {
                      QRCodeDialog.show(context, trackingCode);
                    },
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:entregas_hub_web_panel/app/modules/deliveries/controllers/deliveries_controller.dart';
import 'package:entregas_hub_web_panel/app/theme/colors.dart';
import 'package:entregas_hub_web_panel/app/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeliveriesView extends GetView<DeliveriesController> {
  const DeliveriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Obx(() {
        if (controller.selectedDeliveryMan.value == null) {
          return _buildDeliveryMenGrid();
        } else {
          return _buildDeliveriesList();
        }
      }),
    );
  }

  Widget _buildDeliveryMenGrid() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIcons.truck(PhosphorIconsStyle.duotone),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entregas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Selecione um entregador para ver as entregas',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => controller.fetchDeliveryMen(),
                icon: const Icon(Icons.refresh, color: AppColors.primaryColor),
                tooltip: 'Atualizar',
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const DeliveryManGridSkeleton(itemCount: 6);
            }

            if (controller.deliveryMen.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PhosphorIcons.user(PhosphorIconsStyle.duotone),
                        size: 64,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nenhum entregador encontrado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quando houver entregas, os entregadores aparecerão aqui',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(Get.context!).size.width > 1200
                    ? 4
                    : MediaQuery.of(Get.context!).size.width > 800
                        ? 3
                        : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: controller.deliveryMen.length,
              itemBuilder: (context, index) {
                final deliveryMan = controller.deliveryMen[index];
                return _buildDeliveryManCard(deliveryMan);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeliveryManCard(Map<String, dynamic> deliveryMan) {
    final name = deliveryMan['name'] as String;
    final count = deliveryMan['count'] as int;

    return InkWell(
      onTap: () => controller.selectDeliveryMan(name),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.2),
                      AppColors.primaryLight.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.user(PhosphorIconsStyle.duotone),
                  size: 28,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count ${count == 1 ? 'entrega' : 'entregas'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveriesList() {
    final deliveryMan = controller.selectedDeliveryMan.value!;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => controller.clearSelection(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                tooltip: 'Voltar',
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.2),
                      AppColors.primaryLight.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIcons.user(PhosphorIconsStyle.duotone),
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deliveryMan,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        '${controller.deliveriesForSelectedMan.length} ${controller.deliveriesForSelectedMan.length == 1 ? 'entrega' : 'entregas'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      )),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _showDeleteAllDialog(deliveryMan),
                icon: const Icon(Icons.delete_sweep, size: 20),
                label: const Text('Deletar Todas'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const DeliveryListSkeleton(itemCount: 5);
            }

            if (controller.deliveriesForSelectedMan.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PhosphorIcons.package(PhosphorIconsStyle.duotone),
                        size: 64,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nenhuma entrega encontrada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: controller.deliveriesForSelectedMan.length,
              itemBuilder: (context, index) {
                final delivery = controller.deliveriesForSelectedMan[index];
                return _buildDeliveryCard(delivery);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> delivery) {
    final trackingCode = delivery['trackingCode'] ?? 'N/A';
    final ownerName = delivery['ownerName'] ?? 'Sem nome';
    final location = delivery['location'] ?? 'N/A';
    final createdAt = delivery['createdAt'];
    final imageUrl = delivery['imageUrl'] ?? '';

    String formattedDate = 'Data não disponível';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = DateFormat('dd/MM/yyyy \'às\' HH:mm').format(date);
      } catch (e) {
        // Keep default value
      }
    }

    return InkWell(
      onTap: () => _showPackageDetailsDialog(delivery),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor.withValues(alpha: 0.2),
                                    AppColors.primaryLight.withValues(alpha: 0.1),
                                  ],
                                ),
                              ),
                              child: Icon(
                                PhosphorIcons.package(PhosphorIconsStyle.duotone),
                                color: AppColors.primaryColor,
                                size: 32,
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor.withValues(alpha: 0.2),
                                AppColors.primaryLight.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Icon(
                            PhosphorIcons.package(PhosphorIconsStyle.duotone),
                            color: AppColors.primaryColor,
                            size: 32,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Código: $trackingCode',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          PhosphorIcons.clock(PhosphorIconsStyle.regular),
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(delivery['_id']),
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                tooltip: 'Deletar entrega',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPackageDetailsDialog(Map<String, dynamic> delivery) {
    final trackingCode = delivery['trackingCode'] ?? 'N/A';
    final ownerName = delivery['ownerName'] ?? 'Sem nome';
    final location = delivery['location'] ?? 'N/A';
    final relation = delivery['relation'] ?? 'N/A';
    final subRelation = delivery['subRelation'] ?? '';
    final cpf = delivery['cpf'] ?? '';
    final deliveryMan = delivery['deliveryMan'] ?? 'N/A';
    final imageUrl = delivery['imageUrl'] ?? '';
    final createdAt = delivery['createdAt'];

    String formattedDate = 'Data não disponível';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = DateFormat('dd/MM/yyyy \'às\' HH:mm').format(date);
      } catch (e) {
        // Keep default value
      }
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
          child: Row(
            children: [
              // Lado esquerdo - Imagem e QR Code
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              PhosphorIcons.imageSquare(PhosphorIconsStyle.duotone),
                                              size: 64,
                                              color: AppColors.textTertiary,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Erro ao carregar imagem',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    PhosphorIcons.image(PhosphorIconsStyle.duotone),
                                    size: 64,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'QR Code',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 2,
                                  ),
                                ),
                                child: QrImageView(
                                  data: trackingCode,
                                  version: QrVersions.auto,
                                  size: 120,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Escaneie para re-visualizar',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lado direito - Detalhes
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor.withValues(alpha: 0.2),
                                  AppColors.secondaryColor.withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              PhosphorIcons.package(PhosphorIconsStyle.duotone),
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detalhes da Entrega',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Informações completas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close),
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildDetailRow(
                                PhosphorIcons.barcode(PhosphorIconsStyle.regular),
                                'Código de Rastreio',
                                trackingCode,
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                PhosphorIcons.user(PhosphorIconsStyle.regular),
                                'Destinatário',
                                ownerName,
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                PhosphorIcons.users(PhosphorIconsStyle.regular),
                                'Recebido por',
                                relation == 'Proprietário'
                                    ? 'Proprietário'
                                    : subRelation.isNotEmpty && subRelation != 'none'
                                        ? subRelation
                                        : 'Outro',
                              ),
                              if (cpf.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _buildDetailRow(
                                  PhosphorIcons.identificationCard(PhosphorIconsStyle.regular),
                                  'CPF',
                                  cpf,
                                ),
                              ],
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                                'Localização',
                                location,
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                PhosphorIcons.truck(PhosphorIconsStyle.regular),
                                'Entregador',
                                deliveryMan,
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                PhosphorIcons.calendar(PhosphorIconsStyle.regular),
                                'Data da Entrega',
                                formattedDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Get.back();
                                _showDeleteDialog(delivery['_id']);
                              },
                              icon: const Icon(Icons.delete_outline, size: 20),
                              label: const Text('Deletar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Fechar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente deletar esta entrega?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteDelivery(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(String deliveryMan) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
            'Deseja realmente deletar todas as entregas de $deliveryMan?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAllDeliveriesForMan(deliveryMan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deletar Todas'),
          ),
        ],
      ),
    );
  }
}

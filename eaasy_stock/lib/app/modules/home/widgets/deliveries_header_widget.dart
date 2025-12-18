import 'package:eaasy_stock/app/modules/home/widgets/filter_dialog.dart';
import 'package:eaasy_stock/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/home_controller.dart';

class DeliveriesHeaderWidget extends GetView<HomeController> {
  const DeliveriesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  PhosphorIcons.package(PhosphorIconsStyle.duotone),
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scanned'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.deliveries.length}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.funnelSimple(),
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
              FilterDialog.show(context, controller);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:eaasy_stock/app/modules/home/widgets/action_buttons_widget.dart';
import 'package:eaasy_stock/app/modules/home/widgets/deliveries_header_widget.dart';
import 'package:eaasy_stock/app/modules/home/widgets/deliveries_list_widget.dart';
import 'package:eaasy_stock/app/modules/home/widgets/search_bar_widget.dart';
import 'package:eaasy_stock/app/theme/app_theme.dart';
import 'package:eaasy_stock/app/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.package(PhosphorIconsStyle.duotone),
              color: AppTheme.primaryColor,
              size: 28,
            ),
            SizedBox(width: 8),
            Text("Eaasy Stock".tr),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(PhosphorIcons.dotsThreeVertical()),
            onSelected: (value) async {
              if (value == 'Export') {
                await controller.exportToExcel();
              } else if (value == 'Sync') {
                await controller.syncWithFirebase();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Export',
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.export(),
                        color: AppTheme.secondaryColor,
                      ),
                      SizedBox(width: 12),
                      Text('Export'.tr),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Sync',
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.arrowsClockwise(),
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 12),
                      Text('Sync'.tr),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value &&
                  controller.displayedDeliveries.isEmpty) {
                return CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 24)),
                    SliverToBoxAdapter(child: ActionButtonsWidget()),
                    SliverToBoxAdapter(child: SizedBox(height: 24)),
                    SliverToBoxAdapter(child: SearchBarWidget()),
                    SliverToBoxAdapter(child: SizedBox(height: 24)),
                    SliverToBoxAdapter(child: DeliveriesHeaderWidget()),
                    SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverToBoxAdapter(child: DeliveriesListSkeleton()),
                  ],
                );
              }
              return CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: ActionButtonsWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: SearchBarWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: DeliveriesHeaderWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  DeliveriesListWidget(),
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            }),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.displayedDeliveries.isNotEmpty) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Processando...',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

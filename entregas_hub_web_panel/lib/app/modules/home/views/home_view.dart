import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:entregas_hub_web_panel/app/modules/deliveries/views/deliveries_view.dart';
import 'package:entregas_hub_web_panel/app/modules/stock/views/stock_view.dart';
import 'package:entregas_hub_web_panel/app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> pages = [
    const StockView(),
    const DeliveriesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Row(
        children: [
          AnimatedSidebar(
            expanded: MediaQuery.of(context).size.width > 768,
            items: [
              SidebarItem(
                icon: Icons.inventory_2,
                text: 'Estoque',
              ),
              SidebarItem(
                icon: Icons.local_shipping,
                text: 'Entregas',
              ),
            ],
            selectedIndex: controller.currentIndex.value,
            onItemSelected: controller.changePage,
            headerIcon: Icons.dashboard,
            headerText: 'Hub de Entregas',
            maxSize: MediaQuery.of(context).size.width * 0.2,
            minSize: 80,
            frameDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            itemIconColor: Colors.white,
            itemSelectedColor: AppColors.primaryDark,
            itemHoverColor: AppColors.primaryLight.withValues(alpha: 0.3),
            headerIconColor: Colors.white,
            headerTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            itemTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: controller.isDarkMode.value
                            ? AppColors.cardColorDark
                            : AppColors.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: controller.toggleTheme,
                            icon: Icon(
                              controller.isDarkMode.value
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: controller.isDarkMode.value
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                            tooltip: controller.isDarkMode.value
                                ? 'Modo Claro'
                                : 'Modo Escuro',
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  child: Obx(() {
                    return pages[controller.currentIndex.value];
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EntregasPlaceholderPage extends StatelessWidget {
  const EntregasPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
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
                PhosphorIcons.truck(PhosphorIconsStyle.duotone),
                size: 64,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Página de Entregas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Em desenvolvimento',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RetiradaPlaceholderPage extends StatelessWidget {
  const RetiradaPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.arrowBendDownLeft(PhosphorIconsStyle.duotone),
                size: 64,
                color: AppColors.accentDark,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Página de Retirada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Em desenvolvimento',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

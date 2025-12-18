import 'package:entrega_hub/app/modules/home/widgets/action_buttons_widget.dart';
import 'package:entrega_hub/app/modules/home/widgets/empty_state_widget.dart';
import 'package:entrega_hub/app/modules/home/widgets/error_state_widget.dart';
import 'package:entrega_hub/app/modules/home/widgets/header_widget.dart';
import 'package:entrega_hub/app/modules/home/widgets/packages_list_widget.dart';
import 'package:entrega_hub/app/modules/home/widgets/search_bar_widget.dart';
import 'package:entrega_hub/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchData();
        },
        color: AppColors.primaryColor,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  color: AppColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderWidget(),
                      const SizedBox(height: 24),
                      const ActionButtonsWidget(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SearchBarWidget(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Encomendas Entregues',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        color: AppColors.primaryColor,
                        onPressed: () {
                          print('Abrir filtro');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                } else if (!controller.isLoading.value &&
                    controller.fetchError.value) {
                  return const SliverFillRemaining(
                    child: ErrorStateWidget(),
                  );
                } else if (controller.packages.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyStateWidget(),
                  );
                } else {
                  return const PackagesListWidget();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

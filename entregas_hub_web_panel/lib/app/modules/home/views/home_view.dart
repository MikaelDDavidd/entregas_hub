import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:entregas_hub_web_panel/app/modules/stock/views/stock_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  // Definindo as páginas que serão exibidas no painel
  final List<Widget> pages = [
    StockView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Row(
            children: [
              // Barra lateral animada para navegação
              AnimatedSidebar(
                expanded: MediaQuery.of(context).size.width > 600,
                items: [
                  SidebarItem(icon: Icons.inventory_2, text: 'Estoque'),
                  SidebarItem(icon: Icons.local_shipping, text: 'Entregas'),
                  SidebarItem(icon: Icons.assignment_return, text: 'Retirada'),
                ],
                selectedIndex: controller.currentIndex.value,
                onItemSelected: (index) {
                  controller
                      .changePage(index); // Atualiza a página conforme o índice
                },
                headerIcon: Icons.dashboard,
                headerText: 'Hub de Entregas',
                maxSize: width * 0.2,
              ),

              // Container principal para exibir o conteúdo das páginas
              Expanded(
                child: Obx(() {
                  return pages[controller.currentIndex.value];
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Páginas placeholder para Home, Notifications e Management
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page'));
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications Page'));
  }
}

class ManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Management Page'));
  }
}

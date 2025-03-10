import 'dart:io';
import 'package:entrega_hub/theme/colors.dart';
import 'package:entrega_hub/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async {
          await controller.fetchData();
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Nome do usuário no canto superior esquerdo
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Olá, Usuário', // Nome fictício
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botão de registrar entrega
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.startScanning();
                      print('Registrar entrega');
                    },
                    icon: Icon(
                      Icons.qr_code_scanner,
                      size: 50,
                      color: AppColors.backgroundColor,
                    ),
                    label: Text(
                      "Registrar Entrega",
                      style: TextStyles.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 100),
                    ),
                  ),
                ),
              ),

              // Barra de pesquisa
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar encomendas...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // onChanged: (value) => controller.filterDeliveries(value),
                  ),
                ),
              ),

              // Cabeçalho com botão de filtro
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Encomendas Entregues',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          // Ação para abrir filtro
                          print('Abrir filtro');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Exibir Loading ou Lista de Pacotes
              Obx(() {
                if (controller.isLoading.value) {
                  return SliverFillRemaining(
                    child: Center(
                      child:
                          CircularProgressIndicator(), // Indicador de carregamento
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var package = controller.packages[index];
                        return ListTile(
                          leading: package.imageUrl != null
                              ? Image.network(
                                  package.imageUrl, // Exibe a URL da imagem
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image,
                                  size: 50), // Caso não tenha imagem
                          title: Text('Código: ${package.trackingCode}'),
                          subtitle: Text('${package.ownerName}'),
                          trailing: Text(
                            "Entregue",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      childCount: controller
                          .packages.length, // Exibe a quantidade de pacotes
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
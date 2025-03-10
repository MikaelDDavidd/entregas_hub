import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/modules/conferency/views/tracking_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/interior_controller.dart';

class InteriorView extends GetView<InteriorController> {
  const InteriorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
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
                      color: Colors.white),
                ),
                icon: const Icon(
                  Icons.qr_code,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.startRegistering();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller:
                    controller.searchController, // Linkando com o controller
                decoration: InputDecoration(
                  hintText: "Pesquisar Encomendas",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.blueAccent,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => controller.filterDeliveries(value),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    int _quantidade = controller.deliveriesInterior.length;
                    return Text(
                      'Encomendas Entregues (${_quantidade})', // Contador de encomendas
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      _showDateFilterDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          Obx(() {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final encomenda = controller.deliveriesInterior[index];
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
                        leading: File(encomenda['onTakePhoto']).existsSync()
                            ? Image.file(
                                File(encomenda['onTakePhoto']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.broken_image,
                                color: Colors.red,
                                size: 50,
                              ),
                        title: Text(
                          'Código: ${encomenda["trackingCode"] ?? "Não disponível"}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        subtitle: Text(
                          'Motorista: ${encomenda["name"] ?? "Não disponível"}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => TrackingDialog(
                              trackingCode: encomenda["trackingCode"],
                              imagePath: encomenda[
                                  "photoPath"], // Passa o caminho da imagem da encomenda
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: controller.deliveriesInterior.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _showDateFilterDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        DateTimeRange? selectedRange;
        return AlertDialog(
          backgroundColor: Colors.white, // Cor de fundo do dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordas arredondadas
          ),
          title: Text(
            'Selecione o intervalo de datas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent, // Cor do título
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botões com o estilo adequado
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Cor do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50), // Tamanho do botão
                  elevation: 5,
                ),
                onPressed: () {
                  // Filtra por último 7 dias
                  controller.filterByDateRange(
                      DateTime.now().subtract(Duration(days: 7)),
                      DateTime.now());
                  Navigator.pop(context);
                },
                child: Text('Últimos 7 dias',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 10), // Espaço entre os botões
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 5,
                ),
                onPressed: () {
                  // Filtra por último 15 dias
                  controller.filterByDateRange(
                      DateTime.now().subtract(Duration(days: 15)),
                      DateTime.now());
                  Navigator.pop(context);
                },
                child: Text('Últimos 15 dias',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 5,
                ),
                onPressed: () {
                  // Filtra por último 30 dias
                  controller.filterByDateRange(
                      DateTime.now().subtract(Duration(days: 30)),
                      DateTime.now());
                  Navigator.pop(context);
                },
                child: Text('Últimos 30 dias',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 5,
                ),
                onPressed: () async {
                  // Abre o seletor de intervalo de datas
                  selectedRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                        start: DateTime.now().subtract(Duration(days: 30)),
                        end: DateTime.now()),
                  );

                  if (selectedRange != null) {
                    controller.filterByDateRange(
                      selectedRange!.start,
                      selectedRange!.end,
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text('Escolher intervalo personalizado',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

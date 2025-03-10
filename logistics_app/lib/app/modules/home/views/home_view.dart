import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics_app/app/modules/conferency/controllers/conferency_controller.dart';
import 'package:logistics_app/app/modules/conferency/views/conferency_view.dart';
import 'package:logistics_app/app/modules/interior/views/interior_view.dart';
import 'package:logistics_app/app/modules/listing/views/listing_view.dart';
import 'package:logistics_app/app/modules/scanning/views/scanning_view.dart';
import 'package:logistics_app/app/modules/test_api/views/test_api_view.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Certifique-se de que este pacote esteja corretamente importado
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    ScanningView(),
    ListingView(),
    InteriorView(),
    ConferencyView(),
    TestApiView(),
  ];

  @override
  Widget build(BuildContext context) {
    final ConferencyController conferencyController =
        Get.put(ConferencyController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // Definindo o título com base no index selecionado
          String title = controller.selectedIndex.value == 0
              ? 'Leitor de QR Code'
              : controller.selectedIndex.value == 1
                  ? 'Apuração'
                  : controller.selectedIndex.value == 2
                      ? 'Interior'
                      : controller.selectedIndex.value == 3
                          ? 'Retirada'
                          : 'Test';
          return Text(title);
        }),
        centerTitle: true,
        actions: [
          InkWell(
            child: Icon(Icons.upload),
            onTap: () {
              conferencyController.generateExcel();
            },
          ),
        ],
      ),
      body: Obx(() {
        int _index = controller.selectedIndex.value;
        return Center(child: _widgetOptions[_index]);
      }),
      drawer: Obx(() {
        int _index = controller.selectedIndex.value;
        return Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 140,
                child: Image(image: AssetImage('assets/profile.jpeg')),
              ),
              ListTile(
                title: Text("Scanner"),
                selected: _index == 0,
                onTap: () {
                  controller.onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Apuração"),
                selected: _index == 1,
                onTap: () {
                  controller.onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Interior"),
                selected: _index == 2,
                onTap: () {
                  controller.onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Retirada"),
                selected: _index == 3,
                onTap: () {
                  controller.onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Test"),
                selected: _index == 4,
                onTap: () {
                  controller.onItemTapped(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

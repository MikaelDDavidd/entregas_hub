import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrega_hub/app/modules/home/controllers/home_controller.dart';

class LoadingScreen extends StatefulWidget {
  final String recipient;
  final String relation;
  final String subRelation;
  final String cpf;

  LoadingScreen({
    required this.recipient,
    required this.relation,
    required this.subRelation,
    required this.cpf,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final HomeController controller = Get.find<HomeController>();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startLoadingProcess();
  }

  void _startLoadingProcess() async {
    await Future.delayed(Duration(seconds: 1)); // Simula tempo de carregamento
    await controller.addPackage(
      widget.recipient,
      widget.relation,
      widget.subRelation,
      widget.cpf,
    );
    setState(() {
      isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isCompleted ? Colors.green : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isCompleted) ...[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Processando...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ] else ...[
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 150,
                  key: ValueKey<int>(1),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Entregue!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

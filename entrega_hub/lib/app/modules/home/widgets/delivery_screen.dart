import 'package:entrega_hub/app/modules/home/controllers/home_controller.dart';
import 'package:entrega_hub/app/modules/home/widgets/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final controller = Get.find<HomeController>();
  final _recipientController = TextEditingController();
  String? _selectedRelation = "Proprietário";
  String? _subRelation;
  bool _isButtonEnabled = false;
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _recipientController.text.isNotEmpty &&
          (_selectedRelation == "Proprietário" || _subRelation != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Entrega"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para o destinatário
            TextField(
              controller: _recipientController,
              onChanged: (_) => _validateFields(),
              decoration: InputDecoration(
                labelText: "Nome do Destinatário",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown para relação
            DropdownButtonFormField<String>(
              value: _selectedRelation,
              onChanged: (value) {
                setState(() {
                  _selectedRelation = value;
                  if (_selectedRelation == "Proprietário") {
                    _subRelation = null;
                  }
                  _validateFields();
                });
              },
              decoration: InputDecoration(
                labelText: "Relação com o Destinatário",
                border: OutlineInputBorder(),
              ),
              items: [
                "Proprietário",
                "Outro",
              ].map((relation) {
                return DropdownMenuItem(
                  value: relation,
                  child: Text(relation),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Dropdown para sub-relação (aparece apenas se "Outro" for selecionado)
            if (_selectedRelation == "Outro")
              DropdownButtonFormField<String>(
                value: _subRelation,
                onChanged: (value) {
                  setState(() {
                    _subRelation = value;
                    _validateFields();
                  });
                },
                decoration: InputDecoration(
                  labelText: "Escolha uma relação",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Irmão(a)",
                  "Pai",
                  "Mãe",
                  "Primo(a)",
                  "Tio(a)",
                  "Vizinho(a)",
                  "Amante",
                  "Outro",
                ].map((relation) {
                  return DropdownMenuItem(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),

            // Campo de CPF (opcional)
            TextField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CPF (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),

            // Botão "Entregar"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        final recipient = _recipientController.text;
                        final relation = _selectedRelation;
                        final subRelation = _subRelation;
                        final cpf = _cpfController.text;

                        Get.off(() => LoadingScreen(
                              recipient: recipient,
                              relation: relation!,
                              subRelation: subRelation ?? 'none',
                              cpf: cpf,
                            ));

                        _recipientController.clear();
                        _selectedRelation = "Proprietário";
                        _subRelation = null;
                        _cpfController.clear();
                        _validateFields();
                      }
                    : null,
                child: Text("Entregar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
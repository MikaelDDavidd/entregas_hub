import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/app/modules/interior/controllers/interior_controller.dart';

class DeliveryDialog extends StatefulWidget {
  final String trackingCode;
  final String onTakePhoto;

  const DeliveryDialog({
    Key? key,
    required this.trackingCode,
    required this.onTakePhoto,
  }) : super(key: key);

  @override
  State<DeliveryDialog> createState() => _DeliveryDialogState();
}

class _DeliveryDialogState extends State<DeliveryDialog> {
  String? _selectedName;
  InteriorController controler = Get.find<InteriorController>();

  @override
  Widget build(BuildContext context) {
    final names = [
      "bruno",
      "samuel",
      "edmilson",
      "paulo",
      "wedson encomendas",
      "edson",
      "nanã",
      "naldo",
      "cida",
      "givaldo",
      "erik",
      "kleber"
    ];

    return AlertDialog(
      title: const Text('Selecione o nome'),
      content: SingleChildScrollView(
        child: Column(
          children: names.map((name) {
            return RadioListTile<String>(
              title: Text(name),
              value: name,
              groupValue: _selectedName,
              onChanged: (String? value) {
                setState(() {
                  _selectedName = value;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Salvar'),
          onPressed: () {
            if (_selectedName != null) {
              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
              final registerDate = dateFormat.format(DateTime.now());

              // Salva a entrega com o nome selecionado
              Get.find<InteriorController>().deliveriesInterior.add({
                'trackingCode': widget.trackingCode,
                'registerDate': registerDate,
                'name': _selectedName, // Adiciona o nome à entrega
                'onTakePhoto': widget.onTakePhoto,
              });

              controler.saveDeliveries();
              controler
                  .showToast("Encomenda registrada com sucesso!");
              Navigator.of(context).pop();
            } else {
              controler.showToast("Selecione um nome!");
            }
          },
        ),
      ],
    );
  }
}

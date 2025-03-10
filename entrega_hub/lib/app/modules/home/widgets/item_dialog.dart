import 'package:flutter/material.dart';

class ConfirmarEntregaDialog extends StatelessWidget {
  final Function(String? nome, String? cpf, String? relacao) onConfirm;

  ConfirmarEntregaDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? nomeRecebedor;
    String? cpfRecebedor;
    String? relacaoRecebedor;
    bool isProprietario = false; // Definição da variável faltante

    return AlertDialog(
      title: Text('Confirmar Entrega'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome do Recebedor'),
                    onChanged: (value) {
                      nomeRecebedor = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CPF (opcional)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      cpfRecebedor = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Relação com Proprietário'),
                    items: ['Filho', 'Esposo', 'Esposa', 'Mãe', 'Pai']
                        .map((String relacao) => DropdownMenuItem(
                      value: relacao,
                      child: Text(relacao),
                    ))
                        .toList(),
                    onChanged: (value) {
                      relacaoRecebedor = value;
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Confirmar'),
          onPressed: () {
            if (isProprietario) {
              onConfirm(null, null, null);
            } else if (nomeRecebedor != null && nomeRecebedor!.isNotEmpty) {
              onConfirm(nomeRecebedor, cpfRecebedor, relacaoRecebedor);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Por favor, insira o nome do recebedor.')),
              );
              return;
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
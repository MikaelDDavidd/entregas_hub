import 'package:flutter/material.dart';

class ManualCodeDialog extends StatelessWidget {
  final Function(String) onSubmit;

  const ManualCodeDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return AlertDialog(
      title: const Text("Inserir Código da Encomenda"),
      content: TextField(
        controller: codeController,
        decoration: const InputDecoration(
          labelText: "Código da Encomenda",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final code = codeController.text.trim();
            if (code.isNotEmpty) {
              onSubmit(code);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Por favor, insira um código válido.")),
              );
            }
          },
          child: const Text("Enviar"),
        ),
      ],
    );
  }
}
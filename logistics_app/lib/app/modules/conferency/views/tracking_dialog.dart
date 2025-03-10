import 'dart:io';
import 'package:flutter/material.dart';

class TrackingDialog extends StatelessWidget {
  final String trackingCode;
  final String? imagePath;

  const TrackingDialog({
    Key? key,
    required this.trackingCode,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Detalhes da Encomenda',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,  // Define a largura do dialog
        height: MediaQuery.of(context).size.height * 0.6, // Define a altura do dialog
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imagePath != null && imagePath!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imagePath!),
                      width: double.infinity, // Usa toda a largura disponível
                      height: MediaQuery.of(context).size.height * 0.4, // Aumenta a altura da imagem
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.local_shipping,
                    size: 100,
                    color: Colors.grey,
                  ),
            const SizedBox(height: 15),
            Text(
              'Código de Rastreamento:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              trackingCode,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
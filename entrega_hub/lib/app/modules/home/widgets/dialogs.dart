// dialogs.dart
import 'package:flutter/material.dart';

class TimeoutDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onSkip;

  const TimeoutDialog({
    Key? key,
    required this.onRetry,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("QR Code não escaneado"),
      content: Text("Deseja tentar escanear novamente ou pular esta etapa?"),
      actions: <Widget>[
        TextButton(
          onPressed: onRetry,
          child: Text("Tentar Novamente"),
        ),
        TextButton(
          onPressed: onSkip,
          child: Text("Pular"),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String code;
  final VoidCallback onProceed;
  final VoidCallback onRetry;

  const ConfirmationDialog({
    Key? key,
    required this.code,
    required this.onProceed,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Código Escaneado"),
      content: Text(
          "O código escaneado é: $code.\nDeseja prosseguir ou tentar novamente?"),
      actions: <Widget>[
        TextButton(
          onPressed: onRetry,
          child: Text("Tentar Novamente"),
        ),
        TextButton(
          onPressed: onProceed,
          child: Text("Prosseguir"),
        ),
      ],
    );
  }
}

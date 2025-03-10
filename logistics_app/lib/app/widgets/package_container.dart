import 'dart:io';
import 'package:flutter/material.dart';

class PackageContainer extends StatelessWidget {
  final String trackingCode;
  final String ownerName;
  final bool isDelivered;
  final String? photoPath;
  final String? imageUrl; // Parâmetro opcional para URL de imagem
  final Function()? onTap;

  const PackageContainer({
    Key? key,
    required this.trackingCode,
    required this.ownerName,
    required this.isDelivered,
    this.photoPath,
    this.imageUrl, // Recebe o parâmetro imageUrl
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: _buildImage(), // Usa o método auxiliar para definir a imagem
        subtitle: Text(
          '$ownerName',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[900],
          ),
        ),
        title: Text(
          'Código: $trackingCode',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[900],
          ),
        ),
        trailing: Text(
          isDelivered ? 'Entregue' : 'Pendente',
          style: TextStyle(
            color: isDelivered ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Método auxiliar para decidir qual imagem mostrar
  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Se imageUrl for passado, usa NetworkImage
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    } else if (photoPath != null) {
      // Se photoPath for passado, usa Image.file
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(photoPath!),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Caso contrário, usa um ícone
      return Icon(
        Icons.local_shipping,
        color: isDelivered ? Colors.green : Colors.blueAccent,
        size: 40,
      );
    }
  }
}
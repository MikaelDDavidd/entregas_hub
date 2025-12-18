import 'dart:io';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelServices {
  Future<void> generateExcel(List<Delivery> deliveries) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Entregas'];

      sheet.appendRow([
        TextCellValue('Código de Rastreio'),
        TextCellValue('Data de Registro'),
        TextCellValue('Hora de Registro'),
      ]);

      for (var delivery in deliveries) {
        try {
          DateTime parsedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(delivery.registerDate);
          String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
          String formattedTime = DateFormat('HH:mm:ss').format(parsedDate);

          sheet.appendRow([
            TextCellValue(delivery.trackingCode),
            TextCellValue(formattedDate),
            TextCellValue(formattedTime),
          ]);
        } catch (e) {
          print("Erro ao processar linha do Excel: $e");
        }
      }

      String currentDate = DateFormat('dd-MM-yyyy_HH-mm').format(DateTime.now());
      String fileName = 'entregas_$currentDate.xlsx';

      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        String outputPath = "${directory.path}/$fileName";

        File(outputPath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        await Share.shareXFiles(
          [XFile(outputPath)],
          text: "Confira a tabela de entregas gerada pelo Eaasy Stock!",
        );
      } else {
        throw Exception("Erro ao gerar o arquivo Excel.");
      }
    } catch (e) {
      throw Exception("Erro ao gerar planilha Excel: $e");
    }
  }
}

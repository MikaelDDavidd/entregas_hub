// class  ExcelServices {
//     Future<void> generateExcel() async {
//     try {
//       var excel = Excel.createExcel();
//       Sheet sheet = excel['Sheet1'];

//       sheet.appendRow([
//         TextCellValue('Tracking Code'),
//         TextCellValue('Data'),
//       ]);

//       for (var delivery in deliveries) {
//         try {
//           var trackingCode = delivery['trackingCode'] ?? '';
//           var registerDate = DateFormat('dd/MM/yyyy HH:mm')
//               .parse(delivery['registerDate'] ?? '');
//           var formattedDate = DateFormat('dd/MM/yyyy').format(registerDate);

//           sheet.appendRow([
//             TextCellValue(trackingCode),
//             TextCellValue(formattedDate),
//           ]);
//         } catch (e) {
//           print("Erro ao processar linha do Excel: $e");
//         }
//       }

//       String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//       String fileName = 'entregas_$currentDate.xlsx';

//       List<int>? fileBytes = excel.save();
//       if (fileBytes != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         String outputPath = "${directory.path}/$fileName";

//         File(outputPath)
//           ..createSync(recursive: true)
//           ..writeAsBytesSync(fileBytes);

//         await Share.shareXFiles(
//           [XFile(outputPath)],
//           text: "Confira a tabela de entregas gerada pelo app!",
//         );
//       } else {
//         print("Erro ao gerar o arquivo Excel.");
//       }
//     } catch (e) {
//       print("Erro ao gerar planilha Excel: $e");
//     }
//   }
// }
// import 'package:eaasy_stock/app/modules/home/controllers/home_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class FilterDialog{
//   Future<void> showDateFilterDialog(BuildContext context) async {
//     final HomeController controller = Get.find<HomeController>();
//     showDialog(
//       context: context,
//       builder: (context) {
//         DateTimeRange? selectedRange;
//         return AlertDialog(
//           backgroundColor: Colors.white, // Cor de fundo do dialog
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16), // Bordas arredondadas
//           ),
//           title: Text(
//             'Selecione o intervalo de datas',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.blueAccent, // Cor do título
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Botões com o estilo adequado
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent, // Cor do botão
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: Size(double.infinity, 50), // Tamanho do botão
//                   elevation: 5,
//                 ),
//                 onPressed: () {
//                   // Filtra por último 7 dias
//                   // controller.filterByDateRange(
//                   //     DateTime.now().subtract(Duration(days: 1)),
//                   //     DateTime.now());
//                   Navigator.pop(context);
//                 },
//                 child: Text('Últimos 1 dia',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//               SizedBox(height: 10), // Espaço entre os botões
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: Size(double.infinity, 50),
//                   elevation: 5,
//                 ),
//                 onPressed: () {
//                   // Filtra por último 15 dias
//                   controller.filterByDateRange(
//                       DateTime.now().subtract(Duration(days: 15)),
//                       DateTime.now());
//                   Navigator.pop(context);
//                 },
//                 child: Text('Últimos 15 dias',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: Size(double.infinity, 50),
//                   elevation: 5,
//                 ),
//                 onPressed: () {
//                   // Filtra por último 30 dias
//                   controller.filterByDateRange(
//                       DateTime.now().subtract(Duration(days: 30)),
//                       DateTime.now());
//                   Navigator.pop(context);
//                 },
//                 child: Text('Últimos 30 dias',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: Size(double.infinity, 50),
//                   elevation: 5,
//                 ),
//                 onPressed: () async {
//                   // Abre o seletor de intervalo de datas
//                   selectedRange = await showDateRangePicker(
//                     context: context,
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime.now(),
//                     initialDateRange: DateTimeRange(
//                         start: DateTime.now().subtract(Duration(days: 30)),
//                         end: DateTime.now()),
//                   );

//                   if (selectedRange != null) {
//                     controller.filterByDateRange(
//                       selectedRange!.start,
//                       selectedRange!.end,
//                     );
//                   }
//                   Navigator.pop(context);
//                 },
//                 child: Text('Escolher intervalo personalizado',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
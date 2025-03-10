// import 'package:eaasy_stock/app/modules/home/widgets/custom_toast.dart';
// import 'package:intl/intl.dart';

// class StorageServices {
//   final Function showToast = CustomToast().showToast;

//     Future<void> registerDeliveryLocally(deliveries, qrCode, originalDeliveries) async {
//     try {
//       bool isDuplicate = deliveries
//           .any((delivery) => delivery['trackingCode'] == qrCode.value);
//       if (isDuplicate) {
//         showToast("Esta encomenda já foi registrada!");
//         return;
//       }

//       if (qrCode.value.isNotEmpty) {
//         final trackingCode = qrCode.value;
//         final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
//         final registerDate = dateFormat.format(DateTime.now());

//         var newDelivery = {
//           'trackingCode': trackingCode,
//           'registerDate': registerDate,
//         };

//         deliveries.add(newDelivery);
//         originalDeliveries
//             .add(newDelivery); // Adiciona a nova entrega na lista original

//         await saveDeliveries();
//         showToast("Encomenda registrada com sucesso!");
//       }
//     } catch (e) {
//       showToast("Erro ao registrar entrega localmente: $e");
//     }
//   }
// }
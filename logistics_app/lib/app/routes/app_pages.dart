import 'package:get/get.dart';

import '../modules/conferency/bindings/conferency_binding.dart';
import '../modules/conferency/views/conferency_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/interior/bindings/interior_binding.dart';
import '../modules/interior/views/interior_view.dart';
import '../modules/listing/bindings/listing_binding.dart';
import '../modules/listing/views/listing_view.dart';
import '../modules/scanning/bindings/scanning_binding.dart';
import '../modules/scanning/views/scanning_view.dart';
import '../modules/test_api/bindings/test_api_binding.dart';
import '../modules/test_api/views/test_api_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LISTING,
      page: () => const ListingView(),
      binding: ListingBinding(),
    ),
    GetPage(
      name: _Paths.SCANNING,
      page: () => const ScanningView(),
      binding: ScanningBinding(),
    ),
    GetPage(
      name: _Paths.INTERIOR,
      page: () => const InteriorView(),
      binding: InteriorBinding(),
    ),
    GetPage(
      name: _Paths.CONFERENCY,
      page: () => const ConferencyView(),
      binding: ConferencyBinding(),
    ),
    GetPage(
      name: _Paths.TEST_API,
      page: () => const TestApiView(),
      binding: TestApiBinding(),
    ),
  ];
}

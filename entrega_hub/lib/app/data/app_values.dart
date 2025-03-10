

import 'package:entrega_hub/app/data/storage.dart';
import 'package:get_storage/get_storage.dart';

class AppValues {
  static String storageUser = GetStorage().read(StorageKeys.userKey) ?? '';
}
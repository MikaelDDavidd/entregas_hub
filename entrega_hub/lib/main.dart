import 'package:entrega_hub/app/data/storage.dart';
import 'package:entrega_hub/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando GetStorage
  await GetStorage.init();

  // Inicializando Hive
  await Hive.initFlutter();

  // Abrindo ou registrando caixas (opcional aqui)
  await Hive.openBox('localDeliveries');

  // Verificar se já tem usuário logado
  final storage = GetStorage();
  final savedUser = storage.read(StorageKeys.userKey);
  final initialRoute = (savedUser != null && savedUser != '') ? '/home' : AppPages.INITIAL;

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    ),
  );
}

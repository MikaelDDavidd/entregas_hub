import 'package:eaasy_stock/app/data/localized_stirngs.dart';
import 'package:eaasy_stock/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      title: "Eaasy Stock",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: _getDeviceLocale(),
      fallbackLocale: Locale('en', 'US'),
      translationsKeys: LocalizedStrings.getLocalizedStrings(),
    ),
  );
}

// Função para determinar a localidade do dispositivo
Locale _getDeviceLocale() {
  final deviceLocale = WidgetsBinding.instance.window.locale;

  // Se for português (Brasil), retorna 'pt_BR'
  if (deviceLocale.languageCode == 'pt' && deviceLocale.countryCode == 'BR') {
    return Locale('pt', 'BR');
  } else { 
    return Locale('en', 'US'); // Para outros idiomas, usa 'en_US' como fallback
  }
}

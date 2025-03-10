import 'package:eaasy_stock/app/data/localized_stirngs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: _getDeviceLocale(), // Determina o idioma do dispositivo
      fallbackLocale: Locale('en', 'US'), // Caso não seja português, fallback para inglês
      translationsKeys: LocalizedStrings.getLocalizedStrings(), // Passa as strings manualmente
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
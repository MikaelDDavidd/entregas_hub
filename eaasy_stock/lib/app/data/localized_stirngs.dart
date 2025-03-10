import 'package:flutter/material.dart';

class LocalizedStrings {
  // Strings em inglês
  // Strings em inglês
  static const Map<String, String> _englishStrings = {
    'appName': 'Easy Stock',  // Corrigi a tradução para o nome do app
    'Export': 'Export',
    'Scan': 'Scan',
    'Search': 'Search Orders',
    'Scanned': 'Scanned',
    'Last 7 Days': 'Last 7 Days',
    'Last 15 Days': 'Last 15 Days',
    'Last 30 Days': 'Last 30 Days',
    'Custom': 'Custom',
    'Sync': 'Sync',
  };

  // Strings em português
  static const Map<String, String> _portugueseStrings = {
    'appName': 'Estoque Fácil',
    'Export': 'Exportar',
    'Scan': 'Escanear',
    'Search': 'Pesquisar Encomendas',
    'Scanned': 'Escaneados',
    'Last 7 Days': 'Últimos 7 Dias',
    'Last 15 Days': 'Últimos 15 Dias',
    'Last 30 Days': 'Últimos 30 Dias',
    'Custom': 'Personalizado',
    'Sync': 'Sincronizar',
  };
  // Função que retorna as strings de acordo com a linguagem
  static Map<String, Map<String, String>> getLocalizedStrings() {
    return {
      'pt': _portugueseStrings, // Strings em português
      'en': _englishStrings,    // Strings em inglês
    };
  }
}
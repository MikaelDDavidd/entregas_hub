import 'package:entrega_hub/app/data/app_values.dart';
import 'package:entrega_hub/app/data/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  final storage = GetStorage();
  RxBool isChecked = false.obs;
  RxString user = ''.obs;
  final TextEditingController userNameController = TextEditingController();

  // Função para alternar o estado do checkbox
  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  // Verifica se o usuário já está logado
  void checkUserLoggedIn() {
    if (AppValues.storageUser != '') {
      user.value = AppValues.storageUser;
    }
  }

  // Função de autenticação, que inclui a verificação do diretório do usuário
  Future<void> authenticator() async {
    String userName = userNameController.text.toLowerCase();
    user.value = userName;

    // Se o checkbox estiver marcado, salva o nome de usuário localmente
    if (isChecked.value) {
      storage.write(StorageKeys.userKey, userName);
    }

    print("Usuário autenticado: ${user.value}");

    // Verifica se o diretório do usuário existe e cria se necessário
    await checkAndCreateUserDirectory(userName);

    // Navega para a página inicial
    Get.offNamed('/home'); // Substitua '/home' pela rota real da sua página inicial
  }

  // Função para verificar se o diretório do usuário existe
  Future<void> checkAndCreateUserDirectory(String username) async {
    final String apiUrl = 'http://127.0.0.1:5000/encomendas/check_user/$username';

    try {
      // Faz uma requisição GET para verificar se o diretório do usuário existe
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Diretório já existe para o usuário
        print("Diretório já existe para o usuário: $username");
      } else if (response.statusCode == 404) {
        // Se o diretório não existir, cria o diretório
        await createUserDirectory(username);
      } else {
        print("Erro ao verificar o diretório: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }
  }

  // Função para criar o diretório do usuário na API
Future<void> createUserDirectory(String username) async {
  final String apiUrl = 'http://127.0.0.1:5000/encomendas/$username';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        // Adicione outros dados que você deseja salvar ao criar o diretório
      }),
    );

    if (response.statusCode == 201) {
      // Diretório criado com sucesso
      print("Diretório criado para o usuário: $username");
    } else if (response.statusCode == 409) {
      // Se o usuário já existir
      print("O usuário já existe: $username");
    } else {
      print("Erro ao criar o diretório: ${response.statusCode}");
    }
  } catch (e) {
    print("Erro ao criar diretório: $e");
  }
}

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();
  }
}
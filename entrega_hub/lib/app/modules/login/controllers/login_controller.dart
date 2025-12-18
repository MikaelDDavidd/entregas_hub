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

  // Função de autenticação
  Future<void> authenticator() async {
    String userName = userNameController.text.toLowerCase();
    user.value = userName;

    // Se o checkbox estiver marcado, salva o nome de usuário localmente
    if (isChecked.value) {
      storage.write(StorageKeys.userKey, userName);
    } else {
      // Se desmarcou, remove o nome salvo
      storage.remove(StorageKeys.userKey);
    }

    print("Usuário autenticado: ${user.value}");

    // Navega para a página inicial
    Get.offNamed('/home');
  }

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();

    // Preenche o campo de texto se já tiver usuário salvo
    final savedUser = storage.read(StorageKeys.userKey);
    if (savedUser != null && savedUser != '') {
      userNameController.text = savedUser;
      isChecked.value = true;
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    super.onClose();
  }
}
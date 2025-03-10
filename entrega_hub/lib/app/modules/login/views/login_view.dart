import 'package:entrega_hub/theme/colors.dart';
import 'package:entrega_hub/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/ic/login_ic.svg', // Substitua pelo caminho do seu arquivo SVG
                colorFilter: ui.ColorFilter.mode(
                  AppColors.primaryColor, // A cor que você deseja aplicar
                  ui.BlendMode.srcIn, // O modo de mistura
                ),
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: controller.userNameController,
                  decoration: InputDecoration(
                    labelText: "ENTREGADOR",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mantenha-me Conectado",
                    style: TextStyles.bodyText,
                  ),
                  Obx(() => Checkbox(
                        value: controller.isChecked.value,
                        onChanged:
                          controller.toggleCheckbox,
                      )),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  controller.authenticator();
                },
                child: Text(
                  'Login',
                  style: TextStyles.bodyText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

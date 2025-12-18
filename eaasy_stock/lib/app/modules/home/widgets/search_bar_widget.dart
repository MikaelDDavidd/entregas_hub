import 'package:eaasy_stock/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/home_controller.dart';

class SearchBarWidget extends GetView<HomeController> {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: "Search".tr,
          prefixIcon: Icon(
            PhosphorIcons.magnifyingGlass(),
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

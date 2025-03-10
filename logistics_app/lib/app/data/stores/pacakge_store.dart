import 'package:flutter/foundation.dart';
import 'package:logistics_app/app/data/http/exceptions.dart';
import 'package:logistics_app/app/data/models/package_model.dart';
import 'package:logistics_app/app/data/repositories/package_repositoriy.dart';


class PackageStore {
  final iPackageRepository repository;

  // var relative to loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // var relative to state
  final ValueNotifier<List<Package>> state = ValueNotifier<List<Package>>([]);

  // var relative to error
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  PackageStore({required this.repository});

  Future getPackages() async {
    isLoading.value = true;

    try {
      final result = await repository.getPackages();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}

import 'package:flutter/material.dart';

import '../../init/cache/locale_manager.dart';

abstract class BaseViewModel {
  BuildContext? buildContext;

  LocaleManager localeManager = LocaleManager.instance;
  void setContext(BuildContext context);

  void init();

  void showMessage(String? message) {
    ScaffoldMessenger.of(buildContext!).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            message!,
          ),
          backgroundColor: Colors.green),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:graduation_project_2023/core/init/navigation/app_router.dart';

import '../../../core/base/model/base_view_model.dart';
import '/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'splash_view_model.g.dart';

class SplashViewModel = _SplashViewModelBase with _$SplashViewModel;

abstract class _SplashViewModelBase with Store, BaseViewModel {
  @observable
  bool isStarted = false;

  @action
  void changeIsStarted() {
    isStarted = !isStarted;
  }

  Future<void> startTimer() async {
    await Future.delayed(buildContext!.duration1000);
    changeIsStarted();
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void setContext(BuildContext context) => buildContext = context;
  @override
  void init() async {
    await startTimer();
    //await LocaleManager.instance.setStringValue(PreferencesKeys.TOKEN, '');
    _navigateOnBoard();
  }

  Future<void> _navigateOnBoard() async {
    buildContext!.router.replace(const LoginRoute());
  }
}

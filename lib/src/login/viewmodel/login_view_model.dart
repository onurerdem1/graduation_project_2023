import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/constants/enums/locale_keys_enum.dart';
import '../../../core/init/cache/locale_manager.dart';
import '../model/login_model.dart';
import '/core/extension/context_extension.dart';

import 'package:flutter/material.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';

part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store, BaseViewModel {
  late String? fcmToken;
  late String? deviceId;
  @observable
  bool? rememberMe;
  @observable
  bool isObscure = true;
  @observable
  bool isLoading = false;
  @observable
  bool isReady = false;
  @observable
  bool startAnimation = false;
  @observable
  bool hasError = false;
  @observable
  bool? isLoginSuccessfull;

  int selectedLanguage = 0;

  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LoginModel loginModel;

  @override
  void setContext(BuildContext context) => buildContext = context;

  @override
  Future<void> init() async {
    setRememberMe();

    await startAnimationSequence();
  }

  Future<void> rememberEmailPassword() async {
    await LocaleManager.instance
        .setBoolValue(PreferencesKeys.REMEMBER_ME, true);
    await LocaleManager.instance.setStringValue(
      PreferencesKeys.EMAIL,
      emailController.text,
    );
    await LocaleManager.instance.setStringValue(
      PreferencesKeys.PASSWORD,
      passwordController.text,
    );
  }

  @action
  void setRememberMe() {
    rememberMe =
        LocaleManager.instance.getBoolValue(PreferencesKeys.REMEMBER_ME);
    if (rememberMe!) {
      emailController.text =
          LocaleManager.instance.getStringValue(PreferencesKeys.EMAIL);
      passwordController.text =
          LocaleManager.instance.getStringValue(PreferencesKeys.PASSWORD);
    }
  }

  @action
  void changeRememberMe(bool value) {
    value ? rememberMe = true : rememberMe = false;
  }

  Future<void> startAnimationSequence() async {
    await Future.delayed(buildContext!.duration400);
    isReady = !isReady;
    await Future.delayed(buildContext!.duration100);
    startAnimation = !startAnimation;
  }

  @action
  changeHasError() {
    hasError = !hasError;
  }

  @action
  void changeIsObscure() {
    isObscure = !isObscure;
  }

  @action
  void changeIsLoading() {
    isLoading = !isLoading;
  }

  Future<void> login() async {}
}

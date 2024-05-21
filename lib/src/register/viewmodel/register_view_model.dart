import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project_2023/core/init/navigation/app_router.dart';

import '../../../core/constants/enums/locale_keys_enum.dart';
import '../../../core/init/cache/locale_manager.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../model/register_model.dart';
import '/core/extension/context_extension.dart';

import 'package:flutter/material.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';

part 'register_view_model.g.dart';

class RegisterViewModel = _RegisterViewModelBase with _$RegisterViewModel;

abstract class _RegisterViewModelBase with Store, BaseViewModel {
  late String? fcmToken;
  late String? deviceId;
  @observable
  bool? rememberMe;
  @observable
  bool isObscure1 = true;
  @observable
  bool isObscure2 = true;
  @observable
  bool isLoading = false;
  @observable
  bool isReady = false;
  @observable
  bool startAnimation = false;
  @observable
  bool hasError = false;
  @observable
  bool isRegisterSuccessfull=false;

  int selectedLanguage = 0;

  EmailOTP myauth = EmailOTP();

  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  late RegisterModel registerModel;

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
      passwordController1.text,
    );
    await LocaleManager.instance.setStringValue(
      PreferencesKeys.PASSWORD,
      passwordController2.text,
    );
  }

  @action
  void setRememberMe() {
    rememberMe =
        LocaleManager.instance.getBoolValue(PreferencesKeys.REMEMBER_ME);
    if (rememberMe!) {
      emailController.text =
          LocaleManager.instance.getStringValue(PreferencesKeys.EMAIL);
      passwordController1.text =
          LocaleManager.instance.getStringValue(PreferencesKeys.PASSWORD);
      passwordController2.text =
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
  void serviceStateDialog() {
    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (context) {
        return Dialog(
          elevation: 0,
          child: Container(
            width: context.width,
            height: 200.h,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
            ),
            child: Observer(
              builder: (context) {
                return isLoading
                    ? Center(
                    child: CircularProgressIndicator(
                      color: buildContext!.colorScheme.tertiary,
                    ))
                    : isRegisterSuccessfull
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: buildContext!.colorScheme.tertiary,
                      size: 32.w,
                    ),
                    SizedBox(height: 10.h),
                    Text(LocaleKeys
                        .login_register_success
                        .tr())
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: buildContext!.colorScheme.error,
                      size: 32.w,
                    ),
                    SizedBox(height: 10.h),
                    Text(LocaleKeys.login_register_error
                        .tr()),
                    Text(LocaleKeys.login_email_exist.tr()
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @action
  changeHasError() {
    hasError = !hasError;
  }

  @action
  void changeIsObscure1() {
    isObscure1 = !isObscure1;
  }

  @action
  void changeIsObscure2() {
    isObscure2 = !isObscure2;
  }

  @action
  void changeIsLoading() {
    isLoading = !isLoading;
  }
  void navigateLoginPage(){
    buildContext!.router.replace(const LoginRoute());
  }

  Future<void> register() async {
    final _formState = formKey.currentState;
    if (_formState!.validate()) {
      try {
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController1.text);
        isRegisterSuccessfull=true;
        serviceStateDialog();
        await Future.delayed(const Duration(seconds: 2));
        buildContext!.router.replace(const LoginRoute());
      } catch (e) {
        print(e);
        serviceStateDialog();
        await Future.delayed(const Duration(seconds: 2));
        buildContext!.router.pop();
      }
    }
  }
}

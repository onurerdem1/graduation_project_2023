import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project_2023/core/init/navigation/app_router.dart';
import '../../../core/constants/enums/locale_keys_enum.dart';
import '../../../core/init/cache/locale_manager.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../model/login_model.dart';
import '/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
import "package:firebase_auth/firebase_auth.dart";

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
  bool isLoginSuccessfull=false;

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

  void navigateRegisterPage(){
    buildContext!.router.replace(const RegisterRoute());
  }

  void navigateForgotPassword(){
    buildContext!.router.replace(const ResetPasswordRoute());
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
                    : isLoginSuccessfull
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

  Future<void> login() async {
    final _formState = formKey.currentState;
    if (_formState!.validate()) {
      try{
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        buildContext!.router.replace(const HomePageRoute());
      }catch(e){
        print(e);
      }
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project_2023/core/init/navigation/app_router.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '/core/extension/context_extension.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'forgot_password_view_model.g.dart';

class ResetPasswordViewModel = _ResetPasswordViewModelBase
    with _$ResetPasswordViewModel;

abstract class _ResetPasswordViewModelBase with Store, BaseViewModel {
  @observable
  bool isLoading = false;
  @observable
  bool isReady = false;
  @observable
  bool startAnimation = false;
  @observable
  bool hasError = false;
  @observable
  bool isSendCodeSuccessfull = false;

  EmailOTP resetCode = EmailOTP();


  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();

  @override
  void setContext(BuildContext context) => buildContext = context;

  @override
  Future<void> init() async {
    await startAnimationSequence();
  }

  Future<void> resetPasswordButtonFunc() async {
    await sendResetPasswordCode();
    if (isSendCodeSuccessfull) {
    returnLogin();
     }
  }

  @action
  Future<void> sendResetPasswordCode() async {
    final formState = formKey.currentState;
    if (formState!.validate()) {
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        isSendCodeSuccessfull=true;
        serviceStateDialog();
        await Future.delayed(Duration(seconds: 2));
        buildContext!.router.pop();
      }catch(e){
        isSendCodeSuccessfull=false;
        serviceStateDialog();
        await Future.delayed(Duration(seconds: 2));
        buildContext!.router.pop();
      }
      // resetCode.setConfig(
      //     appEmail: "oevcil7@gmail.com",
      //     appName: "ShopAI",
      //     userEmail: emailController.text,
      //     otpLength: 6,
      //     otpType: OTPType.digitsOnly
      // );
      // if (await resetCode.sendOTP() == true) {
      //   isSendCodeSuccessfull=true;
      //   serviceStateDialog();
      //   await Future.delayed(Duration(seconds: 2));
      //   buildContext!.router.pop();
      // } else {
      //   isSendCodeSuccessfull=false;
      //   serviceStateDialog();
      //   await Future.delayed(Duration(seconds: 2));
      //   buildContext!.router.pop();
      // }
    }
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
  void changeIsLoading() {
    isLoading = !isLoading;
  }

  void navigateActivationPage() {
    buildContext!.router.push(
      ActivationPageRoute(
        email: emailController.text, resendCodeFunc: sendResetPasswordCode, resetCodeX: resetCode),
    );
  }

  void returnLogin() {
    buildContext!.router.replace(const LoginRoute());
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
                    : isSendCodeSuccessfull
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
                        .reset_password_code_send_successfull
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
                    Text(LocaleKeys.reset_password_code_send_error
                        .tr())
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

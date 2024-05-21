import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_2023/core/init/navigation/app_router.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'activation_code_view_model.g.dart';

class ActivationViewModel = _ActivationViewModelBase with _$ActivationViewModel;

abstract class _ActivationViewModelBase with Store, BaseViewModel {
  final String email;
  final Future<void> Function() reSendFunc;
  final EmailOTP resetCodeX;

  _ActivationViewModelBase(this.reSendFunc, this.resetCodeX, {required this.email});

  @observable
  bool isLoading = false;

  @observable
  int timerValue = 120;

  List<TextEditingController> textFieldControllerList =
      List.generate(6, (index) => TextEditingController());

  TextEditingController authCodeController = TextEditingController();

  @override
  void setContext(BuildContext context) => buildContext = context;
  @override
  void init() {
    startTimer();
  }

  Future<void> sendAuthCode() async {

  }

  @action
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue > 0) {
        timerValue--;
      } else {
        timer.cancel();
      }
    });
  }

  @action
  Future<void> reSendCode() async {
    timerValue = 120;
    startTimer();
    await reSendFunc();
  }

  @action
  Future<void> startResendCodeTimer() async {}
  void jumpToNextPinField(int index, String value, BuildContext context) {
    if (value.length == 1) {
      authCodeController.text = authCodeController.text + value;
      FocusScope.of(buildContext!).nextFocus();
    } else {
      authCodeController.text = authCodeController.text
          .substring(0, authCodeController.text.length - 1);
      FocusScope.of(buildContext!).previousFocus();
    }
  }

  @action
  void changeIsLoading() {
    isLoading = !isLoading;
  }

  void navigateCreatePassword() async {
    if (await resetCodeX.verifyOTP(otp: authCodeController.text) == true) {
      buildContext!.router.replace(CreatePasswordRoute(email:email));
    } else {

    }
  }

  void returnPreviousPage() {
    buildContext!.router.pop();
  }
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project_2023/core/extension/string_extension.dart';

import '../../../core/init/lang/locale_keys.g.dart';
import '/core/extension/context_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';

part 'create_password_view_model.g.dart';

class CreatePasswordViewModel = _CreatePasswordViewModelBase
    with _$CreatePasswordViewModel;

abstract class _CreatePasswordViewModelBase with Store, BaseViewModel {
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

  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController secondPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void setContext(BuildContext context) => buildContext = context;
  @override
  Future<void> init() async {
    await startAnimationSequence();
  }

  Future<void> createNewPassword() async {}

  void showResponseMessage(bool responseType) {
    showDialog(
      context: buildContext!,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 100.w,
            height: 100.w,
            child: Text(responseType
                ? LocaleKeys.create_password_response_type_true.locale
                : LocaleKeys.create_password_response_type_false.locale),
          ),
        );
      },
    );
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
}

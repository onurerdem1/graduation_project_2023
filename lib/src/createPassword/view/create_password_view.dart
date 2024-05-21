import 'package:auto_route/auto_route.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app/application_constants.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../viewmodel/create_password_view_model.dart';

@RoutePage<String>(name: 'CreatePasswordRoute')
class CreatePasswordView extends StatelessWidget {
  const CreatePasswordView(
      {Key? key, required this.email})
      : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return BaseView<CreatePasswordViewModel>(
      viewModel: CreatePasswordViewModel(email:email),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return Material(
          child: Scaffold(
            backgroundColor: context.colorScheme.background,
            appBar: appBAr(context),
            body: SizedBox(
              width: context.width,
              height: context.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: buildAnimatedBody(context, viewmodel),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSize appBAr(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: AppBar(
        backgroundColor: context.colorScheme.background,
        automaticallyImplyLeading: false,
        toolbarHeight: 130.h,
        elevation: 0,
        title: buildLogo(context),
        centerTitle: true,
      ),
    );
  }

  Widget buildAnimatedBody(
      BuildContext context, CreatePasswordViewModel viewmodel) {
    return Hero(
      tag: ApplicationConstants.ON_BOARD_ID,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 375.w,
        height: context.height,
        color: context.colorScheme.background,
        child: Material(
          color: context.colorScheme.background,
          child: Column(
            children: [
              MediaQuery.of(context).viewInsets.bottom.toInt() == 0
                  ? SizedBox(height: 20.h)
                  : Container(),
              descriptionTexts(context),
              buildForm(viewmodel, context),
              SizedBox(height: 5.h),
              buildLoginButton(context, viewmodel),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Container descriptionTexts(BuildContext context) {
    return Container(
      padding: context.padding3,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_password_create_new_password.locale,
            style: context.textTheme.displayLarge!,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            LocaleKeys.create_password_create_password_description.locale,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onBackground,
            ),
          )
        ],
      ),
    );
  }

  Widget buildLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: context.value1, left: 10.w),
          height: 70.h,
          child: context.appIcon,
        ),
        context.animation
      ],
    );
  }

  FormBuilder buildForm(
      CreatePasswordViewModel viewmodel, BuildContext context) {
    return FormBuilder(
      key: viewmodel.formKey,
      onChanged: () {
        viewmodel.formKey.currentState!.save();
      },
      child: Observer(
        builder: (_) {
          return Padding(
            padding: context.paddingHorizontal3,
            child: Column(
              children: [
                viewmodel.isReady
                    ? AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: viewmodel.startAnimation ? 1 : 0,
                        child: buildSecondTextField(context, viewmodel),
                      )
                    : Container(),
                viewmodel.isReady
                    ? AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: viewmodel.startAnimation ? 1 : 0,
                        child: buildPasswordTextField(context, viewmodel),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildSecondTextField(
      BuildContext context, CreatePasswordViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.create_password_password.locale,
              style: context.textTheme.bodyLarge,
            )),
        Observer(builder: (_) {
          return SizedBox(
            height: !viewmodel.hasError ? 44.h : 62.h,
            child: FormBuilderTextField(
              controller: viewmodel.passwordController,
              name: 'password1',
              obscureText: viewmodel.isObscure,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: LocaleKeys.login_password_required.locale),
              ]),
              cursorColor: context.colorScheme.tertiary,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.tertiary)),
                filled: true,
                fillColor: context.colorScheme.background,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.onTertiary)),
                suffixIcon: Observer(builder: (_) {
                  return GestureDetector(
                    onTap: viewmodel.changeIsObscure,
                    child: Icon(viewmodel.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                  );
                }),
              ),
              style: context.textTheme.headlineSmall,
            ),
          );
        }),
      ],
    );
  }

  Column buildPasswordTextField(
      BuildContext context, CreatePasswordViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.create_password_password_reenter.locale,
              style: context.textTheme.bodyLarge,
            )),
        Observer(builder: (_) {
          return SizedBox(
            height: !viewmodel.hasError ? 44.h : 62.h,
            child: FormBuilderTextField(
              controller: viewmodel.secondPasswordController,
              name: 'password',
              obscureText: viewmodel.isObscure,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: LocaleKeys.login_password_required.locale),
              ]),
              cursorColor: context.colorScheme.tertiary,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.tertiary)),
                filled: true,
                fillColor: context.colorScheme.background,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.onTertiary)),
                suffixIcon: Observer(builder: (_) {
                  return GestureDetector(
                    onTap: viewmodel.changeIsObscure,
                    child: Icon(viewmodel.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                  );
                }),
              ),
              style: context.textTheme.headlineSmall,
            ),
          );
        }),
      ],
    );
  }

  Widget buildLoginButton(
      BuildContext context, CreatePasswordViewModel viewmodel) {
    return Container(
      margin: context.paddingHorizontal1,
      padding: context.padding2,
      width: context.width,
      height: 70.h,
      child: ElevatedButton(
        child: Text(LocaleKeys.login_login.locale),
        onPressed: () {},
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app/application_constants.dart';
import '/core/constants/image/svg_constants.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../viewmodel/login_view_model.dart';

@RoutePage<String>(name: 'LoginRoute')
class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
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
      ),
    );
  }

  Widget buildAnimatedBody(BuildContext context, LoginViewModel viewmodel) {
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
              rememberMeForgotPassword(context, viewmodel),
              buildLoginButton(context, viewmodel),
              SizedBox(height: 10.h),
              dontHaveAccountRegister(context)
            ],
          ),
        ),
      ),
    );
  }

  Row dontHaveAccountRegister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.login_dont_have_account.tr(),
          style: context.textTheme.bodyLarge!
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          LocaleKeys.login_register.tr(),
          style: context.textTheme.bodyLarge!
              .copyWith(color: context.colorScheme.tertiary),
        )
      ],
    );
  }

  Padding rememberMeForgotPassword(
      BuildContext context, LoginViewModel viewmodel) {
    return Padding(
      padding: context.paddingHorizontal2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(
            builder: (context) => Checkbox(
              activeColor: context.colorScheme.tertiary,
              value: viewmodel.rememberMe,
              onChanged: (value) => viewmodel.changeRememberMe(value!),
            ),
          ),
          Text(
            LocaleKeys.login_remember_me.tr(),
            style: context.textTheme.bodyLarge!
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => viewmodel.navigateResetPasswordPage(),
            child: Text(
              LocaleKeys.login_forgot_password.tr(),
              style: context.textTheme.bodyLarge!
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          )
        ],
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
            LocaleKeys.login_hello.tr(),
            style: context.textTheme.displayLarge!,
          ),
          SizedBox(height: 5.h),
          Text(
            LocaleKeys.login_description.tr(),
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
          width: 120.w,
          child: SvgPicture.asset(SVGImageConstants.instance.splashLogo),
        ),
      ],
    );
  }

  FormBuilder buildForm(LoginViewModel viewmodel, BuildContext context) {
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
                        child: buildEmailTextField(context, viewmodel),
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

  Column buildEmailTextField(BuildContext context, LoginViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.login_username.tr(),
              style: context.textTheme.bodyLarge,
            )),
        SizedBox(
          height: !viewmodel.hasError ? 44.h : 62.h,
          child: FormBuilderTextField(
            controller: viewmodel.emailController,
            name: 'email',
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.email(
                    errorText: LocaleKeys.login_enter_valid_email.tr()),
                FormBuilderValidators.required(
                    errorText: LocaleKeys.login_email_required.tr()),
              ],
            ),
            cursorColor: context.colorScheme.tertiary,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.tertiary)),
                filled: true,
                fillColor: context.colorScheme.background,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: context.colorScheme.onTertiary))),
            style: context.textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  Column buildPasswordTextField(
      BuildContext context, LoginViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.login_password.tr(),
              style: context.textTheme.bodyLarge,
            )),
        Observer(builder: (_) {
          return SizedBox(
            height: !viewmodel.hasError ? 44.h : 62.h,
            child: FormBuilderTextField(
              controller: viewmodel.passwordController,
              name: 'password',
              obscureText: viewmodel.isObscure,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: LocaleKeys.login_password_required.tr()),
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

  Widget buildLoginButton(BuildContext context, LoginViewModel viewmodel) {
    return Container(
      margin: context.paddingHorizontal1,
      padding: context.padding2,
      width: context.width,
      height: 70.h,
      child: ElevatedButton(
        child: Text(LocaleKeys.login_login.tr()),
        onPressed: () => viewmodel.login(),
      ),
    );
  }
}

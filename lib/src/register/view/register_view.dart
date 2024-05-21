import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app/application_constants.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../viewmodel/register_view_model.dart';

@RoutePage<String>(name: 'RegisterRoute')
class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      viewModel: RegisterViewModel(),
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

  Widget buildAnimatedBody(BuildContext context, RegisterViewModel viewmodel) {
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
              SizedBox(height: 20.h),
              buildLoginButton(context, viewmodel),
              SizedBox(height: 5.h),
              dontHaveAccountRegister(context, viewmodel)
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
            LocaleKeys.login_welcome.tr(),
            style: context.textTheme.displayLarge!,
          ),
          SizedBox(height: 5.h),
          Text(
            LocaleKeys.login_register_description.tr(),
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

  FormBuilder buildForm(RegisterViewModel viewmodel, BuildContext context) {
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
                        child: buildPasswordTextField1(context, viewmodel),
                      )
                    : Container(),
                viewmodel.isReady
                    ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: viewmodel.startAnimation ? 1 : 0,
                  child: buildPasswordTextField2(context, viewmodel),
                ):Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildEmailTextField(BuildContext context, RegisterViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.login_email.tr(),
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

  Column buildPasswordTextField1(
      BuildContext context, RegisterViewModel viewmodel) {
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
              controller: viewmodel.passwordController1,
              name: 'password1',
              obscureText: viewmodel.isObscure1,
              validator: (value){
                if(value==null || value.isEmpty){
                  return LocaleKeys.login_password_required.tr();
                }
                if(value.length<6){
                  return LocaleKeys.login_password_length.tr();
                }
              },
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
                    onTap: viewmodel.changeIsObscure1,
                    child: Icon(viewmodel.isObscure1
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

  Column buildPasswordTextField2(
      BuildContext context, RegisterViewModel viewmodel) {
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
              controller: viewmodel.passwordController2,
              name: 'password2',
              obscureText: viewmodel.isObscure2,
              validator: (value){
                if(value==null || value.isEmpty){
                  return LocaleKeys.login_password_required.tr();
                }
                if(value.length<6){
                  return LocaleKeys.login_password_length.tr();
                }
                if(viewmodel.passwordController1.text!=viewmodel.passwordController2.text){
                  return LocaleKeys.login_password_match.tr();
                }
              },
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
                    onTap: viewmodel.changeIsObscure2,
                    child: Icon(viewmodel.isObscure2
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

  Row dontHaveAccountRegister(BuildContext context,RegisterViewModel viewmodel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.login_have_account.tr(),
          style: context.textTheme.bodyLarge!
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        SizedBox(
          width: 5.w,
        ),
        GestureDetector(
          onTap: () => viewmodel.navigateLoginPage(),
          child: Text(
            LocaleKeys.login_login.tr(),
            style: context.textTheme.bodyLarge!
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        )
      ],
    );
  }

  Widget buildLoginButton(BuildContext context, RegisterViewModel viewmodel) {
    return Container(
      margin: context.paddingHorizontal1,
      padding: context.padding2,
      width: context.width,
      height: 70.h,
      child: ElevatedButton(
        child: Text(LocaleKeys.login_register.tr()),
        onPressed: () => viewmodel.register(),
      ),
    );
  }
}



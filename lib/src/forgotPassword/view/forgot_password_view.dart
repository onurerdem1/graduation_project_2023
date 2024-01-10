import 'package:auto_route/auto_route.dart';
import 'package:graduation_project_2023/core/extension/string_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app/application_constants.dart';
import '../viewmodel/forgot_password_view_model.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

@RoutePage<String>(name: 'ResetPasswordRoute')
class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ResetPasswordViewModel>(
      viewModel: ResetPasswordViewModel(),
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
      BuildContext context, ResetPasswordViewModel viewmodel) {
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
              SizedBox(height: 50.h),
              //send reset code button

              buildButton(
                  context, viewmodel, LocaleKeys.reset_password_send_code,
                  textColor: context.colorScheme.onPrimary,
                  onPressed: viewmodel.resetPaswwordButtonFunc),
              SizedBox(height: 10.h),
              //login with activation code button
              buildButton(
                  context, viewmodel, LocaleKeys.reset_password_login_with_code,
                  backgroundColor: context.colorScheme.onPrimary,
                  textColor: context.colorScheme.tertiary,
                  borderSide: BorderSide(
                    color: context.colorScheme.tertiary,
                  ),
                  onPressed: viewmodel.navigateActivationPage),
              SizedBox(height: 20.h),
              returnToLoginPage(context, viewmodel)
            ],
          ),
        ),
      ),
    );
  }

  Widget returnToLoginPage(
      BuildContext context, ResetPasswordViewModel viewmodel) {
    return GestureDetector(
      onTap: () => viewmodel.returnLogin(),
      child: Text(
        LocaleKeys.login_login.locale,
        style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.tertiary, fontWeight: FontWeight.w500),
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
            LocaleKeys.login_hello.locale,
            style: context.textTheme.displayLarge!,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            LocaleKeys.login_description.locale,
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
      ResetPasswordViewModel viewmodel, BuildContext context) {
    return FormBuilder(
      key: viewmodel.formKey,
      onChanged: () {
        viewmodel.formKey.currentState!.save();
      },
      child: Observer(
        builder: (_) {
          return Padding(
            padding: context.paddingHorizontal3,
            child: viewmodel.isReady
                ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: viewmodel.startAnimation ? 1 : 0,
                    child: buildEmailTextField(context, viewmodel),
                  )
                : Container(),
          );
        },
      ),
    );
  }

  Column buildEmailTextField(
      BuildContext context, ResetPasswordViewModel viewmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: context.paddingVertical1,
            child: Text(
              LocaleKeys.reset_password_email_Phone.locale,
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
                    errorText: LocaleKeys.login_enter_valid_email.locale),
                FormBuilderValidators.required(
                    errorText: LocaleKeys.login_email_required.locale),
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

  Widget buildButton(
      BuildContext context, ResetPasswordViewModel viewmodel, String buttonText,
      {Color? backgroundColor,
      Color? textColor,
      BorderSide? borderSide,
      required void Function()? onPressed}) {
    return Container(
      margin: context.paddingHorizontal3,
      width: context.width,
      height: 45.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, side: borderSide),
        onPressed: onPressed,
        child: Text(
          buttonText.locale,
          style: context.textTheme.bodyLarge!.copyWith(color: textColor),
        ),
      ),
    );
  }
}

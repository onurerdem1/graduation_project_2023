import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/base/view/base_view.dart';
import '../viewmodel/activation_code_view_model.dart';
import '/core/extension/context_extension.dart';
import '/core/extension/string_extension.dart';
import '/core/init/lang/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/image/svg_constants.dart';

@RoutePage<String>(name: 'ActivationPageRoute')
class ActivationView extends StatelessWidget {
  const ActivationView(
      {Key? key, required this.email, required this.resendCodeFunc})
      : super(key: key);
  final String email;
  final Future<void> Function() resendCodeFunc;

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivationViewModel>(
      viewModel: ActivationViewModel(resendCodeFunc, email: email),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return Scaffold(
          appBar: appBAr(context, viewmodel),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 500.h,
              width: context.width,
              child: Column(
                children: [
                  titleText(context),
                  subtitleText(context),
                  pinfieldBuilder(context, viewmodel),
                  SizedBox(height: 40.h),
                  sendCodeButton(context, viewmodel),
                  SizedBox(height: 30.h),
                  resendInfoText(context),
                  SizedBox(height: 20.h),
                  resendCodeButton(viewmodel),
                  SizedBox(height: 10.h),
                  timer(viewmodel)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Observer timer(ActivationViewModel viewmodel) {
    return Observer(
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          width: context.width,
          child: Text(
            "${LocaleKeys.reset_password_auth_resend_time.locale} ${viewmodel.timerValue}",
            style: context.textTheme.titleSmall,
          ),
        );
      },
    );
  }

  SizedBox resendCodeButton(ActivationViewModel viewmodel) {
    return SizedBox(
      width: 160.w,
      height: 30.h,
      child: Observer(
        builder: (context) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.background,
                side: BorderSide(
                  color: viewmodel.timerValue != 0
                      ? context.colorScheme.onTertiary
                      : context.colorScheme.tertiary,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.w))),
            onPressed: viewmodel.timerValue == 0 ? viewmodel.reSendCode : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.reset_password_resend_code.locale,
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: viewmodel.timerValue != 0
                          ? context.colorScheme.onTertiary
                          : context.colorScheme.tertiary),
                ),
                Icon(
                  Icons.replay,
                  color: viewmodel.timerValue != 0
                      ? context.colorScheme.onTertiary
                      : context.colorScheme.tertiary,
                )
              ],
            )),
      ),
    );
  }

  Padding resendInfoText(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontal2,
      child: Text(
        LocaleKeys.reset_password_code_expire_note.locale,
        textAlign: TextAlign.center,
      ),
    );
  }

  SizedBox sendCodeButton(BuildContext context, ActivationViewModel viewmodel) {
    return SizedBox(
      width: 300.w,
      height: 45.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.onTertiary),
          onPressed: () => viewmodel.sendAuthCode(),
          child: Text(LocaleKeys.reset_password_next.locale)),
    );
  }

  Container pinfieldBuilder(
      BuildContext context, ActivationViewModel viewmodel) {
    return Container(
      margin: context.paddingHorizontal2,
      width: context.width,
      height: 40.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: context.paddingHorizontal1,
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                border: Border.all(color: context.colorScheme.onTertiary),
                borderRadius: BorderRadius.circular(10.w)),
            child: TextFormField(
              onChanged: (value) {
                viewmodel.jumpToNextPinField(index, value, context);
              },
              controller: viewmodel.textFieldControllerList[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              autofocus: true,
              decoration: const InputDecoration(counterText: ""),
              textInputAction:
                  index == 5 ? TextInputAction.done : TextInputAction.next,
            ),
          );
        },
      ),
    );
  }

  Padding subtitleText(BuildContext context) {
    return Padding(
      padding: context.padding2,
      child: Text(
        LocaleKeys.reset_password_auth_code_description.locale,
        style: context.textTheme.bodyMedium,
      ),
    );
  }

  Container titleText(BuildContext context) {
    return Container(
      padding: context.paddingHorizontal2,
      alignment: Alignment.centerLeft,
      child: Text(
        LocaleKeys.reset_password_auth_code.locale,
        style: context.textTheme.displayLarge,
      ),
    );
  }

  PreferredSize appBAr(BuildContext context, ActivationViewModel viewmodel) {
    return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: AppBar(
        backgroundColor: context.colorScheme.background,
        automaticallyImplyLeading: true,
        toolbarHeight: 130.h,
        elevation: 0,
        // title: buildLogo(context),
        leading: IconButton(
          padding: context.padding2,
          alignment: Alignment.topLeft,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.onBackground,
            size: 24.sp,
          ),
          onPressed: viewmodel.returnPreviousPage,
        ),
      ),
    );
  }

  Widget buildLogo(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      height: 150.h,
      // child: SvgPicture.asset(
      //   SVGImageConstants.instance.loginToprightImage,
      //   fit: BoxFit.fitWidth,
      //   alignment: Alignment.topRight,
      //   allowDrawingOutsideViewBox: true,
      // ),
    );
  }
}

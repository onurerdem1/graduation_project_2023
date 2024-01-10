import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../src/splash/view/splash_view.dart';
import '../../../src/login/view/login_view.dart';
import '../../../src/forgotPassword/view/forgot_password_view.dart';
import '../../../src/activationCode/view/activation_code_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(generateForDir: ['lib/src'])
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: ResetPasswordRoute.page,
          path: '/resetPassword',
        ),
        AutoRoute(
          page: ActivationPageRoute.page,
          path: '/activationCode',
        ),
        //routes
      ];
}

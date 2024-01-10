import 'package:auto_route/auto_route.dart';
import '../../../src/splash/view/splash_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(generateForDir: ['lib/src'])
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
        )
        //routes
      ];
}

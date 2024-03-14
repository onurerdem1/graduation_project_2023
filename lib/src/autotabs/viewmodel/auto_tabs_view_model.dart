import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';

import '../../../core/init/navigation/app_router.dart';
part 'auto_tabs_view_model.g.dart';

class AutoTabsViewModel = _AutoTabsViewModelBase with _$AutoTabsViewModel;

abstract class _AutoTabsViewModelBase with Store, BaseViewModel {
  @observable
  bool isLoading = false;

  @override
  void setContext(BuildContext context) => buildContext = context;
  @override
  Future<void> init() async {}

  @action
  void changeIsLoading() {
    isLoading = !isLoading;
  }

  List<PageRouteInfo> routeList = const [
    HomepageRoute(),
    HistoryPageRoute(),
    ProfileRoute(),
  ];
  void fillRouteList() {
    routeList = [];
  }

  late TabsRouter tRouter;

  void initTabsRouter(TabsRouter router) {
    tRouter = router;
  }

  @observable
  String currentRoute = "";

  @action
  Future<void> navigateBottomBarTab(route) async {
    await tRouter.navigate(route);
    currentRoute = tRouter.current.name;
  }
}

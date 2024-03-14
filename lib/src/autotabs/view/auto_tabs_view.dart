import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project_2023/core/extension/context_extension.dart';
import 'package:graduation_project_2023/core/extension/string_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../viewmodel/auto_tabs_view_model.dart';

@RoutePage(name: 'AutoTabsRoute')
class AutoTabsView extends StatelessWidget {
  const AutoTabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AutoTabsViewModel>(
      viewModel: AutoTabsViewModel(),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return AutoTabsScaffold(
            backgroundColor: context.colorScheme.background,
            routes: viewmodel.routeList,
            transitionBuilder: (context, child, animation) {
              return child;
            },
            extendBody: true,
            bottomNavigationBuilder: (
              context,
              tabsRouter,
            ) {
              viewmodel.initTabsRouter(tabsRouter);

              return Container(
                width: context.width,
                height: 70.h,
                decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.w),
                        topRight: Radius.circular(30.w)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          offset: Offset(0, 1),
                          blurRadius: 10.w)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildBottombarIcon(viewmodel, viewmodel.routeList[0],
                            Icons.home, context),
                        buildBottombarIcon(viewmodel, viewmodel.routeList[1],
                            Icons.calendar_month, context),
                        buildBottombarIcon(viewmodel, viewmodel.routeList[2],
                            Icons.notifications, context),
                        buildBottombarIcon(viewmodel, viewmodel.routeList[3],
                            Icons.person, context),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  Widget buildBottombarIcon(AutoTabsViewModel viewmodel, PageRouteInfo route,
      IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => viewmodel.navigateBottomBarTab(route),
      child: SizedBox(
        width: 25.w,
        height: 25.w,
        child: SvgPicture.asset(
          route.routeName.bottombarIcon,
          colorFilter: ColorFilter.mode(
              viewmodel.tRouter.current.name == route.routeName
                  ? context.colorScheme.tertiary
                  : context.colorScheme.onTertiary,
              BlendMode.srcIn),
        ),
      ),
    );
  }
}

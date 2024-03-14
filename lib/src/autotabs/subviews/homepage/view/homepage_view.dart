import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/base/view/base_view.dart';
import '../viewmodel/homepage_view_model.dart';

@RoutePage(name: 'HomepageRoute')
class HomepageView extends StatelessWidget {
  const HomepageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomepageViewModel>(
      viewModel: HomepageViewModel(),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return Scaffold(
          body: Center(
            child: Text('HOMEPAGE'),
          ),
        );
      },
    );
  }
}

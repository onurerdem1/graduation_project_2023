import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/base/view/base_view.dart';
import '../viewmodel/profile_view_model.dart';

@RoutePage(name: 'ProfileRoute')
class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModel: ProfileViewModel(),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return Scaffold(
          body: Center(
            child: Text('PROFILE'),
          ),
        );
      },
    );
  }
}

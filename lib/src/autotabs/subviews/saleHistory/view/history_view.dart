import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/base/view/base_view.dart';
import '../viewmodel/history_view_model.dart';

@RoutePage(name: 'HistoryPageRoute')
class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      viewModel: HistoryViewModel(),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
      },
      onPageBuilder: (context, viewmodel) {
        return Scaffold(
          body: Center(
            child: Text('HISTORY'),
          ),
        );
      },
    );
  }
}

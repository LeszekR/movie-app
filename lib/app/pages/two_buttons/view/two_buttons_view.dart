import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_controller.dart';
import 'package:flutter_demo/app/pages/two_buttons/two_button_navigation/two_button_navigator.dart';

import '../../../../domain/ui_localized_texts/txt.dart';
import '../../../../bootstrap/get_it_model.dart';
import '../../../components/buttons/button_builder.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizes.dart';
import 'components/button_two_states.dart';

class TwoButtonsView extends CleanView {
  static var movieListButtonKey = Key("movieListButtonKey");
  static var button1Key = Key('button1Key');
  static var button2Key = Key('button2Key');

  const TwoButtonsView({super.key});

  @override
  TwoButtonsViewState createState() => TwoButtonsViewState();
}

class TwoButtonsViewState extends CleanViewState<TwoButtonsView, TwoButtonsController> {
  final Txt _txt;

  TwoButtonsViewState()
      : _txt = getIt<Txt>(),
        super(getIt<TwoButtonsController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder<TwoButtonsController>(builder: (context, controller) {
      final Txt txt = getIt<Txt>();
      final TwoButtonNavigator twoButtonNavigator = getIt<TwoButtonNavigator>();

      return Scaffold(
        appBar: AppBar(
          title: Text(txt.get.two_button_view_title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarBackground,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTwoStates(
                key: TwoButtonsView.button1Key,
                index: 0,
                isOn: controller.state.buttonStates[0],
                onChange: (bool isOn) => controller.clickButton(0),
              ),
              const SizedBox(width: 8),
              ButtonTwoStates(
                key: TwoButtonsView.button2Key,
                index: 1,
                isOn: controller.state.buttonStates[1],
                onChange: (bool isOn) => controller.clickButton(1),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: AppSizes.dialogBottomBarHeight,
          color: AppColors.appBarBackground,
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              ButtonBuilder()
                  .onTap(() => twoButtonNavigator.navigate(context, NavMovieList()))
                  .key(TwoButtonsView.movieListButtonKey)
                  .text(txt.get.goto_movie_list)
                  .width(AppSizes.navButtonWidth)
                  .build(),
              AppSizes.horizontalSeparator()
            ],
          ),
        ),
      );
    });
  }
}

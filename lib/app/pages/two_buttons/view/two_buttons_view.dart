import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_controller.dart';

import '../../../../app/ui_localized_texts/txt.dart';
import '../../../../bootstrap/get_it_model.dart';
import '../../../components/buttons/button_builder.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizes.dart';
import '../../../config/app_style.dart';
import '../navigation/two_buttons_navigator.dart';
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
  final TwoButtonsNavigator _twoButtonNavigator;

  TwoButtonsViewState()
      : _txt = getIt<Txt>(),
        _twoButtonNavigator = getIt<TwoButtonsNavigator>(),
        super(getIt<TwoButtonsController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder<TwoButtonsController>(builder: (context, controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_txt.get.two_button_view_title),
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
              Expanded(child: const SizedBox()),
              ButtonBuilder(context)
                  .onTap((context) => _twoButtonNavigator.navigate(context, NavMovieList()))
                  .key(TwoButtonsView.movieListButtonKey)
                  .text(_txt.get.goto_movie_list)
                  .width(AppSizes.navButtonWidth)
                  .build(),
              AppStyle.horizontalSeparator()
            ],
          ),
        ),
      );
    });
  }
}

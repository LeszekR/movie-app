import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common/config/app_colors.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/components/button_builder.dart';
import 'package:flutter_demo/pages/two_buttons/bloc/two_button_cubit.dart';
import 'package:flutter_demo/pages/two_buttons/bloc/two_button_state.dart';
import 'package:flutter_demo/pages/two_buttons/components/button_two_states.dart';
import 'package:flutter_demo/pages/two_buttons/two_button_navigation/two_button_navigator.dart';

class TwoButtonsView extends StatelessWidget {
  static Key movieListButtonKey = const Key('movieListButtonKey');
  static Key button1Key = const Key('button1Key');
  static Key button2Key = const Key('button2Key');

  final Txt txt;
  final TwoButtonNavigator twoButtonNavigator;

  const TwoButtonsView({
    required this.txt, required this.twoButtonNavigator, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwoButtonCubit>();
    return BlocConsumer<TwoButtonCubit, TwoButtonState>(
        listenWhen: (prev, curr) => prev.navCommand != curr.navCommand,
        listener: (context, state) => twoButtonNavigator.go(context, state.navCommand),
        builder: (context, state) {
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
                    isOn: state.buttonStates[0],
                    onChange: (bool isOn) => cubit.toggleOn(0), //_onButtonValueChange(index: 0, isOn: isOn),
                  ),
                  const SizedBox(width: 8),
                  ButtonTwoStates(
                    key: TwoButtonsView.button2Key,
                    index: 1,
                    isOn: state.buttonStates[1],
                    onChange: (bool isOn) => cubit.toggleOn(1), //_onButtonValueChange(index: 1, isOn: isOn),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: AppSizes.dialogBottomBarHeight,
              color: AppColors.appBarBackground,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ButtonBuilder(context)
                      .onTap(cubit.showMovieList)
                      .key(TwoButtonsView.movieListButtonKey)
                      .text(txt.get.goto_movie_list)
                      .width(AppSizes.navButtonWidth)
                      .build(),
                  AppSizes.horizontalSeparator(),
                ],
              ),
            ),
          );
        },);
  }
}

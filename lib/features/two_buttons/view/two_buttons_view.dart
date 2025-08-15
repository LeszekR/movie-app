import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common/config/app_colors.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_state.dart';
import 'package:flutter_demo/features/two_buttons/two_button_navigation/two_button_navigator.dart';

import '../../../common/config/app_sizes.dart';
import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/button_builder.dart';
import '../bloc/two_button_cubit.dart';
import '../components/button_two_states.dart';

class TwoButtonsView extends StatelessWidget {
  static var movieListButtonKey = Key("movieListButtonKey");
  static var button1Key = Key('button1Key');
  static var button2Key = Key('button2Key');

  final Txt _txt;
  final TwoButtonNavigator _twoButtonNavigator;

  const TwoButtonsView(this._txt, this._twoButtonNavigator, {super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwoButtonCubit>();
    return BlocConsumer<TwoButtonCubit, TwoButtonState>(
        listenWhen: (prev, curr) => prev.navCommand != curr.navCommand,
        listener: (context, state) => _twoButtonNavigator.go(context, state.navCommand),
        builder: (context, state) {
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
                  Expanded(child: SizedBox()),
                  ButtonBuilder()
                      .onTap(cubit.showMovieList)
                      .key(TwoButtonsView.movieListButtonKey)
                      .text(_txt.get.goto_movie_list)
                      .width(200)
                      .build(),
                  AppSizes.horizontalSeparator()
                ],
              ),
            ),
          );
        });
  }
}

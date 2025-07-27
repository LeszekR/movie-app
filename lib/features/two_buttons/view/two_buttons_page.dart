import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_state.dart';
import 'package:flutter_demo/features/two_buttons/two_button_navigation/two_button_navigator.dart';

import '../../../common/config/app_sizes.dart';
import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/button_builder.dart';
import '../bloc/two_button_cubit.dart';
import '../components/button_two_states.dart';

class TwoButtonsPage extends StatelessWidget {
  final TwoButtonNavigator _twoButtonNavigator;
  const TwoButtonsPage(this._twoButtonNavigator, {super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TwoButtonCubit>();
    return BlocConsumer<TwoButtonCubit, TwoButtonState>(
        listenWhen: (prev, curr) => prev.navCommand != curr.navCommand,
        listener: (context, state) => _twoButtonNavigator.go(context, state.navCommand),
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('2-state buttons'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTwoStates(
                    index: 0,
                    isOn: state.buttonStates[0],
                    onChange: (bool isOn) => cubit.toggleOn(0), //_onButtonValueChange(index: 0, isOn: isOn),
                  ),
                  const SizedBox(width: 8),
                  ButtonTwoStates(
                    index: 1,
                    isOn: state.buttonStates[1],
                    onChange: (bool isOn) => cubit.toggleOn(1), //_onButtonValueChange(index: 1, isOn: isOn),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
                height: AppSizes.dialogBottomBarHeight,
                color: Colors.amberAccent.shade100,
                child: Row(
                  children: [
                    Expanded(child: SizedBox()),
                    ButtonBuilder(cubit.showMovieList)
                        .text(Txt.get.goto_movie_list)
                        .width(200)
                        .build(),
                    AppSizes.horizontalSeparator()
                  ],
                )),
          );
        });
  }

  // void _onButtonValueChange({required int index, required bool isOn}) {
  //   final int indexOtherButton = (index + 1) % _buttonIsOn.length;
  //
  //   _buttonIsOn[index] = isOn;
  //   _buttonIsOn[indexOtherButton] = !isOn;
  //
  //   setState(() {});
  // }
}

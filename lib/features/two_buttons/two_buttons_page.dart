import 'package:flutter/material.dart';

import '../../common/config/app_sizes.dart';
import '../../common/ui_localized_texts/txt.dart';
import '../../components/button_builder.dart';
import '../../navigation/app_navigator.dart';
import 'components/button_two_states.dart';

class TwoButtonsPage extends StatefulWidget {
  final AppNavigator appNavigator;

  const TwoButtonsPage(this.appNavigator, {super.key});

  @override
  TwoButtonsPageState createState() => TwoButtonsPageState();
}

class TwoButtonsPageState extends State<TwoButtonsPage> {
  final List<bool> _buttonIsOn = [true, false];

  @override
  Widget build(BuildContext context) => Scaffold(
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
                isOn: _buttonIsOn[0],
                onChange: (bool isOn) => _onButtonValueChange(index: 0, isOn: isOn),
              ),
              const SizedBox(width: 8),
              ButtonTwoStates(
                index: 1,
                isOn: _buttonIsOn[1],
                onChange: (bool isOn) => _onButtonValueChange(index: 1, isOn: isOn),
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
                ButtonBuilder(() => widget.appNavigator.movieList(context))
                    .text(Txt.get.goto_movie_list)
                    .width(200)
                    .build(),
                AppSizes.horizontalSeparator()
              ],
            )),
      );

  void _onButtonValueChange({required int index, required bool isOn}) {
    final int indexOtherButton = (index + 1) % _buttonIsOn.length;

    _buttonIsOn[index] = isOn;
    _buttonIsOn[indexOtherButton] = !isOn;

    setState(() {});
  }
}

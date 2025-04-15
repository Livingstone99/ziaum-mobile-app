import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';

import 'textWidget.dart';

class PinKeyboard extends StatelessWidget {
  final BiometricType biometric;
  final bool showBiometric;
  final ValueSetter<String> onKeyPressed;

  PinKeyboard(
      {required this.onKeyPressed,
      this.biometric = BiometricType.face,
      this.showBiometric = false});

  @override
  Widget build(BuildContext context) {
    Widget bioWidget = SizedBox();

    print(biometric);
    if (showBiometric) {
      if (biometric == BiometricType.face || biometric == BiometricType.iris) {
        bioWidget = SvgPicture.asset("assets/images/svg/iris-scan.svg");
      } else if (biometric == BiometricType.weak) {
        bioWidget = SvgPicture.asset(
          "assets/images/svg/fingerprint.svg",
          height: 45,
        );
      }
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildRow(['biomet', '0', '<'],
              bioWidget: bioWidget, hasEmptyButton: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    List<String> buttons, {
    bool hasEmptyButton = false,
    Widget bioWidget = const SizedBox(),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0), // Set your desired border radius
                ),
              ),
              onPressed: () {
                if (!showBiometric && button == "biomet") {
                  return;
                } else {
                  onKeyPressed(button);
                }
              },
              child: button == '<'
                  ? Icon(Icons.backspace)
                  : (showBiometric && button == "biomet")
                      ? bioWidget
                      : TextWidget(
                          text: (button == "biomet") ? "" : button,
                          fontSize: 25,
                          textColor: Colors.blue.shade900,
                        ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/core/utils/data_connection_checker.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';
import 'package:provider/provider.dart';

class CustomButtonWithProgress extends StatelessWidget {
  final String text;
  final bool isShowProgress;
  final Function onPressed;
  final TextStyle textStyle;
  final bool hideText;
  final Color buttonColor;
  final double progressSize;
  final double borderRadius;

  CustomButtonWithProgress(
      {required this.text,
      required this.onPressed,
      this.isShowProgress = false,
      this.textStyle = const TextStyle(fontSize: 17.2, color: Colors.white),
      this.hideText = false,
      this.buttonColor = primaryColor,
      this.progressSize = 25,
      this.borderRadius = 6});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: buttonColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hideText && isShowProgress
              ? SizedBox()
              : Text(text, style: textStyle),
          SizedBox(width: isShowProgress ? 10 : 0),
          isShowProgress
              ? Container(
                  width: progressSize,
                  height: progressSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.7,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Container()
        ],
      ),
      onPressed: () {
        if (!isShowProgress) {
          onPressed();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';

class Loading extends StatelessWidget {
  final double strokeWidth;
  Color? color;

  Loading({this.strokeWidth = 4.0, this.color});

  @override
  Widget build(BuildContext context) {
    if (color == null) color = primaryColor;
    return Center(
      child: Theme(
        data: ThemeData(accentColor: primaryColor),
        child: new CircularProgressIndicator(strokeWidth: strokeWidth),
      ),
    );
  }
}

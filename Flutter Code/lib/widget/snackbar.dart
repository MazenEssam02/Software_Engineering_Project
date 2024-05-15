import 'package:flutter/material.dart';
import 'package:expenso/theme/colors.dart';
import 'package:flutter/widgets.dart';

class CustomSnackBar {
  BuildContext ctx;
  bool haserror = false;
  String title, actionTile;
  void Function()? onPressed;
  bool isfloating;

  CustomSnackBar(
      {required this.ctx,
      required this.title,
      required this.haserror,
      required this.actionTile,
      required this.isfloating,
      this.onPressed});

  void show() {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: haserror ? errorColor : succses,
      behavior: isfloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: isfloating ? EdgeInsets.all(20) : null,
      duration: Duration(seconds: 2),
      action: actionTile != ""
          ? SnackBarAction(
              label: actionTile,
              onPressed: onPressed ??
                  () {
                    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                  },
              textColor: white,
            )
          : null,
    ));
  }
}

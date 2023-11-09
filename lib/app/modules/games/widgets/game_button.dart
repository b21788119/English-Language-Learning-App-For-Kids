import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:flutter/material.dart';

Widget getGameButton(IconData iconData, VoidCallback onpress) {
  return Container(
    height: 5.0.hp,
    decoration: BoxDecoration(
      border: Border.all(
        color: darkBlue100,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ElevatedButton(
      onPressed: onpress,
      child: Icon(
        iconData,
        size: 4.0.hp,
        color: Colors.white,
      ),
    ),
  );
}

import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:flutter/widgets.dart';

Widget getGameTitle(String title, int gameNumber) {
  var padding;
  var fontSize;
  if (gameNumber == 1) {
    padding = EdgeInsets.all(4.0.wp);
    fontSize = 24.0.sp;
  } else if (gameNumber == 2) {
    padding = EdgeInsets.only(
        left: 1.0.wp, right: 1.0.wp, top: 4.0.wp, bottom: 4.0.wp);
    fontSize = 12.0.sp;
  } else if (gameNumber == 3) {
    padding = EdgeInsets.only(
        left: 4.0.wp, right: 4.0.wp, top: 14.0.wp, bottom: 1.0.wp);
    fontSize = 24.0.sp;
  } else if (gameNumber == 4) {
    padding = EdgeInsets.only(
        left: 4.0.wp, right: 4.0.wp, top: 14.0.wp, bottom: 1.0.wp);
    fontSize = 24.0.sp;
  } else if (gameNumber == 5) {
    padding = EdgeInsets.only(
        left: 4.0.wp, right: 4.0.wp, top: 14.0.wp, bottom: 1.0.wp);
    fontSize = 24.0.sp;
  } else if (gameNumber == 6) {
    padding = EdgeInsets.only(
        left: 4.0.wp, right: 4.0.wp, top: 14.0.wp, bottom: 1.0.wp);
    fontSize = 24.0.sp;
  }
  return Center(
    child: Padding(
      padding: EdgeInsets.all(4.0.wp),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 24.0.sp,
          fontWeight: FontWeight.w900,
          color: darkBlue100,
          shadows: const [
            Shadow(
              color: blue,
              offset: Offset(2, 3),
              blurRadius: 5,
            ),
          ],
          letterSpacing: 2.0.wp,
        ),
      ),
    ),
  );
}

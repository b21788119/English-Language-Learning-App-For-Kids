import 'package:first_app/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String pageName;
  final String menuItemName;
  final IconData iconData;

  const MenuItem({
    super.key,
    required this.pageName,
    required this.menuItemName,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(pageName);
      },
      child: Container(
        margin: EdgeInsets.all(3.0.wp),
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 65, 204, 70),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 11, 54, 13),
              blurRadius: 15,
              offset: Offset(3, 9),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 10.0.wp,
              color: const Color.fromARGB(255, 242, 253, 240),
            ),
            Text(
              menuItemName,
              style: TextStyle(
                color: const Color.fromARGB(255, 242, 253, 240),
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

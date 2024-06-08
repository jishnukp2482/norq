import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key, required this.appBarTitle, this.onPressed})
      : super(key: key);

  final String appBarTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(60),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            color: AppColors.black,
            blurStyle: BlurStyle.outer,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: w * 0.02, top: h * 0.01),
            child: SizedBox(
              //color: AppColors.blue,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.02, 0, 0, 0),
                    child: Text(
                      appBarTitle,
                      style: TextStyle(
                        letterSpacing: 1,
                        color: AppColors.white,
                        fontSize: w * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}

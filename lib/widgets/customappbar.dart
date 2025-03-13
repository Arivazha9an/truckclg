import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isGoBack;
  const CustomAppBar({
    super.key,
    required this.title,
    this.isGoBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isGoBack
          ? Container(
              margin: const EdgeInsets.only(left: 10),
              width: 25,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          : Container(),
      title: Text(
        title,
        style: const TextStyle(
          color: lightBlack,
          letterSpacing: 1,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

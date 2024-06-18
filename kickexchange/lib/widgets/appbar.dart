import 'package:flutter/material.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/views/favorite_product.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Kick",
            style: TextStyle(
              fontFamily: 'raleway',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
            ),
          ),
          Text(
            "Exchange",
            style: TextStyle(
              fontFamily: 'montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FavoriteProductsPage(),
                ),
              ),
              icon: Icon(
                Icons.favorite_border_outlined,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

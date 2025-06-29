import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tractian_task/core/utils/assets_manager.dart';
import 'package:tractian_task/core/utils/colors_manager.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: ColorsManager.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AssetsManager.homeIcon),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

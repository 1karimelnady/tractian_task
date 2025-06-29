import 'package:flutter/material.dart';
import 'package:tractian_task/core/utils/colors_manager.dart';

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ColorsManager.primary : Colors.transparent,
          border: Border.all(
            color: isActive ? ColorsManager.primary : ColorsManager.borderGray,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Color(0xff77818C),
              size: 16,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: isActive ? Colors.white : Color(0xff77818C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

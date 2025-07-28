import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String text;
  final String subText;
  final IconData iconData;

  const ProfileWidget({
    super.key,
    required this.text,
    required this.subText,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.primaryColor
              : AppColors.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(iconData, size: AppSizes.iconMd, color: AppColors.primaryColor),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: AppSizes.md),
              ), // Tani waa magaca qaybta
              Text(
                subText, // Halkan waxaa lagu daabacayaa subText (sida taleefanka ama emailka)
                style: TextStyle(fontSize: AppSizes.md, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

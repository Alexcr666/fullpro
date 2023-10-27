import 'package:flutter/material.dart';

class LanguageItem extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final IconData icon;
  final Color textColor;
  final Color bgColor;
  final Color iconColor;
  final Widget prefixWidget;

  const LanguageItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.textColor,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
    required this.prefixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 13.0),
                Text(
                  title,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
            prefixWidget
          ],
        ),
      ),
    );
  }
}

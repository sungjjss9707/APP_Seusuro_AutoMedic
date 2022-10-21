import 'package:flutter/material.dart';

class ListTileButton extends StatelessWidget {
  const ListTileButton({
    Key? key,
    required this.content,
    required this.onTap,
    this.showIcon = true,
    this.textColor = Colors.black,
  }) : super(key: key);

  final String content;
  final bool showIcon;
  final Color textColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              content,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            showIcon ? const Icon(Icons.chevron_right_rounded) : Container(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined, text }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.elevated,
    this.size = ButtonSize.medium,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    EdgeInsets padding;
    double fontSize;

    switch (size) {
      case ButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        fontSize = 14;
        break;
      case ButtonSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        fontSize = 16;
        break;
      case ButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
        fontSize = 18;
        break;
    }

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    Widget button;

    switch (type) {
      case ButtonType.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: padding,
            textStyle:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            padding: padding,
            textStyle:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
            side: BorderSide(color: color ?? theme.primaryColor),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: color,
            padding: padding,
            textStyle:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
          child: buttonChild,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

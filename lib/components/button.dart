import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'index.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';

enum ButtonType { primary, secondary, price, exit }

class ButtonTheme {
  ButtonTheme(this.color, this.backgroundColor);
  ButtonTheme.primary()
      : this.color = AppColors.white,
        this.backgroundColor = AppColors.brandBlue;
  ButtonTheme.primaryDark()
      : this.color = AppColors.white,
        this.backgroundColor = AppColors.brandDarkBlue;
  ButtonTheme.secondary()
      : color = AppColors.brandBlue,
        backgroundColor = AppColors.grey6;
  ButtonTheme.secondaryDark()
      : color = AppColors.brandDarkBlue,
        backgroundColor = AppColors.darkGrey6;
  ButtonTheme.price({bool disable = false})
      : color = AppColors.white,
        backgroundColor = disable ? AppColors.brandBlue.withOpacity(0.2) : AppColors.brandBlue;
  ButtonTheme.priceDark({bool disable = false})
      : color = disable ? AppColors.backgroundDarkPrimary : AppColors.white,
        backgroundColor = disable ? AppColors.brandDarkBlue.withOpacity(0.2) : AppColors.brandDarkBlue;
  ButtonTheme.exit()
      : color = AppColors.systemRed,
        backgroundColor = AppColors.grey6;
  ButtonTheme.exitDark()
      : color = AppColors.systemDarkRed,
        backgroundColor = AppColors.darkGrey6;

  final Color color;
  final Color backgroundColor;
}

class Button extends StatelessWidget {
  Button({
    Key? key,
    this.title,
    this.type = ButtonType.primary,
    required this.onPress,
    this.margin,
    this.leading,
    this.width,
    this.iconSize,
    this.padding,
    this.price,
    this.disable = false,
  }) : super(key: key);

  final String? title;
  final ButtonType type;
  final Function onPress;
  final EdgeInsetsGeometry? margin;
  final String? leading;
  final double? width;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final int? price;
  final bool disable;

  ButtonTheme getTheme(ButtonType type, bool isDark) {
    switch (type) {
      case ButtonType.primary:
        if (isDark) return ButtonTheme.primaryDark();
        return ButtonTheme.primary();
      case ButtonType.secondary:
        if (isDark) return ButtonTheme.secondaryDark();
        return ButtonTheme.secondary();
      case ButtonType.price:
        if (isDark) return ButtonTheme.priceDark(disable: disable);
        return ButtonTheme.price(disable: disable);
      case ButtonType.exit:
        if (isDark) return ButtonTheme.exitDark();
        return ButtonTheme.exit();
      default:
        if (isDark) return ButtonTheme(Colors.red, Colors.white);
        return ButtonTheme(Colors.red, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    ButtonTheme theme = getTheme(type, themeProvider.mode == ThemeMode.dark);

    return Container(
      height: 52,
      width: width != null ? width : null,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(padding != null ? padding : EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all(theme.backgroundColor),
            foregroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: Row(
            mainAxisAlignment: type == ButtonType.price ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              if (leading != null)
                Container(
                  margin: title != null ? EdgeInsets.only(right: 8) : null,
                  child: CustomIcon(
                    leading!,
                    color: theme.color,
                    width: iconSize != null ? iconSize! : 24,
                    height: iconSize != null ? iconSize! : 24,
                  ),
                ),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(color: theme.color, fontWeight: FontWeight.w400, fontSize: 17),
                ),
              if (price != null)
                Container(
                  height: 28,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$price₽',
                    style: TextStyle(color: theme.color, fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                )
            ],
          ),
          onPressed: disable ? null : () => onPress(),
        ),
      ),
    );
  }
}
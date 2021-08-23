import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';
import 'package:flutter/services.dart';
import 'package:voda/components/index.dart';

class HeaderTheme {
  HeaderTheme.light()
      : this.helper = AppColors.typographyTertiary,
        this.background = AppColors.backgroundPrimary,
        this.icon = AppColors.brandBlue,
        this.title = AppColors.typographyPrimary,
        this.systemOverlayStyle = SystemUiOverlayStyle.dark;
  HeaderTheme.dark()
      : this.helper = AppColors.typographyDarkTertiary,
        this.background = AppColors.backgroundDarkPrimary,
        this.icon = AppColors.brandDarkBlue,
        this.title = AppColors.typographyDarkPrimary,
        this.systemOverlayStyle = SystemUiOverlayStyle.light;

  final Color helper;
  final SystemUiOverlayStyle systemOverlayStyle;
  final Color background;
  final Color icon;
  final Color title;
}

enum HeaderLeading { notification }

class Header extends StatelessWidget implements PreferredSizeWidget {
  Header({
    Key? key,
    this.theme,
    this.title,
    this.height = 60,
    this.leading,
  })  : preferredSize = Size.fromHeight(height),
        super(key: key);

  final ThemeMode? theme;
  final String? title;
  final double height;
  final Size preferredSize;
  final HeaderLeading? leading;

  @override
  Widget build(BuildContext context) {
    HeaderTheme _theme;
    if (theme != null) {
      _theme = theme == ThemeMode.dark ? HeaderTheme.dark() : HeaderTheme.light();
    } else {
      ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _theme = themeProvider.mode == ThemeMode.dark ? HeaderTheme.dark() : HeaderTheme.light();
    }

    return AppBar(
      centerTitle: true,
      toolbarHeight: height,
      elevation: 0,
      systemOverlayStyle: _theme.systemOverlayStyle,
      title: Text(
        title ?? '',
        style: TextStyle(
          color: _theme.title,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      backwardsCompatibility: false,
      backgroundColor: _theme.background,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context, leading),
      actions: [
        IconButton(
          icon: CustomIcon(CustomIcons.shoppingCart, color: _theme.icon),
          onPressed: () => Navigator.of(context).pushNamed('/shoppingcart'),
        ),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context, HeaderLeading? leading) {
    HeaderTheme _theme = theme == ThemeMode.dark ? HeaderTheme.dark() : HeaderTheme.light();

    switch (leading) {
      case HeaderLeading.notification:
        return IconButton(
          icon: CustomIcon(CustomIcons.notification, color: _theme.icon),
          onPressed: () => Navigator.of(context).pushNamed('/notifications'),
        );
      default:
        return null;
    }
  }
}

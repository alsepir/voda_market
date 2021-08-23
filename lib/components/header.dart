import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:flutter/services.dart';
import 'package:voda/components/index.dart';

class HeaderTheme {
  HeaderTheme.light()
      : this.helper = AppColors.typographyTertiary,
        this.background = AppColors.backgroundPrimary,
        this.icon = AppColors.typographyPrimary,
        this.title = AppColors.typographyPrimary,
        this.systemOverlayStyle = SystemUiOverlayStyle.dark;
  HeaderTheme.dark()
      : this.helper = AppColors.typographyDarkTertiary,
        this.background = AppColors.backgroundDarkPrimary,
        this.icon = AppColors.typographyDarkPrimary,
        this.title = AppColors.typographyDarkPrimary,
        this.systemOverlayStyle = SystemUiOverlayStyle.light;

  final Color helper;
  final SystemUiOverlayStyle systemOverlayStyle;
  final Color background;
  final Color icon;
  final Color title;
}

enum HeaderLeading { notification, back }

class Header extends StatelessWidget implements PreferredSizeWidget {
  Header({
    Key? key,
    this.theme,
    this.title,
    this.height = 60,
    this.leading,
    this.actions,
    this.backgroundColor,
  })  : preferredSize = Size.fromHeight(height),
        super(key: key);

  final ThemeMode? theme;
  final String? title;
  final double height;
  final Size preferredSize;
  final HeaderLeading? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;

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
      backgroundColor: backgroundColor ?? _theme.background,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context, leading, _theme),
      actions: actions,
    );
  }

  Widget? _buildLeading(BuildContext context, HeaderLeading? leading, HeaderTheme theme) {
    switch (leading) {
      case HeaderLeading.notification:
        return Consumer<NotificationsProvider>(
          builder: (context, notifications, child) {
            int? quantity = notifications.data?.length;
            return IconButton(
              icon: CustomIcon(
                CustomIcons.notification,
                withBadge: true,
                badgeValue: quantity,
                badgeType: CustomIconBadge.red,
                color: theme.icon,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/notifications'),
            );
          },
        );
      case HeaderLeading.back:
        return IconButton(
          icon: CustomIcon(
            CustomIcons.caretLeft,
            color: theme.icon,
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        );
      default:
        return null;
    }
  }
}

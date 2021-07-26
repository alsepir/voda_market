import 'package:voda/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';

class InputTheme {
  InputTheme.light()
      : this.color = AppColors.typographyPrimary,
        this.placeholder = AppColors.typographyTertiary,
        this.focus = AppColors.brandBlue,
        this.error = AppColors.systemRed,
        this.background = AppColors.backgroundSecondary;
  InputTheme.dark()
      : this.color = AppColors.typographyDarkPrimary,
        this.placeholder = AppColors.typographyDarkTertiary,
        this.focus = AppColors.brandDarkBlue,
        this.error = AppColors.systemDarkRed,
        this.background = AppColors.darkGrey6;

  final Color color;
  final Color placeholder;
  final Color background;
  final Color focus;
  final Color error;
}

class Input extends StatefulWidget {
  Input({Key? key, this.placeholder = '', this.value, this.onChanged}) : super(key: key);

  final String placeholder;
  final String? value;
  final Function(String)? onChanged;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputTheme getTheme(bool isDark) {
    if (isDark) return InputTheme.dark();
    return InputTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    InputTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);
    if (widget.value != null) _controller.value = TextEditingValue(text: widget.value!);

    return TextField(
      controller: _controller,
      style: TextStyle(
        color: theme.color,
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      onChanged: (value) {
        if (widget.onChanged != null) widget.onChanged!(value);
        // setState(() => isError = false);
      },
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        filled: true,
        fillColor: theme.background,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          color: theme.placeholder,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 2, color: theme.focus),
        ),
        errorText: null, //'Введите пароль',
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1, color: theme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1, color: theme.error),
        ),
      ),
    );
  }
}

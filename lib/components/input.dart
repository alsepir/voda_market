import 'package:voda/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Input({
    Key? key,
    this.placeholder = '',
    this.value,
    this.onChanged,
    this.keyboardType,
    this.prefixText,
    this.acceptInputFormatters = false,
    this.fontSize = 17,
    this.controller,
  }) : super(key: key);

  final String placeholder;
  final String? value;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? prefixText;
  final bool acceptInputFormatters;
  final double fontSize;
  final TextEditingController? controller;

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
      keyboardType: widget.keyboardType,
      inputFormatters: widget.acceptInputFormatters ? [PhoneTextFormatter()] : null,
      controller: widget.controller, // != null ? widget.controller : _controller,
      style: TextStyle(color: theme.color, fontSize: widget.fontSize, fontWeight: FontWeight.w400),
      textAlignVertical: TextAlignVertical.center,
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
          fontSize: widget.fontSize,
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
        prefixIcon: widget.prefixText != null
            ? Container(
                alignment: Alignment.centerRight,
                width: 24,
                child: Text(
                  widget.prefixText!,
                  style: TextStyle(color: theme.color, fontSize: widget.fontSize, fontWeight: FontWeight.w400),
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 32 + 24),
      ),
    );
  }
}

class PhoneTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      String phoneMask = '(___) ___-__-__';
      String _text = newValue.text;
      String phone = _text.startsWith('+7 ') ? _text.substring(3) : _text;
      int oldPosition = oldValue.selection.end < 0 ? 0 : oldValue.selection.end;
      bool isPositionGrow = newValue.selection.end - oldValue.selection.end >= 0;
      final newString = _applyMask(phoneMask, phone);
      final poss = _getMaskPosition(phoneMask, oldPosition, isPositionGrow);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.isEmpty ? 0 : poss),
      );
    } else {
      return newValue;
    }
  }

  String _applyMask(String mask, String value) {
    String result = '';
    String digitMask = '_';
    int indexDigits = 0;

    List<String> valueDigits = value.split('').where((element) => int.tryParse(element) is int).toList();
    if (valueDigits.isEmpty) return result;

    mask.split('').asMap().entries.forEach((e) {
      if (e.value == digitMask && valueDigits.length > indexDigits) {
        result = '$result${valueDigits[indexDigits]}';
        indexDigits++;
      } else {
        result = '$result${e.value}';
      }
    });

    return result;
  }

  int _getMaskPosition(String mask, int oldPosition, bool isPositionGrow) {
    int newPosition = isPositionGrow ? oldPosition : oldPosition - 1;

    if (isPositionGrow) {
      for (int i = newPosition; i < mask.length; i++) {
        newPosition++;
        if (mask[i] == '_') break;
      }
    } else {
      for (int i = newPosition; i > 0; i--) {
        if (mask[i - 1] == '_')
          break;
        else
          newPosition--;
      }
    }

    return newPosition;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/components/index.dart';

class CounterTheme {
  CounterTheme.light()
      : color = AppColors.typographyPrimary,
        border = AppColors.border,
        icon = AppColors.brandBlue;
  CounterTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        border = AppColors.borderDark,
        icon = AppColors.brandDarkBlue;

  final Color color;
  final Color icon;
  final Color border;
}

class Counter extends StatefulWidget {
  Counter({
    Key? key,
    this.onChange,
    this.init,
    this.width = 160.0,
    this.value,
  }) : super(key: key);

  final Function(int)? onChange;
  final int? init;
  final double? width;
  final int? value;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.init != null ? widget.init! : 0;
  }

  CounterTheme getTheme(bool isDark) {
    if (isDark) return CounterTheme.dark();
    return CounterTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    CounterTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Stack(
      children: [
        Container(
          width: widget.width,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Container(
          width: widget.width,
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButtonCount(theme, isPlus: false),
              Text(
                '${widget.value ?? amount}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
              ),
              _buildButtonCount(theme),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButtonCount(CounterTheme theme, {bool isPlus = true}) {
    return InkWell(
      onTap: () {
        int _amount = widget.value ?? amount;
        if (isPlus) ++_amount;
        if (!isPlus && _amount > 0) --_amount;
        if (_amount != amount) {
          setState(() => amount = _amount);
          if (widget.onChange != null) widget.onChange!(_amount);
        }
      },
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: amount == 0 && !isPlus ? theme.border : theme.icon,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CustomIcon(
            isPlus ? CustomIcons.plus : CustomIcons.minus,
            width: 24,
            height: 24,
            color: theme.icon,
          ),
        ),
      ),
    );
  }
}

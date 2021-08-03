import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/components/index.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';

class CheckboxButtonTheme {
  CheckboxButtonTheme.light()
      : this.label = AppColors.typographyPrimary,
        this.checkbox = AppColors.white,
        this.box = AppColors.brandBlue;
  CheckboxButtonTheme.dark()
      : this.label = AppColors.typographyDarkPrimary,
        this.checkbox = AppColors.white,
        this.box = AppColors.brandDarkBlue;

  final Color label;
  final Color box;
  final Color checkbox;
}

class CheckboxButton extends StatefulWidget {
  CheckboxButton({
    Key? key,
    this.label,
    this.active = false,
    this.onChanged,
  }) : super(key: key);

  final String? label;
  final bool active;
  final void Function(int)? onChanged;

  @override
  _CheckboxButtonState createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  late bool active;

  @override
  void initState() {
    super.initState();
    active = widget.active;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  CheckboxButtonTheme getTheme(bool isDark) {
    if (isDark) return CheckboxButtonTheme.dark();
    return CheckboxButtonTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    CheckboxButtonTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    if (active) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return GestureDetector(
      onTap: () {
        bool _active = !active;
        setState(() => active = _active);
        if (widget.onChanged != null) widget.onChanged!(_active ? 1 : 0);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.box),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FadeTransition(
                  opacity: _animation,
                  child: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.box,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ScaleTransition(
                      scale: _animation,
                      child: CustomIcon(CustomIcons.checkbox, color: theme.checkbox),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.label != null) ...[
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.label!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.label,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

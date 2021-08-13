import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';

class RadioSegmentTheme {
  RadioSegmentTheme.light()
      : this.label = AppColors.typographyPrimary,
        this.labelActive = AppColors.typographyDarkPrimary,
        this.active = AppColors.brandBlue,
        this.background = AppColors.backgroundSecondary;
  RadioSegmentTheme.dark()
      : this.label = AppColors.typographyDarkPrimary,
        this.labelActive = AppColors.typographyPrimary,
        this.active = AppColors.brandDarkBlue,
        this.background = AppColors.backgroundDarkSecondary;

  final Color label;
  final Color labelActive;
  final Color background;
  final Color active;
}

class RadioSegmentButtons extends StatefulWidget {
  RadioSegmentButtons({
    Key? key,
    this.onChanged,
    required this.data,
    this.initValue,
    this.margin,
  }) : super(key: key);

  final Function(int)? onChanged;
  final int? initValue;
  final List<ListItemModel> data;
  final EdgeInsets? margin;

  @override
  _RadioSegmentButtonsState createState() => _RadioSegmentButtonsState();
}

class _RadioSegmentButtonsState extends State<RadioSegmentButtons> {
  int value = 0;

  @override
  void initState() {
    super.initState();
    value = widget.initValue ?? 0;
  }

  RadioSegmentTheme getTheme(bool isDark) {
    if (isDark) return RadioSegmentTheme.dark();
    return RadioSegmentTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    RadioSegmentTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Container(
      height: 36,
      margin: widget.margin,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          int _length = widget.data.length;
          double shiftLeft = 8;
          double compensationShift = (_length - 1) * shiftLeft / _length;
          double itemWidth = constraints.maxWidth / _length + compensationShift;

          return Stack(
            children: <Widget>[
              ...widget.data.asMap().entries.map((entry) {
                int index = entry.key;

                return Positioned(
                  left: index > 0 ? ((itemWidth - shiftLeft) * index).toDouble() : 0,
                  child: RadioSegment(
                    width: itemWidth,
                    label: entry.value.label,
                    value: value,
                    groupValue: entry.value.id,
                    onChanged: (int newValue) {
                      setState(() => value = newValue);
                      if (widget.onChanged != null) widget.onChanged!(entry.value.id);
                    },
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

class RadioSegment extends StatefulWidget {
  RadioSegment({
    Key? key,
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.width,
  }) : super(key: key);

  final String label;
  final int value;
  final int groupValue;
  final void Function(int)? onChanged;
  final double? width;

  @override
  _RadioSegmentState createState() => _RadioSegmentState();
}

class _RadioSegmentState extends State<RadioSegment> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  RadioSegmentTheme getTheme(bool isDark) {
    if (isDark) return RadioSegmentTheme.dark();
    return RadioSegmentTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    RadioSegmentTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    if (widget.value == widget.groupValue) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) widget.onChanged!(widget.groupValue);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 32,
                    width: widget.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.label, fontWeight: FontWeight.w400, fontSize: 17),
                    ),
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      height: 32,
                      width: widget.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.active,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme.labelActive, fontWeight: FontWeight.w400, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

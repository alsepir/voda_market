import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';

class RadioButtonTheme {
  RadioButtonTheme.light()
      : this.label = AppColors.typographyPrimary,
        this.box = AppColors.brandBlue;
  RadioButtonTheme.dark()
      : this.label = AppColors.typographyDarkPrimary,
        this.box = AppColors.brandDarkBlue;

  final Color label;
  final Color box;
}

class RadioButtons extends StatefulWidget {
  RadioButtons({Key? key, this.onChanged, required this.data, this.value}) : super(key: key);

  final Function(int)? onChanged;
  final int? value;
  final List<ListItemModel> data;

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  int value = 0;

  @override
  void initState() {
    super.initState();
    value = widget.value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...widget.data.asMap().entries.map((entry) {
          int index = entry.key;

          return Column(children: [
            RadioButton(
              label: entry.value.label,
              value: value,
              groupValue: entry.value.id,
              onChanged: (int newValue) {
                setState(() {
                  value = newValue;
                });
                if (widget.onChanged != null) widget.onChanged!(entry.value.id);
              },
            ),
            if (index < widget.data.length - 1) SizedBox(height: 12),
          ]);
        }).toList(),
      ],
    );
  }
}

class RadioButton extends StatefulWidget {
  RadioButton({
    Key? key,
    this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  }) : super(key: key);

  final String? label;
  final int value;
  final int groupValue;
  final void Function(int)? onChanged;

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> with TickerProviderStateMixin {
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

  RadioButtonTheme getTheme(bool isDark) {
    if (isDark) return RadioButtonTheme.dark();
    return RadioButtonTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    RadioButtonTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

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
              padding: EdgeInsets.all(6),
              child: Stack(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.box),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      height: 16,
                      width: 16,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.box,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/theme.dart';

class SliderAppTheme {
  SliderAppTheme.light()
      : this.activeTrack = AppColors.brandBlue,
        this.inactiveTrack = AppColors.backgroundSecondary,
        this.thumb = AppColors.white,
        this.color = AppColors.typographyPrimary;
  SliderAppTheme.dark()
      : this.activeTrack = AppColors.brandDarkBlue,
        this.inactiveTrack = AppColors.backgroundDarkSecondary,
        this.thumb = AppColors.white,
        this.color = AppColors.typographyDarkPrimary;

  final Color activeTrack;
  final Color inactiveTrack;
  final Color thumb;
  final Color color;
}

class SliderApp extends StatefulWidget {
  SliderApp({Key? key, this.onChanged}) : super(key: key);

  final Function(SliderTimeRange)? onChanged;

  @override
  _SliderAppState createState() => _SliderAppState();
}

class _SliderAppState extends State<SliderApp> {
  // day range - 24 * 60 * 60 - 60 = 86340
  // start 8:00 - 8 * 60 * 60 = 28800
  // end 17:30 - 17 * 60 * 60 + 30 * 60 = 63000
  double secondsOfDay = 86340;
  RangeValues _currentSliderValue = RangeValues(28800, 63000);
  late SliderTimeRange _timeRange;

  @override
  void initState() {
    super.initState();
    _timeRange = convertValueToTime(_currentSliderValue);
  }

  SliderAppTheme getTheme(bool isDark) {
    if (isDark) return SliderAppTheme.dark();
    return SliderAppTheme.light();
  }

  SliderTimeRange convertValueToTime(RangeValues range) {
    DateTime now = DateTime.now();
    DateTime dayStart = DateTime(now.year, now.month, now.day);
    DateTime start = dayStart.add(Duration(seconds: range.start.round()));
    DateTime end = dayStart.add(Duration(seconds: range.end.round()));

    return SliderTimeRange(
      start: '${start.hour}:${start.minute.toString().padLeft(2, '0')}',
      end: '${end.hour}:${end.minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SliderAppTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 52,
                width: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: theme.inactiveTrack, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  _timeRange.start,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                ),
              ),
              Text('-', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color)),
              Container(
                height: 52,
                width: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: theme.inactiveTrack, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  _timeRange.end,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 44,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: theme.activeTrack,
              inactiveTrackColor: theme.inactiveTrack,
              thumbColor: theme.thumb,
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 14,
                elevation: 4,
                pressedElevation: 4,
              ),
            ),
            child: RangeSlider(
              values: _currentSliderValue,
              min: 0,
              max: secondsOfDay,
              onChanged: (RangeValues range) {
                SliderTimeRange timeRange = convertValueToTime(range);
                setState(() {
                  _currentSliderValue = range;
                  _timeRange = timeRange;
                });
                if (widget.onChanged != null) widget.onChanged!(timeRange);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SliderTimeRange {
  SliderTimeRange({required this.start, required this.end});

  String start;
  String end;
}

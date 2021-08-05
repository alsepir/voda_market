import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class MapBottomSheetTheme {
  MapBottomSheetTheme.light()
      : label = AppColors.typographyPrimary,
        description = AppColors.typographyTertiary,
        background = AppColors.backgroundPrimary;
  MapBottomSheetTheme.dark()
      : label = AppColors.typographyDarkPrimary,
        description = AppColors.typographyDarkTertiary,
        background = AppColors.backgroundDarkSecondary;

  final Color label;
  final Color description;
  final Color background;
}

class MapBottomSheet extends StatefulWidget {
  MapBottomSheet({Key? key, this.onSelect}) : super(key: key);

  final Function(DeliveryCityModel)? onSelect;

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  MapBottomSheetTheme getTheme(bool isDark) {
    if (isDark) return MapBottomSheetTheme.dark();
    return MapBottomSheetTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(context);
    MapBottomSheetTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);
    List<DeliveryCityModel> cities = deliveryProvider.cities;

    return GestureDetector(
      onPanDown: (details) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          children: [
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: theme.background,
              ),
              margin: EdgeInsets.only(bottom: 6),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                    color: theme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Input(
                          placeholder: 'Куда везти?',
                          autofocus: true,
                          // controller: _nameController,
                          // onChanged: onChangedName,
                        ),
                      ),
                      SizedBox(height: 4),
                      Expanded(
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowGlow();
                            return false;
                          },
                          child: ListView.separated(
                            cacheExtent: 3000,
                            itemCount: cities.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(height: 0.5, thickness: 0.5, indent: 24, endIndent: 24),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  if (index == 0) SizedBox(height: 12),
                                  _buildCityCard(
                                    context,
                                    data: cities[index],
                                    theme: theme,
                                    onTap: (item) {
                                      if (widget.onSelect != null) {
                                        Navigator.of(context).pop();
                                        widget.onSelect!(item);
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityCard(
    BuildContext context, {
    required DeliveryCityModel data,
    required MapBottomSheetTheme theme,
    required Function(DeliveryCityModel) onTap,
  }) {
    return Material(
      color: theme.background,
      child: InkWell(
        onTap: () => onTap(data),
        highlightColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.label),
              ),
              SizedBox(height: 4),
              Text(
                data.description,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
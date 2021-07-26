import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class HistoryCardTheme {
  HistoryCardTheme.light()
      : color = AppColors.typographyPrimary,
        details = AppColors.typographyTertiary,
        border = AppColors.border,
        background = AppColors.backgroundPrimary,
        status = AppColors.white,
        statusBackground = AppColors.systemGreen;
  HistoryCardTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        details = AppColors.typographyDarkTertiary,
        border = AppColors.borderDark,
        background = AppColors.backgroundDarkSecondary,
        status = AppColors.white,
        statusBackground = AppColors.systemDarkGreen;

  final Color color;
  final Color details;
  final Color statusBackground;
  final Color status;
  final Color background;
  final Color border;
}

class HistoryCard extends StatelessWidget {
  HistoryCard({Key? key, required this.data, this.margin, this.onTap}) : super(key: key);

  final HistoryModel data;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  HistoryCardTheme getTheme(bool isDark) {
    if (isDark) return HistoryCardTheme.dark();
    return HistoryCardTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    HistoryCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Card(
      margin: margin != null ? margin : EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: theme.border, width: 1.0),
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: theme.background,
      shadowColor: AppColors.shadow,
      elevation: 16,
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.date,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color),
                  ),
                  _buildStatus(theme, data.label)
                ],
              ),
              SizedBox(height: 16),
              ...data.details
                  .map(
                    (e) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.label,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.details)),
                            Text(e.description,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.details)),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  )
                  .toList(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 4, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Итого', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.details)),
                    Text('${data.price}₽',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: data.mayReturn ? 0 : 1,
                    child: Button(
                      title: data.mayReturn ? null : 'Повторить заказ',
                      width: data.mayReturn ? 52 : null,
                      iconSize: 32,
                      leading: CustomIcons.repeat,
                      onPress: () => {},
                    ),
                  ),
                  if (data.mayReturn)
                    Expanded(
                      child: Button(
                        type: ButtonType.secondary,
                        title: 'Вернуть тару',
                        margin: EdgeInsets.only(left: 12),
                        onPress: () => {},
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(HistoryCardTheme theme, String status) {
    return Container(
      height: 25,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.statusBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: theme.status,
          )),
    );
  }
}

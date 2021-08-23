import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';
import 'package:voda/theme.dart';

class HistoryDetailsScreenTheme {
  HistoryDetailsScreenTheme.light()
      : color = AppColors.typographyPrimary,
        details = AppColors.typographyTertiary,
        icon = AppColors.brandBlue,
        status = AppColors.white,
        statusBackground = AppColors.systemGreen;
  HistoryDetailsScreenTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        details = AppColors.typographyDarkTertiary,
        icon = AppColors.brandDarkBlue,
        status = AppColors.white,
        statusBackground = AppColors.systemDarkGreen;

  final Color color;
  final Color details;
  final Color statusBackground;
  final Color status;
  final Color icon;
}

class HistoryDetailsScreen extends StatelessWidget {
  const HistoryDetailsScreen({Key? key, required this.historyId}) : super(key: key);

  final int historyId;

  HistoryDetailsScreenTheme getTheme(bool isDark) {
    if (isDark) return HistoryDetailsScreenTheme.dark();
    return HistoryDetailsScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    HistoryDetailsScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);
    HistoryModel history = (historyProvider.data ?? []).firstWhere((element) => element.id == historyId);

    return Scaffold(
      appBar: Header(
        title: '#$historyId',
        leading: HeaderLeading.back,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        history.date,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color),
                      ),
                      _buildStatus(theme, history.label)
                    ],
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      children: [
                        ..._buildDetails(theme, history.details),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            CustomIcon(CustomIcons.crosshair, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                            Text(
                              history.target,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color),
                            )
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            CustomIcon(CustomIcons.coin, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                            Text(
                              history.howpay,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color),
                            )
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            CustomIcon(CustomIcons.comment, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                            Text(
                              history.comment,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Итого',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.details)),
                        Text('${history.price}₽',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color))
                      ],
                    ),
                  ),
                  Button(
                    title: 'Повторить заказ',
                    leading: CustomIcons.repeat,
                    onPress: () => {},
                  ),
                  if (history.mayReturn)
                    Button(
                      type: ButtonType.secondary,
                      title: 'Вернуть тару',
                      margin: EdgeInsets.only(top: 12),
                      onPress: () => {},
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetails(HistoryDetailsScreenTheme theme, List<HistoryDetailsModel> details) {
    return details.map((e) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.details)),
              Text(e.description, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.details)),
            ],
          ),
          SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  Widget _buildStatus(HistoryDetailsScreenTheme theme, String status) {
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

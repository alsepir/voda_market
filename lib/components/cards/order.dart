import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class OrderCardTheme {
  OrderCardTheme.light()
      : color = AppColors.typographyPrimary,
        date = AppColors.typographySecondary,
        details = AppColors.typographyTertiary,
        border = AppColors.border,
        background = AppColors.backgroundPrimary,
        icon = AppColors.brandBlue,
        status = AppColors.white,
        statusBackground = AppColors.systemOrange;
  OrderCardTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        date = AppColors.typographyDarkSecondary,
        details = AppColors.typographyDarkTertiary,
        border = AppColors.borderDark,
        background = AppColors.backgroundDarkSecondary,
        icon = AppColors.brandDarkBlue,
        status = AppColors.white,
        statusBackground = AppColors.systemDarkOrange;

  final Color color;
  final Color details;
  final Color date;
  final Color statusBackground;
  final Color status;
  final Color background;
  final Color border;
  final Color icon;
}

class OrderCard extends StatelessWidget {
  OrderCard({Key? key, required this.data, this.margin, this.onTap}) : super(key: key);

  final OrderModel data;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  OrderCardTheme getTheme(bool isDark) {
    if (isDark) return OrderCardTheme.dark();
    return OrderCardTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    OrderCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.date,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color),
                      ),
                      Text(
                        '${data.dateBegin}-${data.dateEnd}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.date),
                      ),
                    ],
                  ),
                  _buildStatus(theme, data.label)
                ],
              ),
              SizedBox(height: 16),
              ...data.details.map((e) {
                return Column(
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
                );
              }).toList(),
              SizedBox(height: 6),
              Row(
                children: [
                  CustomIcon(CustomIcons.crosshair, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                  Text(
                    data.target,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color),
                  )
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  CustomIcon(CustomIcons.coin, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                  Text(
                    data.howpay,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 14, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Итого', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.details)),
                    Text('${data.price}₽',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: theme.color))
                  ],
                ),
              ),
              Expanded(
                flex: data.mayReturn ? 0 : 1,
                child: Button(
                  type: ButtonType.exit,
                  title: 'Отменить заказ',
                  onPress: () => {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(OrderCardTheme theme, String status) {
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

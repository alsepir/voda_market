import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class ShoppingCartCardTheme {
  ShoppingCartCardTheme.light(bool active)
      : color = AppColors.typographyPrimary,
        description = AppColors.typographyTertiary,
        border = AppColors.border,
        background = active ? AppColors.brandBlue.withOpacity(0.15) : AppColors.backgroundPrimary,
        icon = AppColors.brandBlue,
        volume = AppColors.brandBlue.withOpacity(0.5);
  ShoppingCartCardTheme.dark(bool active)
      : color = AppColors.typographyDarkPrimary,
        description = AppColors.typographyDarkTertiary,
        border = AppColors.borderDark,
        background = active ? AppColors.brandDarkBlue.withOpacity(0.15) : AppColors.backgroundDarkSecondary,
        icon = AppColors.brandDarkBlue,
        volume = AppColors.brandDarkBlue.withOpacity(0.5);

  final Color color;
  final Color description;
  final Color volume;
  final Color icon;
  final Color background;
  final Color border;
}

class ShoppingCartCard extends StatelessWidget {
  ShoppingCartCard({Key? key, required this.data, this.margin, this.onTap, this.onLongPress}) : super(key: key);

  final ShoppingCartModel data;
  final EdgeInsetsGeometry? margin;
  final Function(ShoppingCartModel)? onTap;
  final Function(ShoppingCartModel)? onLongPress;

  ShoppingCartCardTheme getTheme(bool isDark, bool active) {
    if (isDark) return ShoppingCartCardTheme.dark(active);
    return ShoppingCartCardTheme.light(active);
  }

  int calculateTotalPrice(int amount) {
    int totalPrice = 0;
    if (amount > 1)
      totalPrice = amount * data.item.priceForTwo;
    else if (amount == 1) totalPrice = data.item.priceForOne;

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ShoppingCartCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark, data.selected);
    int price = calculateTotalPrice(data.amount);

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
        onTap: () {
          if (onTap != null) onTap!(data);
        },
        onLongPress: () {
          if (onLongPress != null) onLongPress!(data);
        },
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  width: 80,
                  height: 96,
                  fit: BoxFit.cover,
                  image: AssetImage(data.item.image),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 96,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.item.title,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                          ),
                          Text(
                            '${data.item.volume}л',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.volume),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 50),
                            child: Text(
                              '$price₽',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                            ),
                          ),
                          Counter(
                            width: 140.0,
                            value: data.amount,
                            init: data.amount,
                            onChange: (int amount) {
                              ShoppingCartProvider shoppingCartProvider =
                                  Provider.of<ShoppingCartProvider>(context, listen: false);
                              shoppingCartProvider.changeAmount(data.item, amount);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

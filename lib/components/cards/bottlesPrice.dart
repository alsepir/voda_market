import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';
import 'package:flutter/scheduler.dart';

class BottlesPriceCardTheme {
  BottlesPriceCardTheme.light()
      : color = AppColors.typographySecondary,
        price = AppColors.typographyPrimary,
        border = AppColors.border,
        background = AppColors.backgroundPrimary;
  BottlesPriceCardTheme.dark()
      : color = AppColors.typographyDarkSecondary,
        price = AppColors.typographyDarkPrimary,
        border = AppColors.borderDark,
        background = AppColors.backgroundDarkSecondary;

  final Color color;
  final Color price;
  final Color background;
  final Color border;
}

class BottlesPriceCard extends StatefulWidget {
  BottlesPriceCard({Key? key, required this.data, this.margin, this.onTap, this.onLongPress}) : super(key: key);

  final ShoppingCartModel data;
  final EdgeInsetsGeometry? margin;
  final Function(ShoppingCartModel)? onTap;
  final Function(ShoppingCartModel)? onLongPress;

  @override
  _BottlesPriceCardState createState() => _BottlesPriceCardState();
}

class _BottlesPriceCardState extends State<BottlesPriceCard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  bool isExpand = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
      shoppingCartProvider.calculatePrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  BottlesPriceCardTheme getTheme(bool isDark) {
    if (isDark) return BottlesPriceCardTheme.dark();
    return BottlesPriceCardTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
    BottlesPriceCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    if (isExpand)
      _controller.forward();
    else
      _controller.reverse();

    return Card(
      margin: widget.margin != null ? widget.margin : EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: theme.border, width: 1.0),
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: theme.background,
      shadowColor: AppColors.shadow,
      elevation: 16,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Цена за тару (${shoppingCartProvider.bottleQuantity}шт.)',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                ),
                Text(
                  '${shoppingCartProvider.bottlesPrice}₽',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.price),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(height: 0.5, thickness: 0.5),
            SizedBox(height: 16),
            CheckboxButton(
              label: 'Есть тара для возврата',
              active: isExpand,
              onChanged: (int state) => setState(() => isExpand = state == 1),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Expanded(
                        child: Text(
                          'Укажите количество',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                        ),
                      ),
                    ),
                    Counter(
                      width: 140.0,
                      value: shoppingCartProvider.bottleReturnQuantity,
                      onChange: (int amount) {
                        shoppingCartProvider.setBottleReturnQuantity(amount);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class CatalogBottomSheetTheme {
  CatalogBottomSheetTheme.light()
      : color = AppColors.typographyPrimary,
        description = AppColors.typographyTertiary,
        border = AppColors.border,
        background = AppColors.backgroundPrimary,
        volume = AppColors.brandBlue.withOpacity(0.5);
  CatalogBottomSheetTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        description = AppColors.typographyDarkTertiary,
        border = AppColors.borderDark,
        background = AppColors.backgroundDarkSecondary,
        volume = AppColors.brandDarkBlue.withOpacity(0.5);

  final Color color;
  final Color description;
  final Color volume;
  final Color background;
  final Color border;
}

class CatalogBottomSheet extends StatefulWidget {
  CatalogBottomSheet({Key? key, required this.item}) : super(key: key);

  final CatalogModel item;

  @override
  _CatalogBottomSheetState createState() => _CatalogBottomSheetState();
}

class _CatalogBottomSheetState extends State<CatalogBottomSheet> {
  int totalPrice = 0;
  bool isDrag = false;

  CatalogBottomSheetTheme getTheme(bool isDark) {
    if (isDark) return CatalogBottomSheetTheme.dark();
    return CatalogBottomSheetTheme.light();
  }

  calculateTotalPrice(int amount) {
    int _totalPrice = totalPrice;
    if (amount > 1)
      _totalPrice = amount * widget.item.priceForTwo;
    else if (amount == 1)
      _totalPrice = widget.item.priceForOne;
    else
      _totalPrice = 0;

    setState(() {
      totalPrice = _totalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    CatalogBottomSheetTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Listener(
      onPointerDown: (event) {
        setState(() => isDrag = true);
      },
      onPointerUp: (event) {
        setState(() => isDrag = false);
      },
      child: FractionallySizedBox(
        heightFactor: 0.7,
        child: Column(
          children: [
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isDrag ? AppColors.white.withOpacity(0.5) : AppColors.white,
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
                    children: [
                      Expanded(
                        child: Image(
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          image: AssetImage(widget.item.image),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.item.title,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: theme.color),
                                ),
                                Text(
                                  '${widget.item.volume}л',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.volume),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.item.description,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.description),
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(child: _buildPriceLabel(theme, 1, widget.item.priceForOne)),
                                SizedBox(width: 8),
                                Expanded(child: _buildPriceLabel(theme, 2, widget.item.priceForTwo)),
                                SizedBox(width: 8),
                                Counter(onChange: calculateTotalPrice),
                              ],
                            ),
                            SizedBox(height: 24),
                            Button(
                              type: ButtonType.price,
                              title: 'Добавить в корзину',
                              price: totalPrice,
                              disable: totalPrice == 0,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              onPress: () => {},
                            )
                          ],
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

  Widget _buildPriceLabel(CatalogBottomSheetTheme theme, int count, int price) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${count > 1 ? 'от' : 'за'} $count шт.',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: theme.color)),
          SizedBox(height: 4),
          Text('$price₽', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color)),
        ],
      ),
    );
  }
}

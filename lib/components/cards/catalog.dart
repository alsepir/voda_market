import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';
import 'package:voda/components/index.dart';

class CatalogCardTheme {
  CatalogCardTheme.light()
      : color = AppColors.typographyPrimary,
        description = AppColors.typographyTertiary,
        border = AppColors.border,
        background = AppColors.backgroundPrimary,
        icon = AppColors.brandBlue,
        volume = AppColors.brandBlue.withOpacity(0.5);
  CatalogCardTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        description = AppColors.typographyDarkTertiary,
        border = AppColors.borderDark,
        background = AppColors.backgroundDarkSecondary,
        icon = AppColors.brandDarkBlue,
        volume = AppColors.brandDarkBlue.withOpacity(0.5);

  final Color color;
  final Color description;
  final Color volume;
  final Color icon;
  final Color background;
  final Color border;
}

class CatalogCard extends StatelessWidget {
  CatalogCard({Key? key, required this.data, this.margin, this.onTap}) : super(key: key);

  final CatalogModel data;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  CatalogCardTheme getTheme(bool isDark) {
    if (isDark) return CatalogCardTheme.dark();
    return CatalogCardTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    CatalogCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

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
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                  image: AssetImage(data.image),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.title,
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.color),
                              ),
                              Text(
                                '${data.volume}л',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.volume),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            data.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.description),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildPriceLabel(theme, 1, data.priceForOne)),
                          SizedBox(width: 8),
                          Expanded(child: _buildPriceLabel(theme, 2, data.priceForTwo)),
                          SizedBox(width: 8),
                          _buildAddLabel(theme),
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

  Widget _buildPriceLabel(CatalogCardTheme theme, int count, int price) {
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
          Text('за $count шт.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: theme.color)),
          SizedBox(height: 4),
          Text('$price₽', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: theme.color)),
        ],
      ),
    );
  }

  Widget _buildAddLabel(CatalogCardTheme theme) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomIcon(CustomIcons.plus, width: 24, height: 24, color: theme.icon),
      ),
    );
  }
}

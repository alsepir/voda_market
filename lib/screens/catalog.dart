import 'package:voda/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';

class CatalogScreenTheme {
  CatalogScreenTheme.light() : gradient = AppColors.backgroundPrimary;
  CatalogScreenTheme.dark() : gradient = AppColors.backgroundDarkPrimary;

  final Color gradient;
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  CatalogScreenTheme getTheme(bool isDark) {
    if (isDark) return CatalogScreenTheme.dark();
    return CatalogScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    CatalogProvider catalogProvider = Provider.of<CatalogProvider>(context);
    List<CatalogModel> catalog = catalogProvider.data ?? [];
    List<CatalogFilterModel> filters = catalogProvider.filters ?? [];
    List<CatalogAdvertisingModel> advertising = catalogProvider.advertising ?? [];
    CatalogScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Каталог', style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: CustomIcon(
            CustomIcons.notification,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/notifications');
          },
        ),
        actions: [
          IconButton(
            icon: CustomIcon(
              CustomIcons.shoppingCart,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                expandedHeight: 174,
                collapsedHeight: 52,
                toolbarHeight: 52,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                pinned: true,
                flexibleSpace: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        cacheExtent: 1000,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              if (index == 0) SizedBox(width: 24),
                              _buildAdvertising(advertising[index]),
                              SizedBox(width: index == filters.length - 1 ? 24 : 16),
                            ],
                          );
                        },
                        itemCount: advertising.length,
                      ),
                    ),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.0),
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.gradient,
                            theme.gradient.withOpacity(0.7),
                            theme.gradient.withOpacity(0),
                          ],
                        ),
                      ),
                      child: ListView.builder(
                        cacheExtent: 1000,
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                if (index == 0) ...[SizedBox(width: 24), ChipsBadge(amount: 1), SizedBox(width: 12)],
                                Chips(item: filters[index]),
                                SizedBox(width: index == filters.length - 1 ? 24 : 12),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ))
          ];
        },
        body: ListView.builder(
          cacheExtent: 3000,
          itemCount: catalog.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return SizedBox(height: 16);
            return CatalogCard(
              data: catalog[index],
              margin: EdgeInsets.fromLTRB(24, 0, 24, index == catalog.length - 1 ? 100 : 16),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  routeSettings: RouteSettings(name: '/catalog/card'),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return CatalogBottomSheet(item: catalog[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdvertising(CatalogAdvertisingModel item) {
    return Container(
      height: 98,
      width: 220,
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(item.image),
          colorFilter: ColorFilter.mode(AppColors.black.withOpacity(0.3), BlendMode.srcOver),
          fit: BoxFit.fitWidth,
        ),
      ),
      alignment: Alignment.topLeft,
      child: Text(item.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.white, height: 1.33)),
    );
  }
}

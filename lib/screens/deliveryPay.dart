import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/utils/date.dart';
import 'package:voda/models/index.dart';
import 'package:date_format/date_format.dart';

class DeliveryPayScreenTheme {
  DeliveryPayScreenTheme.light()
      : color = AppColors.typographyPrimary,
        date = AppColors.typographyTertiary,
        icon = AppColors.brandBlue,
        background = AppColors.backgroundPrimary,
        backgroundActive = AppColors.backgroundSecondary;
  DeliveryPayScreenTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        date = AppColors.typographyDarkTertiary,
        icon = AppColors.brandDarkBlue,
        background = AppColors.backgroundDarkPrimary,
        backgroundActive = AppColors.backgroundDarkSecondary;

  final Color color;
  final Color date;
  final Color icon;
  final Color background;
  final Color backgroundActive;
}

class DeliveryPayScreen extends StatefulWidget {
  const DeliveryPayScreen({Key? key}) : super(key: key);

  @override
  _DeliveryPayScreenState createState() => _DeliveryPayScreenState();
}

class _DeliveryPayScreenState extends State<DeliveryPayScreen> {
  int dayIndexSelect = 0;
  bool isCardPay = false;
  bool isPayUponReceipt = false;

  DeliveryPayScreenTheme getTheme(bool isDark) {
    if (isDark) return DeliveryPayScreenTheme.dark();
    return DeliveryPayScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(context);
    DeliveryPayScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);
    List<String> deliveryDays = deliveryProvider.deliveryDays;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('', style: Theme.of(context).appBarTheme.titleTextStyle),
          leading: IconButton(
            icon: CustomIcon(
              CustomIcons.caretLeft,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Когда доставить?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: theme.color),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 130,
                      child: ListView.builder(
                        cacheExtent: 1000,
                        scrollDirection: Axis.horizontal,
                        itemCount: deliveryDays.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0) SizedBox(width: 24),
                                _buildDayCard(
                                  context,
                                  theme,
                                  item: deliveryDays[index],
                                  isActive: dayIndexSelect == index,
                                  onTap: () {
                                    setState(() => dayIndexSelect = index);
                                    deliveryProvider.date = deliveryDays[index];
                                  },
                                ),
                                SizedBox(width: index == deliveryDays.length - 1 ? 24 : 12),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SliderApp(
                      onChanged: (range) {
                        List<String> _timeRange = [];
                        _timeRange.add(range.start);
                        _timeRange.add(range.end);
                        deliveryProvider.timeRange = _timeRange;
                      },
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Как будете платить?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: theme.color),
                      ),
                    ),
                    SizedBox(height: 16),
                    RadioSegmentButtons(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      data: [
                        ListItemModel(0, 'Наличные'),
                        ListItemModel(1, 'Карта'),
                        ListItemModel(2, 'Apple Pay'),
                      ],
                      onChanged: (value) {
                        deliveryProvider.howPay = value;
                        if (value == 1)
                          setState(() => isCardPay = true);
                        else
                          setState(() => isCardPay = false);
                      },
                    ),
                    SizedBox(height: 16),
                    if (isCardPay)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: CheckboxButton(
                          label: 'Оплатить картой при получении',
                          active: deliveryProvider.isPayUponReceipt,
                          onChanged: (int state) {
                            deliveryProvider.isPayUponReceipt = state == 1;
                            setState(() => isPayUponReceipt = !isPayUponReceipt);
                          },
                        ),
                      ),
                    SizedBox(height: 24),
                    Expanded(child: Container()),
                    Button(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      type: ButtonType.price,
                      title: deliveryProvider.howPay == 1 && !deliveryProvider.isPayUponReceipt ||
                              deliveryProvider.howPay == 2
                          ? 'Оплатить'
                          : 'Заказать',
                      price: deliveryProvider.totalPrice,
                      onPress: () {
                        deliveryProvider.sendForm();
                        Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    DeliveryPayScreenTheme theme, {
    String item = '',
    bool isActive = false,
    Function()? onTap,
  }) {
    DateTime dateTime = DateTime.parse(item);
    String todayFormated = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    String todayFormated2 = formatDate(DateTime.now().add(Duration(days: 1)), [yyyy, '-', mm, '-', dd]);
    String todayFormated3 = formatDate(DateTime.now().add(Duration(days: 2)), [yyyy, '-', mm, '-', dd]);
    String title = '';
    if (todayFormated == item) title = 'Сегодня';
    if (todayFormated2 == item) title = 'Завтра';
    if (todayFormated3 == item) title = 'Послезавтра';

    return Container(
      height: 106,
      width: 200,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.black.withOpacity(0.08),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              offset: Offset(0.0, 4.0),
              blurRadius: 8.0,
              spreadRadius: 0.0,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: theme.color),
              ),
              SizedBox(height: 8),
              Text(
                '${dateTime.day} ${getMonthNamesByIndex(dateTime.month - 1)}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.date),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

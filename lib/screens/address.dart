import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';
import 'package:voda/theme.dart';

class AddressScreenTheme {
  AddressScreenTheme.light()
      : color = AppColors.typographyPrimary,
        icon = AppColors.brandBlue;
  AddressScreenTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        icon = AppColors.brandDarkBlue;

  final Color color;
  final Color icon;
}

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  AddressScreenTheme getTheme(bool isDark) {
    if (isDark) return AddressScreenTheme.dark();
    return AddressScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);
    AddressScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: Header(
          title: 'Уточните адрес',
          leading: HeaderLeading.back,
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIcon(CustomIcons.crosshair, color: theme.icon, margin: EdgeInsets.only(right: 12)),
                        Flexible(
                          child: Text(
                            deliveryProvider.address,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: theme.color),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Input(
                      placeholder: 'Квартира',
                      onChanged: (value) {
                        deliveryProvider.apartment = value;
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            placeholder: 'Подъезд',
                            onChanged: (value) {
                              deliveryProvider.porch = value;
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Input(
                            placeholder: 'Этаж',
                            onChanged: (value) {
                              deliveryProvider.storey = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Input(
                      placeholder: 'Комментарий',
                      onChanged: (value) {
                        deliveryProvider.comment = value;
                      },
                    ),
                    SizedBox(height: 12),
                    CheckboxButton(
                      label: 'Подвезти ко входу в здание',
                      active: false,
                      onChanged: (int state) {
                        deliveryProvider.arriveToBuilding = state == 1;
                      },
                    ),
                    SizedBox(height: 24),
                    Expanded(child: Container()),
                    Button(
                      title: 'Далее',
                      onPress: () {
                        Navigator.of(context).pushNamed('/delivery');
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
}
